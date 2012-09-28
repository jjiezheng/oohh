function aahh.StartDraw(pnl)
	if not pnl:IsValid() then return end
		
	local pos = pnl:GetWorldPos()
	surface.SetTranslation(pos.x, pos.y)
	
	if false and CAPSADMIN then 
		
		if input.IsKeyDown("space") then return end
		
		
		surface.ShouldScale(true)
		surface.SetTranslation(0, 0)

		local siz = pnl:GetSize()
			
		render.SetViewport(
			pos.x, 
			pos.y, 
			siz.w,
			siz.h
		)
		
	end
end

function aahh.Draw(delta)
	if aahh.ActiveSkin then
		aahh.ActiveSkin.FT = delta
		aahh.ActiveSkin:Think(delta)
	end
	if aahh.World:IsValid() then
		aahh.World:Draw()
	end
	
	if aahh.HoveringPanel:IsValid() then
		mouse.SetCursor(aahh.HoveringPanel:GetCursor())
	else
		mouse.SetCursor(1)
	end
end

function aahh.EndDraw()
	surface.SetTranslation(0, 0)
	
	if CAPSADMIN then
		render.SetViewport(0, 0, render.GetScreenSize())
	end
end

function aahh.CallEvent(pnl, name, ...)
	pnl = pnl or aahh.World
	
	return pnl:CallEvent(name, ...)
end

function aahh.MouseInput(key, press, pos)
	local tbl = {}
	for _, pnl in pairs(aahh.GetPanels()) do
		if not pnl.IgnoreMouse and pnl:IsWorldPosInside(pos) then
			table.insert(tbl, pnl)
		end
	end
	
	for _, pnl in pairs(tbl) do
		if pnl:IsInFront() then
			return pnl:SafeCall("OnMouseInput", key, press, pos - pnl:GetWorldPos())
		end
	end
	
	for _, pnl in pairs(tbl) do	
		if press then pnl:BringToFront() end
		return pnl:SafeCall("OnMouseInput", key, press, pos - pnl:GetWorldPos())
	end
end

if CRYENGINE3 then
	aahh.ActivePanel = NULL
	
	hook.Add("PostGameUpdate", "aahh", function(delta)
		for key, pnl in pairs(aahh.GetPanels()) do
			if pnl.remove_me then
				MakeNULL(pnl)
			end
		end
	
		if aahh.ActivePanel:IsValid() then
			input.DisableFocus = true
		else
			input.DisableFocus = false
		end
		
		surface.StartDraw()
			graphics.Set2DFlags()
			
			hook.Call("DrawHUD")
	
			hook.Call("PreDrawMenu")
				aahh.Draw(delta)
			hook.Call("PostDrawMenu")
		surface.EndDraw()
	end)

	function aahh.KeyInput(key, press)
		if key:find("mouse") or key == "mwheel_down" or key == "mwheel_up" then
			aahh.MouseInput(key, press, Vec2(mouse.GetPos()))
		else
			return aahh.CallEvent(aahh.World, "KeyInput", key, press)
		end
	end
	hook.Add("OnKeyInput", "aahh", aahh.KeyInput, print)

	function aahh.CharInput(key, press)
		return aahh.CallEvent(aahh.World, "CharInput", key, press)
	end
	hook.Add("OnCharInput", "aahh", aahh.CharInput, print)
	
	util.MonitorFileInclude()
end