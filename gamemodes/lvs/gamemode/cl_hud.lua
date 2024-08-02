
local hud = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true
}

function GM:HUDShouldDraw( name )

	if hud[name] then return false end

	return self.BaseClass.HUDShouldDraw(self, name)
end
