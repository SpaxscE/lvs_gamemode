AddCSLuaFile()

ENT.Type            = "anim"

ENT.Spawnable		= false
ENT.AdminOnly		= false

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

	function ENT:PhysicsCollide( data, physobj )
	end

	function ENT:OnTakeDamage( dmginfo )
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
