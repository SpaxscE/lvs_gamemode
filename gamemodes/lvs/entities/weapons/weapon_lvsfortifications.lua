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

list.Set("Fortifications", "sandbags", {
	Name = "Sandbags",
	Class = "lvs_fortification_playerblocker",
	Model = "models/props_fortifications/sandbags_line1_tall.mdl",
	GibModels = {
		"models/props_fortifications/sandbag.mdl",
		"models/props_fortifications/sandbag.mdl",
		"models/props_fortifications/sandbag.mdl",
		"models/props_fortifications/sandbag.mdl",
		"models/props_fortifications/sandbag.mdl",
		"models/props_fortifications/sandbag.mdl",
		"models/props_fortifications/sandbag.mdl",
	},
	BreakSounds = {
		"physics/cardboard/cardboard_box_break1.wav",
		"physics/cardboard/cardboard_box_break2.wav",
		"physics/cardboard/cardboard_box_break3.wav",
	},
	Price = 50,
	Health = 2000,
})

list.Set("Fortifications", "hedgehog", {
	Name = "Hedgehog",
	Class = "lvs_fortification_vehicleblocker",
	Model = "models/props_fortifications/hedgehog_small1.mdl",
	GibModels = {
		"models/props_fortifications/hedgehog_small1_gib1.mdl",
		"models/props_fortifications/hedgehog_small1_gib2.mdl",
		"models/props_fortifications/hedgehog_small1_gib3.mdl",
	},
	BreakSounds = {
		"physics/metal/metal_box_break1.wav",
		"physics/metal/metal_box_break2.wav",
	},
	Health = 1000,
	Price = 200,
})

list.Set("Fortifications", "dragonsteeth", {
	Name = "Dragon's teeth",
	Class = "lvs_fortification_vehicleblocker",
	Model = "models/diggercars/props/dragonsteeth.mdl",
	GibModels = {
		"models/props_junk/rock001a.mdl",
		"models/props_combine/breenbust_chunk05.mdl",
		"models/props_combine/breenbust_chunk06.mdl",
		"models/props_combine/breenbust_chunk07.mdl",
		"models/props_debris/concrete_spawnchunk001d.mdl",
		"models/props_debris/rebar004a_32.mdl",
	},
	BreakSounds = {
		"physics/concrete/boulder_impact_hard1.wav",
		"physics/concrete/boulder_impact_hard2.wav",
		"physics/concrete/boulder_impact_hard3.wav",
		"physics/concrete/boulder_impact_hard4.wav",
	},
	Health = 6000,
	Price = 100,
})

list.Set("Fortifications", "wirefence", {
	Name = "Wire Fence",
	Class = "lvs_fortification_playerblocker",
	Model = "models/diggercars/props/wire_test.mdl",
	GibModels = {
		"models/props_debris/rebar001a_32.mdl",
		"models/props_debris/rebar001b_48.mdl",
		"models/props_debris/rebar001c_64.mdl",
		"models/props_debris/rebar_cluster001a.mdl",
		"models/props_debris/wood_chunk02a.mdl",
		"models/props_debris/wood_chunk02b.mdl",
	},
	BreakSounds = {
		"physics/metal/metal_chainlink_impact_soft1.wav",
		"physics/metal/metal_chainlink_impact_soft2.wav",
		"physics/metal/metal_chainlink_impact_soft3.wav",
	},
	Price = 25,
	Health = 100,
})

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 1, "NumIndex" )
	self:NetworkVar( "String", 1, "Item" )

	if SERVER then
		self:SetNumIndex( 1 )
	end
end

function SWEP:GetObjectList()
	if istable( self._ObjectList ) then return self._ObjectList end

	self._ObjectList = list.Get( "Fortifications" )

	return self._ObjectList
end

function SWEP:GetCurrentObject()
	return self:GetObjectList()[ self:GetItem() ]
end

