include( "shared.lua" )

local BuyMenu

local function BuildBuyMenu()
	if IsValid( BuyMenu ) then return BuyMenu end

	local FrameX = math.min( ScrW(), 1200 )
	local FrameY = math.min( ScrH(), 800 )

	BuyMenu = vgui.Create("DFrame")
	BuyMenu:SetSize( FrameX, FrameY )
	BuyMenu:Center()
	BuyMenu:SetTitle("")
	BuyMenu:SetDraggable( false )
	BuyMenu:ShowCloseButton( false )
	BuyMenu:DockPadding(0,0,0,0)

	local CategoryPanel = vgui.Create( "DPanel", BuyMenu )
	CategoryPanel:SetSize(FrameX * 0.25,FrameY)
	CategoryPanel:Dock( LEFT )
	CategoryPanel:DockMargin(0,0,0,0)
	CategoryPanel:DockPadding(10,10,5,10)
	CategoryPanel.Paint = function(self, w, h )
	end

	local MainPanel = vgui.Create( "DPanel", BuyMenu )
	MainPanel:SetSize(FrameX * 0.75,FrameY)
	MainPanel:Dock( RIGHT )
	MainPanel:DockMargin(0,0,0,0)
	MainPanel:DockPadding(5,10,10,10)
	MainPanel.Paint = function(self, w, h )
	end

	local ContentPanel = vgui.Create( "DScrollPanel", MainPanel )
	ContentPanel:Dock( FILL )
	ContentPanel.Paint = function(self, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, color_white )
	end
	function ContentPanel:SetContent( Vehicles )
		self:GetCanvas():Clear()

		for i=1, #Vehicles do
			local DButton = ContentPanel:Add( "DButton" )
			DButton:SetText( Vehicles[ i ] )
			DButton:Dock( TOP )
			DButton:DockMargin( 0, 0, 0, 5 )
			--https://wiki.facepunch.com/gmod/ContentIcon
			--https://wiki.facepunch.com/gmod/DTileLayout
		end
	end

	local lvsNode  = vgui.Create( "DTree", CategoryPanel )
	lvsNode:Dock( FILL )
	lvsNode.Paint = function(self, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, color_white )
	end

	local CategoryNameTranslate = {}
	local Categorised = {}
	local SubCategorised = {}

	local SpawnableEntities = table.Copy( list.Get( "SpawnableEntities" ) )
	local Variants = {
		[1] = "[LVS] - ",
		[2] = "[LVS] -",
		[3] = "[LVS]- ",
		[4] = "[LVS]-",
		[5] = "[LVS] ",
	}

	for _, v in pairs( scripted_ents.GetList() ) do
		if not v.t or not v.t.ClassName or not v.t.VehicleCategory then continue end

		if not isstring( v.t.ClassName ) or v.t.ClassName == "" or not SpawnableEntities[ v.t.ClassName ] then continue end

		SpawnableEntities[ v.t.ClassName ].Category = "[LVS] - "..v.t.VehicleCategory

		if not v.t.VehicleSubCategory then continue end

		SpawnableEntities[ v.t.ClassName ].SubCategory = v.t.VehicleSubCategory
	end

	if SpawnableEntities then
		for k, v in pairs( SpawnableEntities ) do

			local Category = v.Category

			if not isstring( Category ) then continue end

			if not Category:StartWith( "[LVS]" ) and not v.LVS then continue end

			v.SpawnName = k

			for _, start in pairs( Variants ) do
				if Category:StartWith( start ) then
					local NewName = string.Replace(Category, start, "")
					CategoryNameTranslate[ NewName ] = Category
					Category = NewName

					break
				end
			end

			if v.SubCategory then
				SubCategorised[ Category ] = SubCategorised[ Category ] or {}
				SubCategorised[ Category ][ v.SubCategory ] = SubCategorised[ Category ][ v.SubCategory ] or {}

				table.insert( SubCategorised[ Category ][ v.SubCategory ], v )
			end

			Categorised[ Category ] = Categorised[ Category ] or {}

			table.insert( Categorised[ Category ], v )
		end
	end

	local IconList = list.Get( "ContentCategoryIcons" )

	for CategoryName, v in SortedPairs( Categorised ) do
		if CategoryName:StartWith( "[LVS]" ) then continue end

		local Icon = "icon16/lvs_noicon.png"

		if IconList and IconList[ CategoryNameTranslate[ CategoryName ] ] then
			Icon = IconList[ CategoryNameTranslate[ CategoryName ] ]
		end

		local node = lvsNode:AddNode( CategoryName, Icon )
		node.DoClick = function( self )
			local Vehicles = {}
			local Index = 1

			for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
				if ent.SubCategory then
					continue
				end

				Vehicles[ Index ] = ent.ClassName
				Index = Index + 1
			end

			ContentPanel:SetContent( Vehicles )
		end

		local SubCat = SubCategorised[ CategoryName ]

		if not SubCat then continue end

		for SubName, data in SortedPairs( SubCat ) do

			local SubIcon = "icon16/lvs_noicon.png"

			if IconList then
				if IconList[ "[LVS] - "..CategoryName.." - "..SubName ] then
					SubIcon = IconList[ "[LVS] - "..CategoryName.." - "..SubName ]
				else
					if IconList[ "[LVS] - "..SubName ] then
						SubIcon = IconList[ "[LVS] - "..SubName ]
					end
				end
			end

			local subnode = node:AddNode( SubName, SubIcon )
			subnode.DoClick = function( self )
				local Vehicles = {}
				local Index = 1
				for k, ent in SortedPairsByMemberValue( data, "PrintName" ) do
					Vehicles[ Index ] = ent.ClassName
					Index = Index + 1
				end

				ContentPanel:SetContent( Vehicles )
			end
		end
	end

	return BuyMenu
end

function GM:OpenBuyMenu()
	gui.EnableScreenClicker( true )

	BuildBuyMenu():SetVisible( true )
end

function GM:CloseBuyMenu()
	if not IsValid( BuyMenu ) then return end

	gui.EnableScreenClicker( false )

	BuyMenu:SetVisible( false )
end