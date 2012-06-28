chatgui = chatgui or {}

chatgui.font = "arial.ttf"
chatgui.font_size = 12
chatgui.max_history = 20
chatgui.spacing = 1.2

chatgui.history = chatgui.history or {}

local function add_0(n)
	return n < 10 and "0"..n or n
end

function chatgui.Show(fade) 
	for key, data in ipairs(chatgui.history) do
		data.alpha = 0 - (key / chatgui.max_history)
		data.fade = fade
	end
end

function chatgui.Hide()
	for key, data in ipairs(chatgui.history) do 
		data.alpha = 0 - (key / chatgui.max_history)
	end
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
	
	chatgui.show = true
	
	--timer.Simple(10, function() chatgui.show = false end)
end

function chatgui.PlayerSay(ply, str)
	chatgui.AddLine(chatgui.GetTimeStamp() .. ply:GetNickname() .. ": " .. str)
end

hook.Add("PlayerSay", "chatgui", chatgui.PlayerSay)

function chatgui.Draw()
	if not chatgui.show then return end
	for key, data in ipairs(chatgui.history) do
		if not data.fade then data.alpha = math.min(data.alpha + FrameTime() * 8, 1) end
		graphics.DrawText(
			data.str,
			Vec2(x, (data.alpha * chatgui.font_size) + graphics.GetScreenSize().h * 0.5) + Vec2(chatgui.font_size, ((key - #chatgui.history) * chatgui.font_size * chatgui.spacing)),  
			chatgui.font, 
			chatgui.font_size, 
			Color(1, 1, 1, data.alpha),
			Vec2(0,0), 
			Vec2()+1,
			Color(0,0,0,data.alpha)
		)
	end
end

hook.Add("PreDrawMenu", "chatgui", chatgui.Draw, print)
 
if SERVER then
	hook.Add("PlayerSay", "easyluachat", function(ply, str)
		printf("%s : %s", ply:GetNickname(), str)
	end)  
end 

util.MonitorFileInclude()