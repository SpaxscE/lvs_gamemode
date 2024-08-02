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
	self:NetworkVar( "Int", 1, "NumIndex" )
	self:NetworkVar( "String", 1, "Item" )

	if SERVER then
		self:SetNumIndex( 1 )
	end
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
end

function SWEP:GetObjectList()
	if istable( self._ObjectList ) then return self._ObjectList end

	self._ObjectList = list.Get( "Fortifications" )

	return self._ObjectList
end

function SWEP:SecondaryAttack()
	self:EmitSound( "Weapon_Pistol.Empty" )

	if SERVER then
		local objects = self:GetObjectList()

		self:SetNumIndex( self:GetNumIndex() + 1 )

		if self:GetNumIndex() > table.Count( objects ) then
			self:SetNumIndex( 1 )
		end

		local desired = self:GetNumIndex()
		local index = 0

		for name, _ in pairs( objects ) do
			index = index + 1

			if index ~= desired then continue end

			self:SetItem( name )

			break
		end

		self:GetOwner():ChatPrint( self:GetItem() )
	end
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
