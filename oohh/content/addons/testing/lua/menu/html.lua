local frame = aahh.Create("frame")
frame:SetTitle("internet")
frame:SetSize(Vec2(512, 512))
frame:Center()

local html = aahh.Create("html", frame)
html:Dock("fill")
html:LoadURL("http://www.google.com/")