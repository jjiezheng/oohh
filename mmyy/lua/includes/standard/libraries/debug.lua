function debug.trace()	
	MsgN("")
    MsgN("Trace: " )
	
	for level = 1, math.huge do
		local info = debug.getinfo(level, "Sln")
		
		if info then
			if info.what == "C" then
				MsgN(level, "\tC function")
			else
				MsgN(string.format("\t%i: Line %d\t\"%s\"\t%s", level, info.currentline, info.name or "unknown", info.short_src or ""))
			end
		else
			break
		end
    end

    MsgN("")
end

function debug.getparams(f)
		local co = coroutine.create(f)
		local params = {}
		debug.sethook(co, function()
			local i, k = 1, debug.getlocal(co, 2, 1)
			while k do
				if k ~= "(*temporary)" then
					table.insert(params, k)
				end
				i = i+1
				k = debug.getlocal(co, 2, i)
			end
			error("~~end~~")
		end, "c")
		local res, err = coroutine.resume(co)
		if res then
			error("The function provided defies the laws of the universe.", 2)
		elseif string.sub(tostring(err), -7) ~= "~~end~~" then
			error("The function failed with the error: "..tostring(err), 2)
		end
		return params
	end