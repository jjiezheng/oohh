chatgui = chatgui or {}

chatgui.font = "consola.ttf"
chatgui.font_size = 14
chatgui.max_history = 20
chatgui.spacing = 1.4

chatgui.history = chatgui.history or {}

chatgui.alpha = 1

local COLOR_LIGHT = aahh.GetSkinColor("light")
local COLOR_DARK = aahh.GetSkinColor("dark")

local function add_0(n)
	return n < 10 and "0"..n or n
end

function chatgui.Show() 
	chatgui.show = true
end

function chatgui.Hide()
	chatgui.show = false
end

function chatgui.GetTimeStamp()
	local time = os.date("*t")
	return string.format("%s:%s", add_0(time.hour), add_0(time.min)) .. " - "
end
 
function chatgui.AddLine(str)	
	if #chatgui.history > chatgui.max_history then
		table.remove(chatgui.history, 1)
	end
	table.insert(chatgui.history, {str = str, alpha = 0})
		
	chatgui.Show()
		
	timer.Create("hide_chatgui", 15, 1, function() chatgui.Hide() end)
end

function chatgui.PlayerSay(ply, str)
	if typex(ply) == "player" then
		ply = ply:GetNickname()
	else
		ply = tostring(ply)
	end
	chatgui.AddLine(chatgui.GetTimeStamp() .. ply .. ": " .. str)
end

hook.Add("PlayerSay", "chatgui", chatgui.PlayerSay)

function chatgui.Draw()
	
	if chatgui.show then
		chatgui.alpha = math.clamp(chatgui.alpha + FrameTime()*10, 0, 1)
	else
		chatgui.alpha = math.clamp(chatgui.alpha - FrameTime()*0.5, 0, 1)
	end	

	if chatgui.alpha < 0.1 then return end
	
	for key, data in ipairs(chatgui.history) do	
		graphics.DrawText(
			data.str,
			Vec2(0, (chatgui.alpha * chatgui.font_size) + graphics.GetScreenSize().h * 0.5) + Vec2(chatgui.font_size, ((key - #chatgui.history) * chatgui.font_size * chatgui.spacing)), 
			chatgui.font, 
			chatgui.font_size, 
			Color(COLOR_LIGHT.r, COLOR_LIGHT.g, COLOR_LIGHT.b, chatgui.alpha),
			Vec2(0,0), 
			Vec2()+1,
			Color(COLOR_DARK.r, COLOR_DARK.g, COLOR_DARK.b, chatgui.alpha)
		)
	end
end

hook.Add("PreDrawMenu", "chatgui", chatgui.Draw, print)

util.MonitorFileInclude()