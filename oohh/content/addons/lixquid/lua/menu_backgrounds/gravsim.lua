menu = menu or {}
menu.backgrounds = menu.backgrounds or {}

local tex = Texture( 100, 100 )
local img = tex:GetPixelTable( true )
for i = 0, tex:GetLength() do
	img[i].r, img[i].g, img[i].b = 255, 255, 255
	-- img[i].a = i % render.GetScreenSize() < 360 and 100 * math.cos( math.rad( ( i % render.GetScreenSize() ) / 4 ) ) or 0
	local x = i % 100
	local y = math.floor( i / 100 )
	img[i].a = math.min( math.max( 50 - ( ( 50 - x )^2 + ( 50 - y )^2 ) ^ 0.6, 0 ) ^ 1.45, 255)
end
tex:SetPixelTable( img )

local tab = {}
menu.backgrounds.gravsim = tab
tab.name = "Gravity Simulator"
tab.desc = "aaaaa my framerate aaaaaa."
tab.author = "Lixquid / Capsadmin"
tab.func = function( size )
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
		
		graphics.DrawTexture( tex, Rect( v.pos - speed / 2, Vec2( speed, speed ) ), col)
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