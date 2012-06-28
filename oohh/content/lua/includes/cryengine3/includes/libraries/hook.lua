if CLIENT then
	message.Hook("hookcall", function(hook_name, ...)
		hook.Call(hook_name, ...)
	end)
end

if SERVER then
	function hook.CallOnClient(hook_name, client, ...)
		message.SendToClient("hookcall", client, hook_name, ...)
	end
end

function hook.CallOnShared(hook_name, client, ...)
	if SERVER then message.SendToClient("hookcall", client, hook_name, ...) end
	hook.Call(hook_name, ...)
end