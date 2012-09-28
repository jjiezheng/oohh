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


local errors = 
{
	[0] = "all is OK",
	[1] = "memory error",
	[2] = "can't open the file",
	[3] = "can't find a free/valid driver",
	[4] = "the sample buffer was lost",
	[5] = "invalid handle",
	[6] = "unsupported sample format",
	[7] = "invalid position",
	[8] = "BASS_Init has not been successfully called",
	[9] = "BASS_Start has not been successfully called",
	[14] = "already initialized/paused/whatever",
	[18] = "can't get a free channel",
	[19] = "an illegal type was specified",
	[20] = "an illegal parameter was specified",
	[21] = "no 3D support",
	[22] = "no EAX support",
	[23] = "illegal device number",
	[24] = "not playing",
	[25] = "illegal sample rate",
	[27] = "the stream is not a file stream",
	[29] = "no hardware voices available",
	[31] = "the MOD music has no sequence data",
	[32] = "no internet connection could be opened",
	[33] = "couldn't create the file",
	[34] = "effects are not available",
	[37] = "requested data is not available",
	[38] = "the channel is a \"decoding channel\"",
	[39] = "a sufficient DirectX version is not installed",
	[40] = "connection timedout",
	[41] = "unsupported file format",
	[42] = "unavailable speaker",
	[43] = "invalid BASS version (used by add-ons)",
	[44] = "codec is not available/supported",
	[45] = "the channel/file has ended",
	[46] = "the device is busy",
	[-1] = "some other mystery problem",
}

function bass.ErrorToString(enum)
	return errors[enum] or errors[-1]
end

function bass.GetLastError()
	return bass.ErrorToString(bass.Status())
end