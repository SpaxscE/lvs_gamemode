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
		self:SetModel( "models/maxofs2d/hover_plate.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		self:SetUseType( SIMPLE_USE )

		local PObj = self:GetPhysicsObject()

		if not IsValid( PObj ) then 
			self:Remove()

			return
		end

		PObj:EnableMotion( false )
	end

	function ENT:Use( ply )
		if ply:lvsGetAITeam() ~= self:GetAITEAM() then return end

		local Weapon = ply:GetActiveWeapon()

		if not IsValid( Weapon ) then return end

		local Class = Weapon:GetClass()

		ply:SetSuppressPickupNotices( true )

		ply:StripWeapons()
		ply:RemoveAllAmmo()

		hook.Call( "PlayerLoadout", GAMEMODE, ply )

		ply:SetSuppressPickupNotices( false )

		ply:SelectWeapon( Class )
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

	local ring = Material( "effects/select_ring" )
	local mat = Material( "sprites/light_glow02_add" )

	function ENT:GetTeamColor()
		if self:GetAITEAM() ~= LocalPlayer():lvsGetAITeam() then return ColEnemy end

		return ColFriend
	end

	local Mat = Material( "lvs/3d2dmats/refil.png" )

	function ENT:DrawTranslucent( flags )
		local Col = self:GetTeamColor()

		local Pos = self:LocalToWorld( Vector(0,0,20) )

		render.SetMaterial( ring )
		render.DrawSprite( Pos, 24 + math.Rand(-1,1), 24 + math.Rand(-1,1), Col )

		render.SetMaterial( mat )
		render.DrawSprite( Pos, 100, 100, Col )

		local ply = LocalPlayer()

		if not IsValid( ply ) or ply:InVehicle() then return end

		if ply:lvsGetAITeam() ~= self:GetAITEAM() then return end

		for i = 0, 1 do
			cam.Start3D2D( Pos, self:LocalToWorldAngles( Angle(0,180 * i + CurTime() * 100,90) ), 0.2 )
				surface.SetDrawColor( color_white )

				surface.SetMaterial( Mat )
				surface.DrawTexturedRect( -100, -100, 200, 200 )
			cam.End3D2D()
		end
	end

	function ENT:Draw( flags )
		self:DrawModel()
	end

	function ENT:OnRemove()
	end

	function ENT:Think()
	end
end
