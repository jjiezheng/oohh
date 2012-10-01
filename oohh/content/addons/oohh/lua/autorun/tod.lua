tod = {}

tod.Params = {}
tod.CurrentParams = {}

local P = tod.Params
local C = tod.CurrentParams

tod.DefaultEngine3DParams =
{
	[E3DPARAM_HDR_DYNAMIC_POWER_FACTOR] = 0,

	[E3DPARAM_SUN_COLOR] = Vec3(1,1,1),
	[E3DPARAM_SUN_COLOR_MULTIPLIER] = 0,

	[E3DPARAM_SKY_COLOR] = Vec3(1,1,1),
	[E3DPARAM_SKY_COLOR_MULTIPLIER] = 0,

	[E3DPARAM_AMBIENT_GROUND_COLOR] = Vec3(1,1,1),
	[E3DPARAM_AMBIENT_MIN_HEIGHT] = 0,
	[E3DPARAM_AMBIENT_MAX_HEIGHT] = 0,
	[E3DPARAM_AMBIENT_AFFECT_GLOBALCUBEMAP] = 1,

	[E3DPARAM_FOG_COLOR] = Vec3(1,1,1),
	[E3DPARAM_FOG_COLOR2] = Vec3(1,1,1),
	[E3DPARAM_FOG_RADIAL_COLOR] = Vec3(1,1,1),

	[E3DPARAM_VOLFOG_HEIGHT_DENSITY] = Vec3(0,0,0),
	[E3DPARAM_VOLFOG_HEIGHT_DENSITY2] = Vec3(0,0,0),

	[E3DPARAM_VOLFOG_GRADIENT_CTRL] = Vec3(0, 0, 0), 

	[E3DPARAM_VOLFOG_GLOBAL_DENSITY] = Vec3(0,0,0),
	[E3DPARAM_VOLFOG_RAMP] = 0,

	[E3DPARAM_SKYLIGHT_SUN_INTENSITY] = 0,
	[E3DPARAM_SKYLIGHT_SUN_INTENSITY_MULTIPLIER] = 0,

	[E3DPARAM_SKYLIGHT_KM] = 0,
	[E3DPARAM_SKYLIGHT_KR] = 0,
	[E3DPARAM_SKYLIGHT_G] = 0,

	[E3DPARAM_SKYLIGHT_WAVELENGTH_R] = 0,
	[E3DPARAM_SKYLIGHT_WAVELENGTH_G] = 0,
	[E3DPARAM_SKYLIGHT_WAVELENGTH_B] = 0,

	[E3DPARAM_NIGHSKY_HORIZON_COLOR] = Vec3(1,1,1),
	[E3DPARAM_NIGHSKY_ZENITH_COLOR] = Vec3(1,1,1),
	[E3DPARAM_NIGHSKY_ZENITH_SHIFT] = 0,

	[E3DPARAM_NIGHSKY_STAR_INTENSITY] = 0,

	[E3DPARAM_NIGHSKY_MOON_DIRECTION] = Vec3(0,0,0),
	[E3DPARAM_NIGHSKY_MOON_COLOR] = Vec3(1,1,1),
	[E3DPARAM_NIGHSKY_MOON_SIZE] = 0,
	[E3DPARAM_NIGHSKY_MOON_INNERCORONA_COLOR] = Vec3(1,1,1),
	[E3DPARAM_NIGHSKY_MOON_INNERCORONA_SCALE] = Vec3(1,1,1),
	[E3DPARAM_NIGHSKY_MOON_OUTERCORONA_COLOR] = Vec3(1,1,1),
	[E3DPARAM_NIGHSKY_MOON_OUTERCORONA_SCALE] = Vec3(1,1,1),

	[E3DPARAM_CLOUDSHADING_MULTIPLIERS] = 1,
	[E3DPARAM_CLOUDSHADING_SUNCOLOR] = Vec3(1,1,1),
	[E3DPARAM_CLOUDSHADING_SKYCOLOR] = Vec3(1,1,1),

	[E3DPARAM_CORONA_SIZE] = 0,

	[E3DPARAM_OCEANFOG_COLOR] = Vec3(1,1,1),
	[E3DPARAM_OCEANFOG_COLOR_MULTIPLIER] = 0.1,
	[E3DPARAM_OCEANFOG_DENSITY] = 0,

	-- Sky highlight (ex. From Lightning)
	[E3DPARAM_SKY_HIGHLIGHT_COLOR] = Vec3(1,1,1),
	[E3DPARAM_SKY_HIGHLIGHT_SIZE] = 1,
	[E3DPARAM_SKY_HIGHLIGHT_POS] = Vec3(0,0,0),

	[E3DPARAM_SKY_SUNROTATION] = Vec3(0,0,0),
	[E3DPARAM_SKY_MOONROTATION] = Vec3(0,0,0),

	[E3DPARAM_SKY_SKYBOX_ANGLE] = Vec3(0,0,0),
	[E3DPARAM_SKY_SKYBOX_STRETCHING] = 0,

	[EPARAM_SUN_SHAFTS_VISIBILITY] = 0,

	[E3DPARAM_SKYBOX_MULTIPLIER] = 0,

	[E3DPARAM_DAY_NIGHT_INDICATOR] = 0,

	-- Tone mapping tweakables
	[E3DPARAM_HDR_FILMCURVE_SHOULDER_SCALE] = 0,
	[E3DPARAM_HDR_FILMCURVE_LINEAR_SCALE] = 1,
	[E3DPARAM_HDR_FILMCURVE_TOE_SCALE] = 1,
	[E3DPARAM_HDR_FILMCURVE_WHITEPOINT] = 1,
	
	[E3DPARAM_HDR_BLUE_SHIFT] = Vec3(0, 0, 0),
	[E3DPARAM_HDR_BLUE_SHIFT_THRESHOLD] = 0,
	
	[E3DPARAM_HDR_COLORGRADING_COLOR_SATURATION] = 1,
	[E3DPARAM_HDR_COLORGRADING_COLOR_CONTRAST] = 1,
	[E3DPARAM_HDR_COLORGRADING_COLOR_BALANCE] = Vec3(1,1,1),

	[E3DPARAM_COLORGRADING_COLOR_SATURATION] = 1,
	[E3DPARAM_COLORGRADING_FILTERS_PHOTOFILTER_COLOR] = Vec3(1,1,1),
	[E3DPARAM_COLORGRADING_FILTERS_PHOTOFILTER_DENSITY] = 0,
	[E3DPARAM_COLORGRADING_FILTERS_GRAIN] = 0,
	
	wind = Vec3(0,0,0),
	ocean_level = 0,
	tod = 0,
} 

