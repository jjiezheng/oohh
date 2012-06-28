solution "mmyy"
	location("../project_files/" .. _ACTION)

	platforms "x32"

	if _ACTION == "vs2010" or _ACTION == "vs2008"  then
		buildoptions "/MP"
	end

	configurations{"Debug"}

	project "test app"
		kind "ConsoleApp"
		language "C++"
		flags "Symbols"

		includedirs "../include/"
		libdirs "../lib/"

		files{ "../example.cpp", "../include/**.hpp" }

		libdirs "lib"
		links "lua51"

		configuration "x32"

		targetdir "../bin32"
		debugdir "../bin32"
		objdir "../bin32"