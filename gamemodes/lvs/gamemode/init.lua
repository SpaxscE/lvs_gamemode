include( "shared.lua" )
include( "buymenu/sv_buymenu.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "buymenu/cl_buymenu.lua" )
AddCSLuaFile( "buymenu/cl_buymenu_button.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player_class/player_lvs.lua" )
AddCSLuaFile( "sh_moneysystem.lua" )
AddCSLuaFile( "sh_vehicles.lua" )

DEFINE_BASECLASS( "gamemode_base" )

function GM:PlayerSpawn( pl, transiton )

	player_manager.SetPlayerClass( pl, "player_lvs" )

	BaseClass.PlayerSpawn( self, pl, transiton )

end

function GM:PlayerInitialSpawn( pl, transiton )

	BaseClass.PlayerInitialSpawn( self, pl, transiton )

	local ConVar = GetConVar( "lvs_start_money" )

	if not ConVar then return end

	pl:AddMoney( ConVar:GetInt() )

end

--F1
function GM:ShowHelp( ply )
end

--F2
function GM:ShowTeam( ply )
end

--F3
function GM:ShowSpare1( ply )
	ply:SendLua( "GAMEMODE:OpenBuyMenu()" )
end

--F4
function GM:ShowSpare2( ply )
	ply:SendLua( "GAMEMODE:OpenBuyMenu()" )
end