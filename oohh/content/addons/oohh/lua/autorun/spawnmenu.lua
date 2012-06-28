spawnmenu = {}

if CLIENT then
	function spawnmenu.Open()
		local pnl = spawnmenu.Panel
		if not pnl then
			pnl = aahh.Create("draggable")
			pnl:SetRect(window.GetWorkingRect():Shrink(100))
			spawnmenu.Panel = pnl
		end

		pnl:MakeActivePanel()
	end

	function spawnmenu.Close()

	end

	if CAPSADMIN then
		--hook.Add("LuaOpen", 1, function() timer.Simple(0, function() spawnmenu.Open() end) end)
		--util.FileMonitorReoh() 
	end
end

if SERVER then

end