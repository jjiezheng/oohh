do return end
if CLIENT then
	local text = ""
	local history = {}

	function Say(ply, str)
		table.insert(history, ply:GetNickname() .. ": " .. str)

		if #history > 10 then
			table.remove(history, 1)
		end

		text = table.concat(history, "\n")
	end

	hook.Add("PlayerSay", "chat", Say)

	local showing = false

	concommand.Add("showchat", function(ply)
		if not showing then
			local panel = aahh.Create("textentry")
			panel:SetPos(Vec2(0, render.GetScreenSize().h-200))
			panel:SetSize(Vec2(256, 16))
			panel:MakeActivePanel()

			panel.OnEnter = function(_, str)
				if #str > 0 then
					concommand.Run("say", str)
				end
				panel:Remove()
				system.ShowCursor(false)

				showing = false
			end

			system.ShowCursor(true)
			showing = true
		end
	end)

	hook.Add("PostHUDUpdate", "chat", function(delta)
		surface.StartDraw()
			local size = graphics.GetTextSize("impact.ttf", text) * 14
			graphics.DrawText(text, Vec2(10, render.GetScreenSize().h/2), "impact.ttf", size, Color()+1, Vec2(0,1), Vec2()+2)
		surface.EndDraw()
	end)
end

concommand.Add("say", function(ply, line)
	hook.CallOnShared("PlayerSay", nil, ply, line)
end, true)

-- lua

if SERVER then
	hook.Add("PlayerSay", "easyluachat", function(ply, str)
		--printf("%s : %s", ply:GetNickname(), str)
		local cmd, code = str:match("(!l%s-)(.+)")
		if cmd == "!l" then
			local data = easylua.RunLua(ply, code, ply:GetNickname())
			if data.error then
				print(data.error)
			end
		end

		local cmd, code = str:match("(!lc%s-)(.+)")
		if cmd == "!lc" then
			for key, ply in pairs(entities.GetAllPlayers()) do
				ply:SendLua(code, ply:GetNickname())
			end
		end

		local cmd, code = str:match("(!goto%s-)(.+)")
		if cmd == "!goto" then
			print(cmd, code)
			local ent = easylua.FindEntity(code)
			if ent:IsValid() then
				ply:SetPos(ent:GetPos())
			end
		end
	end)
end
