
AddCSLuaFile()

DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables( self )

end

function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()

	self.Player:Give( "weapon_lvs" )
	self.Player:Give( "weapon_lvsrepair" )

	self.Player:SwitchToDefaultWeapon()

end

player_manager.RegisterClass( "player_lvs", PLAYER, "player_default" )
