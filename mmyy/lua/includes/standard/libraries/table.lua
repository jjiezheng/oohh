function table.HasValue(tbl, val)
	for k,v in pairs(tbl) do
		if v == val then
			return k
		end
	end

	return false
end

function table.GetKey(tbl, val)
	for k,v in pairs(tbl) do
		if k == val then
			return k
		end
	end

	return nil
end

function table.count(tbl)
	check(tbl, "table")
	local i = 0
	for k,v in pairs(tbl) do
		i = i + 1
	end

	return i
end

function table.merge(a,b)
	for k,v in pairs(b) do
		a[k] = v
	end

	return a
end

function table.random(tbl)
	local key = math.random(1, table.count(tbl))
	local i = 1
	for _key, _val in pairs(tbl) do
		if i == _key then
			return _val, _key
		end
		i = i + 1
	end
end

do -- table print

	local function table_print(tt, indent, done)
		done = done or {}
		indent = indent or 0
		if type(tt) == "table" then
			for key, value in pairs (tt) do
				Msg(string.rep ("\t", indent))
				if type (value) == "table" and not done [value] then
					done [value] = true
					MsgN(string.format("[%s] = table", tostring (key)));
					Msg(string.rep (" ", indent+4)) -- indent it
					MsgN("(");
					table_print(value, indent + 7, done)
					Msg(string.rep (" ", indent+4)) -- indent it
					MsgN(")");
				else
					MsgN(string.format("[%s] = %s",
					tostring (key), tostring(value)))
				end
			end
		else
			MsgN(tt)
		end
	end

	function table.print(...)
		local args = {...}
		print("")
		table_print(#args == 1 and args[1] or args)
		print("")
	end

end

do -- table copy
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end

	function table.copy(object)
		lookup_table = {}
		return _copy(object)
	end
end