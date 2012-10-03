include("richtext.lua")

local frame = util.RemoveOldObject(aahh.Create("frame"))
frame:Center()
frame:SetSize(100,100)

local test = aahh.Create("RichText", frame)
test:Dock("fill")
test:Add("hell\n\nadasdasdas\nasdasd",Color(255,0,0))