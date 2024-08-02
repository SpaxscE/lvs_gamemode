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

--[[
models/diggercars/props/dragonsteeth.mdl


models/diggercars/props/wire_test.mdl


models/props_fortifications/hedgehog_small1.mdl
models/props_fortifications/hedgehog_small1_gib1.mdl
models/props_fortifications/hedgehog_small1_gib2.mdl
models/props_fortifications/hedgehog_small1_gib3.mdl


models/props_fortifications/sandbags_line1_tall.mdl
models/props_fortifications/sandbag.mdl
]]

function SWEP:SetupDataTables()
end

if CLIENT then
	SWEP.PrintName		= "Fortifications"
	SWEP.Author			= "Luna"

	SWEP.Slot				= 3
	SWEP.SlotPos			= 1

	SWEP.Purpose			= ""
	SWEP.Instructions		= ""

	SWEP.DrawWeaponInfoBox 	= true

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

function SWEP:Reload()
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW )

	return true
end

function SWEP:Think()
end

function SWEP:Holster( wep )
	return true
end

function SWEP:OnRemove()
end

function SWEP:OnDrop()
end
