local snd = Sound("any_clues.wav")

snd:Play()
snd:SetVolume(100)

hook.Add("PostGameUpdate", 1, function()
	local x = (mouse.GetPos() / render.GetScreenSize()) * snd:GetLength()
	snd:SetSamplePos(x)
end)