function SWEP:GetTrace()
	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	local Trace = ply:GetEyeTrace()

	local SpawnAllowed = (Trace.HitPos - ply:GetShootPos()):Length() < self.SpawnDistance

	return Trace, SpawnAllowed
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

	function SWEP:GetPreviewGhost()
		if IsValid( PreviewGhost ) then
			return PreviewGhost
		end

		PreviewGhost = ClientsideModel( "models/error.mdl" )
		PreviewGhost:SetMaterial( "lights/white" )
		PreviewGhost:SetRenderMode( RENDERMODE_TRANSCOLOR )
		PreviewGhost:SetNoDraw( true )

		return PreviewGhost
	end

	local oldallowed

	function SWEP:Think()
		local Object = self:GetCurrentObject()
		local ply = self:GetOwner()

		if not IsValid( ply ) or not Object then return end

		if not Object.Model or Object.Model == "" then return end

		local Ghost = self:GetPreviewGhost()

		local trace, allowed = self:GetTrace()

		if Ghost:GetModel() ~= Object.Model then
			Ghost:SetModel( Object.Model )
			Ghost:SetNoDraw( false )
			oldallowed = nil
		end

		local CanAfford = ply:CanAfford( Object.Price )

		if not CanAfford then allowed = false end

		if allowed ~= oldallowed then
			oldallowed = allowed

			if allowed then
				Ghost:SetColor( Color(255,255,255,150) )
			else
				Ghost:SetColor( Color(255,0,0,100) )
			end
		end

		Ghost:SetPos( trace.HitPos )
		Ghost:SetAngles( Angle(0, ply:EyeAngles().y, 0 ) )
	end

	function SWEP:Deploy()
		self:SendWeaponAnim( ACT_VM_DEPLOY )

		self:GetPreviewGhost():SetNoDraw( false )

		return true
	end

	function SWEP:Holster( wep )
		self:GetPreviewGhost():SetNoDraw( true )

		return true
	end

	function SWEP:OnRemove()
		self:GetPreviewGhost():SetNoDraw( true )
	end

	function SWEP:OnDrop()
		self:GetPreviewGhost():SetNoDraw( false )
	end
else
	function SWEP:Think()
		local ply = self:GetOwner()

		if not IsValid( ply ) then return end

		local Reload = ply:KeyDown( IN_RELOAD )

		if self._oldReload == Reload then return end

		self._oldReload = Reload

		if not Reload then return end

		local trace, allowed = self:GetTrace()
	
		local target = trace.Entity

		if not IsValid( target ) or not target.IsFortification or target:GetCreatedBy() ~= ply then return end

		if SERVER then
			if isnumber( target.ReturnMoney ) then
				ply:AddMoney( target.ReturnMoney )
			end

			target:Remove()
		end

		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		ply:SetAnimation( PLAYER_ATTACK1 )
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

	if CLIENT then return end

	local Object = self:GetCurrentObject()

	if not Object or not Object.Class or not Object.Model or Object.Model == "" then return end

	local trace, allowed = self:GetTrace()

	if not allowed then return end

	if not ply:CanAfford( Object.Price ) then return end

	ply:TakeMoney( Object.Price )

	local Ent = ents.Create( Object.Class )
	Ent:SetModel( Object.Model )
	Ent:SetPos( trace.HitPos )
	Ent:SetAngles( Angle(0, ply:EyeAngles().y, 0 ) )
	Ent:Spawn()
	Ent:Activate()

	Ent:SetCreatedBy( ply )

	Ent.ReturnMoney = Object.Price

	if Object.GibModels then
		Ent.GibModels = Object.GibModels
	end

	if Object.BreakSounds then
		Ent.BreakSounds = Object.BreakSounds
	end

	if Object.Health and Ent.SetHP and Ent.SetMaxHP then
		Ent:SetHP( Object.Health )
		Ent:SetMaxHP( Object.Health )
	end
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
	end
end

function SWEP:Reload()
end
