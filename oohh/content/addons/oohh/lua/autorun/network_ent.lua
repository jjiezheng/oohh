console.AddCommand("test_box", function(ply)
	local ent = entities.Create("BasicEntity", nil)
		ent:Spawn()
		ent:SetModelNoNetwork("objects/box.cgf")
		ent:SetPos(ply:GetEyeTrace().HitPos)
end, true)