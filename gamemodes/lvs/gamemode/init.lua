include( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player_class/player_lvs.lua" )

DEFINE_BASECLASS( "gamemode_base" )

function GM:PlayerSpawn( pl, transiton )

	player_manager.SetPlayerClass( pl, "player_lvs" )

	BaseClass.PlayerSpawn( self, pl, transiton )

end

function GM:PlayerInitialSpawn( pl, transiton )

	BaseClass.PlayerInitialSpawn( self, pl, transiton )

end
