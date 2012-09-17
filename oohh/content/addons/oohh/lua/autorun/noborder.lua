hook.Add("SystemEvent", "noborder", function(event)
	if stop then return end	
	if event == ESYSTEM_EVENT_GAME_POST_INIT_DONE or event == ESYSTEM_EVENT_STYLE_CHANGED then
		if system.GetCommandLine().noborder then
			timer.Simple(0, function()
				window.SetRect(window.GetWorkingRect())
				window.SetNoBorder(true)
				
				timer.Simple(0.1, function()
					if aahh then
						hook.Call("ResolutionChanged")
						aahh.World:RequestLayout()
					end
				end)
			end)
		end	
	end
end)

if SERVER or system.GetCommandLine().server then
	window.SetTitle("oohh server")
elseif CLIENT then 
	window.SetTitle("oohh client")
end