
if SERVER then
	local me = me

	for key, ent in pairs(entities.GetAllByClass("oohh_scripted_weapon")) do
		ent:Remove()
	end

	timer.Simple(0.5, function()
		local wep = me:GiveSent("physgun", true)
	end)
end