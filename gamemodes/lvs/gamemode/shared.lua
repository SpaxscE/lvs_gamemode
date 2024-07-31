GM.Name = "LVS-Tournament"
GM.Author = "Luna"
GM.Email = "juliewerding@gmx.de"
GM.Website = "https://discord.gg/BeVtn7uwNH"

DeriveGamemode( "sandbox" )

function GM:Initialize()
print("runs")

	LVS.HudForceDefault = true
	LVS.FreezeTeams = true
	LVS.TeamPassenger = true

	cvars.RemoveChangeCallback( "lvs_freeze_teams", "lvs_freezeteams_callback" )
	cvars.RemoveChangeCallback( "lvs_teampassenger", "lvs_teampassenger_callback" )
end
