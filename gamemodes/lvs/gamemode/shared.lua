GM.Name = "LVS-Tournament"
GM.Author = "Luna"
GM.Email = "juliewerding@gmx.de"
GM.Website = "https://discord.gg/BeVtn7uwNH"

DeriveGamemode( "base" )

include( "player_class/player_lvs.lua" )
include( "sh_moneysystem.lua" )
include( "sh_vehicles.lua" )
include( "sh_spectator.lua" )
include( "sh_playerragdoll.lua" )

function GM:Initialize()
	LVS.HudForceDefault = true
	LVS.FreezeTeams = true
	LVS.TeamPassenger = true

	cvars.RemoveChangeCallback( "lvs_freeze_teams", "lvs_freezeteams_callback" )
	cvars.RemoveChangeCallback( "lvs_teampassenger", "lvs_teampassenger_callback" )
end

function GM:InitPostEntity()
	self:BuildVehiclePrices()
end

function GM:CreateTeams()
end

function GM:HandlePlayerVaulting( ply, velocity, plyTable )

	if ( !plyTable ) then plyTable = ply:GetTable() end

	if ( velocity:LengthSqr() < 300000 ) then return end

	if ( ply:IsOnGround() ) then return end

	plyTable.CalcIdeal = ACT_MP_SWIM

	return true

end