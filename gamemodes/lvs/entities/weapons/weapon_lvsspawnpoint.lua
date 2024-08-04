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

SWEP.SpawnDistance = 512

function SWEP:SetupDataTables()
end

function SWEP:GetTrace()
	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	local Trace = ply:GetEyeTrace()

	local SpawnAllowed = (Trace.HitPos - ply:GetShootPos()):Length() < self.SpawnDistance

	return Trace, SpawnAllowed
end

if CLIENT then
	SWEP.PrintName		= "Spawnpoint"
	SWEP.Author			= "Luna"

	SWEP.Slot				= 2
	SWEP.SlotPos			= 1

	SWEP.Purpose			= "Set Spawnpoint"
	SWEP.Instructions		= "Left Click to Set,"

	SWEP.DrawWeaponInfoBox 	= true

	--SWEP.WepSelectIcon 			= surface.GetTextureID( "weapons/lvsrepair" )

	function SWEP:Think()
	end

	function SWEP:Deploy()
		self:SendWeaponAnim( ACT_VM_DEPLOY )

		return true
	end

	function SWEP:Holster( wep )
		return true
	end

	function SWEP:OnRemove()
	end

	function SWEP:OnDrop()
	end
else
	function SWEP:Think()
	end

	function SWEP:Deploy()
		self:SendWeaponAnim( ACT_VM_DEPLOY )
		return true
	end

	function SWEP:Holster( wep )
		return true
	end

	function SWEP:OnRemove()
	end

	function SWEP:OnDrop()
	end
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

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end
