if SERVER then 
mouse.ShowCursor(false)
return end

aahh = {}

aahh.ActivePanels = aahh.ActivePanels or {}
aahh.ActivePanel = NULL
aahh.World = NULL
aahh.Stats = 
{
	layout_count = 0
}

function aahh.Initialize()
	aahh.UseSkin("default")
	
	local WORLD = aahh.Create("base")
		WORLD:SetMargin(Rect()+5)
		
		function WORLD:GetSize()
			return Vec2(render.GetScreenSize())
		end
		
		function WORLD:GetPos()
			return Vec2(0, 0)
		end
		
	aahh.World = WORLD

	hook.Call("PostAahhInit")
end

aahh.IsSet = class.IsSet

function aahh.GetSet(PANEL, name, var, ...) 
	class.GetSet(PANEL, name, var, ...)
	if name:find("Color") then
		PANEL["Set" .. name] = function(self, color) 
			self[name] = self:HandleColor(color) or var
		end 
	end
end

function aahh.Panic()
	for key, pnl in pairs(aahh.ActivePanels) do
		pnl:Remove()
	end

	aahh.ActivePanels = {}
end

aahh.LayoutRequests = {}

include("panels.lua")
include("events.lua")
include("skin.lua")
include("util.lua")

aahh.Initialize()