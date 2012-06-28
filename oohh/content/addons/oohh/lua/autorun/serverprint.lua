if CLIENT then
	message.Hook("svprint", function(str)
		print("$5"..str)
	end)
end

if SERVER then
	hook.Add("ConsolePrint", "serverprint", function(str)
		message.SendToClient("svprint", nil, str)
	end)
end