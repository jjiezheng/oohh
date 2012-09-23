local RANGE = 20
local ZOFFSET = 2

local TEXT_OFFSET = Vec2(-0.5, 0)
local HEALTH_TEXT_OFFSET = Vec2(-0.5, 3.3)

local HEALTH_BAR_WIDTH = 100
local HEALTH_BAR_HEIGHT = 20

hook.Add("DrawHUD", "nametags", function()
	local me = entities.GetLocalPlayer()
	-- if not in game return end
	if not me:IsValid() then return end
	
	for key, ent in pairs(entities.FindInSphere(me:GetPos(), RANGE)) do
		if typex(ent) == "player" and me ~= ent then
            local dist = (me:GetPos() - ent:GetPos()):GetLength()
            local alpha = -(dist / RANGE)
            
            local pos, vis = (ent:GetPos() + Vec3(0, 0, ZOFFSET)):ToScreen()
            
            local text = ent:GetNickname()-- .. " [" .. math.floor(dist) .. "m]"
            
            local healthcol = Color(1, 0, 0, alpha)
            healthcol:SetHue(ent:GetHealth() / ent:GetMaxHealth() * 100)
            local healthtext = math.floor(ent:GetHealth() / ent:GetMaxHealth() * 100) .. "%"
            
            if vis > 0 then
                graphics.DrawText(text, pos, "impact.ttf", Vec2()+15, Color(1, 1, 1, alpha), TEXT_OFFSET, Vec2()+2)
				
                if ent:GetHealth() > 0 and ent:GetHealth() < ent:GetMaxHealth() then					
					graphics.DrawRect(Rect(pos.x - 52, pos.y + 25, HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT), Color(1, 1, 1, alpha), 4, 1, Color(0,0,0,alpha))
                    
                    local w = HEALTH_BAR_WIDTH * (ent:GetHealth() / ent:GetMaxHealth())
                    graphics.DrawRect(Rect(pos.x - 52, pos.y + 25, w, HEALTH_BAR_HEIGHT):Shrink(0.9), healthcol, 4)
                 
                    graphics.DrawText(healthtext, pos, "arial.ttf", Vec2(10, 10), Color(0, 0, 0, alpha), HEALTH_TEXT_OFFSET)
                end
				
				if DrawChatAboveHead then
					DrawChatAboveHead(pos + Vec2(0, 60), ent:GetChatAboveHead())
				end
            end
		end
	end
end)

util.MonitorFileInclude()