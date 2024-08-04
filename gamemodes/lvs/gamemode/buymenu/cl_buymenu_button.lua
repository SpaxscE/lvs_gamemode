local PANEL = {}

local matOverlay_Normal = Material( "gui/ContentIcon-normal.png" )
local matOverlay_Hovered = Material( "gui/ContentIcon-hovered.png" )

local matOverlay_AdminOnly = Material( "icon16/shield.png" )

AccessorFunc( PANEL, "m_Color", "Color" )
AccessorFunc( PANEL, "m_SpawnName", "SpawnName" )
AccessorFunc( PANEL, "m_ClassName", "ClassName" )
AccessorFunc( PANEL, "m_bAdminOnly", "AdminOnly" )

function PANEL:Init()

	self:SetPaintBackground( false )
	self:SetSize( 128, 128 )
	self:SetText( "" )
	self:SetDoubleClickingEnabled( false )

	self.Image = self:Add( "DImage" )
	self.Image:SetPos( 3, 3 )
	self.Image:SetSize( 128 - 6, 128 - 6 )
	self.Image:SetVisible( false )

	self.Label = self:Add( "DLabel" )
	self.Label:Dock( BOTTOM )
	self.Label:SetTall( 18 )
	self.Label:SetContentAlignment( 5 )
	self.Label:DockMargin( 4, 0, 4, 6 )
	self.Label:SetTextColor( color_white )
	self.Label:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )

	self.Border = 0

end

function PANEL:SetPrice( price )

	self.m_VehiclePrice = price

end

function PANEL:GetPrice( price )
	if not isnumber( self.m_VehiclePrice ) then return 0 end

	return self.m_VehiclePrice
end

function PANEL:SetName( name )

	self:SetTooltip( name )
	self.Label:SetText( name )
	self.m_NiceName = name

end

function PANEL:SetMaterial( name )

	self.m_MaterialName = name

	local mat = Material( name )

	if not mat or mat:IsError() then

		name = name:Replace( "entities/", "VGUI/entities/" )
		name = name:Replace( ".png", "" )
		mat = Material( name )

		return
	end

	self.Image:SetMaterial( mat )
end

function PANEL:DoClick()
	GAMEMODE:CloseBuyMenu()

	net.Start( "lvs_buymenu" )
		net.WriteString( self:GetClassName() )
	net.SendToServer()

	surface.PlaySound( "ui/buttonclickrelease.wav" )
end

function PANEL:DoRightClick()
end

function PANEL:OpenMenu()
end

function PANEL:OnDepressionChanged( b )
end

local ColorPriceA= Color(255,191,0,255)
local ColorPriceB = Color(255,0,0,255)
local ColorPriceC = Color(0,255,0,255)

function PANEL:Paint( w, h )

	if self.Depressed and not self.Dragging then
		if self.Border ~= 8 then
			self.Border = 8
			self:OnDepressionChanged( true )
		end
	else
		if self.Border ~= 0 then
			self.Border = 0
			self:OnDepressionChanged( false )
		end
	end

	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	self.Image:PaintAt( 3 + self.Border, 3 + self.Border, 128 - 8 - self.Border * 2, 128 - 8 - self.Border * 2 )

	render.PopFilterMin()
	render.PopFilterMag()

	surface.SetDrawColor( 255, 255, 255, 255 )

	if not dragndrop.IsDragging() and (self:IsHovered() or self.Depressed or self:IsChildHovered()) then

		surface.SetMaterial( matOverlay_Hovered )
		self.Label:Hide()

		LocalPlayer():CanAfford( GAMEMODE:GetVehiclePrice( self:GetClassName() ) )

	else

		surface.SetMaterial( matOverlay_Normal )
		self.Label:Show()

	end

	local Money = LocalPlayer():GetMoney()
	local Price = self:GetPrice()

	if Price == 0 then

	else
		if Money < Price then
			surface.SetDrawColor( 255, 0, 0, 255 )
		end
	end

	surface.DrawTexturedRect( self.Border, self.Border, w-self.Border*2, h-self.Border*2 )

	if Price == 0 then
		draw.DrawText( "$ ".."Free", "LVS_FONT", self.Border + 10, self.Border + 8, ColorPriceC, TEXT_ALIGN_LEFT )
	else
		if Money < Price then
			draw.DrawText( "$ "..Price, "LVS_FONT", self.Border + 10, self.Border + 8, ColorPriceB, TEXT_ALIGN_LEFT )
		else
			draw.DrawText( "$ "..Price, "LVS_FONT", self.Border + 10, self.Border + 8, ColorPriceA, TEXT_ALIGN_LEFT )
		end
	end

	surface.SetDrawColor( 255, 255, 255, 255 )

	if self:GetAdminOnly() then
		surface.SetMaterial( matOverlay_AdminOnly )
		surface.DrawTexturedRect( self.Border + 8, self.Border + 8, 16, 16 )
	end
end

function PANEL:PaintOver( w, h )

	self:DrawSelections()

end

vgui.Register( "DButtonLVS", PANEL, "DButton" )