local channel = bass.CreateChannelFromFile(Path("sounds/amenbreak.wav"))
channel:Play()

local freq = channel:GetFrequency()
print(freq)
Thinker(function()
	channel:SetFrequency(freq)
	freq = freq - 50
end)