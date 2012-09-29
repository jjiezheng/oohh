local RANGE = 20
local ZOFFSET = 2

local TEXT_OFFSET = Vec2(-0.5, 0)

local HEALTH_BAR_WIDTH = 100
local HEALTH_BAR_HEIGHT = 10

local COLOR = aahh.GetSkinColor("light")
local COLOR_DARK = aahh.GetSkinColor("dark")
local H,S,L = ColorToHSV(aahh.GetSkinColor("highlight1"))

hook.Add("DrawHUD", "nametags", function()
	local me = entities.GetLocalPlayer()
	-- if not in game return end
	if not me:IsValid() then return end
    
    local trace = me:GetEyeTrace().HitPhysics
    if trace:IsValid() then
        trace = trace:GetEntity()
        if typex(trace) == "player" and (trace:GetHealth() / trace:GetMaxHealth() * 100) > 0 then
            local scrw, scrh = render.GetScreenSize()
            graphics.DrawText(trace:GetNickname() .. " " .. math.round(trace:GetHealth() / trace:GetMaxHealth() * 100) .. "%", Vec2(scrw / 2, scrh / 2 + 100), "segoeui.ttf", Vec2() + 14, COLOR, TEXT_OFFSET, Vec2() + 1)
        end
    end
	
	for key, ent in pairs(entities.FindInSphere(me:GetPos(), RANGE)) do
		if typex(ent) == "player" and me ~= ent then
			local wpos
			if (ent:GetParent() or NULL):IsValid() then
				wpos = ent:GetParent():GetPos() 
			else
				wpos = ent:GetPos()
			end
			
            local dist = (me:GetPos() - wpos):GetLength()
            local alpha = -(dist / RANGE)
			
            local pos, vis = (wpos + Vec3(0, 0, ZOFFSET)):ToScreen()
            
            if vis > 0 then
                local healthcol = Color(1, 0, 0, alpha)
                healthcol:SetHue(ent:GetHealth() / ent:GetMaxHealth() * 100)
				healthcol:SetSaturation(S)
				healthcol:SetLightness(L)
                local healthtext = math.round(ent:GetHealth() / ent:GetMaxHealth() * 100) .. "%"
                
                graphics.DrawText(ent:GetNickname(), pos, "segoeui.ttf", Vec2() + 18, Color(COLOR.r, COLOR.g, COLOR.b, alpha), TEXT_OFFSET, Vec2() + 1)
				
                if ent:GetHealth() > 0 and ent:GetHealth() < ent:GetMaxHealth() then					
					graphics.DrawRect(Rect(pos.x - 52, pos.y + 25, HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT), Color(COLOR_DARK.r, COLOR_DARK.g, COLOR_DARK.b, alpha), nil, 1, Color(0, 0, 0, alpha))
                    
                    local w = HEALTH_BAR_WIDTH * (ent:GetHealth() / ent:GetMaxHealth())
                    graphics.DrawRect(Rect(pos.x - 52, pos.y + 25, w, HEALTH_BAR_HEIGHT):Shrink(0.9), healthcol)
                end
				
				if DrawChatAboveHead then
					DrawChatAboveHead(pos + Vec2(0, 50), ent:GetChatAboveHead(), alpha)
				end
            end
		end
	end
end)

util.MonitorFileInclude()