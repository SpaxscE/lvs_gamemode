AddCSLuaFile()

ENT.Type            = "anim"

ENT.Spawnable		= false
ENT.AdminOnly		= false

ENT.RenderGroup = RENDERGROUP_BOTH 

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",1, "CreatedBy" )
end

function ENT:GetAITEAM()
	local ply = self:GetCreatedBy()

	if not IsValid( ply ) then return 0 end

	return ply:lvsGetAITeam()
end

if SERVER then
	function ENT:Initialize()	
		self:SetModel( "models/props_combine/combine_mine01.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

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
		if self.IsDestroyed then return end

		if not dmginfo:IsDamageType( DMG_BLAST ) then return end

		self:Destroy()
	end

	function ENT:Explode()
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( self:OBBCenter() ) )
		util.Effect( "lvs_fortification_explosion", effectdata, true, true )

		if istable( self.BreakSounds ) then
			self:EmitSound( table.Random( self.BreakSounds ),80,100,1)
		else
			if isstring( self.BreakSounds ) then
				self:EmitSound( self.BreakSounds,80,100,1)
			end
		end
	end

	function ENT:Destroy()
		if self.IsDestroyed then return end

		self.IsDestroyed = true

		self:Explode()
		self:SetSolid( SOLID_NONE )
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		SafeRemoveEntityDelayed( self, 0 )
	end
end

if CLIENT then
	local ColFriend = Color(0,127,255,255)
	local ColEnemy = Color(255,0,0,255)

	local ring = Material( "effects/select_ring" )
	local mat = Material( "sprites/light_glow02_add" )

	function ENT:GetTeamColor()
		if self:GetAITEAM() ~= LocalPlayer():lvsGetAITeam() then return ColEnemy end

		return ColFriend
	end

	function ENT:DrawTranslucent( flags )
		local Col = self:GetTeamColor()

		local Pos = self:LocalToWorld( Vector(0,0,20) )

		render.SetMaterial( ring )
		render.DrawSprite( Pos, 24 + math.Rand(-1,1), 24 + math.Rand(-1,1), Col )

		render.SetMaterial( mat )
		render.DrawSprite( Pos, 100, 100, Col )
	end

	function ENT:Draw( flags )
		self:DrawModel()
	end

	function ENT:OnRemove()
	end

	function ENT:Think()
	end
end
