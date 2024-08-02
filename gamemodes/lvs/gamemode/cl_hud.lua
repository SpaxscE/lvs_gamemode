
local function DrawPlayerHud( X, Y, ply )
	if not ply:Alive() then return end

	local Health = math.Round( ply:Health(), 0 )

	draw.DrawText( "HEALTH ", "LVS_FONT", X + 102, Y + 35, color_white, TEXT_ALIGN_RIGHT )
	draw.DrawText( Health, "LVS_FONT_HUD_LARGE", X + 102, Y + 20, color_white, TEXT_ALIGN_LEFT )

	local Armor = math.Round( ply:Armor(), 0 )

	if Armor <= 0 then return end

	draw.DrawText( "ARMOR ", "LVS_FONT", X + 255, Y + 35, color_white, TEXT_ALIGN_RIGHT )
	draw.DrawText( Armor, "LVS_FONT_HUD_LARGE", X + 255, Y + 20, color_white, TEXT_ALIGN_LEFT )
end

local function PlayerHud()
	local ply = LocalPlayer()

	if not IsValid( ply ) or ply:InVehicle() then return end

	local editor = LVS.HudEditors["VehicleHealth"]

	if not editor then return end

	local X = ScrW()
	local Y = ScrH()

	local ScaleX = editor.w / editor.DefaultWidth
	local ScaleY = editor.h / editor.DefaultHeight

	local PosX = editor.X / ScaleX
	local PosY = editor.Y / ScaleY

	local Width = editor.w / ScaleX
	local Height = editor.h / ScaleY

	local ScrW = X / ScaleX
	local ScrH = Y / ScaleY

	if ScaleX == 1 and ScaleY == 1 then
		DrawPlayerHud( PosX, PosY, ply )
	else
		local m = Matrix()
		m:Scale( Vector( ScaleX, ScaleY, 1 ) )

		cam.PushModelMatrix( m )
			DrawPlayerHud( PosX, PosY, ply )
		cam.PopModelMatrix()
	end
end

function GM:HUDPaint()
	if hook.Call( "HUDShouldDraw", self, "LVSHudHealth" ) then
		PlayerHud()
	end
end

local hud = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true
}

function GM:HUDShouldDraw( name )

	if hud[name] then return false end

	return self.BaseClass.HUDShouldDraw(self, name)
end
