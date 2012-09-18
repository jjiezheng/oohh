-- merge easylua and luadev here when they're done!!!!

aowl = aowl or {} local s = aowl

-- used for moderators
aowl.ConfigRCON =
{
	whitelist =
	{
		"wire_",
		"sbox_",
		"banid",
		"sv_tod",
		"ms_lobby_party",
		"removeid",
		"removeip",
		"kickid",
	},

	blacklist =
	{
		";",
		"aowl",
	},
}

aowl.Prefix			= "[!|/|%.]" -- a pattern
aowl.StringPattern	= "[\"|']" -- another pattern
aowl.ArgSepPattern	= "[,]" -- would you imagine that yet another one
aowl.EscapePattern	= "[\\]" -- holy shit another one! holy shit again they are all teh same length! Unintentional! I promise!!1
--team.SetUp(1, "default", Color(68, 112, 146))

local function compare(a, b)

	if a == b then return true end
	if a:find(b, nil, true) then return true end
	if a:lower() == b:lower() then return true end
	if a:lower():find(b:lower(), nil, true) then return true end

	return false
end

do -- goto locations
	GotoLocations = {}

	GotoLocations["spawn"] = function(p) p:Spawn() end

	GotoLocations["#1"] = function(p) p:Cexec("connect 88.191.111.120:27015") end
	GotoLocations["#2"] = function(p) p:Cexec("connect 88.191.102.162:27015") end
	GotoLocations["#caps"] = function(p) p:Cexec("connect 188.165.243.200:27031") end
	GotoLocations["#matt"] = function(p) p:Cexec("connect 188.165.243.200:27030") end
	GotoLocations["#hotel"] = GotoLocations["#caps"]
	GotoLocations["#wendy"] = GotoLocations["#caps"]
	GotoLocations["#wendys"] = GotoLocations["#caps"]
	GotoLocations["#morten"] = function(p) p:Cexec("connect 188.126.204.161:27016") end
	GotoLocations["#noiwex"] = function(p) p:Cexec("connect g1.noiwex.net") end
	GotoLocations["#noi"] = GotoLocations["#noiwex"]

	GotoLocations["kebab"] = function(p) p:SendLua[[gui.OpenURL"http://www.youtube.com/leanback#watch/vf12nHhz5XM"]] end -- joke :v:

	GotoLocations["build@gm_construct_m_"] = Vec3(-1014.9700317383, 1957.5198974609, -13247.96875)
	GotoLocations["cinema@gm_construct_m_"] = Vec3(-14270.897460938,-2847.6254882812,14208.03125)
	GotoLocations["sea@gm_construct_m_"] = Vec3(4186.3037109375, 10523.151367188, 12320.03125)
	GotoLocations["rp@gm_construct_m_"] = Vec3(-4419.7651367188, 9466.7353515625, -13303.96875)
	GotoLocations["science@gm_construct_m_"] = Vec3(-6175.779296875, 3894.951171875, -15855.96875)

	GotoLocations["televator@gm_construct_m_"] = function(p)
		local closestpos = nil
		local d = math.huge

		for place, data in pairs(ms and ms.Elevators or {}) do
			if data.Elevator then
				local dist = p:GetPos():Distance(data.Elevator:GetPos())
				if dist < d then
					d = dist
					closestpos = data.Elevator:GetPos()
				end
			end
		end

		if closestpos then p:SetPos(closestpos-Vec3(0,0,p:BoundingRadius()/2)) end
	end
end

--[[do -- teams
	timer.Simple(0, function()
		local META = FindMetaTable("Player")
		luadata.AccessorFunc(META, "AowlTeamName", "aowl_team_color", true, "default")
		luadata.AccessorFunc(META, "AowlTeamColor", "aowl_team_name", true, Color(68, 112, 146))

		local cache = {}

		function META:GetAowlTeamUID()
			local name = self:GetAowlTeamName()
			local c = self:GetAowlTeamColor()

			local crc = util.CRC(name..c.r..c.g..c.b)

			return crc
		end

		function aowl.UpdateTeamColors()
			for key, ply in pairs(player.GetAll()) do
				local id = ply:GetAowlTeamUID()%10000
				team.SetUp(id, ply:GetAowlTeamName(), ply:GetAowlTeamColor(), true)
				if SERVER then
					ply:SetTeam(id)
				end
			end
		end

		--timer.Create("setup_aowl_teams", 1, 0, aowl.UpdateTeamColors)
	end)
end]]

