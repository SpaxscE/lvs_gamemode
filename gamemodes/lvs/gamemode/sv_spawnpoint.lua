
local meta = FindMetaTable( "Player" )

function meta:SetSpawnPoint( ent )
	self._CurSpawnPoint = ent
end

function meta:GetSpawnPoint()
	return self._CurSpawnPoint
end


function GM:PlayerSelectSpawn( pl, transiton )

	-- If we are in transition, do not reset player's position
	if ( transiton ) then return end

	local SpawnPoint = pl:GetSpawnPoint()

	if IsValid( SpawnPoint ) then

		hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, SpawnPoint, true )

		return SpawnPoint
	end

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