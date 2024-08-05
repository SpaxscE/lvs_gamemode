include( "shared.lua" )
include( "cl_hud.lua" )
include( "cl_join.lua" )
include( "buymenu/cl_buymenu.lua" )
include( "buymenu/cl_buymenu_button.lua" )

local ColFriend = Color(0,127,255,255)
local ColEnemy = Color(255,0,0,255)

function GM:GetTeamColor( ent )

	local team = TEAM_UNASSIGNED
	if ( ent.Team ) then team = ent:Team() end

	if team == TEAM_SPECTATOR or not ent.lvsGetAITeam then
		return GAMEMODE:GetTeamNumColor( team )
	end

	return (LocalPlayer():lvsGetAITeam() == ent:lvsGetAITeam()) and ColFriend or ColEnemy
end