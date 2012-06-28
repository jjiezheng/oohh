local siz = Vec2(render.GetScreenSize())
local tex = graphics.CreateTexture("gwen/c.dds")

hook.Add("PostDrawMenu", 1, function(delta)
	surface.StartDraw()

		-- background
		graphics.DrawFilledRect(Rect(0,0, siz.w, siz.h), Color(0, 0.5, 1, 0.5))
		local shadow_dir = (Vec2(mouse.GetPos()) - Vec2(render.GetScreenSize()) * 0.5) / -100

		-- testing
		graphics.DrawRect(
			-- box
			Rect(siz.w/2, siz.h/2, 200, 200):Center(),

			-- box color
			Color(0.9,0.9,0.85,1),

			-- roundness
			math.ceil(math.abs(math.sin(CurTime()*3)*80))%100,
			
			-- border size
			5,

			-- border color
			Color(0.9,0.8,0.9,0.5),

			-- shadow direction
			shadow_dir
		)

		graphics.DrawTexture(tex, Rect(siz.w/2, siz.h/2 - 32, 24, 24):Center())

		graphics.DrawText(" ICE\nCREAM", Vec2(siz.w/2, siz.h/2), "impact.ttf", --[[shadow_dir, Color(0,0,0,0.2),]] 15, Color(1,1,1,1)*0.25, Vec2(0.5,0.5))

		for i = 32, 127 do
			---graphics.DrawText(string.rep(string.char(i), 1000), Vec2((i - 32) * 16, 16))
		end

	surface.EndDraw()
end)