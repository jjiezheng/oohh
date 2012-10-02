util.MonitorFileInclude()

local sayings = {
	"fascinating!!1",
	"WahhEngine3",
	"got caps for me?",
	"achieved with AowlEngine3",
	"what am i doing",
	"[menu.lua]:" .. math.random( 50, 350 ) .. ": '<eof>' expected near 'oohh'",
	"eek",
	"did that take forever to calculate"
}
local thissaying = sayings[ math.random( 1, #sayings ) ]

menu = menu or {}

if menu.backplate and menu.backplate:IsValid() then
	menu.backplate:Remove()
end

-- Backgrounds

menu.backgrounds = {}
menu.activebackground = "plain"

menu.backgrounds.plain = function( size )
	graphics.DrawFilledRect( Rect( 0, 0, size ), Color( 0.8, 0.8, 0.8, 1 ) )
end

menu.backgrounds.pixelgrid = function( size ) 
	local mpos = Vec2(mouse.GetPos()) - size.w / 20
	for i = 0, 9 do
		for j = 0, math.ceil( 9 * size.h / size.w ) do
			local a = 0.2 + math.clamp( 1 - ( ( mpos.x - size.x * i / 10 )^2 + ( mpos.y - size.w * j / 10 )^2 ) ^ 0.5 / 800, 0, 1 ) * 0.7
			graphics.DrawFilledRect( Rect( i * size.w / 10, j * size.w / 10, size.w / 10, size.w / 10 ), Color( a, a, a, 1 ) )
		end
	end
end

menu.backgrounds.sand = function( size )
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
	graphics.DrawFilledRect(f.rect, Color( 0.9, 0.9, 0.9, 1 ) )
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
		surface.SetColor(Color(part.vel.x*0.01, part.vel.y*0.01, 1, 1 ))
		surface.DrawLine(part.pos.x, part.pos.y, part.pos.x - part.vel.x*0.5, part.pos.y - part.vel.y*0.5)
	end
	--surface.SetTranslation(x,y)
	
	f.last_pos = pos
end

menu.backgrounds.gridvacuum = function( size )
	local mpos = Vec2(mouse.GetPos())
	graphics.DrawFilledRect( Rect( 0, 0, size ), Color( 0.3, 0.3, 0.3, 1 ) )
	for i = -50, graphics.GetScreenSize().w + 100, 50 do
		for j = -50, graphics.GetScreenSize().h + 100, 50 do
			surface.SetColor( Color( 1, 1, 1, 1 ) )
			local p1 = Vec2( i, j ) + Vec2( math.clamp( ( mpos - Vec2( i, j ) ).x, -50, 50 ), math.clamp( ( mpos - Vec2( i, j ) ).y, -50, 50 ) ) * ( CurTime() % 1 )
			local p2 = Vec2( i + 50, j ) + Vec2( math.clamp( ( mpos - Vec2( i + 50, j ) ).x, -50, 50 ), math.clamp( ( mpos - Vec2( i + 50, j ) ).y, -50, 50 ) ) * ( CurTime() % 1 )
			local p3 = Vec2( i, j + 50 ) + Vec2( math.clamp( ( mpos - Vec2( i, j + 50 ) ).x, -50, 50 ), math.clamp( ( mpos - Vec2( i, j + 50 ) ).y, -50, 50 ) ) * ( CurTime() % 1 )
			surface.DrawLine( p1.x, p1.y, p2.x, p2.y )
			surface.DrawLine( p1.x, p1.y, p3.x, p3.y )
		end
	end
end

local textures = {}

menu.backgrounds.gravsim = function( size )
	local mpos = Vec2(mouse.GetPos())
	grav_particles = grav_particles or {}
	
	while #grav_particles < 300 do
		local part = {}
		part.pos = Vec2( math.random( 0, size.w ), math.random( 0, size.h ) )
		part.vel = Vec2( math.random( -500, 500 ), math.random( -500, 500 ) ) / 10000
		part.mass = math.random( 20, 200 ) / 100
		grav_particles[#grav_particles + 1] = part
	end
	
	graphics.DrawFilledRect( Rect( 0, 0, size ), Color( 0.1, 0.1, 0.1, 1 ) )
	
	graphics.DisableFlags( true )
	render.SetState( bit.bor(	
		--OS_ADD_BLEND,
		OS_MULTIPLY_BLEND,
		GS_BLSRC_SRCALPHA, GS_BLDST_DSTALPHA,
		--GS_BLSRC_ONEMINUSDSTCOL, GS_BLDST_SRCCOL,
		GS_NODEPTHTEST
	) )
	for k, v in pairs( grav_particles ) do
		v.pos = v.pos + v.vel * RealFrameTime() * 100
		if math.random( 1, 100 ) < 4 then
			for nk, nv in pairs( grav_particles ) do
				if nk ~= k then
					v.vel = v.vel + ( nv.pos - v.pos ) / 100000 * nv.mass * v.mass
				end
			end
		end
		local col = Color( math.min( math.abs( v.vel.x / 1 ), 1 ), math.min( math.abs( v.vel.y / 1 ), 1 ), 1, 1 )
		local speed = v.vel:GetLength() * 300
		col.a = 0.015
		
		graphics.DrawTexture( textures.spriteglow, Rect( v.pos - speed / 2, Vec2( speed, speed ) ), col)
		col.a = 1
		surface.SetColor( col )
		surface.DrawLine( v.pos.x, v.pos.y, v.pos.x - v.vel.x * 10 * v.mass, v.pos.y - v.vel.y * 10 * v.mass )
		
		if v.pos.x < 0 or v.pos.x > size.x then
			v.vel.x = v.vel.x * -0.95
			if v.pos.x < 0 then
				v.pos.x = 0
			else
				v.pos.x = size.x
			end
		end
		if v.pos.y < 0 or v.pos.y > size.y then
			v.vel.y = v.vel.y * -0.95
			if v.pos.y < 0 then
				v.pos.y = 0
			else
				v.pos.y = size.y
			end
		end
	end

end

-- GUI

textures.backgrad = Texture( 100, 1 )
local img = textures.backgrad:GetPixelTable( true )
for i = 0, textures.backgrad:GetLength() do
	img[i].r, img[i].g, img[i].b = 1, 1, 1
	-- img[i].a = i % render.GetScreenSize() < 360 and 100 * math.cos( math.rad( ( i % render.GetScreenSize() ) / 4 ) ) or 0
	img[i].a = 100 - i
end
textures.backgrad:SetPixelTable( img )
textures.innerpan = Texture( 1, 50 )
local img = textures.innerpan:GetPixelTable( true )
for i = 0, textures.innerpan:GetLength() do
	img[i].r, img[i].g, img[i].b = 1, 1, 1
	-- img[i].a = i % render.GetScreenSize() < 360 and 100 * math.cos( math.rad( ( i % render.GetScreenSize() ) / 4 ) ) or 0
	img[i].a = 50 - i
end
textures.innerpan:SetPixelTable( img )
textures.spriteglow = Texture( 100, 100 )
local img = textures.spriteglow:GetPixelTable( true )
for i = 0, textures.spriteglow:GetLength() do
	img[i].r, img[i].g, img[i].b = 255, 255, 255
	-- img[i].a = i % render.GetScreenSize() < 360 and 100 * math.cos( math.rad( ( i % render.GetScreenSize() ) / 4 ) ) or 0
	local x = i % 100
	local y = math.floor( i / 100 )
	img[i].a = math.min( math.max( 50 - ( ( 50 - x )^2 + ( 50 - y )^2 ) ^ 0.6, 0 ) ^ 1.45, 255)
end
textures.spriteglow:SetPixelTable( img )

local backpan = aahh.Create( "panel" )
menu.backplate = backpan
backpan:SetObeyMargin( false )
backpan:SetSize( graphics.GetScreenSize() )
backpan.OnDraw = function( me, size )
	if not MULTIPLAYER then
		menu.backgrounds[ menu.activebackground ]( graphics.GetScreenSize() )
	end
	graphics.DrawFilledRect( Rect( 0, 0, size ), Color( 0, 0, 0, 0.5 ) )
	graphics.DrawTexture( textures.backgrad, Rect( 0, 0, 300, size.h ) )
	
	for i = -1, 1 do
		for j = -1, 1 do
			graphics.DrawText( "oohh", Vec2( 50 + i, 50 + j ), "verdana.ttf", 40, Color( 1, 1, 1, math.abs( math.sin( CurTime() ) * 0.9 + 0.1 ) ) )
		end
	end
	graphics.DrawText( "oohh", Vec2( 50, 50 ), "verdana.ttf", 40, Color( 1, 1, 1, 1 ) )
	graphics.DrawText( thissaying, Vec2( 50, 100 ), "verdana.ttf", 20, Color( 0.8, 0.8, 0.8, 1 ) )
	
	graphics.DrawFilledRect( Rect( 0, size.h - 40, size.w, 40 ), Color( 0, 0, 0, 0.2 ) )
	graphics.DrawText( "Connecting...", Vec2( 14, size.h - 22 ), "verdana.ttf", 14, Color( 1, 1, 1, 1 ), Vec2( 0, -0.5 ) )
end

menu.controls = {}

local connectmenuheight = 94
local conpan = aahh.Create( "button", backpan )
menu.controls.butconnect = conpan
local conmen = aahh.Create( "panel", backpan )
menu.controls.menconnect = conmen
conpan:SetPos( Vec2( 50, 200 ) )
conpan:SetSize( Vec2( 200, 40 ) )
conpan.OnDraw = function( me, size )
	graphics.DrawText( "Connect", Vec2( 12, 12 ), "verdana.ttf", 16, Color( 1, 1, 1, 1 ) )
	if me:IsMouseOver() then
		graphics.DrawOutlinedRect( Rect( 1, 1, size - 1 ), 1, Color( 1, 1, 1, 0.1 ) )
		graphics.DrawFilledRect( Rect( size.w - 39, 2, 1, 37 ), Color( 1, 1, 1, 0.1 ) )
		graphics.DrawOutlinedRect( Rect( 0, 0, size - 1 ), 1, Color( 0, 0, 0, 0.2 ) )
		graphics.DrawFilledRect( Rect( size.w - 40, 1, 1, 37 ), Color( 0, 0, 0, 0.2 ) )
	end
end
conpan.OnPress = function( me )
	if ( mouse.GetPos() - me:GetPos() ).w > 160 then
		if conmen:GetSize().w < 9 then
			conmen:SetVisible( true )
			conmen:SetSize( Vec2( 9, connectmenuheight ) )
			conmen:SizeTo( Vec2( 200, connectmenuheight ), 0.4 )
		else
			conmen:SizeTo( Vec2( 0, connectmenuheight ), 0.4, 0, 1, function() conmen:SetVisible( false ) end )
		end
	else
		-- aahh.StringInput("Enter the server IP", cookies.Get("lastip", "localhost"), function(str)
			-- cookies.Set("lastip", str)
			-- console.RunString("connect "..str)
		-- end)
		local pan = aahh.Create( "context" )
		
		pan:AddOption( Texture("gui/corner.dds"), "asd", function() print( "asd" ) end )
	end
end

conmen:SetPos( Vec2( 250, 200 ) )
conmen:SetSize( Vec2( 0, conmenheight ) )
conmen:SetVisible( false )
local inpdel = false
conmen.OnDraw = function( me, size )
	if me.shutitdown then
		me.shutitdown = false
		conmen:SizeTo( Vec2( 0, connectmenuheight ), 0.4, 0, 1, function() conmen:SetVisible( false ) end )
	end
	if inpdel and not input.IsKeyDown( "mouse1" ) then
		me.shutitdown = true
	end
	inpdel = me:GetSize().w > 199 and input.IsKeyDown( "mouse1" ) or false
	graphics.DrawTexture( textures.innerpan, Rect( 0, size.h - connectmenuheight, size.w, connectmenuheight ) )
	-- graphics.DrawOutlinedRect( Rect( 1, 1, size - 1 ), 1, Color( 1, 1, 1, 0.05 ) )
	graphics.DrawOutlinedRect( Rect( 0, 0, size ), 1, Color( 0, 0, 0, 0.2 ) )
end

local conlast = aahh.Create( "button", conmen )
conlast:SetTrapInsideParent( false )
conlast:SetPos( Vec2( 2, 2 ) )
conlast:SetSize( Vec2( 196, 30 ) )
conlast.OnDraw = function( me, size )
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
		graphics.DrawOutlinedRect( Rect( 1, 1, size - 1 ), 1, Color( 1, 1, 1, 0.1 ) )
		graphics.DrawOutlinedRect( Rect( 0, 0, size - 1 ), 1, Color( 0, 0, 0, 0.2 ) )
	end
end
conlast.textanim = 0
conlast.OnPress = function( me )
	console.RunString( "connect " .. cookies.Get( "lastip", "localhost" ), true, true )
end
local conhist = aahh.Create( "button", conmen )
conhist:SetTrapInsideParent( false )
conhist:SetPos( Vec2( 2, 32 ) )
conhist:SetSize( Vec2( 196, 30 ) )
conhist.OnDraw = function( me, size )
	graphics.DrawText( "History", Vec2( 8, 8 ), "verdana.ttf", 12, Color( 1, 1, 1, 1 ) )
	if me:IsMouseOver() then
		graphics.DrawOutlinedRect( Rect( 1, 1, size - 1 ), 1, Color( 1, 1, 1, 0.1 ) )
		graphics.DrawOutlinedRect( Rect( 0, 0, size - 1 ), 1, Color( 0, 0, 0, 0.2 ) )
	end
end
conhist.OnPress = function( me )
	-- console.RunString( "connect " .. cookies.Get( "lastip", "localhost" ), true, true )
end
local conbrow = aahh.Create( "button", conmen )
conbrow:SetTrapInsideParent( false )
conbrow:SetPos( Vec2( 2, 62 ) )
conbrow:SetSize( Vec2( 196, 30 ) )
conbrow.OnDraw = function( me, size )
	graphics.DrawText( "Browse", Vec2( 8, 8 ), "verdana.ttf", 12, Color( 1, 1, 1, 1 ) )
	if me:IsMouseOver() then
		graphics.DrawOutlinedRect( Rect( 1, 1, size - 1 ), 1, Color( 1, 1, 1, 0.1 ) )
		graphics.DrawOutlinedRect( Rect( 0, 0, size - 1 ), 1, Color( 0, 0, 0, 0.2 ) )
	end
end
conbrow.OnPress = function( me )
	-- console.RunString( "connect " .. cookies.Get( "lastip", "localhost" ), true, true )
end

local disconpan = aahh.Create( "button", backpan )
menu.controls.butdisconnect = disconpan
disconpan:SetPos( Vec2( 50, 240 ) )
disconpan:SetSize( Vec2( 200, 40 ) )
disconpan:SetVisible( MULTIPLAYER )
disconpan.OnDraw = function( me, size )
	graphics.DrawText( "Disconnect", Vec2( 12, 12 ), "verdana.ttf", 16, Color( 1, 1, 1, 1 ) )
	if me:IsMouseOver() then
		graphics.DrawOutlinedRect( Rect( 1, 1, size - 1 ), 1, Color( 1, 1, 1, 0.1 ) )
		graphics.DrawOutlinedRect( Rect( 0, 0, size - 1 ), 1, Color( 0, 0, 0, 0.2 ) )
	end
end

local hostpan = aahh.Create( "button", backpan )
menu.controls.buthost = hostpan
hostpan:SetPos( Vec2( 50, 260 + ( disconpan:IsVisible() and 40 or 0 ) ) )
hostpan:SetSize( Vec2( 200, 40 ) )
hostpan.OnDraw = function( me, size )
	graphics.DrawText( "Host", Vec2( 12, 12 ), "verdana.ttf", 16, Color( 1, 1, 1, 1 ) )
	if me:IsMouseOver() then
		graphics.DrawOutlinedRect( Rect( 1, 1, size - 1 ), 1, Color( 1, 1, 1, 0.1 ) )
		graphics.DrawOutlinedRect( Rect( 0, 0, size - 1 ), 1, Color( 0, 0, 0, 0.2 ) )
	end
end
function hostpan:OnPress( me )
	aahh.StringInput("Enter the map name", cookies.Get("lastmap", "oh_island"), function(str)
		cookies.Set("lastmap", str)
		os.execute([[start "" "%CD%\bin32\launcher.exe" "server" "+r_driver dx9" "+map ]] .. str .. [[ s"]])
		--console.RunString("map " .. str .. " s")
		--menu.Close()
	end)
end

local setpan = aahh.Create( "button", backpan )
menu.controls.butsettings = setpan
setpan:SetPos( Vec2( 50, 320 + ( disconpan:IsVisible() and 40 or 0 ) ) )
setpan:SetSize( Vec2( 200, 40 ) )
setpan.OnDraw = function( me, size )
	graphics.DrawText( "Settings", Vec2( 12, 12 ), "verdana.ttf", 16, Color( 1, 1, 1, 1 ) )
	if me:IsMouseOver() then
		graphics.DrawOutlinedRect( Rect( 1, 1, size - 1 ), 1, Color( 1, 1, 1, 0.1 ) )
		graphics.DrawOutlinedRect( Rect( 0, 0, size - 1 ), 1, Color( 0, 0, 0, 0.2 ) )
	end
end

local extrasmenuheight = 64
local morpan = aahh.Create( "button", backpan )
menu.controls.butextras = morpan
local mormen = aahh.Create( "panel", backpan )
menu.controls.menextras = mormen
morpan:SetPos( Vec2( 50, 360 + ( disconpan:IsVisible() and 40 or 0 ) ) )
morpan:SetSize( Vec2( 200, 40 ) )
morpan.OnDraw = function( me, size )
	graphics.DrawText( "Extras", Vec2( 12, 12 ), "verdana.ttf", 16, Color( 1, 1, 1, 1 ) )
	if me:IsMouseOver() then
		graphics.DrawOutlinedRect( Rect( 1, 1, size - 1 ), 1, Color( 1, 1, 1, 0.1 ) )
		graphics.DrawOutlinedRect( Rect( 0, 0, size - 1 ), 1, Color( 0, 0, 0, 0.2 ) )
	end
end
morpan.OnPress = function( me, k )
	if mormen:GetSize().w < 9 then
		mormen:SetVisible( true )
		mormen:SetSize( Vec2( 9, extrasmenuheight ) )
		mormen:SizeTo( Vec2( 200, extrasmenuheight ), 0.4 )
	else
		mormen:SizeTo( Vec2( 0, extrasmenuheight ), 0.4, 0, 1, function() mormen:SetVisible( false ) end )
	end
end
mormen:SetPos( Vec2( 250, 360 + ( disconpan:IsVisible() and 40 or 0 ) ) )
mormen:SetSize( Vec2( 0, conmenheight ) )
mormen:SetVisible( false )
local inpdel = false
mormen.OnDraw = function( me, size )
	if me.shutitdown then
		me.shutitdown = false
		me:SizeTo( Vec2( 0, extrasmenuheight ), 0.4, 0, 1, function() me:SetVisible( false ) end )
	end
	if inpdel and not input.IsKeyDown( "mouse1" ) then
		me.shutitdown = true
	end
	inpdel = me:GetSize().w > 199 and input.IsKeyDown( "mouse1" ) or false
	graphics.DrawTexture( textures.innerpan, Rect( 0, size.h - extrasmenuheight, size.w, extrasmenuheight ) )
	-- graphics.DrawOutlinedRect( Rect( 1, 1, size - 1 ), 1, Color( 1, 1, 1, 0.05 ) )
	graphics.DrawOutlinedRect( Rect( 0, 0, size ), 1, Color( 0, 0, 0, 0.2 ) )
end

local reohpan = aahh.Create( "button", backpan )
menu.controls.butreoh = reohpan
reohpan:SetPos( Vec2( 50, 420 + ( disconpan:IsVisible() and 40 or 0 ) ) )
reohpan:SetSize( Vec2( 200, 40 ) )
reohpan.OnDraw = function( me, size )
	graphics.DrawText( "Reset", Vec2( 12, 12 ), "verdana.ttf", 16, Color( 1, 1, 1, 1 ) )
	if me:IsMouseOver() then
		graphics.DrawOutlinedRect( Rect( 1, 1, size - 1 ), 1, Color( 1, 1, 1, 0.1 ) )
		graphics.DrawOutlinedRect( Rect( 0, 0, size - 1 ), 1, Color( 0, 0, 0, 0.2 ) )
	end
end
function reohpan:OnPress()
	console.RunString( "reoh", true, true )
end

local extpan = aahh.Create( "button", backpan )
menu.controls.butexit = extpan
extpan:SetPos( Vec2( 50, 460 + ( disconpan:IsVisible() and 40 or 0 ) ) )
extpan:SetSize( Vec2( 200, 40 ) )
extpan.OnDraw = function( me, size )
	graphics.DrawText( "Exit", Vec2( 12, 12 ), "verdana.ttf", 16, Color( 1, 1, 1, 1 ) )
	if me:IsMouseOver() then
		graphics.DrawOutlinedRect( Rect( 1, 1, size - 1 ), 1, Color( 1, 1, 1, 0.1 ) )
		graphics.DrawOutlinedRect( Rect( 0, 0, size - 1 ), 1, Color( 0, 0, 0, 0.2 ) )
	end
end
function extpan:OnPress()
	console.RunString( "quit", true, true )
end

-- Commands

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