directx.Open()

local font
hook.Add("PostDirectDraw", "test", function()	
	do return end
	font = font or directx.LoadFont("Arial", false, 15)
	--directx.BeginContext()
	directx.Begin()
		directx.SetDrawColor(255, 255, 255, 255)
		directx.RenderText(font, 300, 300, "HHHHHHHHHHHHHHHHHHHHHASIDJASIDJIAS DJASDIJOIODJ IASD")
		local x,y = mouse.GetPos() 
		directx.DrawFilledRect(x,y,100,100)
	directx.End()
	--directx.EndContext()
end)

util.MonitorFileInclude()