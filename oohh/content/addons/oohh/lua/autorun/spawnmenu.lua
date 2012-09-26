spawnmenu = spawnmenu or {}
spawnmenu.Panel = spawnmenu.Panel or NULL

if CLIENT then
	function spawnmenu.Open()
		local frame = spawnmenu.Panel
		if frame:IsValid() then
			frame:Remove()
		end 
		
		frame = aahh.Create("frame")
		frame:SetRect(window.GetWorkingRect():Shrink(100))
		frame:SetTitle("spawnmenu")
		
		spawnmenu.Panel = frame

		frame:MakeActivePanel()
		
		local grid = aahh.Create("grid", frame)
		grid:Dock("fill")
		
		grid:SetItemSize(Vec2()+20)

		local function populate(dir)
			frame:SetTitle(dir)
			
			if path.GetParentFolder(dir):find("/", nil, true) then
				local btn = aahh.Create("textbutton")
					btn:SetText("<<")
					
					function btn:OnRelease()
						grid:RemoveChildren()
						populate(path.GetParentFolder(dir))
					end
					
				grid:AddChild(btn)
			end
			
			for name in pairs(file.FindInPak(dir .. "*")) do
				if name ~= "." and name ~= ".." then
					local btn = aahh.Create("textbutton")
					btn:SetText(name)
					
					if name:find(".cgf", nil, true) then
						function btn:OnPress()
							console.RunString("o spawn_prop " .. dir..name)
						end
					elseif not name:find("%.") then
						function btn:OnPress()
							grid:RemoveChildren()
							populate(dir .. name .. "/")
						end
					else
						function btn:OnPress()

						end
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
			frame:Remove()
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
	
	input.Bind("q", "o spawnmenu 1")
	input.Bind("~q", "o spawnmenu 0")
end

--if SERVER then
console.AddCommand("spawn_prop", function(ply, line)
	local ent = entities.Create("PropNetworked")
	ent:Spawn()
	ent:SetPos(ply:GetEyeTrace().HitPos)
	ent:SetModel(line)
	local phys = ent:PhysicalizeEx(PE_RIGID)
	phys:Wake()
end, "server")
--end

util.MonitorFileInclude()