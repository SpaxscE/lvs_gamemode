
AddCSLuaFile()

DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.SlowWalkSpeed		= 100
PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 400

PLAYER.CrouchedWalkSpeed	= 0.3		-- Multiply move speed by this when crouching

PLAYER.DuckSpeed			= 0.1		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.1		-- How fast to go from ducking, to not ducking

PLAYER.JumpPower			= 200		-- How powerful our jump should be
PLAYER.CanUseFlashlight		= true		-- Can we use the flashlight
PLAYER.MaxHealth			= 100		-- Max health we can have
PLAYER.MaxArmor				= 100		-- Max armor we can have
PLAYER.StartHealth			= 100		-- How much health we start with
PLAYER.StartArmor			= 0			-- How much armour we start with
PLAYER.DropWeaponOnDie		= false		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide	= true		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= true		-- Automatically swerves around other players
PLAYER.UseVMHands			= true		-- Uses viewmodel hands

PLAYER.TauntCam = TauntCamera()

function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables( self )

end

function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()

	self.Player:Give( "weapon_lvs" )
	self.Player:Give( "weapon_lvsrepair" )

	self.Player:SwitchToDefaultWeapon()

end

function PLAYER:ShouldDrawLocal()

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

function PLAYER:CreateMove( cmd )

	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

function PLAYER:CalcView( view )

	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

	-- Your stuff here

end

local JUMPING

function PLAYER:StartMove( move )
	if bit.band( move:GetButtons(), IN_JUMP ) ~= 0 and bit.band( move:GetOldButtons(), IN_JUMP ) == 0 and self.Player:OnGround() and not self.Player:InVehicle() then
		JUMPING = true
	end
end

function PLAYER:FinishMove( move )

	if JUMPING then
		local forward = move:GetAngles()
		forward.p = 0
		forward = forward:Forward()

		local speedBoostPerc = ( ( not self.Player:Crouching() ) and 0.5 ) or 0.1
		local speedAddition = math.abs( move:GetForwardSpeed() * speedBoostPerc )
		local maxSpeed = move:GetMaxSpeed() * ( 1 + speedBoostPerc )
		local newSpeed = speedAddition + move:GetVelocity():Length2D()
		
		if newSpeed > maxSpeed then
			if move:GetVelocity():Dot(forward) < 0 then -- neu
				speedAddition = speedAddition - (newSpeed - maxSpeed)
			else
				speedAddition = speedAddition + (newSpeed - maxSpeed) -- neu
			end
		end

		if move:GetForwardSpeed() < 0 then
			speedAddition = -speedAddition
		end

		move:SetVelocity(forward * speedAddition + move:GetVelocity())
	end

	JUMPING = nil

end

player_manager.RegisterClass( "player_lvs", PLAYER, "player_default" )
