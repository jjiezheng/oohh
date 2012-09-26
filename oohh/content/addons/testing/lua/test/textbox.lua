--x,y mouse.GetPos()
--mouse.ShowCursor(true)  
--
--window.SetClipboard(str)
--str = windo.GetClipboard()
--input.IsKeyDown(str) 
--!lc TextBox.Create(Vec2(1600,512),30,2,Color(1,1,1,1),12) TextBox.Create(Vec2(768,768),30,2,Color(1,1,1,1),12) 
--!lc TextBox.Create(Vec2(1600,768),30,2,Color(1,1,1,1),12) 
--!lc for k,v in ipairs(TextBox.Boxes) do graphics.DrawFilledRect(Rect(v.Pos.x,v.Pos.y,v.Cwidth*16,v.Cheight*16,0.7),v.Color) graphics.DrawOutlinedRect(Rect(v.Pos.x,v.Pos.y,v.Cwidth*16,v.Cheight*16,0.7),Color(0,0,0,1)) end

TextBox={}
TextBox.Total=1
TextBox.Boxes={}

--creates a new textbox
TextBox.Create=function(pos,cwidth,cheight,color,size)
	TextBox.Boxes[TextBox.Total]={}
	TextBox.Boxes[TextBox.Total].Pos=pos
	TextBox.Boxes[TextBox.Total].Cwidth=cwidth
	TextBox.Boxes[TextBox.Total].Cheight=cheight
	TextBox.Boxes[TextBox.Total].Color=color
	TextBox.Boxes[TextBox.Total].Size=size
	TextBox.Boxes[TextBox.Total].Text="a"
	TextBox.Boxes[TextBox.Total].Font="consola.ttf"
	TextBox.Boxes[TextBox.Total].Focus=false
	TextBox.Boxes[TextBox.Total].Enabled=true
	TextBox.Boxes[TextBox.Total].MultiLine=true
	TextBox.Boxes[TextBox.Total].Lines={}
	TextBox.Boxes[TextBox.Total].CurrentLine=1
	TextBox.Boxes[TextBox.Total].Pointer=1
	TextBox.Boxes[TextBox.Total].PointerX=1
	TextBox.Boxes[TextBox.Total].PointerY=1
	TextBox.Boxes[TextBox.Total].CharPositions={}
	TextBox.Boxes[TextBox.Total].CharPosWidth=(8.75*v.Size)/10
	TextBox.Boxes[TextBox.Total].CharPosHeight=(8.75*v.Size)/10
	local total=1
	for i=1,cheight do
		for j=1,cwidth do
			TextBox.Boxes[TextBox.Total].CharPositions[total]=Vec2((v.Pos.x+2)+(total*(8.75*v.Size)/10),(v.Pos.y+2)+((i*(8.75*v.Size)/8.25)-(8.75*v.Size)/8.25))
			total=total+1
		end
	end
	TextBox.Total=TextBox.Total+1
end

--returns the textbox thats focused by user
TextBox.GetFocused=function()
for k,v in ipairs(TextBox.Boxes) do
	if v.Focus==true then
		return v
	end
end
end

--internal function, it calculates the pointer position
TextBox.PointerCalc=function(id)
	local linesused=math.floor(TextBox.Boxes[id].Pointer/(TextBox.Boxes[id].Cwidth+1))
	local linedifference=(TextBox.Boxes[id].Pointer/(TextBox.Boxes[id].Cwidth+1))-linesused
	local charused=TextBox.Boxes[id].Pointer-(linesused*(TextBox.Boxes[id].Cwidth+1))
	if linedifference>0 then
			TextBox.Boxes[id].PointerY=linesused+1
	else
		TextBox.Boxes[id].PointerY=linesused
	end
	if charused==0 then
		TextBox.Boxes[id].PointerX=TextBox.Boxes[id].Cwidth+1
	else
		TextBox.Boxes[id].PointerX=charused
	end
end

--returns true if an character is valid, not any symbol character
TextBox.KeyIsValid=function(key)
	local valid={"a","A","b","B","c","C","d","D","e","E","f","F","g","G","h","H","i","I",
	"j","J","k","K","l","L","m","M","n","N","o","O","p","P","q","Q","r","R","s","S","t","T"
	,"u","U","v","V","w","W","x","X","y","Y","z","Z","0","1","2","3","4","5","6","7","8","9"
	,".",",","/","|","\\","[","]","(",")","*","-","+","^","~",";","<",">","=","@","!","#",
	"%","¨","&","^","~",";","*","'",'"',"$","_"," "}
	local result=false
	for k,v in ipairs(valid) do
		if key==v then
			result=true
		end
	end
	return result
end

