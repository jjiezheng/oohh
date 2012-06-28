local META = util.FindMetaTable("vec2")

META.__old_index = META.__old_index or META.__index
function META.__index(self, key, ...)
	if key == "p" or key == "w" then
		key = "x"
	elseif key == "h" then
		key = "y"
	end
	return META.__old_index(self, key, ...)
end

META.__old_newindex = META.__old_newindex or META.__newindex
function META.__newindex(self, key, ...)
	if key == "p" or key == "w" then
		key = "x"
	elseif key == "h" then
		key = "y"
	end
	return META.__old_newindex(self, key, ...)
end