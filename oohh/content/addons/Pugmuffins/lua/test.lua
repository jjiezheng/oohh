-- local ScrH = Vec2(render.GetScreenSize()).h;
-- local health = entities.GetLocalPlayer():GetHealth();

-- hook.Add("DrawHUD", 1, function()
-- 	health = entities.GetLocalPlayer():GetHealth();
-- 	graphics.DrawRect( Rect(32, ScrH - 256, (health / 100) * 128, 16), Color(0.75, 0.4, 0.4, 1) );

-- 	--graphics.DrawRect(x, y, w, h, c)
-- end);
if CRYSTAL and CRYSTAL:IsValid() then CRYSTAL:Remove() end
local mat = materials.CreateFromFile("objects/Crystalisk_Structure/Skel_Crystalisk.mtl");

CRYSTAL = entities.Create("BasicEntity");
CRYSTAL:SetPos(there);
CRYSTAL:Spawn();
-- CRYSTAL:SetModelNoNetwork("objects/Crystalisk_Structure/Crystalisk_Structure.cgf");
CRYSTAL:SetModelNoNetwork("objects/Crystalisk_Structure/Skel_Crystalisk.cgf");
CRYSTAL:SetMaterial(mat);
CRYSTAL:SetScale(Vec3(1, 1, 1) * 0.25)
print(mat:GetName())

util.MonitorFileInclude();