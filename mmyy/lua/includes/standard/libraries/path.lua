path = {}

function path.GetPath(level)
	return (debug.getinfo(level or 1).source:gsub("\\", "/"):sub(2):gsub("//", "/"))
end

function path.GetFolder(str)
	str = str or path.GetPath()
	return str:match("(.+/).+") or ""
end

function path.GetParentFolder(str, level)
	str = str or path.GetPath()
	return str:match("(.*/)" .. (level == 0 and "" or (".*/"):rep(level or 1))) or ""
end

function path.GetFilename(str)
	str = str or path.GetPath()
	return str:match(".+/(.+)") or ""
end

function path.GetExtension(str)
	str = str or path.GetPath()
	return str:match(".+%.(%a+)")
end