
local meta = FindMetaTable( "Player" )

function meta:AddEntityList( ent )
	if not istable( self._EntList ) then
		self._EntList = {}
	end

	table.insert( self._EntList, ent )
end

function meta:GetEntityList()
	if not istable( self._EntList ) then return {} end

	for id, ent in pairs( self._EntList ) do
		if IsValid( ent ) then continue end

		self._EntList[ id ] = nil
	end

	return self._EntList
end

function GM:CanPlayerSuicide( ply )
	return ply:Team() ~= TEAM_SPECTATOR
end

function GM:PlayerDisconnected( ply )
	for _, ent in pairs( ply:GetEntityList() ) do
		ent:Remove()
	end
end

function GM:PlayerSpawn( ply, transiton )

	if ply:Team() == TEAM_SPECTATOR then

		self:PlayerSpawnAsSpectator( ply )

		return

	end

	ply:UnSpectate()

	player_manager.SetPlayerClass( ply, "player_lvs" )
	player_manager.OnPlayerSpawn( ply, transiton )
	player_manager.RunClass( ply, "Spawn" )

	if not transiton then
		hook.Call( "PlayerLoadout", GAMEMODE, ply )
	end

	hook.Call( "PlayerSetModel", GAMEMODE, ply )

	ply:SetupHands()

end

function GM:PlayerInitialSpawn( ply, transiton )

	ply:lvsSetAITeam( 0 )
	ply:SetTeam( TEAM_SPECTATOR )
	ply:SendLua( "GAMEMODE:OpenJoinMenu()" )

	local ConVar = GetConVar( "lvs_start_money" )

	if not ConVar then return end

	ply:AddMoney( ConVar:GetInt() )

end

function GM:PlayerSpawnAsSpectator( ply )
	ply:StripWeapons()

	ply:SetTeam( TEAM_SPECTATOR )
	ply:Spectate( OBS_MODE_ROAMING )

end

function GM:PlayerCanJoinTeam( ply, teamid )
	if teamid ~= 1 and teamid ~= 2 and teamid ~= TEAM_SPECTATOR then ply:ChatPrint( "You can't join that team" ) return false end

	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10

	if ply.LastTeamSwitch and RealTime() - ply.LastTeamSwitch < TimeBetweenSwitches then

		ply.LastTeamSwitch = ply.LastTeamSwitch + 1

		ply:ChatPrint( Format( "Please wait %i more seconds before trying to change team again", ( TimeBetweenSwitches - ( RealTime() - ply.LastTeamSwitch ) ) + 1 ) )

		return false
	end

	if ply:lvsGetAITeam() == teamid then
		ply:ChatPrint( "You're already on that team" )

		return false
	end

	return true
end

function GM:PlayerRequestTeam( ply, teamid )

	if not self:PlayerCanJoinTeam( ply, teamid ) then return end

	self:PlayerJoinTeam( ply, teamid )
end

function GM:PlayerJoinTeam( ply, teamid )
	local iOldTeam = ply:Team()

	if ply:Alive() then
		if iOldTeam == TEAM_SPECTATOR then
			ply:KillSilent()
		else
			ply:Kill()
		end
	end

	if teamid == TEAM_SPECTATOR then
		ply:SetTeam( TEAM_SPECTATOR )
		ply:lvsSetAITeam( 0 )
	else
		ply:SetTeam( TEAM_UNASSIGNED )
		ply:lvsSetAITeam( teamid )
	end

	ply.LastTeamSwitch = RealTime()

	self:OnPlayerChangedTeam( ply, iOldTeam, teamid )
end

function GM:OnPlayerChangedTeam( ply, oldteam, newteam )

	local Spawn = ply:GetSpawnPoint()

	if IsValid( Spawn ) then Spawn:Remove() end

	if newteam == TEAM_SPECTATOR then

		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos( Pos )

	elseif oldteam == TEAM_SPECTATOR then

		ply:Spawn()

	end
end
