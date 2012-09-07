
if CLIENT then
	message.Hook("steambot", function(nick, text, seed, ply)
		chatgui.AddLine(chatgui.GetTimeStamp() .. nick .. ": " .. text)
	end)
end

if SERVER then

	if steambot then steambot:Remove() end
	steambot = luasocket.Server("udp")

	steambot:Host("10.0.0.1", 27015)
		
	function steambot:OnReceive(data, ip, port)
		local name, text = data:match("^(.-): (.*)$")

		if name and text then
			local ply
			
			if active_steambots and active_steambots[name] and active_steambots[name]:IsValid() then
				ply = active_steambots[name]
			end

			message.SendToClient("steambot", nil, name, text, math.random(100), ply or table.random(entities.GetAllPlayers()))

			if ply then
				hook.Call("SteamBotChat", GAMEMODE, ply, text, name)
			end
		else
			print("steambot: " .. data)
		end
	end
	
	function steambot:OnError()
		print("ReadFrom: " .. status)
	end

end
