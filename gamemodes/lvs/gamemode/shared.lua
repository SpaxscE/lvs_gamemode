GM.Name = "LVS-Tournament"
GM.Author = "Luna"
GM.Email = "juliewerding@gmx.de"
GM.Website = "https://discord.gg/BeVtn7uwNH"

DeriveGamemode( "base" )

include( "player_class/player_lvs.lua" )
include( "sh_moneysystem.lua" )

function GM:Initialize()
	LVS.HudForceDefault = true
	LVS.FreezeTeams = true
	LVS.TeamPassenger = true

	cvars.RemoveChangeCallback( "lvs_freeze_teams", "lvs_freezeteams_callback" )
	cvars.RemoveChangeCallback( "lvs_teampassenger", "lvs_teampassenger_callback" )
end

GM.VehiclePrices = {}

function GM:InitPostEntity()
	self:BuildVehiclePrices()
end

function GM:GetVehiclePrice( class )
	if not self.VehiclePrices[ class ] then return 0 end

	return self.VehiclePrices[ class ]
end

function GM:BuildVehiclePrices()
	for s, v in pairs( scripted_ents.GetList() ) do
		if not v.t or not v.t.VehicleCategory then continue end

		local IgnoreForce = v.t.DSArmorIgnoreForce
		local MaxHealth = v.t.MaxHealth
		local MaxShield = v.t.MaxShield
		local MaxVelocity = v.t.MaxVelocity

		if (not MaxHealth or not MaxVelocity) and v.t.Base then
			local Base = scripted_ents.GetList()[ v.t.Base ].t

			if Base then
				if not IgnoreForce then
					IgnoreForce = Base.DSArmorIgnoreForce
				end

				if not MaxHealth then
					MaxHealth = Base.MaxHealth
				end

				if not MaxShield then
					MaxShield = Base.MaxShield
				end

				if not MaxVelocity then
					MaxVelocity = Base.MaxVelocity
				end
			end
		end

		IgnoreForce = IgnoreForce or 0
		MaxHealth = MaxHealth or 0
		MaxShield = MaxShield or 0
		MaxVelocity = MaxVelocity or 0
	
		self.VehiclePrices[s] = math.Round( IgnoreForce * 0.25 + (MaxHealth + MaxShield * 1.5) * 0.25 + MaxVelocity * 0.1, 0 )
	end
end