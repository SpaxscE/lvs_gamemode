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
	--PrintChat( self:GetClassName() )
end

function PANEL:DoRightClick()
end

function PANEL:OpenMenu()
end

function PANEL:OnDepressionChanged( b )
end

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

	else

		surface.SetMaterial( matOverlay_Normal )
		self.Label:Show()

	end

	surface.DrawTexturedRect( self.Border, self.Border, w-self.Border*2, h-self.Border*2 )

	if self:GetAdminOnly() then
		surface.SetMaterial( matOverlay_AdminOnly )
		surface.DrawTexturedRect( self.Border + 8, self.Border + 8, 16, 16 )
	end
end

function PANEL:PaintOver( w, h )

	self:DrawSelections()

end

vgui.Register( "DButtonLVS", PANEL, "DButton" )