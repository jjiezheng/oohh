if CLIENT then
	message.Hook("reoh", function()
		concommand.Run("say", "reoh!")
		console.RunString("reoh")
	end)
end

concommand.Add("reohall", function()
	message.SendToClient("reoh")
	console.RunString("reoh")
end, true)