printf("mmyy: No platform name set! mmmy will use a while loop to update instead.")

hook.Add("LuaOpen", "nil", function()
	while true do
		hook.Call("Update")
		timer.Update()
	end
end)