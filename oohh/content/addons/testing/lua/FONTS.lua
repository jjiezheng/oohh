if CLIENT then
	local fnt = 
	{	
		Font("impact.ttf"),
		Font("tahoma.ttf"),
		Font("opensans.ttf"),
	}
	
	hook.Add("DrawHUD", 1, function() 
		local fnt = fnt[math.clamp(1, math.ceil(CurTime()*100%3), #fnt)]
		local str = "FIX THIS"
		local x,y = render.GetScreenSize()
		x=x/2
		y=y/2
		local siz = math.sin(CurTime()*1)*100
		
		local w, h = surface.GetTextSize(fnt, str)
		local sw, sh = render.GetScreenScale()
		
		--w = w*(sh/sw)  
		h = h * (sh ) 
						
		surface.SetFont(fnt)
		surface.SetColor(Color(1,1,1,1))

		surface.DrawText(str, x, y, siz*2, 0, 0, 2)
			
		graphics.DrawRect(Rect(x, y, w*siz, h*siz), Color(0,1,0,0.1))

	end)
	
	if CAPSADMIN then
		console.RunString("r_width " .. math.random(200, 1680))
		console.RunString("r_height " .. math.random(200, 1050)) 
	end
	
	util.MonitorFileInclude()
end  