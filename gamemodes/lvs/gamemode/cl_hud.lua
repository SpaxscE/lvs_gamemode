
local ColorNormal = color_white
local ColorLow = Color(255,0,0,255)

local function DrawPlayerHud( X, Y, ply )
	local Health = math.Round( ply:Health(), 0 )

	local ColHealth = (Health <= 20) and ColorLow or ColorNormal

	draw.DrawText( "HEALTH ", "LVS_FONT", X + 102, Y + 35, ColHealth, TEXT_ALIGN_RIGHT )
	draw.DrawText( Health, "LVS_FONT_HUD_LARGE", X + 102, Y + 20, ColHealth, TEXT_ALIGN_LEFT )

	local Armor = math.Round( ply:Armor(), 0 )

	if Armor <= 0 then return end

	local ColArmor = (Armor <= 20) and ColorLow or ColorNormal

	draw.DrawText( "ARMOR ", "LVS_FONT", X + 265, Y + 35, ColArmor, TEXT_ALIGN_RIGHT )
	draw.DrawText( Armor, "LVS_FONT_HUD_LARGE", X + 265, Y + 20, ColArmor, TEXT_ALIGN_LEFT )
end

local function DrawPlayerAmmo( X, Y, ply )
	local SWEP = ply:GetActiveWeapon()

	if not SWEP.DrawAmmoInfo then return end

	SWEP:DrawAmmoInfo( X, Y, ply )
end

function GM:PlayerHud( ply )
	if ply:InVehicle() or not ply:Alive() then return end

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

function GM:PlayerAmmo( ply )
	if ply:InVehicle() or not ply:Alive() then return end

	local editor = LVS.HudEditors["WeaponInfo"]

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
		DrawPlayerAmmo( PosX, PosY, ply )
	else
		local m = Matrix()
		m:Scale( Vector( ScaleX, ScaleY, 1 ) )

		cam.PushModelMatrix( m )
			DrawPlayerAmmo( PosX, PosY, ply )
		cam.PopModelMatrix()
	end
end
function GM:HUDPaint()
	local ply = LocalPlayer()

	if not IsValid( ply ) or ply:Team() == TEAM_SPECTATOR then return end

	if hook.Call( "HUDShouldDraw", self, "LVSHudHealth" ) then
		self:PlayerHud( ply )
	end

	if hook.Call( "HUDShouldDraw", self, "LVSHudAmmo" ) then
		self:PlayerAmmo( ply )
	end

	if hook.Call( "HUDShouldDraw", self, "LVSHudMoney" ) then
		self:DrawPlayerMoney( ply )
	end

	hook.Run( "HUDDrawTargetID" )
	hook.Run( "HUDDrawPickupHistory" )
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
