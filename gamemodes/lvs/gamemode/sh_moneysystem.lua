
local meta = FindMetaTable( "Player" )

function meta:GetMoney()
	return self:GetNWFloat("PlayerMoney", 0)
end

function meta:CanAfford( price )
	if not isnumber( price ) then return true end

	return self:GetMoney() >= price
end

if CLIENT then
	local MoneyTime = 0
	local MoneyNextSound = 0
	local OldMoney = 0
	local MoneyDifference = 0
	local MoneyDifferenceTime = 0
	local smMoneyVisible = 0
	local smMoney = 0
	local smMoneyOld = 0

	local Price = 0
	local PriceTime = 0
	function meta:CanAfford( price )
		if not isnumber( price ) then return true end

		local T =  CurTime()

		MoneyTime = T + 5
		PriceTime = T + 5

		Price = price

		return self:GetMoney() >= price
	end

	hook.Add( "PlayerBindPress", "lvs_show_moneyinfo", function( ply, bind, pressed )
		if string.find( bind, "+showscores" ) then 
			MoneyTime = CurTime() + 5
		end
	end )

	local function DrawPlayerMoney( X, Y, ply )
		local Money = ply:GetMoney()

		local FT = RealFrameTime()
		local T = CurTime()

		if OldMoney ~= Money then

			MoneyDifference = Money - OldMoney

			ply:EmitSound("lvs/tournament/store_buy.wav", 140, 100, 0.25)

			OldMoney = Money

			MoneyTime = T + 5
			MoneyDifferenceTime = T + 5
		end

		local Rate = FT * math.max( Money, smMoney, 150 )

		smMoney = smMoney + math.Clamp(Money - smMoney,-Rate,Rate)
		smMoneyVisible = smMoneyVisible + (((MoneyTime > T) and 1 or 0) - smMoneyVisible) * FT * 5

		if smMoney ~= smMoneyOld then
			smMoneyOld = smMoney

			MoneyTime = CurTime() + 5

			if MoneyNextSound < CurTime() then
				MoneyNextSound = CurTime() + 0.075
				ply:EmitSound("buttons/lightswitch2.wav",75,100,0.25)
			end
		end

		if smMoneyVisible < 0 then return end

		local ColorMoney = Color(255,191,0,255 * smMoneyVisible)

		local absMoneyDifference = math.abs( MoneyDifference )

		if PriceTime > T then
			if Price == 0 then
				local ColorPrice = Color(0,255,0,255 * smMoneyVisible)
	
				draw.DrawText( "Free", "LVS_FONT", X + 40, Y - 50, ColorPrice, TEXT_ALIGN_LEFT )
			else
				if Price > Money then
					local ColorPrice = Color(255,0,0,255 * smMoneyVisible)

					draw.DrawText( "- ", "LVS_FONT", X + 40, Y - 50, ColorPrice, TEXT_ALIGN_RIGHT )
					draw.DrawText( Price, "LVS_FONT", X + 40, Y - 50, ColorPrice, TEXT_ALIGN_LEFT )
				else
					local ColorPrice = Color(0,255,0,255 * smMoneyVisible)

					draw.DrawText( "- ", "LVS_FONT", X + 40, Y - 50, ColorPrice, TEXT_ALIGN_RIGHT )
					draw.DrawText( Price, "LVS_FONT", X + 40, Y - 50, ColorPrice, TEXT_ALIGN_LEFT )
				end
			end
		end

		if MoneyDifferenceTime > T and abMoneyDifference ~= 0 then
			if MoneyDifference > 0 then
				local Col = Color(0,255,0,255 * smMoneyVisible)
				draw.DrawText( "+ ", "LVS_FONT", X + 40, Y - 33, Col, TEXT_ALIGN_RIGHT )
				draw.DrawText( absMoneyDifference, "LVS_FONT", X + 40, Y - 33, Col, TEXT_ALIGN_LEFT )
			else
				local Col = Color(255,0,0,255 * smMoneyVisible)
				draw.DrawText( "- ", "LVS_FONT", X + 40, Y - 33, Col, TEXT_ALIGN_RIGHT )
				draw.DrawText( absMoneyDifference, "LVS_FONT", X + 40, Y - 33, Col, TEXT_ALIGN_LEFT )
			end
		end

		draw.DrawText( "$ ", "LVS_FONT_HUD_LARGE", X + 38, Y - 15, ColorMoney, TEXT_ALIGN_RIGHT )
		draw.DrawText( math.Round( smMoney , 0 ), "LVS_FONT_HUD_LARGE", X + 38, Y - 15, ColorMoney, TEXT_ALIGN_LEFT )
	end

	function GM:DrawPlayerMoney( ply )
		DrawPlayerMoney( -200 + 250 * math.sin( math.rad( (smMoneyVisible ^ 2) * 120 ) ), ScrH() * 0.5, ply )
	end

	return
end

function meta:AddMoney( amount )
	if not isnumber( amount ) then return end

	self:SetNWFloat("PlayerMoney", math.max(self:GetMoney() + amount,0) )
end

function meta:TakeMoney( amount )
	if not isnumber( amount ) then return end

	self:AddMoney( amount * -1 )
end