
function GM:CanPlayerSuicide( ply )
	return ply:Team() ~= TEAM_SPECTATOR
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

function GM:PlayerSelectSpawn( pl, transiton )

	-- If we are in transition, do not reset player's position
	if ( transiton ) then return end

	-- Save information about all of the spawn points
	-- in a team based game you'd split up the spawns
	if ( !IsTableOfEntitiesValid( self.SpawnPoints ) ) then

		self.LastSpawnPoint = 0
		self.SpawnPoints = ents.FindByClass( "info_player_start" )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_deathmatch" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_combine" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_rebel" ) )

		-- CS Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_counterterrorist" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_terrorist" ) )

		-- DOD Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_axis" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_allies" ) )

		-- (Old) GMod Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "gmod_player_start" ) )

		-- TF Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_teamspawn" ) )

		-- INS Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "ins_spawnpoint" ) )

		-- AOC Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "aoc_spawnpoint" ) )

		-- Dystopia Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "dys_spawn_point" ) )

		-- PVKII Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_pirate" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_viking" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_knight" ) )

		-- DIPRIP Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "diprip_start_team_blue" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "diprip_start_team_red" ) )

		-- OB Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_red" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_blue" ) )

		-- SYN Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_coop" ) )

		-- ZPS Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_human" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_zombie" ) )

		-- ZM Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_zombiemaster" ) )

		-- FOF Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_fof" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_desperado" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_vigilante" ) )

		-- L4D Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_survivor_rescue" ) )
		-- Removing this one for the time being, c1m4_atrium has one of these in a box under the map
		--self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_survivor_position" ) )

	end

	local Count = table.Count( self.SpawnPoints )

	if ( Count == 0 ) then
		Msg("[PlayerSelectSpawn] Error! No spawn points!\n")
		return nil
	end

	-- If any of the spawnpoints have a MASTER flag then only use that one.
	-- This is needed for single player maps.
	for k, v in pairs( self.SpawnPoints ) do

		if ( v:HasSpawnFlags( 1 ) && hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, v, true ) ) then
			return v
		end

	end

	local ChosenSpawnPoint = nil

	-- Try to work out the best, random spawnpoint
	for i = 1, Count do

		ChosenSpawnPoint = table.Random( self.SpawnPoints )

		if ( IsValid( ChosenSpawnPoint ) && ChosenSpawnPoint:IsInWorld() ) then
			if ( ( ChosenSpawnPoint == pl:GetVar( "LastSpawnpoint" ) || ChosenSpawnPoint == self.LastSpawnPoint ) && Count > 1 ) then continue end

			if ( hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, ChosenSpawnPoint, i == Count ) ) then

				self.LastSpawnPoint = ChosenSpawnPoint
				pl:SetVar( "LastSpawnpoint", ChosenSpawnPoint )
				return ChosenSpawnPoint

			end

		end

	end

	return ChosenSpawnPoint

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
	if newteam == TEAM_SPECTATOR then

		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos( Pos )

	elseif oldteam == TEAM_SPECTATOR then

		ply:Spawn()

	end
end
