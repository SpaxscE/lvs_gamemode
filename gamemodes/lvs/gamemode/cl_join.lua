local blur = Material("pp/blurscreen")

function GM:OpenJoinMenu()
	local ply = LocalPlayer()

	self:CloseJoinMenu()

	local X = ScrW()
	local Y = ScrH()

	local Canvas = vgui.Create("DPanel")
	Canvas:SetPos( 0, 0 )
	Canvas:SetSize( X, Y )
	Canvas.Paint = function(self, w, h )
		surface.SetMaterial( blur )

		blur:SetFloat( "$blur", 5 )
		blur:Recompute()

		if render then render.UpdateScreenEffectTexture() end

		surface.SetDrawColor( 255, 255, 255, 255 )

		surface.DrawTexturedRect( 0, 0, w, h )
	end

	self.JoinBar = Canvas

	local TopBar = vgui.Create("DPanel", Canvas )
	TopBar:SetSize( 1, 25 )
	TopBar:Dock( TOP )
	TopBar.Paint = function(self, w, h )
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		surface.DrawRect(0, 0, w, h)
	
		surface.SetDrawColor( LVS.ThemeColor )
		surface.DrawRect(1, 1, w - 2, h - 2)

		draw.SimpleText( "[LVS] - Tournament", "LVS_FONT", 5, 11, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

	local TopBarClose = vgui.Create( "DButton", TopBar )
	TopBarClose:SetText( "CLOSE" )
	TopBarClose:SetSize( 50, 25 )
	TopBarClose:Dock( RIGHT )
	TopBarClose:DockMargin( 0, 0, 0, 0 )
	function TopBarClose:DoClick()
		GAMEMODE:CloseJoinMenu()
	end

	local PaddingW = (X - 400) * 0.5
	local PaddingH = (Y - 25 - 300) * 0.5

	local MainCanvas = vgui.Create("DPanel", Canvas )
	MainCanvas:Dock( FILL )
	MainCanvas:DockPadding( PaddingW, PaddingH, PaddingW, PaddingH )
	MainCanvas:SetPaintBackground( false )

	local CenterMenu = vgui.Create("DPanel", MainCanvas )
	CenterMenu:Dock( FILL )
	CenterMenu:DockPadding( 1, 1, 1, 1 )
	CenterMenu.Paint = function(self, w, h )
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		surface.DrawRect(0, 0, w, h)
	end

	local CenterTop = vgui.Create("DPanel", CenterMenu )
	CenterTop:Dock( TOP )
	CenterTop:SetSize( 400, 200 )
	CenterTop:SetPaintBackground( false )

	local CenterBottom = vgui.Create("DPanel", CenterMenu )
	CenterBottom:Dock( BOTTOM )
	CenterBottom:SetSize( 400, 98 )
	CenterBottom:SetPaintBackground( false )

	local ButtonTeam1 = vgui.Create( "DButton", CenterTop )
	ButtonTeam1:SetSize( 199, 98 )
	ButtonTeam1:SetText( "Join Team 1" )
	ButtonTeam1:Dock( LEFT )
	function ButtonTeam1:DoClick()
		GAMEMODE:CloseJoinMenu()

		RunConsoleCommand( "changeteam", 1 )
	end

	local ButtonTeam2 = vgui.Create( "DButton", CenterTop )
	ButtonTeam2:SetSize( 199, 98 )
	ButtonTeam2:SetText( "Join Team 2" )
	ButtonTeam2:Dock( RIGHT )
	function ButtonTeam2:DoClick()
		GAMEMODE:CloseJoinMenu()

		RunConsoleCommand( "changeteam", 2 )
	end

	local ButtonSpectate = vgui.Create( "DButton", CenterBottom )
	ButtonSpectate:SetText( "SPECTATE" )
	ButtonSpectate:Dock( FILL )
	function ButtonSpectate:DoClick()
		GAMEMODE:CloseJoinMenu()

		RunConsoleCommand( "changeteam", TEAM_SPECTATOR )
	end

	gui.EnableScreenClicker( true )
end

function GM:CloseJoinMenu()
	gui.EnableScreenClicker( false )

	if IsValid( self.JoinBar ) then
		self.JoinBar:Remove()
	end
end
