if CLIENT then
	local showing = false
	local i = 1
	local history = {}
	local panel
	
	function Say(str)
		str = tostring(str)
		console.RunCommand("say_safe", base64.encode(str))
	end

	console.AddCommand("showchat", function(ply)
		if not MULTIPLAYER then return end
		
		if not showing then
			if chatgui then chatgui.Show(1) end
			panel = aahh.Create("textinput")
				panel:SetPos(Vec2(20, Vec2(render.GetScreenSize()).h-300))
				panel:SetSize(Vec2(512, 16))
				panel:MakeActivePanel()
				
				panel.OnUnhandledKey = function(_, key)	
					local browse = false
					
					if key == "up" then
						i = math.clamp(i + 1, 1, #history)
						browse = true
					elseif key == "down" then
						i = math.clamp(i - 1, 1, #history)
						browse = true
					end
					
					if browse and history[i] then
						panel:SetText(history[i])
						panel:SetCaretPos(#history[i])
					end
					
					if key == "esc" then
						panel:OnEnter("")
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
	printf("%s : %s", ply:GetNickname(), str)
	hook.CallOnShared("PlayerSay", nil, ply, line)
end, true)

if SERVER then
	function Say(str)
		hook.CallOnShared("PlayerSay", nil, entities.GetLocalPlayer(), str)
	end
end