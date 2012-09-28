do return end
local blacklist = 
{
	HMMWV = true,
	SpeedBoat = true,
	MH60_Blackhawk = true,
	Abrams = true,
}

hook.Add("EntitySpawn", blacklist, function(name)
	if blacklist[name] then
		return false
	end
end)

hook.Add("PostGameUpdate", "blacklist", function()
	for key, ent in pairs(entities.GetAll()) do
		local name = ent:GetClass()
		
		if typex(ent) == "weapon" or blacklist[name] then
			ent:Remove()
		end
	end
end)