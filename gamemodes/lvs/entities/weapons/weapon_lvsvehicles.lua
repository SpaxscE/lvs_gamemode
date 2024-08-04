AddCSLuaFile()

SWEP.Category				= "[LVS]"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.ViewModel			= "models/weapons/c_slam.mdl"
SWEP.WorldModel			= "models/weapons/w_slam.mdl"
SWEP.UseHands				= true

SWEP.HoldType				= "pistol"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo		= "none"

SWEP.SpawnDistance = 512
SWEP.RemoveDistance = 512
SWEP.RemoveTime = 1 --20

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 1, "VehicleRemoveTime" )
	self:NetworkVar( "Entity", 1, "Vehicle" )
end

function SWEP:GetTrace()
	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	local Trace = ply:GetEyeTrace()

	local SpawnAllowed = (Trace.HitPos - ply:GetShootPos()):Length() < self.SpawnDistance

	return Trace, SpawnAllowed
end

if CLIENT then
	SWEP.PrintName		= "Vehicle Remote"
	SWEP.Author			= "Luna"

	SWEP.Slot				= 4
	SWEP.SlotPos			= 1

	SWEP.Purpose			= "Spawn Your LVS Vehicle"
	SWEP.Instructions		= "Right Click to Open Store, Left Click to Spawn, Reload to Remove"

	SWEP.DrawWeaponInfoBox 	= true

	--SWEP.WepSelectIcon 			= surface.GetTextureID( "weapons/lvsrepair" )

	local circles = include("includes/circles/circles.lua")

	local Circle = circles.New(CIRCLE_OUTLINED, 30, 0, 0, 5)
	Circle:SetColor( color_white )
	Circle:SetX( ScrW() * 0.5 )
	Circle:SetY( ScrH() * 0.5 )
	Circle:SetStartAngle( 0 )
	Circle:SetEndAngle( 0 )

	local ColorText = Color(255,255,255,255)

	local function DrawText( x, y, text, col )
		local font = "TargetIDSmall"

		draw.DrawText( text, font, x + 1, y + 1, Color( 0, 0, 0, 120 ), TEXT_ALIGN_CENTER )
		draw.DrawText( text, font, x + 2, y + 2, Color( 0, 0, 0, 50 ), TEXT_ALIGN_CENTER )
		draw.DrawText( text, font, x, y, col or color_white, TEXT_ALIGN_CENTER )
	end

	function SWEP:DoDrawCrosshair( x, y )
		local ply = LocalPlayer()

		if not ply:KeyDown( IN_RELOAD ) then return end

		local Vehicle = self:GetVehicle()

		if not IsValid( Vehicle ) or (ply:GetPos() - Vehicle:GetPos()):Length() > self.RemoveDistance then return end

		local TimeLeft = math.Round( self:GetVehicleRemoveTime() - CurTime(), 0 )

		if TimeLeft < 0 then return end

		draw.DrawText( TimeLeft, "LVS_FONT_HUD_LARGE", x, y - 20, color_white, TEXT_ALIGN_CENTER )

		return true
	end

	local IconInstructionA = Material( "lvs/instructions/mouse_right.png" )
	local IconInstructionB = Material( "lvs/instructions/mouse_left.png" )

	function SWEP:DrawHUD()
		local ply = LocalPlayer()

		if ply:InVehicle() and not ply:GetAllowWeaponsInVehicle() then return end

		local Vehicle = self:GetVehicle()

		if not ply:KeyDown( IN_RELOAD ) then
		
			if IsValid( Vehicle ) or vgui.CursorVisible() then return end

			local data = ply:lvsGetCurrentVehicleData()

			local X = ScrW() * 0.5
			local Y = ScrH() - 105

			if not data then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( IconInstructionA )
				surface.DrawTexturedRect( X - 32, Y, 64, 64 )

				draw.DrawText( "Open Store", "LVS_FONT", X, Y + 68, color_white, TEXT_ALIGN_CENTER )

				return
			end

			local CanAfford = ply:CanAfford( data )

			if not CanAfford then return end

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( IconInstructionB )
			surface.DrawTexturedRect( X - 32, Y, 64, 64 )

			draw.DrawText( "Place Vehicle", "LVS_FONT", X, Y + 68, color_white, TEXT_ALIGN_CENTER )

			return
		end

		local X = ScrW() * 0.5
		local Y = ScrH() * 0.5

		if not IsValid( Vehicle ) then DrawText( X, Y + 34, "!No Vehicle!", Color(255,0,0,255) ) return end

		if (ply:GetPos() - Vehicle:GetPos()):Length() > self.RemoveDistance then DrawText( X, Y + 34, "!Vehicle too far away!", Color(255,0,0, math.abs( math.cos( CurTime() * 5 ) ) * 255 ) ) return end

		if #Vehicle:GetEveryone() > 0 then DrawText( X, Y + 34, "!Vehicle is in use!", Color(255,0,0, math.abs( math.cos( CurTime() * 5 ) ) * 255 ) ) return end

		local RemoveTime = math.min( (self:GetVehicleRemoveTime() - CurTime()) / self.RemoveTime, 1 )

		if RemoveTime < 0 then return end

		draw.NoTexture()

		Circle:SetX( X )
		Circle:SetY( Y )
		Circle:SetStartAngle( -360 * RemoveTime )
		Circle:SetEndAngle( 0 )
		Circle()

		DrawText( X, Y + 34, "Selling Vehicle..." )
	end

	local FrameMat = Material( "lvs/3d2dmats/frame.png" )
	local ArrowMat = Material( "lvs/3d2dmats/arrow.png" )

	hook.Add( "PostDrawOpaqueRenderables", "the_system_is_rigged", function( bDrawingDepth, bDrawingSkybox, isDraw3DSkybox )

		if bDrawingDepth or bDrawingSkybox or isDraw3DSkybox then return end

		local ply = LocalPlayer()

		if not IsValid( ply ) then return end

		local SWEP = ply:GetWeapon( "weapon_lvsvehicles" )

		if not IsValid( SWEP ) or SWEP ~= ply:GetActiveWeapon() or (ply:InVehicle() and not ply:GetAllowWeaponsInVehicle()) or ply:KeyDown( IN_RELOAD ) or vgui.CursorVisible() then return end

		if ply:lvsGetCurrentVehicle() == "" or IsValid( SWEP:GetVehicle() ) then return end

		local trace, allowed = SWEP:GetTrace()

		local pos = trace.HitPos + trace.HitNormal
		local ang = Angle(0,ply:EyeAngles().y - 90,0)

		if allowed then
			surface.SetDrawColor( 0, 127, 255, 255 )
		else
			surface.SetDrawColor( 255, 0, 0, 255 )
		end

		cam.Start3D2D( pos, ang, 0.05 )
			surface.SetMaterial( FrameMat )
			surface.DrawTexturedRect( -1024, -1024, 2048, 2048 )
		cam.End3D2D()

		cam.Start3D2D( pos + Vector(0,0,50 + math.cos( CurTime() * 4 ) * 25 ), ang + Angle(0,180,-90), 0.05 )
			surface.SetMaterial( ArrowMat )
			surface.DrawTexturedRect( -512, -512, 1024, 1024 )
		cam.End3D2D()
	end )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )

	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	if CLIENT then return end

	local Vehicle = self:GetVehicle()

	if IsValid( Vehicle ) then
		if isfunction( Vehicle.IsDestroyed ) and Vehicle:IsDestroyed() then
			Vehicle:Remove() --  TODO: add nice effect
		else
			ply:ChatPrint( "You already have a Vehicle!" )

			return
		end
	end

	local trace, allowed = self:GetTrace()

	if not allowed then return end

	local class = ply:lvsGetCurrentVehicle()
	local price = GAMEMODE:GetVehiclePrice( class )

	if not ply:CanAfford( price ) then ply:ChatPrint( "You don't have enough money!" ) return end

	ply._SpawnedVehicle = GAMEMODE:SpawnVehicle( ply, class, trace )

	if not IsValid( ply._SpawnedVehicle ) then return end

	ply:TakeMoney( price )

	self:SetVehicleRemoveTime( CurTime() + self.RemoveTime )

	self:SetVehicle( ply._SpawnedVehicle )

	ply:ChatPrint( "Vehicle Purchased" )
