if CLIENT then
	message.Hook("reoh", function()
		console.RunString("reoh")
	end)
end

console.AddCommand("reohall", function()
	message.SendToClient("reoh")
	console.RunString("reoh")
end, true)