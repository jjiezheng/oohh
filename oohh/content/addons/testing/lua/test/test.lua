TextBox={}
TextBox.Total=1
TextBox.Boxes={}
--x,y mouse.GetPos()
--mouse.ShowCursor(true)  
--!lc TextBox.Create(Vec2(512,512),30,2,Color(1,1,1,1))
--!lc for k,v in ipairs(TextBox.Boxes) do graphics.DrawFilledRect(Rect(v.Pos.x,v.Pos.y,v.Cwidth*16,v.Cheight*16,0.7),v.Color) graphics.DrawOutlinedRect(Rect(v.Pos.x,v.Pos.y,v.Cwidth*16,v.Cheight*16,0.7),Color(0,0,0,1)) end

TextBox.Create=function(pos,cwidth,cheight,color)
	TextBox.Boxes[TextBox.Total]={}
	TextBox.Boxes[TextBox.Total].Pos=pos
	TextBox.Boxes[TextBox.Total].Cwidth=cwidth
	TextBox.Boxes[TextBox.Total].Cheight=cheight
	TextBox.Boxes[TextBox.Total].Color=color
	TextBox.Boxes[TextBox.Total].Text=""
	TextBox.Boxes[TextBox.Total].Focus=false
	TextBox.Boxes[TextBox.Total].Enabled=true
	TextBox.Total=TextBox.Total+1
end

hook.Add("DrawHUD", "TextBoxDraw", function()
	for k,v in ipairs(TextBox.Boxes) do
		graphics.DrawFilledRect(Rect(v.Pos.x,v.Pos.y,v.Cwidth*16,v.Cheight*16,0.7),v.Color)
		graphics.DrawOutlinedRect(Rect(v.Pos.x,v.Pos.y,v.Cwidth*16,v.Cheight*16,0.7),0.7,Color(0,0,0,1))
	end
end)

local CursorEnabled=false
hook.Add("OnKeyInput", "TextBoxInput", function(key, pressed)
	if key=="mouse1" then
		x,y=mouse.GetPos()
		for k,v in ipairs(TextBox.Boxes) do
			if x>
		end
	end
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