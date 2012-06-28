tod = {}

tod.Default =
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

tod.Enums.wind = 
{
	set = engine3d.SetWind,
	get = engine3d.GetWind,
}

tod.Enums.ocean_level = 
{
	set = engine3d.SetOceanLevel,
	get = engine3d.GetOceanLevel,
}

tod.Enums.tod = 
{
	set = engine3d.SetTOD,
	get = engine3d.GetTOD,
}

function tod.SetConfig(data, force_update)
	for key, val in pairs(data) do
		local var = tod.Enums[key]
		if type(var) == "table" then
			var.set(val)
		elseif var then	
			engine3d.SetGlobalParameter(var, val)
		end
	end
	if force_update then
		engine3d.UpdateSky()
	end
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

function tod.Lerp(mult, a, b)	
	local params = {}
	for key, val in pairs(a) do
		if type(val) == "number" then
			params[key] =  math.lerp(mult, val, b[key] or val)
		elseif typex(val) == "vec3" then
			if not params[key] then
				params[key] = Vec3(0,0,0)
			end
			params[key].x = math.lerp(mult, val.x, b[key].x or val.x)
			params[key].y = math.lerp(mult, val.y, b[key].y or val.y)
			params[key].z = math.lerp(mult, val.z, b[key].z or val.z)
		elseif typex(val) == "vec2" then
			if not params[key] then
				params[key] = Vec2(0,0)
			end
			params[key].x = math.lerp(mult, val.x, b[key].x or val.x)
			params[key].y = math.lerp(mult, val.y, b[key].y or val.y)
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

function tod.GetCycle(scale)
	local time = (CurTime() / scale)%2
	time = time - 1
	
	return time
end

util.MonitorFileInclude()

local day = tod.LoadConfig("day")
local night = tod.LoadConfig("night")

hook.Add("PostGameUpdate", 1, function()
	tod.SetConfig(tod.LerpConfigs(tod.GetCycle(10), day, night), true) 
end)