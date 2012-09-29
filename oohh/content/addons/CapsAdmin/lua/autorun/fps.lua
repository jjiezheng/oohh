local smoothfps = 0
local color = aahh.GetSkinColor("light")

hook.Add("DrawHUD", "FPS", function()
	local fps = 1 / FrameTime()
	if tonumber(tostring(fps)) then 
		smoothfps = smoothfps + ((fps - smoothfps) * FrameTime())
		graphics.DrawText("FPS: "..math.round(smoothfps), Vec2() + 10, nil, nil, color)
	end
end)