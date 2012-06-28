util.MonitorFileInclude()

local day = tod.LoadConfig("day")
local night = tod.LoadConfig("night")

tod.SetConfig(day, true) 

--[[
hook.Add("PostGameUpdate", 1, function()
	tod.SetConfig(tod.LerpConfigs(tod.GetCycle(10), day, night), true) 
end)
]]
