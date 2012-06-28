local frame = aahh.Create("frame")
frame:SetTitle("particles!")
frame:SetSize(Vec2(200, 200))
frame:Center()

function frame:OnPostDraw()
	local pnl = self
	pnl.fungi = pnl.fungi or {}
	local f = pnl.fungi
				
	if not f.sand then
		f.max_size = 5

		f.count = 1000
		f.gravity = Vec2(0,-0.5)
		f.sand = {}

		for i=1, f.count do
			local siz = math.randomf(1,max_size)
			f.sand[i] =
			{
				pos = {x = 0, y = 0},
				vel = {x = 0, y = 0},
				siz = 1,
				drag = 0.996,
			}
		end
	end			
	
	local pos = pnl:GetPos()
	local vel = (f.last_pos or pos) - pos
	vel = vel * 2
	f.last_pos = pos
	
	local m = pnl:GetMargin()
	f.size = Rect(pos.x, pos.y, pos.x + pnl:GetWidth(), pos.y + pnl:GetHeight())
	f.size.x = f.size.x + m.x
	f.size.y = f.size.y + m.y
	f.size.w = f.size.w - m.w
	f.size.h = f.size.h - m.h
	
	-- external velocity
	ext_vel_x, ext_vel_y = vel.x, vel.y
	ext_vel_x = ext_vel_x * 0.3
	ext_vel_y = ext_vel_y * 0.3
	
	-- gravity

	ext_vel_x = ext_vel_x - f.gravity.x
	ext_vel_y = ext_vel_y - f.gravity.y
	
	local delta = FrameTime() * 5
	
	local x,y = surface.GetTranslation()
	surface.SetTranslation(0,0)
	for i, part in pairs(f.sand) do
		-- random velocity for some variation
		part.vel.x = part.vel.x + ext_vel_x + math.randomf(-2,2)
		part.vel.y = part.vel.y + ext_vel_y + math.randomf(-2,2)
		
		-- velocity
		part.pos.x = part.pos.x + (part.vel.x * delta)
		part.pos.y = part.pos.y + (part.vel.y * delta)
		
		-- friction
		part.vel.x = part.vel.x * part.drag
		part.vel.y = part.vel.y * part.drag
									
		-- collision with other particles (buggy)
		if part.pos.x - part.siz < f.size.x then
			part.pos.x = f.size.x + part.siz
			part.vel.x = part.vel.x * -part.drag
		end
		
		if part.pos.x + part.siz > f.size.w then
			part.pos.x = f.size.w - part.siz
			part.vel.x = part.vel.x * -part.drag
		end
		
		if part.pos.y - part.siz < f.size.y then
			part.pos.y = f.size.y + part.siz
			part.vel.y = part.vel.y * -part.drag
		end
		
		if part.pos.y + part.siz > f.size.h then
			part.pos.y = f.size.h + part.siz
			part.vel.y = part.vel.y * -part.drag
		end
	
		--surface.DrawTexturedRect(part.pos.x, part.pos.y, part.siz, part.siz)
		surface.SetColor(Color(part.vel.x*0.01, part.vel.y*0.01, 1, 1))
		surface.DrawLine(part.pos.x, part.pos.y, part.pos.x - part.vel.x*0.1, part.pos.y - part.vel.y*0.1)
	end
	surface.SetTranslation(x,y)

	f.last_pos = pos
end