local FOLDER = os.getenv("CRYENGINETHREEFOLDER") or "NOTFOUND"

-- replaces \ with / and removes the last / if there are any
FOLDER = FOLDER:gsub("\\", "/"):gsub("(/)$", "")

if not os.isdir(FOLDER) then
	error("cannot find the cryengine3 '" .. cryengine3 .. "' is not a valid directory")
end

if _ACTION == "link" then
	local function exists(cmd)
		os.execute("@echo off")
		local exists = os.execute("help " .. cmd) == 1 -- lol
		os.execute("@echo on")

		return exists
	end

	local LINK_DIR
	local LINK_FIL

	if exists("mklink") then
		LINK_DIR = "mklink /d"
		LINK_FIL = "mklink"
	else
		LINK_DIR = "linkd"
		LINK_FIL = "FSUTIL hardlink create"
	end

	local f = string.format

	local cmd = {}

	local link_dir = function(a,b)
		table.insert(cmd, f([[rmdir /S /Q "TARGET_DIR/%s"]], a))
		table.insert(cmd, f([[LINK_DIR "TARGET_DIR/%s" "WORKING_DIR/%s"]], a, b))
	end

	local link_fil = function(a,b)
		table.insert(cmd, f([[del /S /F "TARGET_DIR/%s"]], a))
		table.insert(cmd, f([[LINK_FIL "TARGET_DIR/%s" "WORKING_DIR/%s"]], a, b))
	end

	table.insert(cmd, [[rmdir "TARGET_DIR/data"]])
	table.insert(cmd, [[mkdir "TARGET_DIR/data"]])
	table.insert(cmd, [[rmdir /S /Q "TARGET_DIR/lua"]])
	table.insert(cmd, [[mkdir "TARGET_DIR/lua"]])
	table.insert(cmd, [[rmdir /S /Q "TARGET_DIR/lua/includes"]])
	table.insert(cmd, [[mkdir "TARGET_DIR/lua/includes"]])

	link_fil("lua/init.lua", "mmyy/lua/init.lua")
	link_fil("lua/init.lua", "mmyy/lua/init.lua")
	link_dir("lua/includes/modules", "mmyy/lua/includes/modules")
	link_dir("lua/includes/nil", "mmyy/lua/includes/nil")
	link_dir("lua/includes/standard", "mmyy/lua/includes/standard")
	
	link_dir("lua/includes/cryengine3", "oohh/content/lua/includes/cryengine3")
	link_dir("addons", "oohh/content/addons")
	link_dir("Game/Scripts", "oohh/content/Game/Scripts")
	link_dir("Game/Entities", "oohh/content/Game/Entities")	
		
	local function copy(a, b) table.insert(cmd, f([[BSLASH copy "WORKING_DIR/%s" "TARGET_DIR/%s"]], a, b)) end
	
	copy("mmyy/lib/lua51.dll", "bin32")
	copy("oohh/content/bin32/auto_dev_login.exe", "bin32")
	copy("oohh/content/bin32/msvcr110d.dll", "bin32")
	copy("oohh/content/bin32/msvcp110d.dll", "bin32")
	copy("awesomium/build/bin/*", "bin32")

	copy("oohh/content/bin32/CryGame.dll", "bin32")

	link_dir("Game/Levels/oh_island", "oohh/content/Game/Levels/oh_island")
	link_dir("Game/Levels/oh_grass", "oohh/content/Game/Levels/oh_grass")

	for i, line in ipairs(cmd) do
		line = line:gsub("LINK_DIR", LINK_DIR)
		line = line:gsub("LINK_FIL", LINK_FIL)
		line = line:gsub("WORKING_DIR", path.getabsolute("../"))
		line = line:gsub("TARGET_DIR", FOLDER)
		
		if line:find("BSLASH") or line:find("rmdir") then
			line = line:gsub("BSLASH", "")
			line = line:gsub("(.-)(\".+)", function(a, s) return a.. s:gsub("/", "\\") end)
		end
		
		print(line)
			
		os.execute(line)
	end

return end

solution("oohh")
	location(FOLDER .. "/oohh_project_files/" .. _ACTION)
	
	platforms("x32")
	defines("FORCE_STANDARD_ASSERT")
	defines("NDEBUG")
	defines("GAMEDLL_EXPORTS")
	defines("_XKEYCHECK_H")
		
	defines("CE3")

	if _ACTION == "vs2010" or _ACTION == "vs2008" then
		buildoptions("/MP")
		flags("NoMinimalRebuild")
	end

	configurations{"Debug", "Release"}

	project("GameDLL")
		language("C++")
		kind("SharedLib")

		targetname("CryGame")		
	
		targetdir("../oohh/content/bin32")
		debugdir(FOLDER .. "/Bin32/")
		objdir(FOLDER .. "/BinTemp/")
		
		includedirs("../oohh/")
		includedirs("../mmyy/include/")
		includedirs("../awesomium/")
		includedirs("../awesomium/include")

		includedirs(FOLDER .. "/Code/CryEngine/CryAction/")
		includedirs(FOLDER .. "/Code/CryEngine/CryCommon/")		
	
		includedirs("../gamedll/")
		includedirs(FOLDER .. "/Code/SDKs/boost/")
		includedirs(FOLDER .. "/Code/SDKs/STLPORT/")
	
		files("../gamedll/**.h")
		files("../gamedll/**.cpp")

		files("../mmyy/include/**.cpp")
		files("../mmyy/include/**.hpp")

		files("../oohh/**.hpp")
		files("../oohh/**.cpp")
				
		files("../awesomium/**.h")
		files("../awesomium/**.hpp")
		files("../awesomium/**.cpp")

		excludes("../oohh/content/*")

		vpaths
		{
			["gamedll/*"] = path.getabsolute("../gamedll"),
			["oohh/*"] = path.getabsolute("../oohh"),
			["mmyy/*"] = path.getabsolute("../mmyy/include"),
			["awesomium/*"] = path.getabsolute("../awesomium"),
		}
		
		libdirs("../mmyy/lib/")
		libdirs("../awesomium/build/lib/")
		links("lua51")
		links("awesomium")
		
		postbuildcommands(([[xcopy /Y "%s" "%s"]]):format(path.getabsolute("../oohh/content/bin32/CryGame.*"):gsub("/", "\\"), (FOLDER .. "/bin32/"):gsub("/", "\\")))
		
		debugargs("-noborder -dx9")
		debugdir(FOLDER.."/bin32")

		configuration("debug")
			flags("Symbols")
			
		configuration("release")
			flags("Optimize")