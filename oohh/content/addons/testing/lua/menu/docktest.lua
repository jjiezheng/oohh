
docktest = aahh.Create("frame")

local frame = docktest

frame:SetMargin(Rect(4, 17, 4, 4))
frame:SetTitle("dock test")
frame:SetSize(Vec2(512, 512))
frame:Center()

local textinput = aahh.Create("textinput", frame)
textinput:Dock("fill")
textinput:SetSize(Vec2(20, 20))

local textinput = aahh.Create("textinput", frame)
textinput:Dock("top")
textinput:SetSize(Vec2(20, 20))

local textinput = aahh.Create("textinput", frame)
textinput:Dock("bottom")
textinput:SetSize(Vec2(20, 20))

local textinput = aahh.Create("textinput", frame)
textinput:Dock("left")
textinput:SetSize(Vec2(20, 20))

local textinput = aahh.Create("textinput", frame)
textinput:Dock("right")
textinput:SetSize(Vec2(20, 20))

util.MonitorFileInclude()

