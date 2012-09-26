local GRENADE_SIZE = 14
local HEALTH_SIZE = 30

hook.Add("DrawHUD", "hud", function()
    local me = entities.GetLocalPlayer()
    if not me:IsValid() then return end
    
    local w, h = render.GetScreenSize()
    
    local health = math.round(me:GetHealth() / me:GetMaxHealth() * 100)
    if health > 0 and health < 100 then
        local alpha = 0.8
       
        if health <= 25 then
            alpha = math.abs(math.sin(CurTime() * 8) * 0.8)
        end
        
        local healthcol = Color(1, 0, 0, alpha)
        healthcol:SetHue(health)
        
        graphics.DrawText(health .. "%", Vec2(30, h - HEALTH_SIZE - 30), "segoeui.ttf", Vec2() + HEALTH_SIZE, healthcol, nil, Vec2() + 1)
    end
    
    local wep = me:GetActiveWeapon()
    if wep == NULL then return end
    local ammo = wep:GetAmmoCount(wep:GetClass())
    
    graphics.DrawText("1", Vec2(w - GRENADE_SIZE - 20, h - GRENADE_SIZE - 70), "segoeui.ttf", Vec2() + GRENADE_SIZE, Color(1, 1, 1, 0.8), Vec2(-1, 0), Vec2() + 1)
    graphics.DrawText(ammo, Vec2(w - HEALTH_SIZE, h - HEALTH_SIZE - 30), "segoeui.ttf", Vec2() + HEALTH_SIZE, Color(1, 1, 1, 0.8), Vec2(-1, 0), Vec2() + 1)
end)

util.MonitorFileInclude()