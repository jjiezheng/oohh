local smoothfps = 0

hook.Add("DrawHUD", "FPS", function()
	local fps = 1 / FrameTime()
	if tonumber(tostring(fps)) then 
		smoothfps = smoothfps + ((fps - smoothfps) * FrameTime())
		graphics.DrawText("FPS: "..math.round(smoothfps), Vec2()+10)
	end
	
	-- this shouldn't really be here..
	--[[if CLIENT then
		if not window.IsFocused() and console.GetCVarNumber("e_render") == 1 then
			console.RunString("e_render 0")
		elseif window.IsFocused() and console.GetCVarNumber("e_render") == 0 then
			console.RunString("e_render 1")
		end
	end]]
end)