tod.Enums = {}

for key, val in pairs(_G) do
	if key:find("E3DPARAM_") then
		key = key:gsub("E3DPARAM_", "")
		key = key:lower()
			
		tod.Enums[key] = val
	end
end

for key, val in pairs(tod.Enums) do
	P[key] = tod.DefaultEngine3DParams[val]
end

for key, val in pairs(tod.Params) do
	if type(val) ~= "function" then
		tod.CurrentParams[key] = val
	end
end

-- lerping
do
	function tod.Lerp(mult, a, b)	
		local params = {}
		for key, val in pairs(a) do
			if type(val) == "number" then
				params[key] =  math.lerp(mult, val, b[key] or val)
			elseif hasindex(val) and val.GetLerped then
				params[key] = val:GetLerped(mult, b[key] or val)
			end
		end
		return params
	end

	local function lerp(mult, tbl)
		local out = {}

		for i = 1, #tbl - 1 do
			out[i] = tod.Lerp(mult, tbl[i], tbl[i + 1])
		end

		if #out > 1 then
			return lerp(mult, out) 
		else 
			return out[1] 
		end
	end 

	function tod.LerpConfigs(mult, ...)
		return lerp(mult, {...})
	end 
end

tod.nv = nvars.CreateObject("tod")

function tod.UpdateParams()
	engine3d.PauseTOD(true)
	
	for key, val in pairs(tod.CurrentParams) do
		key = tod.Enums[key]
		if key then
			engine3d.SetGlobalParameter(key, val)
		end
	end
	
end

function tod.SetParameter(key, val)
	if type(tod.Params[key]) == "function" then
		tod.Params[key](val)
	end
	tod.CurrentParams[key] = val
end

function tod.GetParameter(key)
	return tod.CurrentParams[key]
end

function tod.SetConfig(data)
	for key, val in pairs(data) do
		tod.SetParameter(key, val)
	end
	tod.UpdateParams()
end

function tod.GetCycle(scale)
	if SERVER and tod.current_cycle and tod.current_cycle >= 0 then 
		return tod.current_cycle 
	end
	
	scale = scale or 1
	
	local time = tod.nv.current_cycle or 0
		
	if CLIENT and not time then 
		time = (CurTime() / scale)
	end
	
	return time%1
end

if SERVER then
	function tod.SetCycle(time)
		tod.nv.current_cycle = time and (time%1) or -1
	end
end

if SERVER then
	local enable = console.CreateVariable("sv_tod", 1)

	local function cmd(val)
		if val == "demo" then
			enable:Set(false)
			tod.SetCycle()
		else
			local daytime = tonumber(val)
			
			if daytime then
				enable:Set(false)
				tod.SetCycle((daytime / 24)%1)
			else
				enable:Set(true)
				tod.SetCycle()
			end
		end
	end
	
	if aowl then
		aowl.AddCommand("settod", function(player, line, val)
			cmd(val)
		end, "moderators")
	else
		console.AddCommand("settod", function(ply, line, val)
			if ply:IsAdmin() then
				cmd(val)
			end			
		end)
	end
	
	timer.Create("real_time_tod", 1, 0, function()
		if not enable:Get() then return end
		
		local H, M, S = os.date("%H"), os.date("%M"), os.date("%S")
		local fraction = (H*3600 + M*60 + S) / 86400

		tod.SetCycle(fraction%1)
	end)
end

function tod.GetCurrentConfig()
	local out = {}
	for key, val in pairs(tod.Enums) do
		if type(val) == "table" then
			out[key] = val.get()
		else
			out[key] = engine3d.GetGlobalParameter(val, type(tod.Default[val]) == "number")
		end
	end
	return out
end
 
function tod.SaveConfig(name, cfg)
	luadata.WriteFile(Path("tod/" .. name .. ".tod"), cfg)
end

function tod.LoadConfig(name)
	return luadata.ReadFile(Path("tod/" .. name .. ".tod"))
end

-- finally, the actual config!

local cache = {}

local day = tod.LoadConfig("day")
local night = tod.LoadConfig("night")

function tod.SetTime(time)
	time = time or math.round(tod.GetCycle(20), 3)
	local cfg

	if cache[time] then
		cfg = cache[time]
	else
		cfg = tod.LerpConfigs(time, night, day, day, night)
		cache[time] = cfg
	end

	tod.SetConfig(cfg)	
end


util.MonitorFileInclude()