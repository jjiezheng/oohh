hook.Add("ClientConnect", "playerconnected", function(name)
    chatgui.AddLine(name .. " connected.")
end)

hook.Add("ClientDisconnect", "playerdisconnected", function(name, cause, desc)
    chatgui.AddLine(name .. " disconnected (" .. desc .. ").")
end)

hook.Add("EntitySpawned", "playerentered", function(ply)
	if typex(ply) == "player" then
		chatgui.AddLine(ply:GetNickname() .. " entered the game.")
	end
end)

hook.Add("EntityRemoved", "playerleft", function(ply)
	if typex(ply) == "player" then
		chatgui.AddLine(ply:GetNickname() .. " left the game.")
	end
end)