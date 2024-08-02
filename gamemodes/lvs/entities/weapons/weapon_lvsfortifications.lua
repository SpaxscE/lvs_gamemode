AddCSLuaFile()

SWEP.Category				= "[LVS]"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.ViewModel			= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"
SWEP.UseHands				= true

SWEP.HoldType				= "revolver"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo		= "none"

list.Set("Fortifications", "sandbags", {
	Name = "Sandbags",
	Class = "lvs_fortification",
	Model = "models/props_fortifications/sandbags_line1_tall.mdl",
})

list.Set("Fortifications", "hedgehog", {
	Name = "Hedgehog",
	Class = "lvs_fortification",
	Model = "models/props_fortifications/hedgehog_small1.mdl",
})

list.Set("Fortifications", "dragonsteeth", {
	Name = "Dragon's teeth",
	Class = "lvs_fortification",
	Model = "models/diggercars/props/dragonsteeth.mdl",
})

list.Set("Fortifications", "wirefence", {
	Name = "Wire Fence",
	Class = "lvs_fortification",
	Model = "models/diggercars/props/wire_test.mdl",
})

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
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	ply:SetAnimation( PLAYER_ATTACK1 )

	if SERVER then PrintChat( list.Get( "Fortifications" ) ) end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DEPLOY )

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
