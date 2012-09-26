if SERVER then
	local ent = entities.Create("BasicEntity")
	ent:Spawn()
	ent:NetBind()
	ent:SetPos(entities.GetLocalPlayer():GetPos())
	ent:SetModel("objects/props/storage/crates/palette_box.cgf")
	local phys = ent:PhysicalizeEx(PE_RIGID)
	phys:Wake()
	
	print(ent, ent:GetPos())
end