--console.RunString("sys_flash 0")

input.Bind("escape", "o toggle_menu")

console.AddCommand("toggle_menu", function()
	menu.Toggle()
end)

util.MonitorFileInclude()

menu = menu or {}

if menu.Close then
	menu.Close()
end

function menu.RenderBackground()	
	if entities.GetLocalPlayer():IsValid() then return end
	mouse.ShowCursor(true)
	local scrw, scrh = render.GetScreenSize()
	
	--graphics.DrawFilledRect(Rect(0, 0, scrw, scrh), aahh.GetSkinColor("light"))
	
	--do return end
	
	local steps = 50			-- Amount of detail
	local wavelength = 50		-- Distance between dark and light
	local speed =  0.2 			-- Speed
	local amplitude = 0.2 		-- Difference between light and dark
	local median = 0.8			-- Lightness (Min: 0 Max: 1) [WARNING: median + amplitude should be between 0 and 1]
	
	local t = CurTime() * 0.001
	
	
	local r, g, b = aahh.GetSkinColor("light"):Unpack()
	
	for i=0, steps-1 do
		local fract = i/steps
		local f = math.sin(fract*100/wavelength+CurTime()*speed)*amplitude+median
		graphics.DrawFilledRect(Rect(0, scrh*fract, scrw, scrh/steps), Color(r*f, g*f, b*f, 1))
	end
end

function menu.FadeIn()
	local i = 1 
	hook.Add("PostDrawMenu", "StartupMenu", function()
		i = i - (i*1.5) * FrameTime() * 5
		graphics.DrawFilledRect(Rect(0,0,render.GetScreenSize()), Color(0,0,0,i))
		if i < 0 then
			return HOOK_DESTROY
		end
	end)
end

function menu.Toggle()
	if menu.visible then
		print("closing menu")
		menu.Close()
	else
		print("opening menu")
		menu.Open()
	end
end

function menu.Open()
	if menu.visible then return end
	mouse.ShowCursor(true)
	menu.MakeButtons()
	hook.Add("PreDrawMenu", "StartupMenu", menu.RenderBackground)
	menu.visible = true
end

function menu.Close()
	if not menu.visible then return end
	mouse.ShowCursor(false)
	for k,v in ipairs(menu.buttons)do
		if type(v) == "table" and v.Remove then v:Remove() end
	end
	hook.Remove("PreDrawMenu", "StartupMenu")
	menu.visible = false
end


menu.buttons = {}

function menu.AddButton(name, func)

	local pnl = aahh.Create("label")
		pnl:SetSkinColor("text", "light")
		pnl:SetSkinColor("shadow", Color(0,0,0,0.1)) 
		pnl:SetFont("impact.ttf")
		pnl:SetTextSize(18)	
		pnl:SetText(name) 		
		
		pnl:SetShadowDir(Vec2()+2)
		pnl:SetShadowSize(1.01)
		
		pnl:SetIgnoreMouse(false)
		pnl:SetSize(Vec2(100, 18))	
		function pnl:OnMouseInput(key, press)
			if key == "mouse1" and press then
				func()
			end
		end
	
	menu.buttons[#menu.buttons+1] = pnl
	
end 

function menu.AddButtonSpace()
	menu.buttons[#menu.buttons+1] = true
end

function menu.SetupButtons()
	
	local sw, sh = render.GetScreenSize()
	
	local margin = 50
	
	local x = margin
	local y = sh/1.4
	
	for i=1, #menu.buttons do
		local b = menu.buttons[#menu.buttons-i+1]
		
		if b == true then
			y = y - (margin / 2)
		else
			b:SetPos(Vec2(x, y-b:GetHeight() * 2)) 
			y = y - (margin / 1.25)
		end
	end
	
end

function menu.MakeButtons()
	if entities.GetLocalPlayer():IsValid() then
		menu.AddButton("Resume", function() timer.Simple(0.1, function() menu.Close() end) end)
	end
	
	menu.AddButton("Connect", function()
		aahh.StringInput("Enter the server IP", cookies.Get("lastip", "localhost"), function(str)
			cookies.Set("lastip", str)
			console.RunString("connect "..str)
			menu.Close()
		end)
	end)
	menu.AddButton("Host", function() 
		aahh.StringInput("Enter the map name", cookies.Get("lastmap", "oohh_flatgrass"), function(str)
			cookies.Set("lastmap", str)
			os.execute([[start "" "%CD%\bin32\launcher.exe" "server" "+map ]] .. str .. [[ s"]])
			--console.RunString("map " .. str .. " s")
			--menu.Close()
		end)
	end)
	menu.AddButtonSpace()

	menu.AddButton("Tests", function()

		local frame = aahh.Create("frame")
		frame:SetTitle("test")
		frame:SetSize(Vec2(512, 512))
		frame:Center()
		
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
			
			for name in lfs.dir(dir) do
				if name ~= "." and name ~= ".." then
					local btn = aahh.Create("textbutton")
					btn:SetText(name)
					
					if name:find(".lua", nil, true) then
						function btn:OnPress()
							easylua.Start(entities.GetLocalPlayer())
							tester.Begin(name)
								include(dir .. name)
							tester.End()
							easylua.End()
							frame:Remove()
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
		
		if not MULTIPLAYER then
			populate("!/../addons/testing/lua/menu/")
		else
			populate("!/../addons/testing/lua/")
		end
	end)
	menu.AddButtonSpace()

	--[[menu.AddButton("Aahh Stats", function() 
		local frame = aahh.Create("frame")
		frame:SetTitle("stats")
		frame:SetSize(Vec2(200, 200))
		frame:Center()
		
		function frame:OnPostDraw()
			local i = 25
			for key, val in pairs(aahh.Stats) do
				graphics.DrawText(key .. " = " ..  val, Vec2(20, i), "tahoma", 10, Color(0.5, 0.5, 0.5, 1))
				i = i + 25
			end
		end
	end)
	menu.AddButtonSpace()]]
	menu.AddButton("Restart", function() timer.Simple(0.1, function() console.RunString("reoh", true, true) end) end)
	menu.AddButton("Exit", function() console.RunString("quit") end)
	
	menu.SetupButtons()
	hook.Add("ResolutionChanged", "startup", menu.SetupButtons)
end

if not MULTIPLAYER then
	menu.Open()
end