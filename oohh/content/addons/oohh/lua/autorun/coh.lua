local META = util.FindMetaTable("player")

local FONT = "arial.ttf"
local SIZE = 10

function META:GetChatAboveHead()
	return self.coh_str or ""
end

if CLIENT then
	function META:SetChatAboveHead(str, send)
		self.coh_str = str
		
		if send and entities.GetLocalPlayer() == self then
			message.Send("coh", str)
		end 
	end

	hook.Add("OnChatTextChanged", "coh", function(str)
		message.Send("coh", str)
	end)
	
	message.Hook("coh", function(ply, str) 
		ply:SetChatAboveHead(str)
	end)
	 
	function DrawChatAboveHead(pos, str) 
		if str ~= "" then
			local size = graphics.GetTextSize(FONT, str) * SIZE
			pos = pos - size / 2
			graphics.DrawRect(Rect(pos.x, pos.y, size.w, size.h):Expand(6), Color(1, 1, 1, 1), 2, 1, Color(0,0,0,1))
			graphics.DrawText(str, pos, FONT, Vec2()+SIZE, Color(0, 0, 0, 1))
		end
	end
end

if SERVER then
	function META:SetChatAboveHead(str)
		self.coh_str = str
		message.Send("coh", nil, self, str)
	end
	
	message.Hook("coh", function(ply, str)
		local filter = message.PlayerFilter()
		filter:AddAllExcept(ply)
		message.Send("coh", filter, ply, str)
	end)
end 

util.MonitorFileInclude()