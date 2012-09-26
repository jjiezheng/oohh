local SCOREBOARD_WIDTH = 400

local FONTSIZE = 10

local fadingin = false
local fadingout = false
local showing = false

local alpha = 0

hook.Add("DrawHUD", "scoreboard", function()
    if not entities.GetLocalPlayer():IsValid() then return end

    if fadingin then
        if alpha == 0.8 then
            fadingin = false
            showing = true
        else
            alpha = math.clamp(alpha + 0.1, 0, 0.8)
        end
    end
    
    if fadingout then
        if alpha == 0 then
            fadingout = false
            showing = false
        else
            alpha = math.clamp(alpha - 0.1, 0, 0.8)
        end
    end
        
    local scrw, scrh = render.GetScreenSize()
    
    local playertable = entities.GetAllPlayers()
    
    local h = table.count(playertable) * FONTSIZE * 2.3
    
    graphics.DrawRect(
        Rect((scrw / 2) - (SCOREBOARD_WIDTH / 2), (scrh / 2) - (h / 2), SCOREBOARD_WIDTH, h),
        Color(0, 0, 0, alpha), 10,
        nil, nil, nil, nil,
        false, true, true, true)
        
    graphics.DrawRect(
        Rect((scrw / 2) - (SCOREBOARD_WIDTH / 2), (scrh / 2) - (h / 2) - 20, 90, 20),
        Color(0, 0, 0, alpha), 10,
        nil, nil, nil, nil,
        true, false, true, false)
    
    local x = ((scrw / 2) - (SCOREBOARD_WIDTH / 2)) + 10
    local y = (scrh / 2) - (h / 2) + 10
    local pingx = ((scrw / 2) + (SCOREBOARD_WIDTH / 2)) - FONTSIZE
    
    graphics.DrawText(table.count(playertable) .. " players", Vec2(x, (scrh / 2) - (h / 2) - FONTSIZE - 3), "segoeui.ttf", Vec2() + FONTSIZE, Color(1, 1, 1, alpha))
     
    for k, v in pairs(playertable) do
        graphics.DrawText(v:GetNickname(), Vec2(x, y), "segoeui.ttf", Vec2() + FONTSIZE, Color(1, 1, 1, alpha))
        graphics.DrawText(math.round(v:GetPing(true) * 1000), Vec2(pingx, y), "segoeui.ttf", Vec2() + FONTSIZE, Color(1, 1, 1, alpha), Vec2(-1, 0))
        
        y = y + FONTSIZE + 10
    end
end)

hook.Add("OnKeyInput", "scoreboard", function(key, press)
	if key == "tab" then
		if press then
			fadingin = true
			fadingout = false
		else
			fadingin = false
			fadingout = true
		end
	end
end)

util.MonitorFileInclude()