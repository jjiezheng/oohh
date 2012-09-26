if SERVER or system.GetCommandLine().server then 
	timer.Simple(1, function()
		window.SetAffinity(1)
		window.SetPriority(0x00004000)
		console.RunString(
			[[
			r_displayInfo 1

			s_DummySound 1
			s_SoundEnable 0
			s_MusicEnable 0
			e_render 0
			sys_maxfps 30
			]]
		)
		
		hook.Add("PostGameUpdate", "server", function()
			render.Clear(Color(0,0,0,1))
		end)
				
		timer.Create("server_kl", 0.1, 0, function()
			console.Show(true)
			
			local pos = Vec3(0,0,0)
			local server = entities.GetLocalPlayer()
			local players = entities.GetAllPlayers()
			local count = table.count(players) - 1

			if count > 0 then
				for key, ply in pairs(players) do
					if ply ~= server then
						pos = pos + ply:GetPos()
					end
				end

				pos = pos / count

				server:SetPos(pos + Vec3(10,10,50))
			end
		end)
	end)
	--[[
		system.AttachConsole()
		hook.Add("ConsolePrint", "console_print", function(str)
			system.ConsolePrint(str .. "\n")
		end)
	]]
end