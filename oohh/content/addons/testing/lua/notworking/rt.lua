local rt = render.CreateRenderTarget(100, 100)

hook.Add("PreMenuRender", 1, function()
	render.SetRenderTarget(rt)
	render.BeginFrame()
	
	surface.StartDraw()
	graphics.DrawRect(Rect(0, 0, math.random(10), math.random(10)), Color(1,1,0,1))			
	surface.EndDraw()
	
	render.EndFrame()
	render.SetRenderTarget()
end)

hook.Add("PostHUDUpdate", 1, function()
	surface.StartDraw()
		graphics.DrawTexture(rt, Rect(0, 0, 100, 100), Color(1,1,1,1))
	surface.EndDraw()
end)