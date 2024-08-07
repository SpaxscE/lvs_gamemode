
if CLIENT then
	hook.Add( "OnEntityCreated", "deathragdollsetup", function( rag )
		if rag:GetClass() ~= "prop_ragdoll" then return end

		rag.GetPlayer = function( self )
			local owner = self:GetNWEntity("PlayerRagdollOwner" )

			return owner
		end

		rag.GetPlayerColor = function( self ) 
			local owner = self:GetPlayer()

			if IsValid( owner ) then
				return owner:GetPlayerColor()
			end
		end
	end )

	return
end

local meta = FindMetaTable( "Player" )

function meta:GetRagdollSV()
	return self._ragdollSV
end

function meta:CreateRagdollSV( dmginfo )
	if IsValid( self._ragdollSV ) then
		self._ragdollSV:Remove()
	end

	local vel = self:GetVelocity()

	local rag = ents.Create( "prop_ragdoll" )
	rag:SetModel( self:GetModel() )
	rag:SetPos( self:GetPos() )
	rag:SetAngles( self:GetAngles() )
	rag:SetColor( self:GetColor() )
	rag:SetSkin( self:GetSkin() )
	rag:Spawn()
	rag:Activate()

	rag:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

	rag:SetNWEntity("PlayerRagdollOwner", self )

	for i = 1, rag:GetPhysicsObjectCount() do
		local bone = rag:GetPhysicsObjectNum( i )
		if IsValid( bone ) then
			local pos, ang = self:GetBonePosition( rag:TranslatePhysBoneToBone( i ) )
			bone:SetPos( pos )
			bone:SetAngles( ang )

			bone:AddVelocity( vel )
		end
	end

	for i = 0, 11 do rag:SetBodygroup( i, self:GetBodygroup( i ) ) end

	self:Spectate( OBS_MODE_CHASE )
	self:SpectateEntity( rag )

	self._ragdollSV = rag

	if dmginfo:IsDamageType( DMG_DISSOLVE ) then
		local dissolver = ents.Create("env_entity_dissolver")
		dissolver:SetMoveParent( rag )
		dissolver:SetSaveValue("m_flStartTime",0)
		dissolver:Spawn()
		dissolver:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)

		rag:SetSaveValue("m_flDissolveStartTime",0)
		rag:SetSaveValue("m_hEffectEntity",dissolver)
		rag:AddFlags(FL_DISSOLVING)

		for i = 1, rag:GetPhysicsObjectCount() do
			local bone = rag:GetPhysicsObjectNum( i )
			if IsValid( bone ) then
				bone:EnableGravity( false )
			end
		end
	end

	if dmginfo:IsDamageType( DMG_SHOCK ) then
		rag:Fire("StartRagdollBoogie")

		for i = 1, 30 do
			timer.Simple( i * math.Rand(0.1,0.3), function()
				if not IsValid( rag ) then return end

				local effect = EffectData()
				effect:SetEntity( rag )
				effect:SetMagnitude(30)
				effect:SetScale(30)
				effect:SetRadius(30)
				util.Effect("TeslaHitBoxes", effect)

				rag:EmitSound("Weapon_StunStick.Activate")
			end )
		end
	end
end

function meta:RemoveRagdollSV()
	if not IsValid( self._ragdollSV ) then return end

	self._ragdollSV:SetRenderFX( kRenderFxFadeFast  )

	timer.Simple(0.5, function()
		if not IsValid( self ) then return end

		if IsValid( self._ragdollSV ) then
			self._ragdollSV:Remove()
		end
	end)
end