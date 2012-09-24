local TextBox={}
TextBox.Total=1
TextBox.Boxes={}
--x,y mouse.GetPos()
--mouse.ShowCursor(true)
TextBox.Create=function(rect,color)
	TextBox.Boxes[TextBox.Total]={}
	TextBox.Boxes[TextBox.Total].Rect=rect
	TextBox.Boxes[TextBox.Total].Color=color
	TextBox.Total=TextBox.Total+1
end

hook.Add("DrawHUD", "TextBoxDraw", function()
	for k,v in ipairs(TextBox.Boxes) do
	end
	--graphics.DrawFilledRect(Rect(512,512,64,16),Color(1,1,1,1))
end)

local CursorEnabled=false
hook.Add("OnKeyInput", "TextBoxInput", function(key, pressed)
	print(key)
	if key=="c" then
		if CursorEnabled==false then
			mouse.ShowCursor(true)
			CursorEnabled=true
		else
			mouse.ShowCursor(false)
			CursorEnabled=false
		end
	end
end)

util.MonitorFileInclude()