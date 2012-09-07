
docktest = aahh.Create("frame")

local frame = docktest

frame:SetMargin(Rect(4, 17, 4, 4))
frame:SetTitle("dock test")
frame:SetSize(Vec2(512, 512))
frame:Center()

local textentry = aahh.Create("textentry", frame)
textentry:Dock("fill")
textentry:SetSize(Vec2(20, 20))

local textentry = aahh.Create("textentry", frame)
textentry:Dock("top")
textentry:SetSize(Vec2(20, 20))

local textentry = aahh.Create("textentry", frame)
textentry:Dock("bottom")
textentry:SetSize(Vec2(20, 20))

local textentry = aahh.Create("textentry", frame)
textentry:Dock("left")
textentry:SetSize(Vec2(20, 20))

local textentry = aahh.Create("textentry", frame)
textentry:Dock("right")
textentry:SetSize(Vec2(20, 20))

util.MonitorFileInclude()

