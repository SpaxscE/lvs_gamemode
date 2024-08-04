AddCSLuaFile()

ENT.Type            = "anim"

ENT.Spawnable		= false
ENT.AdminOnly		= false

ENT.RenderGroup = RENDERGROUP_BOTH 

function ENT:UpdateTransmitState() 
	return TRANSMIT_ALWAYS
end

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
	end
end

if CLIENT then
	local ColFriend = Color(0,127,255,255)
	local ColEnemy = Color(255,0,0,255)

	local mat = Material( "sprites/light_glow02_add" )
	function ENT:DrawTranslucent()
		self:DrawModel( flags )

		local pos = self:GetPos()
		local endpos = self:LocalToWorld( Vector(0,0,14) )

		local Col = self:GetAITEAM() ~= LocalPlayer():lvsGetAITeam() and ColEnemy or ColFriend

		render.SetMaterial( mat )
		render.DrawSprite( pos, 30, 30, Col )
		render.DrawSprite( endpos, 100, 100, Col )
	end

	local RING = Material( "effects/select_ring" )
	function ENT:Draw()
		local pos = self:GetPos()

		local Col = self:GetAITEAM() ~= LocalPlayer():lvsGetAITeam() and ColEnemy or ColFriend

		if (self.NextPing or 0) < CurTime() then
			self.NextPing = CurTime() + 3
			self.WaveScale = 1
			self:EmitSound( "npc/combine_gunship/ping_search.wav",90,80,0.25 )
		end

		if (self.WaveScale or 0) > 0 then
			self.WaveScale = math.max( self.WaveScale - FrameTime(), 0 )
			local InvScale = 1 - self.WaveScale

			cam.Start3D2D( self:GetPos() + Vector(0,0,10), self:LocalToWorldAngles( Angle(0,-90,0) ), 1 )
				surface.SetDrawColor( Col.r, Col.g, Col.b, 255 * self.WaveScale )
				surface.SetMaterial( RING )
				surface.DrawTexturedRectRotated( 0, 0, 256 * InvScale, 256 * InvScale, 0 )
			cam.End3D2D()
		end
	end

	function ENT:OnRemove()
	end

	function ENT:Think()
	end
end
