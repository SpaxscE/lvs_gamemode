GM.Vehicles = {}
GM.VehiclePrices = {}

function GM:VehicleClassAllowed( class )
	return isbool( self.Vehicles[ class ] )
end

function GM:VehicleClassAdminOnly( class )
	return self.Vehicles[ class ] == true
end

function GM:GetVehiclePrice( class )
	if not self.VehiclePrices[ class ] then return 0 end

	return self.VehiclePrices[ class ]
end

function GM:BuildVehiclePrices()
	for s, v in pairs( scripted_ents.GetList() ) do
		if not v.t or not v.t.VehicleCategory then continue end

		local Spawnable = v.t.Spawnable == true
		local AdminSpawnable = v.t.AdminSpawnable == true

		if not Spawnable then continue end

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

		if v.t.Base == "lvs_base_wheeldrive_trailer" then
			self.VehiclePrices[s] = math.Round( IgnoreForce * 0.05 + (MaxHealth + MaxShield) * 0.15, 0 )
		else
			self.VehiclePrices[s] = math.Round( IgnoreForce * 0.25 + (MaxHealth + MaxShield * 10) * 0.25 + MaxVelocity * 0.1, 0 )
		end

		self.Vehicles[ s ] = AdminSpawnable
	end
end