do -- util	
	function aowl.Message(ply, msg, type, duration)
		
	end
end

do -- commands
	function aowl.CallCommand(ply, cmd, line, args)
		cmd = aowl.cmds[cmd]
		if cmd and ply:CheckUserGroupLevel(cmd.group) then

		local allowed, reason = hook.Call("AowlCommand", cmd, ply, line, unpack(args))

			if allowed ~= false then
				easylua.Start(ply)
				allowed, reason = cmd.callback(ply, line, unpack(args))
				easylua.End()
			end

			if allowed == false and ply:IsValid() then
				if reason then
					aowl.Message(ply, reason, "error")
				end

				--ply:EmitSound("buttons/button8.wav", 100, 120)
			end
		end
	end

	function aowl.CMDInternal(ply, line, cmd, ...)
		if aowl.cmds[cmd] then
			_G.COMMAND = true
				aowl.CallCommand(ply, cmd, table.concat({...}, " "), args)
			_G.COMMAND = nil
		end
	end

	function aowl.SayCommand(ply, txt)
		if txt:sub(1, 1):find(aowl.Prefix) then
			local cmd = txt:match(aowl.Prefix.."(.-) ") or txt:match(aowl.Prefix.."(.+)") or ""
			local line = txt:match(aowl.Prefix..".- (.+)")

			cmd = cmd:lower()
			
			if aowl.cmds[cmd] then
				_G.CHAT = true
					aowl.CallCommand(ply, cmd, line, line and console.ParseCommandArgs(line) or {})
				_G.CHAT = nil
			end
		end
	end

	if SERVER then
		console.AddCommand("aowl", aowl.CMDInternal)

		hook.Add("PlayerSay", "aowl_say_cmd", aowl.SayCommand, print)
	end

	function aowl.AddCommand(cmd, callback, group)
		aowl.cmds = aowl.cmds or {}
		aowl.cmds[cmd] = {callback = callback, group = group or "players", cmd = cmd}
	end
end

