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
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo		= "none"

function SWEP:SetupDataTables()
end

if CLIENT then
	SWEP.PrintName		= "Vehicle Remote"
	SWEP.Author			= "Luna"

	SWEP.Slot				= 4
	SWEP.SlotPos			= 1

	--SWEP.Purpose			= "Spawn Your LVS Vehicle"
	--SWEP.Instructions		= "Primary to Spawn"

	SWEP.DrawWeaponInfoBox 	= false

	--SWEP.WepSelectIcon 			= surface.GetTextureID( "weapons/lvsrepair" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )

	self:EmitSound("buttons/button14.wav")
end

function SWEP:SecondaryAttack()
	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )

	self:EmitSound("buttons/button18.wav")
end

function SWEP:Reload()
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW )

	return true
end

if SERVER then
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
	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	self:CalcMenu( ply:KeyDown( IN_RELOAD ) )
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
