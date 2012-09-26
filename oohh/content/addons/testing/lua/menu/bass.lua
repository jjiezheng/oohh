if channel and channel:IsValid() then channel:Remove() end
channel = Channel(BASS_URL, "http://epic-empires.co.uk:8000/ukgamer.ogg", 0, BASS_STREAM_STATUS)
print("create " .. bass:Status())
channel:Play()
print("play " .. bass:Status())

local tags = {}

function channel:OnStreamLoaded()
	local data = bass.DecodeTags(channel:GetTags(BASS_TAG_OGG))
	print("tAGASSADASDASD")
	for key, val in pairs(data) do
		print(key, val)
	end
end