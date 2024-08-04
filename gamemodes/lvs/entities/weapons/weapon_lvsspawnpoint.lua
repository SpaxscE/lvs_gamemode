AddCSLuaFile()

SWEP.Category				= "[LVS]"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.HoldType				= "normal"

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
	SWEP.Instructions		= "Left Click to Set, Right Click to Remove"

	SWEP.DrawWeaponInfoBox 	= true

	--SWEP.WepSelectIcon 			= surface.GetTextureID( "weapons/lvsrepair" )

	function SWEP:PrimaryAttack()
	end

	function SWEP:SecondaryAttack()
	end

	function SWEP:Reload()
	end

	return
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	if IsValid( ply:GetSpawnPoint() ) then return end

	local StartPos = ply:GetShootPos()
	local EndPos = StartPos - Vector(0,0,60000)

	local trace = util.TraceLine( {
		start = StartPos,
		endpos = EndPos,
		filter = ply
	} )

	local ent = ents.Create( "lvs_spawnpoint" )
	ent:SetPos( trace.HitPos + trace.HitNormal )
	ent:SetAngles( Angle(0,ply:EyeAngles().y,0) )
	ent:Spawn()
	ent:Activate()
	ent:SetOwner( ply )
	ent:SetCreatedBy( ply )

	ply:SetSpawnPoint( ent )
end

function SWEP:SecondaryAttack()
	self:Reload()
end

function SWEP:Reload()
	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	local oldSpawn = ply:GetSpawnPoint()
	if IsValid( oldSpawn ) then
		oldSpawn:Remove()
	end
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster( wep )
	return true
end

function SWEP:OnRemove()
end

function SWEP:OnDrop()
end
