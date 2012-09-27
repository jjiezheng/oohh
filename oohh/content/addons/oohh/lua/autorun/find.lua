local done = {}

local function find(tbl, name, pattern)
	for key, val in pairs(tbl) do
		local T = type(val)
		key = tostring(key)
		if T == "table" and not done[val] then
			done[val] = true
			find(val, name .. "." .. key, pattern)
		else
			if (T == "function" or T == "number") and (key:Compare(pattern) or key:find(pattern) or name:Compare(pattern) or name:find(pattern)) then
				if T == "function" then
					val = "args(" .. table.concat(debug.getparams(val), ", ") .. ")"
					if val == "args()" then
						val = "args(??EXTERNAL??)"
					end
				else
					val = type(val)
				end
				MsgN(string.format("%s.%s = %s", name, key, val))
			end
		end
	end
end

console.AddCommand("lua_find", function(ply, line, pattern, server)
	if CLIENT or SERVER and server then
		done = 
		{
			[_G] = true,
			[_R] = true,
			[package] = true,
		}
		find(_G, "_G", pattern)
	end
end, "shared")