menu = menu or {}
menu.backgrounds = menu.backgrounds or {}

local tab = {}
menu.backgrounds.sand = tab
tab.name = "Sand"
tab.desc = "I swear sand isn't this colour."
tab.author = "Capsadmin"
tab.func = function( size )
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