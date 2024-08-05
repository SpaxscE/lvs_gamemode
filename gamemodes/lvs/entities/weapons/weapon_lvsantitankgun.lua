AddCSLuaFile()

SWEP.Base            = "weapon_lvsbasegun"

SWEP.Category				= "[LVS]"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/c_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"
SWEP.UseHands				= true

SWEP.HoldType				= "rpg"

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip		= 4
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SniperRound"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo		= "none"

function SWEP:SetupDataTables()
end

if CLIENT then
	SWEP.PrintName		= "Anti Tank Gun"
	SWEP.Author			= "Blu-x92"

	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:GetCrosshairFilterEnts()
	return { self, self:GetOwner() }
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire( CurTime() + 1.5 )

	self:TakePrimaryAmmo( 1 )

	self:ShootEffects()

	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	ply:EmitSound("weapons/ar2/ar2_altfire.wav",75,80,1)
	self:EmitSound("weapons/flaregun/fire.wav",75,255,1)

	if IsFirstTimePredicted() then
		ply:ViewPunch( Angle(-math.Rand(3,5),-math.Rand(3,5),0) )
		ply:SetVelocity( -ply:GetAimVector() * 650 )
	end

	if CLIENT then return end

	local bullet = {}
	bullet.Src = ply:GetShootPos() + ply:EyeAngles():Right() * 7

	bullet.Dir = (ply:GetEyeTrace().HitPos - bullet.Src):GetNormalized()

	bullet.Spread 	= Vector(0.1,0.1,0.1) * math.min( ply:GetVelocity():Length() / 400, 1 )
	bullet.TracerName = "lvs_tracer_antitankgun"
	bullet.Force	= 6000
	bullet.HullSize 	= 1
	bullet.Damage	= 50

	bullet.SplashDamage = 100
	bullet.SplashDamageRadius = 25
	bullet.SplashDamageEffect = "lvs_fortification_explosion_mine"
	bullet.SplashDamageType = DMG_SONIC

	bullet.Velocity = 4000
	bullet.Entity = self
	bullet.Attacker 	= ply
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType( DMG_SNIPER )
	end

	LVS:FireBullet( bullet )
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if self:DefaultReload( ACT_VM_RELOAD ) then
		self:EmitSound("npc/sniper/reload1.wav")
	end
end

function SWEP:Think()
end

function SWEP:OnRemove()
end

function SWEP:OnDrop()
end

function SWEP:Holster( wep )
	return true
end
