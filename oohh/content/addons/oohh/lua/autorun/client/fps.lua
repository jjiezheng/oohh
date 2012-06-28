local smoothfps = 0

hook.Add("PostDrawMenu", "FPS", function()
	local fps = 1 / FrameTime()
	if tonumber(tostring(fps)) then 
		smoothfps = smoothfps + ((fps - smoothfps) * FrameTime())
		graphics.DrawText("FPS: "..math.round(smoothfps), Vec2(3, 3))
	end
end)