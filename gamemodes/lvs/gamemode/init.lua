include( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player_class/player_lvs.lua" )
AddCSLuaFile( "buymenu/buymenu.lua" )
AddCSLuaFile( "buymenu/buymenu_button.lua" )

DEFINE_BASECLASS( "gamemode_base" )

function GM:PlayerSpawn( pl, transiton )

	player_manager.SetPlayerClass( pl, "player_lvs" )

	BaseClass.PlayerSpawn( self, pl, transiton )

end

function GM:PlayerInitialSpawn( pl, transiton )

	BaseClass.PlayerInitialSpawn( self, pl, transiton )

end

--F1
function GM:ShowHelp( ply )
end

--F2
function GM:ShowTeam( ply )
end
