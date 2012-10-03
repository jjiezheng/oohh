-- oohh menu v3
-- Let's not fuck this one up edition

-- TODO
-- Server information panel
-- History / Favorites Browser
-- Settings
-- Some Other Shit ™

util.MonitorFileInclude()

-- Structure

menu = menu or {}

local sayings = {
	"fascinating!!1",
	"WahhEngine3",
	"got caps for me?",
	"achieved with AowlEngine3",
	"what am i doing",
	"[menu.lua]:" .. math.random( 50, 350 ) .. ": '<eof>' expected near 'oohh'",
	"eek",
	"did that take forever to calculate",
	"oohh im cryeng u dno tn knw whatt m to do wht my lief",
}
local thissaying = sayings[ math.random( 1, #sayings ) ]

-- WARNING REMVOE THIS SHIT WHEN COMPLETE WARNING
if menu.backplate and menu.backplate:IsValid() then
	menu.backplate:Remove()
end

-- Backgrounds

menu.backgrounds = {}

local tab = {}
menu.backgrounds.plain = tab
tab.name = "Plain Background"
tab.desc = "No frills, no spills. Maximum FPS."
tab.author = "Lixquid"
tab.func = function( size )
	graphics.DrawFilledRect( Rect( 0, 0, size ), Color( 0.8, 0.8, 0.8, 1 ) )
end

for filename, filedata in pairs( file.Find( "addons/lixquid/lua/menu_backgrounds/*", true ) ) do
	include( "menu_backgrounds/" .. filename )
end

-- GUI

do -- Backplate
	local texture = Texture( 100, 1 )
	local img = texture:GetPixelTable( true )
	for i = 0, texture:GetLength() do
		img[i].r, img[i].g, img[i].b = 1, 1, 1
		img[i].a = ( 100 - i ) * 1.5
	end
	texture:SetPixelTable( img )
	
	menu.backplate = aahh.Create( "panel" )
	menu.backplate:SetObeyMargin( false )
	menu.backplate:SetPos( Vec2( 0, 0 ) )
	menu.backplate:SetSize( graphics.GetScreenSize() )
	menu.backplate.OnDraw = function( me, size )
		if not MULTIPLAYER then
			menu.backgrounds[ cookies.Get( "background_active", "plain" ) ].func( size )
		end
		graphics.DrawFilledRect( Rect( 0, 0, size ), Color( 0, 0, 0, 0.5 ) )
		graphics.DrawTexture( texture, Rect( 0, 0, 300, size.h ) )
		for i = -1, 1 do
			for j = -1, 1 do
				graphics.DrawText( "oohh", Vec2( 50 + i, 50 + j ), "verdana.ttf", 40, Color( 1, 1, 1, math.abs( math.sin( CurTime() ) * 0.9 + 0.1 ) ) )
			end
		end
		graphics.DrawText( "oohh", Vec2( 50, 50 ), "verdana.ttf", 40, Color( 1, 1, 1, 1 ) )
		graphics.DrawText( thissaying, Vec2( 50, 100 ), "verdana.ttf", 20, Color( 0.8, 0.8, 0.8, 1 ) )
		graphics.DrawFilledRect( Rect( 0, size.h - 40, size.w, 40 ), Color( 0, 0, 0, 0.2 ) )
		graphics.DrawText( "", Vec2( 14, size.h - 22 ), "verdana.ttf", 14, Color( 1, 1, 1, 1 ), Vec2( 0, -0.5 ) )
	end
end

do -- Resume
	local pan = aahh.Create( "button", menu.backplate )
	pan:SetPos( Vec2( 50, 180 ) )
	pan:SetSize( Vec2( 200, 40 ) )
	pan:SetVisible( MULTIPLAYER )
	pan.OnDraw = function( me, size )
		graphics.DrawText( "Resume", Vec2( 12, 20 ), "verdana.ttg", 16, Color( 1, 1, 1, 1 ), Vec2( 0, -0.25 ) )
		if me:IsMouseOver() then
			graphics.DrawOutlinedRect( Rect( 0, 0, size ), 1, Color( 0, 0, 0, 0.3 ) )
			graphics.DrawOutlinedRect( Rect( 1, 1, size - 2 ), 1, Color( 1, 1, 1, 0.1 ) )
		end
	end
	pan.OnPress = function()
		console.RunString( "o toggle_menu", true, true )
	end
end

do -- Connect (and co.)
	local pan = aahh.Create( "button", menu.backplate )
	local menu = aahh.Create( "panel", menu.backplate )
	
	pan:SetPos( Vec2( 50, 180 + ( MULTIPLAYER and 60 or 0 ) ) )
	pan:SetSize( Vec2( 200, 40 ) )
	pan.OnDraw = function( me, size )
		graphics.DrawText( "Connect", Vec2( 12, 20 ), "verdana.ttg", 16, Color( 1, 1, 1, 1 ), Vec2( 0, -0.25 ) )
		if me:IsMouseOver() then
			graphics.DrawOutlinedRect( Rect( 0, 0, size ), 1, Color( 0, 0, 0, 0.3 ) )
			graphics.DrawOutlinedRect( Rect( 1, 1, size.w - 43, size.h - 2 ), 1, Color( 1, 1, 1, 0.1 ) )
			graphics.DrawOutlinedRect( Rect( size.w - 41, 1, 40, 38 ), 1, Color( 1, 1, 1, 0.1 ) )
			graphics.DrawFilledRect( Rect( size.w - 42, 1, 1, 38 ), Color( 0, 0, 0, 0.3 ) )
		end
	end
	pan.OnPress = function( me, size )
		if ( mouse.GetPos() - me:GetPos() ).w > 160 then
			if not menu:IsVisible() then
				menu:SetVisible( true )
				menu:SetSize( Vec2( 200, 6 ) )
				menu:SizeTo( Vec2( 200, 200 ), 0.5 )
			end
		else
			print( "connect" )
		end
	end
	
	local mousedown = false
	local closemenu = false
	
	menu:SetPos( Vec2( 250, 180 + ( MULTIPLAYER and 60 or 0 ) ) )
	menu:SetSize( 200, 0 )
	menu:SetVisible( false )
	menu.OnDraw = function( me, size )
		if size.h < 4 then
			me:SetVisible( false )
		end
		if closemenu then
			closemenu = false
			me:SizeTo( Vec2( 200, 0 ), 0.5, 0, 1, function() end )
		end
		if mousedown and not input.IsKeyDown( "mouse1" ) and size.h > 199 then
			closemenu = true
		end
		mousedown = input.IsKeyDown( "mouse1" )
		
		graphics.DrawFilledRect( Rect( 0, 0, size ), Color( 0, 0, 0, 0.2 ) )
		graphics.DrawOutlinedRect( Rect( 0, 0, size ), 1, Color( 0, 0, 0, 0.3 ) )
		graphics.DrawOutlinedRect( Rect( 1, 1, size - 2 ), 1, Color( 1, 1, 1, 0.1 ) )
	end
	
	local pan = aahh.Create( "button", menu )
	pan:SetTrapInsideParent( false )
	pan:SetPos( Vec2( 2, 2 ) )
	pan:SetSize( Vec2( 196, 30 ) )
	pan.OnDraw = function( me, size )
		me.textanim = me.textanim + ( ( me:IsMouseOver() and 1 or 0 ) - me.textanim ) * math.min( FrameTime() * 15, 1 )
		graphics.DrawText( "Last Server", Vec2( 8, 8 - 30 * me.textanim ), "verdana.ttf", 12, Color( 1, 1, 1, 1 ) )
		local lastip = cookies.Get( "lastip", "localhost" )
		local textsize = graphics.GetTextSize( "verdana.ttf", lastip ) * 12
		if textsize.w > 190 then
			graphics.DrawText( lastip, Vec2( 38 + textsize.w - ( textsize.w + 30 ) * ( CurTime() % ( textsize.w / 40 ) ) / ( textsize.w / 40 ), 38 - 30 * me.textanim ), "verdana.ttf", 12, Color( 1, 1, 1, 1 ) )
			graphics.DrawText( lastip, Vec2( 8 - ( textsize.w + 30 ) * ( CurTime() % ( textsize.w / 40 ) ) / ( textsize.w / 40 ), 38 - 30 * me.textanim ), "verdana.ttf", 12, Color( 1, 1, 1, 1 ) )
		else
			graphics.DrawText( lastip, Vec2( 8, 38 - 30 * me.textanim ), "verdana.ttf", 12, Color( 1, 1, 1, 1 ) )
		end
		if me:IsMouseOver() then
			graphics.DrawOutlinedRect( Rect( 0, 0, size ), 1, Color( 0, 0, 0, 0.2 ) )
			graphics.DrawOutlinedRect( Rect( 1, 1, size - 2 ), 1, Color( 1, 1, 1, 0.05 ) )
		end
	end
	pan.textanim = 0
	pan.OnPress = function( me )
		console.RunString( "connect " .. cookies.Get( "lastip", "localhost" ), true, true )
	end
end

do -- Host
	local pan = aahh.Create( "button", menu.backplate )
	pan:SetPos( Vec2( 50, 220 + ( MULTIPLAYER and 60 or 0 ) ) )
	pan:SetSize( Vec2( 200, 40 ) )
	pan.OnDraw = function( me, size )
		graphics.DrawText( "Host", Vec2( 12, 20 ), "verdana.ttg", 16, Color( 1, 1, 1, 1 ), Vec2( 0, -0.25 ) )
		if me:IsMouseOver() then
			graphics.DrawOutlinedRect( Rect( 0, 0, size ), 1, Color( 0, 0, 0, 0.3 ) )
			graphics.DrawOutlinedRect( Rect( 1, 1, size - 2 ), 1, Color( 1, 1, 1, 0.1 ) )
		end
	end
	pan.OnPress = function()
		print( "host" )
	end
end

do -- Extras
	local pan = aahh.Create( "button", menu.backplate )
	pan:SetPos( Vec2( 50, 280 + ( MULTIPLAYER and 60 or 0 ) ) )
	pan:SetSize( Vec2( 200, 40 ) )
	pan.OnDraw = function( me, size )
		graphics.DrawText( "Extras", Vec2( 12, 20 ), "verdana.ttg", 16, Color( 1, 1, 1, 1 ), Vec2( 0, -0.25 ) )
		if me:IsMouseOver() then
			graphics.DrawOutlinedRect( Rect( 0, 0, size ), 1, Color( 0, 0, 0, 0.3 ) )
			graphics.DrawOutlinedRect( Rect( 1, 1, size.w - 43, size.h - 2 ), 1, Color( 1, 1, 1, 0.1 ) )
			graphics.DrawOutlinedRect( Rect( size.w - 41, 1, 40, 38 ), 1, Color( 1, 1, 1, 0.1 ) )
			graphics.DrawFilledRect( Rect( size.w - 42, 1, 1, 38 ), Color( 0, 0, 0, 0.3 ) )
		end
	end
	pan.OnPress = function()
		print( "extras" )
	end
end

do -- Settings
	local pan = aahh.Create( "button", menu.backplate )
	pan:SetPos( Vec2( 50, 320 + ( MULTIPLAYER and 60 or 0 ) ) )
	pan:SetSize( Vec2( 200, 40 ) )
	pan.OnDraw = function( me, size )
		graphics.DrawText( "Settings", Vec2( 12, 20 ), "verdana.ttg", 16, Color( 1, 1, 1, 1 ), Vec2( 0, -0.25 ) )
		if me:IsMouseOver() then
			graphics.DrawOutlinedRect( Rect( 0, 0, size ), 1, Color( 0, 0, 0, 0.3 ) )
			graphics.DrawOutlinedRect( Rect( 1, 1, size - 2 ), 1, Color( 1, 1, 1, 0.1 ) )
		end
	end
	pan.OnPress = function()
		print( "settings" )
	end
end

do -- Disconnect
	local pan = aahh.Create( "button", menu.backplate )
	pan:SetPos( Vec2( 50, 380 + ( MULTIPLAYER and 60 or 0 ) ) )
	pan:SetSize( Vec2( 200, 40 ) )
	pan:SetVisible( MULTIPLAYER )
	pan.OnDraw = function( me, size )
		graphics.DrawText( "Disconnect", Vec2( 12, 20 ), "verdana.ttg", 16, Color( 1, 1, 1, 1 ), Vec2( 0, -0.25 ) )
		if me:IsMouseOver() then
			graphics.DrawOutlinedRect( Rect( 0, 0, size ), 1, Color( 0, 0, 0, 0.3 ) )
			graphics.DrawOutlinedRect( Rect( 1, 1, size - 2 ), 1, Color( 1, 1, 1, 0.1 ) )
		end
	end
	pan.OnPress = function()
		console.RunString( "disconnect", true, true )
	end
end

do -- Quit
	local pan = aahh.Create( "button", menu.backplate )
	pan:SetPos( Vec2( 50, 380 + ( MULTIPLAYER and 100 or 0 ) ) )
	pan:SetSize( Vec2( 200, 40 ) )
	pan.OnDraw = function( me, size )
		graphics.DrawText( "Quit", Vec2( 12, 20 ), "verdana.ttg", 16, Color( 1, 1, 1, 1 ), Vec2( 0, -0.25 ) )
		if me:IsMouseOver() then
			graphics.DrawOutlinedRect( Rect( 0, 0, size ), 1, Color( 0, 0, 0, 0.3 ) )
			graphics.DrawOutlinedRect( Rect( 1, 1, size - 2 ), 1, Color( 1, 1, 1, 0.1 ) )
		end
	end
	pan.OnPress = function()
		console.RunString( "quit", true, true )
	end
end

-- Control

input.Bind( "escape", "o toggle_menu" )
console.AddCommand( "toggle_menu", function()
	menu.Toggle()
end )

function menu.Show()
	menu.backplate:SetVisible( true )
	mouse.ShowCursor( true )
end

function menu.Hide()
	menu.backplate:SetVisible( false )
	mouse.ShowCursor( false )
end

function menu.Toggle()
	if menu.backplate:IsVisible() then
		menu.Hide()
	else
		menu.Show()
	end
end

if not MULTIPLAYER then
	hook.Add("SystemEvent", "mainmenu", function(event) 
		if event == ESYSTEM_EVENT_GAME_POST_INIT then
			menu.Show()
			return HOOK_DESTROY
		end
	end)
	menu.Show()
end