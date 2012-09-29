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



local bg_oohh = {}
for i = 1, 40 do
	local tab = {}
	tab.text = string.rep( "o", math.random( 2, 8 ) ) .. "hh"
	tab.color = Color( math.random( 0, 100 ) / 100, math.random( 0, 100 ) / 100, math.random( 0, 100 ) / 100, 1 )
	tab.size = math.random( 14, 30 )
	tab.speed = math.random( 500, 1000 ) / 30
	bg_oohh[i] = tab
end

menu.backgrounds = {}

function menu.AddBackground( draw, id )
	menu.backgrounds[id or tostring(draw)] = draw
end

menu.AddBackground( function( size, fade ) 
	graphics.DrawFilledRect( Rect( 0, 0, size.w, size.h ), Color( 0.1, 0.1, 0.1, 1 * fade ) )
	for i = 1, 40 do
		local color = bg_oohh[i].color:Copy()
		color.a = color.a * fade
		
		graphics.DrawText( 
			bg_oohh[i].text, 
			Vec2( ( size.w * 2 - os.clock() * 3 * bg_oohh[i].speed ) % ( size.w * 2 ) - size.w, 
			( bg_oohh[i].speed * 30 * math.floor( ( size.w - os.clock() * 3 * bg_oohh[i].speed ) / size.w ) ) % size.h ), 
			"trebuc.ttf", 
			bg_oohh[i].size, 
			color
		)
	end
end )

menu.AddBackground( function( size, fade ) 
	local mpos = Vec2(mouse.GetPos()) - size.w / 20
	for i = 0, 9 do
		for j = 0, math.ceil( 9 * size.h / size.w ) do
			local a = 0.2 + math.clamp( 1 - ( ( mpos.x - size.x * i / 10 )^2 + ( mpos.y - size.w * j / 10 )^2 ) ^ 0.5 / 800, 0, 1 ) * 0.7
			graphics.DrawFilledRect( Rect( i * size.w / 10, j * size.w / 10, size.w / 10, size.w / 10 ), Color( a, a, a, 1 * fade ) )
		end
	end
end )

menu.AddBackground( function( size, fade )
	sand_particles = sand_particles or {}
	local f = sand_particles
				
	if not f.sand then
		f.max_size = 5

		f.count = 500
		f.gravity = Vec2(0,-0.5)
		f.sand = {}

		for i=1, f.count do
			local siz = math.randomf(1,max_size)
			f.sand[i] =
			{
				pos = {x = 0, y = 0},
				vel = {x = 0, y = 0},
				siz = 1,
				drag = 0.997,
			}
		end
	end			
	
	local pos = Vec2(mouse.GetPos())
	local vel = (f.last_pos or pos) - pos
	vel = vel * -0.25
	f.last_pos = pos
	
	f.rect = Rect(0, 0, size:Unpack())
	
	-- external velocity
	ext_vel_x, ext_vel_y = vel.x, vel.y
	ext_vel_x = ext_vel_x * 0.3
	ext_vel_y = ext_vel_y * 0.3
	
	-- gravity

	ext_vel_x = ext_vel_x - f.gravity.x
	ext_vel_y = ext_vel_y - f.gravity.y
	
	local delta = RealFrameTime() * 20

	--local x,y = surface.GetTranslation()
	--surface.SetTranslation(0,0)
	
	graphics.Set2DFlags()
	graphics.DrawFilledRect(f.rect)
	for i, part in pairs(f.sand) do
		-- random velocity for some variation
		part.vel.x = part.vel.x + ext_vel_x + math.randomf(-1,1)
		part.vel.y = part.vel.y + ext_vel_y + math.randomf(-1,1)
		
		-- velocity
		part.pos.x = part.pos.x + (part.vel.x * delta)
		part.pos.y = part.pos.y + (part.vel.y * delta)
		
		-- friction
		part.vel.x = part.vel.x * part.drag
		part.vel.y = part.vel.y * part.drag
									
		-- collision with other particles (buggy)
		if part.pos.x - part.siz < f.rect.x then
			part.pos.x = f.rect.x + part.siz * 1
			part.vel.x = part.vel.x * -part.drag
		end
		
		if part.pos.x + part.siz > f.rect.w then
			part.pos.x = f.rect.w - part.siz * -1
			part.vel.x = part.vel.x * -part.drag
		end
		
		if part.pos.y - part.siz < f.rect.y then
			part.pos.y = f.rect.y + part.siz * 1
			part.vel.y = part.vel.y * -part.drag
		end
		
		if part.pos.y + part.siz > f.rect.h then
			part.pos.y = f.rect.h + part.siz * -1
			part.vel.y = part.vel.y * -part.drag
		end
	
		--surface.DrawTexturedRect(part.pos.x, part.pos.y, part.siz, part.siz)
		surface.SetColor(Color(part.vel.x*0.01, part.vel.y*0.01, 1, 1))
		surface.DrawLine(part.pos.x, part.pos.y, part.pos.x - part.vel.x*0.5, part.pos.y - part.vel.y*0.5)
	end
	--surface.SetTranslation(x,y)
	
	f.last_pos = pos
end )  

function menu.SelectRandomBackground()
	if menu.active_background then
		menu.prev_active_background = menu.active_background
		menu.background_fade = 0
	end
	
	menu.active_background = table.random(menu.backgrounds)
	
	if not menu.prev_active_background or menu.active_background == menu.prev_active_background then
		menu.prev_active_background = nil
	end
end

menu.SelectRandomBackground()

-- Render Code

util.MonitorFileInclude()
function menu.Render()
	local size = graphics.GetScreenSize()
	
	if not entities.GetLocalPlayer():IsValid() and menu.active_background then
		if menu.prev_active_background then
			menu.background_fade = math.clamp(menu.background_fade + FrameTime(), 0, 1)
			menu.prev_active_background( size, -menu.background_fade + 1 )
			menu.active_background( size, menu.background_fade )
			
			if menu.background_fade == 1 then
				menu.prev_active_background = nil
			end	
		else
			menu.active_background( size, 1 )		
		end
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
butquit.OnRelease = function() console.RunString("disconnect") end
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