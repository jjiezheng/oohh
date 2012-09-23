if CLIENT then
	local showing = false
	local i = 1
	local history = {}
	local panel
	
	function Say(str)
		console.RunCommand("say_safe", base64.encode(str))
	end

	console.AddCommand("showchat", function(ply)
		if not MULTIPLAYER then return end
		
		if not showing then
			chatgui.show = true
			panel = aahh.Create("textentry")
				panel:SetPos(Vec2(20, Vec2(render.GetScreenSize()).h-300))
				panel:SetSize(Vec2(512, 16))
				panel:MakeActivePanel()
				
				panel.OnUnhandledKey = function(_, key)
					if key == "tab" then 
						if input.IsKeyDown("up") then
							i = math.clamp(i + 1, 1, #history)
						elseif input.IsKeyDown("down") then
							i = math.clamp(i - 1, 1, #history)
						end
						
						if history[i] then
							panel:SetText(history[i])
							panel:SetCaretPos(#history[i])
						end
					end
				end
				
				panel.OnTextChanged = function(self, str)
					hook.Call("OnChatTextChanged", str)
				end
				
				panel.OnEnter = function(_, str)
					i = 0
					if #str > 0 then
						Say(str)
						if history[1] ~= str then
							table.insert(history, 1, str)
						end
					end
					
					mouse.ShowCursor(false)
					showing = false
					
					panel:Remove()
					
					hook.Call("OnChatTextChanged", "")
				end
			
			mouse.ShowCursor(true)
			showing = true
		end
	end)
	
	input.Bind("y", "o showchat")
end

console.AddCommand("say_safe", function(ply, line)
	line = base64.decode(line)
	hook.CallOnShared("PlayerSay", nil, ply, line)
end, true)

console.AddCommand("say", function(ply, line)
	hook.CallOnShared("PlayerSay", nil, ply, line)
end, true)

if SERVER then
	function Say(str)
		hook.CallOnShared("PlayerSay", nil, entities.GetLocalPlayer(), str)
	end
end