do -- added commands
	function aowl.TargetNotFound(target)
		return string.format("could not find: %q", target or "<no target>")
	end
	
	if CLIENT then
		message.Hook("lc", function(ply, line)
			easylua.RunLua(ply, line, nil, true)
		end)
	end

	if SERVER then
		do -- move
			aowl.AddCommand("message", function(_,_, msg, duration, type)
				if not msg then
					return false, "no message"
				end

				type = type or "generic"
				duration = duration or 15

				aowl.Message(nil, msg, "generic", duration)
				--all:EmitSound("buttons/button15.wav")

			end, "developers")

			aowl.AddCommand("tp", function(ply)
				local pos = ply:GetEyeTrace().HitPos
				ply:SetPos(pos)
				if ply.UnStuck then
					timer.Create('Ply'..ply:EntIndex()..'unstuck',1,1,function()
						ply:UnStuck()
					end)
				end
			end)

			aowl.AddCommand("goto", function(ply, line, target)
				if not line then return end
				local x,y,z = line:match("(%-?%d+%.*%d*)[,%s]%s-(%-?%d+%.*%d*)[,%s]%s-(%-?%d+%.*%d*)")

				if x and y and z and ply:CheckUserGroupLevel("moderators") then
					ply:SetPos(Vec3(tonumber(x),tonumber(y),tonumber(z)))
					return
				end

				for k,v in pairs(GotoLocations) do
					local loc, map = k:match("(.*)@(.*)")
					if target and target == k or (loc == target and string.find(game.GetMap(), "^" .. map)) then
						if type(v) == "Vec3" then
							ply:SetPos(v)
							return
						else
							return v(ply)
						end
					end
				end

				local ent = easylua.FindEntity(target)
				
				if ent:IsValid() and ent ~= ply and not ply.GotoDisallowed then
					local dir = ent:GetRotation():GetAng3()
					dir.p = 0
					dir.r = 0
					dir = (dir:GetForward() * -1)

					-- TODO: FIX EET
					ply:SetPos(ent:GetPos() + dir)
					if ply.UnStuck then
						timer.Create('Ply'..ply:EntIndex()..'unstuck',1,1,function()
							if IsValid(ply) then
								ply:UnStuck()
							end
						end)
					end
					ply:SetEyeAngles((ent:EyePos() - ply:EyePos()):Angle())
					--ply:EmitSound("buttons/button15.wav")

					return
				end

				return false, aowl.TargetNotFound(target)
			end)

			aowl.AddCommand("gotoid", function(ply, line, target)
				local url
				local function gotoip(str)
					if not ply:IsValid() then return end
					local ip = str:match([[Garry's Mod.-connect/(.-)">Join</a>]])
					if ip then
						aowl.Message(ply, string.format("found %s from %s", ip, target), "generic")
						aowl.Message(ply, string.format("connecting in 3 seconds.. press jump to abort", ip, target), "generic")

						local uid = tostring(ply) .. "_aowl_gotoid"
						timer.Create(uid, 3, 1, function()
							ply:Cexec("connect " .. ip)
						end)

						hook.Add("KeyPress", uid, function(_ply, key)
							if key == IN_JUMP and _ply == ply then
								timer.Remove(uid)
								ply:SendLua(string.format("notification.Kill('aowl_gotoid')"))
								aowl.Message(ply, "aborted gotoid", "generic")

								hook.Remove("KeyPress", uid)
							end
						end)
					else
						ply:SendLua(string.format("notification.Kill('aowl_gotoid')"))
						aowl.Message(ply, "couldnt fetch the server ip from " .. target, "error")
					end
				end
				local function gotoid()
					if not ply:IsValid() then return end

					ply:SendLua(string.format("local l=notification l.Kill('aowl_gotoid')l.AddProgress('aowl_gotoid', %q)", "looking up steamid ..."))

					http.Get(url, "", function(str)
						gotoip(str)
					end)
				end

				if tonumber(target) then
					url = ("http://steamcommunity.com/profiles/%s/?xml=1"):format(target)
					gotoid()
				elseif target:find("STEAM") then
					url = ("http://steamcommunity.com/profiles/%s/?xml=1"):format(aowl.SteamIDToCommunityID(target))
					gotoid()
				else
					ply:SendLua(string.format("local l=notification l.Kill('aowl_gotoid')l.AddProgress('aowl_gotoid', %q)", "looking up steamid ..."))

					http.Get(string.format("http://steamcommunity.com/actions/Search?T=Account&K=%q", target:gsub("%p", function(char) return "%" .. ("%X"):format(char:byte()) end)), "", function(str)
						gotoip(str)
					end)
				end
			end)

			aowl.AddCommand("bring", function(ply, line, target)
				local ent = easylua.FindEntity(target)

				if ent:IsValid() and ent ~= ply then
					ent = (ent.GetVehicle and ent:GetVehicle():IsValid()) and ent:GetVehicle() or ent

					ent:SetPos(ply:GetEyeTrace().HitPos)
					ent[ent:IsPlayer() and "SetEyeAngles" or "SetAngles"](ent, (ply:GetEyePos() - ent:GetEyePos()):GetAng3())

					return
				end

				return false, aowl.TargetNotFound(target)
			end, "developers")

			aowl.AddCommand("spawn", function(ply, line, target)
				local ent = ply:CheckUserGroupLevel("developers") and target and easylua.FindEntity(target) or ply

				if ent:IsValid() then
					ent:Spawn()
				end
			end)

			aowl.AddCommand("resurrect", function(player, line, ...)
				player:Kill()
				local pos = player:GetPos()
				player:Spawn()
				player:SetPos(pos)
			end, "players")
		end
			
		do -- lua		
			aowl.AddCommand("l", function(ply, line)
				easylua.RunLua(ply, line, nil, true)
			end, "developers")

			aowl.AddCommand("ls", function(ply, line)
				message.SendToClient("lc", nil, ply, line)
				easylua.RunLua(ply, line, nil, true)
			end, "developers")

			aowl.AddCommand("lc", function(ply, line)
				message.SendToClient("lc", nil, ply, line)
			end, "developers")

			aowl.AddCommand("print", function(ply, line)
				easylua.RunLua(ply, "print(" .. line .. ")", nil, true)
			end, "developers")

			aowl.AddCommand("table", function(ply, line)
				easylua.RunLua(ply, "table.print(" .. line .. ")", nil, true)
			end, "developers")

			aowl.AddCommand("printc", function(ply, line)
				message.SendToClient("lc", nil, ply, "Say(" .. line .. ")")
			end, "developers")

			aowl.AddCommand("say", function(player, line)
				message.SendToClient("lc", nil, ply, "Say(" .. line .. ")")
			end, "developers")
		end

		do -- admin
			aowl.AddCommand("exit", function(ply, line, target, reason)
				local ent = easylua.FindEntity(target)

				if ent:IsPlayer() then
					return ent:SendLua("LocalPlayer():ConCommand('exit')")
				end

				return false, aowl.TargetNotFound(target)
			end, "developers")

			aowl.AddCommand("kick", function(ply, line, target, reason)
				local ent = easylua.FindEntity(target)

				if ent:IsPlayer() then
					return ent:Kick(reason or "byebye!!")
				end

				return false, aowl.TargetNotFound(target)
			end, "developers")

			aowl.AddCommand("ban", function(ply, line, target, length, reason)
				local id = easylua.FindEntity(target)
				local ip

				if id:IsPlayer() then
					if id.SetRestricted then
						return id:SetRestricted(true)
					else
						ip = id:IPAddress():match("(.-):")
						id = id:GetProfileId()
					end
				else
					id = target
				end

				RunConsoleCommand("banid", length or 0, id)
				--if ip then RunConsoleCommand("addip", length or 0, ip) end -- unban ip??
				timer.Simple(0.1, function()
					RunConsoleCommand("kickid", id, reason or "")
					RunConsoleCommand("writeid")
				end)
			end, "developers")

			aowl.AddCommand("unban", function(ply, line, target)
				local id = easylua.FindEntity(target)

				if id:IsPlayer() then
					if id.SetRestricted then
						return id:SetRestricted(false)
					else
						id = id:GetProfileId()
					end
				else
					id = target
				end

				RunConsoleCommand("removeid", id)
				RunConsoleCommand("writeid")
			end, "developers")

			aowl.AddCommand("rcon", function(ply, line)
				line = line or ""

				if false and ply:IsUserGroup("developers") then
					for key, value in pairs(rcon_whitelist) do
						if not str:find(value, nil, 0) then
							return false, "cmd not in whitelist"
						end
					end

					for key, value in pairs(rcon_blacklist) do
						if str:find(value, nil, 0) then
							return false, "cmd is in blacklist"
						end
					end
				end

				game.ConsoleCommand(line .. "\n")

			end, "developers")

			aowl.AddCommand("cexec", function(ply, line, target, ...)
				local ent = easylua.FindEntity(target)

				if ent:IsPlayer() then
					return ent:SendLua(string.format("LocalPlayer():ConCommand(%q)", table.concat({...}, " ")))
				end

				return false, aowl.TargetNotFound(target)
			end, "developers")

			aowl.AddCommand("cleanup", function(player, line,player,time)
				if(tonumber(player) or not player) then
					aowl.CountDown(tonumber(player) or 0, "CLEANING UP SERVER", function()
						game.CleanUpMap()
					end)
				else
					local player=easylua.FindEntity(player)
					if(not _R.Entity.CPPIGetOwner) then return false,"no prop protection found" end
					if(not player) then return false,"player not found" end
					aowl.CountDown(tonumber(time) or 0, "CLEANING UP "..player:Name():upper().."'S PROPS", function()
						for k,v in pairs(ents.GetAll()) do
							if(type(v)~="Weapon" and type(v)~="Player" and v:CPPIGetOwner()==player) then
								v:Remove()
							end
						end
					end)
				end
			end, "developers")

			aowl.AddCommand("abort", function(player, line)
				aowl.AbortCountDown()
			end, "developers")

			aowl.AddCommand("map", function(ply, line, map, time)
				if file.Exists("maps/"..map..".bsp", true) then
					time = tonumber(time) or 10
					aowl.CountDown(time, "CHANGING MAP TO " .. map, function()
						game.ConsoleCommand("changelevel " .. map .. "\n")
					end)
				else
					return false, "map not found"
				end
			end)

			aowl.AddCommand("maprand", function(player, line, map, time)
				time = tonumber(time) or 10
				local maps = file.Find("maps/*.bsp", true)
				local candidates = {}

				for k, v in ipairs(maps) do
					if v:find(map) then
						table.insert(candidates, v:match("^(.*)%.bsp$"):lower())
					end
				end

				if #candidates == 0 then
					return false, "map not found"
				end

				local map = table.Random(candidates)

				aowl.CountDown(tonumber(time), "CHANGING MAP TO " .. map, function()
					game.ConsoleCommand("changelevel " .. map .. "\n")
				end)
			end, "developers")

			aowl.AddCommand("reset", function(player, line)
				aowl.CountDown(line, "RESETING SERVER", function()
					game.CleanUpMap()
					for k, v in ipairs(_G.player.GetAll()) do v:Spawn() end
				end)
			end, "developers")

			aowl.AddCommand("retry", function(player, line)
				aowl.CountDown(line, "RECONNECTING ALL CLIENTS", function()
					for k, v in ipairs(_G.player.GetHumans()) do v:SendLua("LocalPlayer():ConCommand(\"retry\")") end
				end)
			end, "developers")

			aowl.AddCommand("shutitdown", function(player, line, count)
				for k, v in ipairs(ents.GetAll()) do
					v:Fire("close")
				end

				aowl.CountDown(tonumber(count) or 5, "SHUT IT DOWN", function()
					BroadcastLua("surface.PlaySound(chatsounds.GetSound(\"cough\").path)")
				end)
			end, "developers")

			aowl.AddCommand("name", function(player, line)
				player:SetNick(line)
			end)

			aowl.AddCommand("restart", function(player, line)
				local time = math.max(tonumber(line), 1)

				aowl.CountDown(time, "RESTARTING SERVER", function()
					game.ConsoleCommand("changelevel " .. game.GetMap() .. "\n")
				end)
			end, "developers")

			aowl.AddCommand("reboot", function(player, line, target)
				local time = math.max(tonumber(line), 1)

				aowl.CountDown(time, "SERVER IS REBOOTING", function()
					BroadcastLua("LocalPlayer():ConCommand(\"disconnect; snd_restart; retry\")")

					timer.Simple(0.5, function()
						game.ConsoleCommand("exit\n")
						game.ConsoleCommand("shutdown\n")
					end)
				end)
			end, "developers")

			aowl.AddCommand("rank", function(player, line, target, rank)
				local ent = easylua.FindEntity(target)

				if ent:IsPlayer() then
					ent:SetUserGroup(rank)
					return
				end
			end, "owners")

			aowl.AddCommand("settod", function(ply, line, tod)
				engine3d.SetTOD(tod)
			end, "owners")
			
			--[[
			aowl.AddCommand("jointeam", function(ply, line, name, r,g,b)

				local ent = easylua.FindEntity(name)

				if not (r and g and b) and ent:IsPlayer() then
					ply:SetAowlTeamName(ent:GetAowlTeamName())
					ply:SetAowlTeamColor(ent:GetAowlTeamColor())
				else
					if name and #name > 220 then
						return false, "team name is too long"
					end

					if not name then
						name = ply:GetAowlTeamName()
					end

					r = tonumber(r)
					g = tonumber(g)
					b = tonumber(b)

					if not r and g == nil and b == nil then
						local c = ply:GetAowlTeamColor()
						r = c.r
						g = c.g
						b = c.b
					end

					ply:SetAowlTeamName(name)

					if r and g == nil and b == nil then
						ply:SetAowlTeamColor(HSVToColor(r, 0.53333336114883, 0.57254904508591))
					else
						ply:SetAowlTeamColor(Color(r,g,b))
					end
				end

				aowl.UpdateTeamColors()

				timer.Simple(0.1, function()
					umsg.Start("aowl_join_team")
						umsg.Entity(ply)
					umsg.End()
				end)
			end)]]
		end
	end

	do -- restart
		if SERVER then

			local function Shake()
				for k,v in pairs(player.GetAll()) do
					util.ScreenShake(v:GetPos(), math.Rand(1,10), math.Rand(1,5), 2, 500)
				end
			end

			function aowl.CountDown(seconds, msg, callback, typ)
				seconds = seconds and tonumber(seconds) or 0

				local function timeout()
					umsg.Start("__countdown__")
						umsg.Short(-1)
					umsg.End()
					if callback then
						Msg("[Countdown] ") print("'"..tostring(msg).."' finished, calling "..tostring(callback) )
						callback()
					else
						if seconds<1 then
							Msg("[Countdown] ") print("Aborted" )
						else
							Msg("[Countdown] ") print("'"..tostring(msg).."' finished. Initated without callback by "..tostring(source))
						end
					end
				end


				if seconds > 0.5 then
					timer.Create("__countdown__", seconds, 1, timeout)
					timer.Create("__countbetween__", 1, math.floor(seconds), Shake)

					message.SendtoClients("__countdown__", typ or 2, seconds, msg)
					local date = os.prettydate and os.prettydate(seconds) or seconds.." seconds"
					Msg("[Countdown] ") print("'"..msg.."' in "..date )
				else
					timer.Remove "__countdown__"
					timer.Remove "__countbetween__"
					timeout()
				end
			end

			aowl.AbortCountDown = aowl.CountDown

		end

		if CLIENT and false then
			local CONFIG = {}

			CONFIG.TargetTime 	= 0
			CONFIG.Counting 	= false
			CONFIG.Warning 		= ""
			CONFIG.PopupText	= ""
			CONFIG.PopupPos		= {0,0}
			CONFIG.LastPopup	= CurTime()
			CONFIG.Popups		= { "HURRYnot ", "FASTERnot ", "YOU WON'T MAKE ITnot ", "QUICKLYnot ", "GOD YOU'RE SLOWnot ", "DID YOU GET EVERYTHING?not ", "ARE YOU SURE THAT'S EVERYTHING?not ", "OH GODnot ", "OH MANnot ", "YOU FORGOT SOMETHINGnot ", "SAVE SAVE SAVE" }
			CONFIG.StressSounds = { Sound("vo/ravenholm/exit_hurry.wav"), Sound("vo/npc/Barney/ba_hurryup.wav"), Sound("vo/Citadel/al_hurrymossman02.wav"), Sound("vo/Streetwar/Alyx_gate/al_hurry.wav"), Sound("vo/ravenholm/monk_death07.wav"), Sound("vo/coast/odessa/male01/nlo_cubdeath02.wav") }
			CONFIG.NextStress	= CurTime()
			CONFIG.NumberSounds = { Sound("npc/overwatch/radiovoice/one.wav"), Sound("npc/overwatch/radiovoice/two.wav"), Sound("npc/overwatch/radiovoice/three.wav"), Sound("npc/overwatch/radiovoice/four.wav"), Sound("npc/overwatch/radiovoice/five.wav"), Sound("npc/overwatch/radiovoice/six.wav"), Sound("npc/overwatch/radiovoice/seven.wav"), Sound("npc/overwatch/radiovoice/eight.wav"), Sound("npc/overwatch/radiovoice/nine.wav") }
			CONFIG.LastNumber	= CurTime()


			local function DrawWarning()
				surface.SetDrawColor(255, 50, 50, 100 + (math.sin(CurTime() * 3) * 80))
				surface.DrawRect(0, 0, ScrW(), ScrH())

				surface.SetFont("HUDNUMBER5")
				surface.SetTextColor(Color(50, 50, 50, 255))
				local w = surface.GetTextSize(CONFIG.Warning)

				surface.SetTextPos((ScrW() / 2) - w / 2, 200)
				surface.DrawText(CONFIG.Warning)

				surface.SetDrawColor(Color(0,255,0,255))
				surface.DrawRect((ScrW() - w)/2, 175, w * math.max(0, (CONFIG.TargetTime-CurTime())/(CONFIG.TargetTime-CONFIG.StartedCount) ), 20)
				surface.SetDrawColor(color_black)
				surface.DrawOutlinedRect((ScrW() - w)/2, 175, w, 20)

				local Count = tostring(CONFIG.TargetTime - CurTime()):sub(1, 6)
				w = surface.GetTextSize(Count)

				surface.SetTextPos((ScrW() / 2) - w / 2, 240)
				surface.DrawText(Count)

				surface.SetTextColor(255, 255, 255, 255)
				if(CurTime() - CONFIG.LastPopup > 0.5) then
					CONFIG.PopupText = { CONFIG.Popups[math.random(1,#CONFIG.Popups)], CONFIG.Popups[math.random(1,#CONFIG.Popups)], CONFIG.Popups[math.random(1,#CONFIG.Popups)] }
					CONFIG.PopupPos = {{math.random(1, ScrW() - 150), math.random(1, ScrH() - 10) },{math.random(1, ScrW() - 150), math.random(1, ScrH() - 10) },{math.random(1, ScrW() - 150), math.random(1, ScrH() - 10) }}
					CONFIG.LastPopup = CurTime()
				end

				if(CurTime() > CONFIG.NextStress) then
					LocalPlayer():EmitSound(CONFIG.StressSounds[math.random(1, #CONFIG.StressSounds)], 80, 100)
					CONFIG.NextStress = CurTime() + math.random(1, 2)
				end

				local num = math.floor(CONFIG.TargetTime - CurTime())
				if(CONFIG.NumberSounds[num] ~= nil and CurTime() - CONFIG.LastNumber > 1) then
					CONFIG.LastNumber = CurTime()
					LocalPlayer():EmitSound(CONFIG.NumberSounds[num], 511, 100)
				end

				for i = 1, 3 do
					surface.SetTextPos(CONFIG.PopupPos[i][1], CONFIG.PopupPos[i][2])
					surface.DrawText(CONFIG.PopupText[i])
				end
			end

			message.Hook("__countdown__", function(um, typ, time)
				CONFIG.Sound = CONFIG.Sound or CreateSound(LocalPlayer(), Sound("ambient/alarms/siren.wav"))

				if typ  == -1 then
					CONFIG.Counting = false
					CONFIG.Sound:FadeOut(2)
					hook.Remove("HUDPaint", "__countdown__")
					return
				end

				CONFIG.Sound:Play()
				CONFIG.StartedCount = CurTime()
				CONFIG.TargetTime = CurTime() + time
				CONFIG.Counting = true

				hook.Add("HUDPaint", "__countdown__", DrawWarning)

				if typ == 0 then
					CONFIG.Warning = "SERVER IS RESTARTING THE LEVEL, SAVE YOUR PROPS AND HIDE THE CHILDRENnot "
				elseif typ == 1 then
					CONFIG.Warning = string.format("SERVER IS CHANGING LEVEL TO %s, SAVE YOUR PROPS AND HIDE THE CHILDRENnot ", um:ReadString():upper())
				elseif typ == 2 then
					CONFIG.Warning = um:ReadString()
				end
			end)
		end
	end
end

do -- groups

	if not file.Exists("aowl/userslog.txt") then -- loggggh
		file.Write("aowl/userslog.txt", os.time() .. " Log Started  (" .. os.date() .. ")\n")
	end

	local list =
	{
		players = 1,
		--moderators = 2,
		developers = 2, -- 3,
		owners = math.huge,
	}

	local alias =
	{
		[":D"] = "players",
		user = "players",
		default = "players",
		admin = "developers",
		sandals = "developers",
		moderators = "developers",
		guests = "developers",
		gays = "owners",
		administrator = "developers",
	}

	local META = util.FindMetaTable("Player")

	function META:CheckUserGroupLevel(name)
		name = alias[name] or name

		local a = list[self:GetUserGroup()]
		local b = list[name]

		return a and b and a >= b
	end

	function META:IsAdmin()
		return self:CheckUserGroupLevel("developers")
	end

	function META:IsSuperAdmin()
		return self:CheckUserGroupLevel("developers")
	end

	function META:IsUserGroup(name)
		name = alias[name] or name
		name = name:lower()

		return self:GetUserGroup() == name or false
	end

	function META:GetUserGroup()
		return "owners" --self.nv.usergroup
	end

	--team.SetUp(1, "players", 		Color(68, 	112, 146))
	--team.SetUp(2, "developers", Color(147, 63,  147))
	--team.SetUp(3, "owners", 		Color(207, 110, 90))

	if SERVER then
		local dont_store =
		{
			"moderators",
			"players",
			"users",
		}

		local function clean_users(users, _steamid)

			for name, group in pairs(users) do
				name = name:lower()
				if not list[name] then
					users[name] = nil
				else
					for steamid in pairs(group) do
						if steamid:lower() == _steamid:lower() then
							group[steamid] = nil
						end
					end
				end
			end

			return users
		end

		local function safe(str)
			return str:gsub("{",""):gsub("}","")
		end
		
		function META:SetUserGroup(name, force)
			name = name:Trim()
			name = alias[name] or name

			self.nv.usergroup = name

			if force == false or #name == 0 then return end

			name = name:lower()

			if force or (not table.HasValue(dont_store, name) and list[name]) then
				local users = luadata.ReadFile("aowl/users.txt")
					users = clean_users(users, self:GetProfileId())
					users[name] = users[name] or {}
					users[name][self:GetProfileId()] = self:GetNickname():gsub("%A", "") or "???"
				luadata.WriteFile("aowl/users.txt", users)
				
				--Msg"[aowl] " print(string.format("Changing %s (%s) usergroup to %s",self:GetNickname(), self:GetProfileId(), name))
				--file.Append( "aowl/userslog.txt", string.format( "TIME {%i} USERNAME {%s} SID {%s} GROUP {%s}", os.time(), safe(self:GetNickname()), self:GetProfileId(), safe(name) ) .. "\n" )
			end
		end

		function aowl.GetUserGroupFromSteamID(id)
			for name, users in pairs(luadata.ReadFile("aowl/users.txt")) do
				for steamid, nick in pairs(users) do
					if steamid == id then
						return name, nick
					end
				end
			end
		end

		function aowl.CheckUserGroupFromSteamID(id, name)
			local group = aowl.GetUserGroupFromSteamID(id)

			if group then
				name = alias[name] or name

				local a = list[group]
				local b = list[name]

				return a and b and a >= b
			end

			return false
		end


		for _, ply in pairs(entities.GetAllPlayers()) do
			ply:SetUserGroup("players")

			local users = luadata.ReadFile("aowl/users.txt")

			for name, users in pairs(users) do
				for steamid in pairs(users) do
					if ply:GetProfileId() == steamid then
						ply:SetUserGroup(name, false)
					end
				end
			end
		end
	end

end