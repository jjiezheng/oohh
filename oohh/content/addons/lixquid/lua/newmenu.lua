menu = menu or {}

local sayings = {
	"fascinating!!1",
	"WahhEngine3",
	"got caps for me?",
	"achieved with AowlEngine3",
	"what am i doing",
	"[menu.lua]:" .. math.random( 50, 350 ) .. ": '<eof>' expected near 'oohh'",
	"eek"
}
local thissaying = sayings[ math.random( 1, #sayings ) ]

-- Render Code

util.MonitorFileInclude()
function menu.Render()
	local size = graphics.GetScreenSize()
	
	if not entities.GetLocalPlayer():IsValid() then
		graphics.DrawFilledRect( Rect( 0, 0, size.w, size.h ), Color( 0.5, 0.5, 0.5, 1 ) )
	end
	
	graphics.DrawFilledRect( Rect( 0, 0, size.w, size.h ), Color( 0, 0, 0, 0.3 ) )
	graphics.DrawFilledRect( Rect( 0, size.h - 60, size.w, 60 ), Color( 0, 0, 0, 0.2 ) )
	
	for i = 0, 499 do
		graphics.DrawFilledRect( Rect( i, 0, 1, size.h ), Color( 0, 0, 0, 0.6 - 0.6 * ( i / 500 ) ) )
	end
	
	graphics.DrawText( "oohh", Vec2( 50, 50 ), "trebuc.ttf", 40, Color( 1, 1, 1, 1 ) )
	graphics.DrawText( thissaying, Vec2( 50, 100 ), "trebuc.ttf", 20, Color( 0.8, 0.8, 0.8, 1 ) )
	
	
end

-- Buttons'n'shite
menu.contents = menu.contents or {}

for key, pnl in pairs( menu.contents ) do
	if pnl:IsValid() then
		pnl:Remove()
	end
end

local butquit = aahh.Create( "button" )
butquit.OnDraw = function( self, size )
	local size = self:GetSize()
	graphics.DrawFilledRect( Rect( 0, 0, size.w, size.h ), Color( 0, 0, 0, 0.5 ) )
	graphics.DrawText( "QUIT", Vec2( 55, 24 ), "trebuc.ttf", 10, Color( 1, 1, 1, 1 ), Vec2( 0, -0.5 ) )
	graphics.DrawOutlinedRect( Rect( 0, 0, size.w, size.h ), 2, Color( 1, 1, 1, 0.1 ) )
	graphics.DrawOutlinedRect( Rect( 0, 0, size.w, size.h ), 1, Color( 0, 0, 0, 1 ) )
end
butquit.OnMouseEntered = function(self)
	self:MoveTo( graphics.GetScreenSize() - Vec2( 150, 50 ) - 5, 1, 0, 1 )
	self:SizeTo( Vec2( 150, 50 ), 1, 0, 1 )
	menu.contents.settings:MoveTo( graphics.GetScreenSize() - Vec2( 205, 50 ) - 5, 1, 0, 1 )
end
butquit.OnMouseLeft = function(self)
	self:MoveTo( graphics.GetScreenSize() - Vec2( 50, 50 ) - 5, 1, 0, 1 )
	self:SizeTo( Vec2( 50, 50 ), 1, 0, 1 )
	menu.contents.settings:MoveTo( graphics.GetScreenSize() - Vec2( 105, 50 ) - 5, 1, 0, 1 )
end
butquit:SetPos( graphics.GetScreenSize() - Vec2( 50, 50 ) - 5 )
butquit:SetSize( Vec2( 50, 50 ) )
butquit.OnRelease = function() console.RunString("quit") end
menu.contents.quit = butquit

local butset = aahh.Create( "button" )
butset.OnDraw = function( self, size )
	local size = self:GetSize()
	graphics.DrawFilledRect( Rect( 0, 0, size.w, size.h ), Color( 0, 0, 0, 0.5 ) )
	graphics.DrawText( "SETTINGS", Vec2( 55, 24 ), "trebuc.ttf", 10, Color( 1, 1, 1, 1 ), Vec2( 0, -0.5 ) )
	graphics.DrawOutlinedRect( Rect( 0, 0, size.w, size.h ), 2, Color( 1, 1, 1, 0.1 ) )
	graphics.DrawOutlinedRect( Rect( 0, 0, size.w, size.h ), 1, Color( 0, 0, 0, 1 ) )
end
butset.OnMouseEntered = function(self)
	self:MoveTo( graphics.GetScreenSize() - Vec2( 205, 50 ) - 5, 1, 0, 1 )
	self:SizeTo( Vec2( 150, 50 ), 1, 0, 1 )
end
butset.OnMouseLeft = function(self)
	self:MoveTo( graphics.GetScreenSize() - Vec2( 105, 50 ) - 5, 1, 0, 1 )
	self:SizeTo( Vec2( 50, 50 ), 1, 0, 1 )
end
butset:SetPos( graphics.GetScreenSize() - Vec2( 105, 50 ) - 5 )
butset:SetSize( Vec2( 50, 50 ) )
menu.contents.settings = butset

local butdc = aahh.Create( "button" )
butdc.OnDraw = function( self, size )
	local size = self:GetSize()
	graphics.DrawFilledRect( Rect( 0, 0, size.w, size.h ), Color( 0, 0, 0, 0.5 ) )
	graphics.DrawText( "DISCONNECT", Vec2( 55, 24 ), "trebuc.ttf", 10, Color( 1, 1, 1, 1 ), Vec2( 0, -0.5 ) )
	graphics.DrawOutlinedRect( Rect( 0, 0, size.w, size.h ), 2, Color( 1, 1, 1, 0.1 ) )
	graphics.DrawOutlinedRect( Rect( 0, 0, size.w, size.h ), 1, Color( 0, 0, 0, 1 ) )
end
butdc.OnMouseEntered = function(self)
	self:SizeTo( Vec2( 150, 50 ), 1, 0, 1 )
end
butdc.OnMouseLeft = function(self)
	self:SizeTo( Vec2( 50, 50 ), 1, 0, 1 )
end
butdc:SetPos( Vec2( 5, graphics.GetScreenSize().y - 55 ) )
butdc:SetSize( Vec2( 50, 50 ) )
menu.contents.disconnect = butdc

-- Other shit

input.Bind( "escape", "o toggle_menu" )
console.AddCommand( "toggle_menu", function()
	menu.Toggle()
end )

menu.visible = false

function menu.Open()
	menu.visible = true
	hook.Add( "PreDrawMenu", "MainMenu", menu.Render )
	for k, v in pairs( menu.contents ) do
		v:SetVisible( true )
	end
	if entities.GetLocalPlayer():IsValid() then
		menu.contents.disconnect:SetVisible( true )
	else
		menu.contents.disconnect:SetVisible( false )
	end
	mouse.ShowCursor( true )
end
function menu.Close()
	menu.visible = false
	hook.Remove( "PreDrawMenu", "MainMenu" )
	for k, v in pairs( menu.contents ) do
		v:SetVisible( false )
	end
	mouse.ShowCursor( false )
end

function menu.Toggle()
	if menu.visible then
		menu.Close()
	else
		menu.Open()
	end
end

if not MULTIPLAYER then
	hook.Add("SystemEvent", "mainmenu", function(event) 
		if event == ESYSTEM_EVENT_GAME_POST_INIT then
			menu.Open()
			return HOOK_DESTROY
		end
	end)
	menu.Open()
end