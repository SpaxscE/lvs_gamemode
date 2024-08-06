
local meta = FindMetaTable( "Player" )

function meta:CreateGibs( dmginfo )
	local ent = ents.Create( "lvs_player_explosion" )

	if not IsValid( ent ) then return end

	ent:SetPos( self:GetPos() )
	ent:SetAngles( self:GetAngles() )
	ent:SetHull( self:GetHull() )

	if dmginfo then
		ent:SetForce( dmginfo:GetDamageForce() * 0.001 + self:GetVelocity() )
	end

	ent:Spawn()
	ent:Activate()
end

function meta:ClearEntityList()
	for _, ent in pairs( ply:GetEntityList() ) do
		ent:Remove()
	end

	self._EntList = nil
end

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

function GM:GetPlayersTeam1()
	local players = {}

	for _, ply in ipairs( player.GetAll() ) do
		if ply:lvsGetAITeam() ~= 1 then continue end

		table.insert( players, ply )
	end

	return players
end

function GM:GetPlayersTeam2()
	local players = {}

	for _, ply in ipairs( player.GetAll() ) do
		if ply:lvsGetAITeam() ~= 2 then continue end

		table.insert( players, ply )
	end

	return players
end
