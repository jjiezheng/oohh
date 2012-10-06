spawnmenu = spawnmenu or {}
spawnmenu.Panel = spawnmenu.Panel or NULL

if CLIENT then
	function spawnmenu.Open()
		local frame = spawnmenu.Panel
		if frame:IsValid() then
			frame:SetVisible(true)
		else
			frame = aahh.Create("frame")
		end
		
		frame:SetRect(window.GetWorkingRect():Shrink(100))
		frame:SetTitle("spawnmenu")
		
		frame.OnClose = function() spawnmenu.Close() end
		
		spawnmenu.Panel = frame

		--frame:MakeActivePanel()
		
		local grid = aahh.Create("grid", frame)
		grid:Dock("fill")
		
		grid:SetItemSize(Vec2()+20)

		local function populate(dir)
			frame:SetTitle(dir)
			
			if path.GetParentFolder(dir):find("/", nil, true) then
				local btn = aahh.Create("textbutton")
					btn:SetText("<<")
					
					function btn:OnPress()
						grid:RemoveChildren()
						populate(path.GetParentFolder(dir))
					end
					
				grid:AddChild(btn)
			end
			
			for name in pairs(file.FindInPak(dir .. "*")) do
				if name ~= "." and name ~= ".." then
					local btn = aahh.Create("textbutton")
					btn:SetText(name)
					
					if name:find(".cg", nil, true) then
						function btn:OnPress()
							console.RunString("o spawn_prop " .. dir..name)
						end
					elseif not name:find("%.") then
						function btn:OnPress()
							grid:RemoveChildren()
							populate(dir .. name .. "/")
						end
					else
						btn:Remove()
					end	
					
					grid:AddChild(btn)
				end
			end
			
			grid:RequestLayout(true)
			--frame:SetHeight(grid:GetCurrentSize().h + 33)
			--frame:RequestLayout(true)
		end
		
		populate("objects/")
		
		mouse.ShowCursor(true)
	end

	function spawnmenu.Close()
		local frame = spawnmenu.Panel
		
		if frame:IsValid() then
			frame:SetVisible(false)
		end 
		
		mouse.ShowCursor(false)
	end

	console.AddCommand("spawnmenu", function(ply, line, open)
		if open == "1" then
			spawnmenu.Open()
		else
			spawnmenu.Close()
		end
	end)
	
	input.Bind("b", "spawnmenu 1")
	input.Bind("~b", "spawnmenu 0")
end

--if SERVER then
console.AddCommand("spawn_prop", function(ply, line)
	if SERVER then
		local ent = entities.Create("BasicEntity")
		ent:BindToNetwork()
		ent:Spawn()
		ent:SetModel(line)
		ent:SetPos(ply:GetEyeTrace().HitPos)
		local phys = ent:Physicalize(PE_RIGID)
		phys:SetMass(100)
	end
end, "server")
--end

util.MonitorFileInclude()