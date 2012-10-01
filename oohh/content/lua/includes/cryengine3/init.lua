if IsEditor() then return end

CRYENGINE3 = true

function RefreshStates()
	HOST = IsMultiPlayer() and IsServer()

	MULTIPLAYER = IsMultiPlayer()
	EDITOR = IsEditor()
	DEDICATED = IsDedicated()

	if system.GetCommandLine().server then
		SERVER = true
		CLIENT = false
	else
		SERVER = false
		CLIENT = true
		
		if entities.GetLocalPlayer():IsValid() then
			MULTIPLAYER = true
		else
			MULTIPLAYER = false
		end
	end
end

RefreshStates()

include("includes/libraries/enums.lua")
include("includes/libraries/message.lua")
include("includes/libraries/console.lua")
include("includes/libraries/*")

if CLIENT then
	include("includes/libraries/client/*")
end

if SERVER then
	include("includes/libraries/server/*")
end

include("includes/meta/*")

if CLIENT then
	input.Initialize()
end

util.DeriveMetaFromBase("actor", "entity", "GetEntity")

util.DeriveMetaFromBase("player", "entity", "GetEntity")
util.DeriveMetaFromBase("player", "actor", "GetActor")

util.DeriveMetaFromBase("weapon", "entity", "GetEntity")

console.AddCommand("lua_run", function(ply, line)
	easylua.RunLua(ply, line, nil, true)
end)

console.AddCommand("lua_run_sv", function(ply, line)
	easylua.RunLua(ply, line, nil, true)
end, true)

console.AddCommand("lua_run_sh", function(ply, line)
	easylua.RunLua(ply, line, nil, true)
end, "shared")

console.AddCommand("lua_open", function(ply, line)
	easylua.Start(ply)
		include(line)
	easylua.End()
end)

console.AddCommand("lua_open_sv", function(ply, line)
	easylua.Start(ply)
		include(line)
	easylua.End()
end, true)

nvars.Initialize()
nvars.FullUpdate()


hook.Add("PostGameUpdate", "timer_update", timer.Update)

local function confine_cursor()
	if not mouse.IsVisible() and not console.IsVisible() and entities.GetLocalPlayer():IsValid() and window.IsFocused() then
		local w, h = render.GetScreenSize()
		mouse.SetPos(w/2, h/2)
	end
end

hook.Add("PostGameUpdate", "CRYENGINE3", function()
	RefreshStates()

	confine_cursor()
end, math.huge)

local test = {}
for key, val in pairs(_G) do
	if key:find("ESYSTEM_") then
		test[val] = key
	end
end

hook.Add("SystemEvent", "reoh", function(event, low, high)	
	if event == ESYSTEM_EVENT_LEVEL_UNLOAD then
		timer.Simple(0, function() console.RunString("reoh") end)
	elseif event == ESYSTEM_EVENT_LEVEL_PRECACHE_END then	
		RefreshStates()
		hook.Call("LocalPlayerEntered", entities.GetLocalPlayer())
		hook.Call("MenuInitialized", true)
		hook.Call("GameInitialized", true)
	end
end)

hook.Add("LuaOpen", "reoh", function()
	RefreshStates()
	
	addons.AutorunAll()

	if CLIENT then
		addons.AutorunAll("client")
	end

	if SERVER then
		addons.AutorunAll("server")
	end
	
	hook.Call("LocalPlayerEntered", entities.GetLocalPlayer())
		
	if entities.GetLocalPlayer():IsValid() then
		hook.Call("MenuInitialized", true)
		hook.Call("GameInitialized", true)
	else
		hook.Call("MenuInitialized", true)
	end
	
	GAME_INIT = true
end)