end

function SWEP:SecondaryAttack()
	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )
end

function SWEP:Reload()
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW )

	local ply = self:GetOwner()

	if IsValid( ply ) and IsValid( ply._SpawnedVehicle ) then
		self:SetVehicle( ply._SpawnedVehicle )
	end

	return true
end

function SWEP:HandleVehicleRemove()
	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	local Reload = ply:KeyDown( IN_RELOAD )

	local Vehicle = self:GetVehicle()

	if Reload and IsValid( Vehicle ) and isfunction( Vehicle.GetEveryone ) then
		if #Vehicle:GetEveryone() > 0 then
			Reload = false
		end

		if (ply:GetPos() - Vehicle:GetPos()):Length() > self.RemoveDistance then
			Reload = false
		end
	end

	if self._oldReload ~= Reload then
		self._oldReload = Reload

		if Reload and IsValid( Vehicle ) then
			self._NotifyPlayed = nil
			self:SetVehicleRemoveTime( CurTime() + self.RemoveTime )
		end
	end

	if not Reload or not IsValid( Vehicle ) then return end

	local RemoveTime = (self:GetVehicleRemoveTime() - CurTime()) / self.RemoveTime

	if RemoveTime > 0 then return end

	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )

	if CLIENT then return end

	ply:EmitSound("buttons/button15.wav")

	ply:ChatPrint( "Vehicle Sold" )

	Vehicle:Remove()
end

if SERVER then
	function SWEP:Think()
		self:HandleVehicleRemove()
	end

	function SWEP:EnterVehicle( vehicle )
		local ply = self:GetOwner()

		if not IsValid( vehicle ) or not IsValid( ply ) then return end

		if not vehicle:IsInitialized() then
			timer.Simple( 0, function()
				if not IsValid( self ) then return end

				self:EnterVehicle( vehicle )
			end )

			return
		end

		vehicle:SetPassenger( ply )
	end

	function SWEP:Holster( wep )
		return true
	end

	function SWEP:OnRemove()
	end

	function SWEP:OnDrop()
	end

	return
end

function SWEP:CalcMenu( Open )
	if self._oldOpen == Open then return end

	self._oldOpen = Open

	if Open then
		GAMEMODE:OpenBuyMenu()
	else
		GAMEMODE:CloseBuyMenu()
	end
end

function SWEP:Think()
	self:HandleVehicleRemove()

	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	self:CalcMenu( ply:KeyDown( IN_ATTACK2 ) )
end

function SWEP:Holster( wep )
	self:CalcMenu( false )

	return true
end

function SWEP:OnRemove()
	self:CalcMenu( false )
end

function SWEP:OnDrop()
	self:CalcMenu( false )
end
