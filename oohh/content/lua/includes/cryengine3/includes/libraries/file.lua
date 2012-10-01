function file.GetFullAbsPath()
	return (file.GetFullPath("Bin32/Launcher.exe"):lower():gsub("\\bin32\\launcher.exe", ""))
end