--draw the textboxes
hook.Add("DrawHUD", "TextBoxDraw", function()
	for k,v in ipairs(TextBox.Boxes) do
		if v.Enabled==true then
			graphics.DrawFilledRect(Rect(v.Pos.x,v.Pos.y,(v.Cwidth*(v.Size*0.92)),v.Cheight*(v.Size*1.3),0.7),v.Color) 
			graphics.DrawOutlinedRect(Rect(v.Pos.x,v.Pos.y,(v.Cwidth*(v.Size*0.92)),v.Cheight*(v.Size*1.3),0.7),0.7,Color(0,0,0,1))
			--TextBox.Boxes[k].Lines=split(TextBox.Boxes[k].Text,"\\n") 
			TextBox.Boxes[k].Text=""
			local totaldrawed=0
			for a,b in ipairs(TextBox.Boxes[k].Lines) do
				if a<=TextBox.Boxes[k].Cheight then 
					TextBox.Boxes[k].Text=TextBox.Boxes[k].Text..b
				end
			end
			TextBox.PointerCalc(k)
			for a,b in ipairs(TextBox.Boxes[k].Lines) do
				local totalchunk=0
				if a<=TextBox.Boxes[k].Cheight then 
					for chunk in b:gmatch(".") do
						graphics.DrawText(chunk,Vec2((v.Pos.x+2)+(totalchunk*(8.75*v.Size)/10),(v.Pos.y+2)+((a*(8.75*v.Size)/8.25)-(8.75*v.Size)/8.25)),v.Font,v.Size,Color(0,0,0,1))
						totalchunk=totalchunk+1
						if v.Focus==true then 
							graphics.DrawText("|",Vec2((v.Pos.x+2)+(v.PointerX*((8.75*v.Size)/10)),(v.Pos.y+2)+((v.PointerY*(8.75*v.Size)/8.25)-(8.75*v.Size)/8.25)),v.Font,v.Size,Color(0,0,0,1))
						end
					end
				end
			end
		end
	end
end)

--lots of input controls
hook.Add("OnKeyInput", "TextBoxInput", function(key, pressed)
	--print(key)
	if key=="left" then
	elseif key=="right" then
	elseif key=="up" then
	elseif key=="down" then
	elseif key=="mouse1" then
		x,y=mouse.GetPos()
		for a,b in ipairs(TextBox.Boxes) do
			b.Focus=false
		end
		for k,v in ipairs(TextBox.Boxes) do
			if v.Enabled==true then
				if x>(v.Pos.x) and x<(v.Pos.x+(v.Cwidth*16)) and y>(v.Pos.y) and y<(v.Pos.y+(v.Cheight*16)) then
					for a,b in ipairs(TextBox.Boxes) do
						b.Focus=false
					end
					v.Focus=true
				end
			end
		end
	end
	if TextBox.GetFocused()~=nil then
		mouse.ShowCursor(true)
		return false
	end
end)

hook.Add("PostGameUpdate", "TextBoxThink", function()
	if TextBox.GetFocused()~=nil then
		mouse.ShowCursor(true)
		return false
	else
		if input.IsKeyDown("c")==true then
			mouse.ShowCursor(true)
		else
			mouse.ShowCursor(false)
		end
	end
end)

--!lc TextBox.Create(Vec2(768,512),30,2,Color(1,1,1,1),12) 
--convert pressed keys into text for focused and enabled textboxes
hook.Add("OnCharInput","TextBoxWrite",function(str)
	--print(string.byte(str))
	local txt=TextBox.GetFocused()
	if txt~=nil then
		print(txt.Text)
		if TextBox.KeyIsValid(str)==true then
			if txt.Lines[txt.CurrentLine]==nil then
				txt.Lines[txt.CurrentLine]=""
			end
			if string.len(txt.Lines[txt.CurrentLine])>txt.Cwidth then
				txt.CurrentLine=txt.CurrentLine+1
				if txt.Lines[txt.CurrentLine]==nil then
					txt.Lines[txt.CurrentLine]=""
				end
				txt.Lines[txt.CurrentLine]=txt.Lines[txt.CurrentLine]..str
			else
				txt.Lines[txt.CurrentLine]=txt.Lines[txt.CurrentLine]..str
			end
		end
	end
	if txt~=nil then
		if string.byte(str)==8 then
			if txt.Lines[txt.CurrentLine] == "" then
				if txt.CurrentLine>1 then
					txt.CurrentLine=txt.CurrentLine-1
				end
			else
				if string.len(txt.CurrentLine)>=1 then
					txt.Lines[txt.CurrentLine]=string.sub(txt.Lines[txt.CurrentLine],1,string.len(txt.Lines[txt.CurrentLine])-1)
				end
			end
		end
	end
end)

--split string into table function..
function split (s, delim)
  assert (type (delim) == "string" and string.len (delim) > 0,
          "bad delimiter")
  local start = 1
  local t = {}
  while true do
	local pos = string.find (s, delim, start, true)
    if not pos then
      break
    end
    table.insert (t, string.sub (s, start, pos - 1))
    start = pos + string.len (delim)
  end 
  table.insert (t, string.sub (s, start))
  return t
end

util.MonitorFileInclude()