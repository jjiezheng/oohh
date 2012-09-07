metastruct = {}
metastruct.players = {}

gmod.Hook("msp", function(id, x,y,z, p,y)
	local data = metastruct.players[id]
	
	if data then
		data.pos.x = x
		data.pos.y = y
		data.pos.z = z
		
		data.ang.p = p
		data.ang.y = y
		
		data.ent:SetPos(data.pos)
		data.ent:SetRotation(data.ang:GetAng3())
	end	
end)

gmod.Hook("mspc", function(id, nick)
	if metastruct.players[id] then
		metastruct.players[id].ent:Remove()
		metastruct.players[id] = nil
	end

	local data = {}
		
	data.pos = Vec3(0,0,0)
	data.ang = Ang3(0,0,0)
	
	data.ent = entities.Create("Grunt")
	data.ent.msref = {id = id, nick = nick}
	
	metastruct.players[id] = data
end)

gmod.Hook("mspd", function(id)
	metastruct.players[id].ent:Remove()
	metastruct.players[id] = nil
end)

gmod.Send("l", [[
for key, ply in pairs(player.GetAll()) do
	oohh.Send("mspc", ply:EntIndex(), ply:Nick())
end

hook.Add("OnEntityCreated", "cryenginesync", function(ply)
	if ply:IsPlayer() and ply:IsValid() then
		oohh.Send("mspc", ply:EntIndex(), ply:Nick())
	end
end)

hook.Add("EntityRemoved", "cryenginesync", function(ply)
	if ply:IsPlayer() and ply:IsValid() then
		oohh.Send("mspd", ply:EntIndex())
	end
end)

hook.Add("Think", "cryenginesync", function()
	for key, ply in pairs(player.GetAll()) do
		local pos = ply:GetPos()
		local ang = ply:EyeAngles()
		
		oohh.Send("msp", ply:EntIndex(), math.ceil(pos.x), math.ceil(pos.y), math.ceil(pos.z),  math.ceil(ang.p), math.ceil(ang.y))
	end
end)
]])