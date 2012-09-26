function bass.DecodeTags(data)
	local out = {}

	if data then
		for line, str in pairs(data) do
			local key, val = str:match("(.-)=(.+)")
			if key and val then
				out[key] = val
			end
		end
	end
	
	return out
end