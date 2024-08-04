AddCSLuaFile()

ENT.Type            = "anim"

ENT.Spawnable		= false
ENT.AdminOnly		= false

ENT.IsFortification = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",1, "CreatedBy" )
	self:NetworkVar( "Float",1, "HP" )
	self:NetworkVar( "Float",2, "MaxHP" )
end

if SERVER then
	function ENT:Initialize()
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

		local PObj = self:GetPhysicsObject()

		if not IsValid( PObj ) then 
			self:Remove()

			return
		end

		PObj:EnableMotion( false )
	end

	function ENT:Think()
		return false
	end

	function ENT:TakeCollisionDamage( damage, attacker )
		if not IsValid( attacker ) then
			attacker = game.GetWorld()
		end

		local dmginfo = DamageInfo()
		dmginfo:SetDamage( damage )
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( attacker )
		dmginfo:SetDamageType( DMG_CRUSH + DMG_VEHICLE ) -- this will communicate to the damage system to handle this kind of damage differently.
		self:TakeDamageInfo( dmginfo )
	end

	function ENT:PhysicsCollide( data, physobj )
		self:TakeCollisionDamage( self:GetHP() * 2, data.HitEntity )
	end

	ENT.DSArmorDamageReduction = 0.1
	ENT.DSArmorDamageReductionType = DMG_AIRBOAT + DMG_SNIPER

	ENT.DSArmorIgnoreDamageType = DMG_BULLET + DMG_CLUB
	ENT.DSArmorIgnoreForce = 0

	function ENT:OnTakeDamage( dmginfo )
		if dmginfo:IsDamageType( self.DSArmorIgnoreDamageType ) then return end

		if dmginfo:IsDamageType( self.DSArmorDamageReductionType ) then
			if dmginfo:GetDamage() ~= 0 then
				dmginfo:ScaleDamage( self.DSArmorDamageReduction )

				dmginfo:SetDamage( math.max(dmginfo:GetDamage(),1) )
			end
		end

		local IsFireDamage = dmginfo:IsDamageType( DMG_BURN )
		local IsCollisionDamage = dmginfo:GetDamageType() == (DMG_CRUSH + DMG_VEHICLE)

		if dmginfo:GetDamageForce():Length() < self.DSArmorIgnoreForce and not IsFireDamage then return end

		local Damage = dmginfo:GetDamage()

		if Damage <= 0 then return end

		local CurHealth = self:GetHP()

		local NewHealth = math.Clamp( CurHealth - Damage, -self:GetMaxHP(), self:GetMaxHP() )

		self:SetHP( NewHealth )

		if NewHealth <= 0 then
			SafeRemoveEntityDelayed( self, 0 )
		end
	end
end

if CLIENT then
	function ENT:Draw( flags )
		self:DrawModel( flags )
	end

	function ENT:OnRemove()
	end

	function ENT:Think()
	end
end
