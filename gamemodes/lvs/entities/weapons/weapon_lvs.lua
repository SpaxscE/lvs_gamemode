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
end

function SWEP:SecondaryAttack()
	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )
end

function SWEP:Think()
end

function SWEP:OnRemove()
end

function SWEP:OnDrop()
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW )

	return true
end

function SWEP:Holster( wep )
	return true
end
