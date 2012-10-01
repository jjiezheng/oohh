local cmd = {}

local function bslash(str)
	return str:gsub("/", "\\") or str
end

local link_fil = function(a, b)
	table.insert(cmd, string.format([[mklink "TARGET_DIR\%s" "WORKING_DIR\%s"]], bslash(b), bslash(a)))
end

local link_dir = function(a, b)
	table.insert(cmd, string.format([[mklink /d "TARGET_DIR\%s" "WORKING_DIR\%s"]], bslash(b), bslash(a)))
end

local blacklist = 
{
	["crysis2_animations.pak"] = true,
	["crysiswars_shadercache.pak"] = true,
	["crysiswars_shaders.pak"] = true,
	["crysiswars_gamedata.pak"] = true,
	["crysiswars_zpatch1.pak"] = true,
	["crysiswars_zpatch1.pak.patch1"] = true,
	["crysiswars_textures.pak"] = true,
	["nexuiz_scripts.pak"] = true,
}

local allowed = function(name)
	if blacklist[name:lower()] then return false end
	
	return true
end

local link_paks = function(str, dir)
	for file_name in lfs.dir(str .. dir) do
		if file_name:find("%.pak") then
			local full = str .. dir .. file_name
			printf("oohh mounting %q", full)
			
			local game_name = path.GetFolderName(path.GetParentFolder(full))
			game_name = game_name:gsub(" ", "_")
			game_name = game_name:gsub("%p", "")
			local new_file_name = game_name .. "_" .. file_name
			
			-- hacks
			if allowed(new_file_name) then
				link_fil(file_name, "game" .. dir .. "zzz_mounted_" .. new_file_name)
				
				luadata.SetKeyValueInFile("mounted_packs.txt", new_file_name:gsub("%.pak", ""), full)
			end
		end
	end
end

local function link_levels(str, dir)
	for level in lfs.dir(str .. dir) do
		if not level:find("%.") then
			link_dir(dir .. level, "game/levels/" .. level)
		end
	end
end

function MountGame(str)	
	str = str:gsub("\\", "/")
	console.RunString("log_verbosity 10")
		
	link_paks(str, "/")
	link_paks(str, "/Localized/")
	link_paks(str, "/_fastload/")

	link_levels(str, "/levels/")
	link_levels(str, "/levels/SinglePlayer/")
	link_levels(str, "/levels/Multiplayer/IA")
	link_levels(str, "/levels/Multiplayer/PS")
	link_levels(str, "/levels/Wars/")
	
	local path = file.GetFullAbsPath()
	
	for i, line in ipairs(cmd) do
		line = line:gsub("TARGET_DIR", bslash(path))
		line = line:gsub("WORKING_DIR", bslash(str))
		print(line)
		os.execute(line)
	end
	
	console.RunString("log_verbosity 0")
end