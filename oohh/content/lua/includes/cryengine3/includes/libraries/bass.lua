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

local META = util.FindMetaTable("channel")

function META:SetOnTagsChanged(tag_type, callback)
	Thinker(function()
		if not self:IsValid() then return false end
		local data = self:GetTags(tag_type)
		local tags = table.concat(data, "\n")
		
		if self.last_tags ~= tags then
			callback(bass.DecodeTags(data))
			self.last_tags = tags
		end		
	end)
end