
local font_size = 15
local function GetTextSize(str)
	local w, h = surface.GetTextSize(surface.GetFont(), str)
	local ws, hs = render.GetScreenScale()
	return w*font_size,h*font_size
end


-- Fonts
	-- Normal font
	local defaultfont=Font("opensans.ttf")

	-- ChatPrint font
	local chatprint_color = Color( 0.7,1,0.5, 255) -- lime green. EEK!
	local chatprint_font  = Font("tahoma.ttf")

local function SetFont(str)
	return graphics.GetFont(str) or defaultfont
end

	
local bigfont=Font("impact.ttf")
local todraw={}

local function DrawText(txtdata,frac,drawoffset)
	local _a=os.clock()
	local x,y=10,drawoffset
	surface.SetTranslation(0,0)
	local fx,fy=x,y

	local maxtall = 0

	-- grab maxtall and etc.
	for k,v in pairs(txtdata) do
        if type(v) == "string" then
            local w,h=GetTextSize(v)
            maxtall=maxtall<h and h or maxtall
			fx,fy=fx+w,fy+h     
        elseif v[1] and type(v[1])=="string" then
			SetFont(v[1])
		end
    end
	fy=y+maxtall
	--surface.SetDrawColor(100,100,100,30)
	--surface.DrawRect(x,y,fx-x,fy-y)
	-- AGAIN --

	local fx,fy=x,y
	local maxtall = 0	
	for k,v in pairs(txtdata) do
        if type(v) == "string" then
            local w,h=GetTextSize(v)
            maxtall=maxtall<h and h or maxtall
			fx,fy=fx+w,fy+h
            surface.DrawText(v, x+w, y, (Vec2()+font_size) / Vec2(render.GetScreenScale()) * 1.75, nil, nil, 2)
        elseif v.r then
			surface.SetColor(Color( v.r,v.g,v.b,v.a and frac or frac))
		elseif v[1] and type(v[1])=="string" then
			SetFont(v[1])
		end
    end

	return maxtall
end



local length=4
local startpadding=11
local startfade=.2
local function DoDraw(i,txtdata,start,drawoffset)
	local frac=((start-(os.clock()-length-startpadding))/length)
	local frac2=(os.clock()-start)/startfade
	frac=frac>1 and 1 or frac<0 and 0 or frac
	if frac<=0 then 
		table.remove(todraw,i)
		return 0
	end
	frac2=frac2>1 and 1 or frac2<0 and 0 or frac2
	frac=frac*frac2

	surface.SetColor(Color( 1,1,1,frac))
    SetFont(defaultfont)
	local maxtall=DrawText(txtdata,frac,drawoffset)

	return maxtall+2
end

local first=5
local function HUDPaint() 
	local _, h = render.GetScreenSize()
	-- spamcheck..
	local remove=true
	
	local drawoffset=h*0.5

	local data,i=true,0
	while data do
		i=i+1
		data = todraw[i]
		if not data then break end

		remove=false
        data[3]=data[3] or h*0.5
		drawoffset=drawoffset - ( DoDraw( i, data[1], data[2], data[3] )  )
		data[3]=math.approach(data[3],drawoffset,FrameTime()*150)
	end

	if remove then
		hook.Remove("DrawHUD", "chatgui")
	end
end

local function unitochartable(ustring)
	local tbl={}
	local len=0
	--for uchar in string.gmatch(ustring, "([%z\1-\127\194-\244][\128-\191]*)") do
	for uchar in ustring:gmatch("(.)") do
          tbl[#tbl+1]=uchar
		  len=len+#uchar
    end
	return tbl
end

local function Wide(txt,font,maxwide)
	local wide = 0
	if font then
		SetFont(font)
	end
    local tbl={}
	local txttbl=unitochartable(txt)
	local size=#txttbl
	local split=false
	local lastspacepos
	local lastspacepos_wide
	local pos=0
	for i=1,size do
            local char=txttbl[i]
			pos=pos+#char
			local w,h=GetTextSize(char=="&" and "%" or char)
			if char==" " then lastspacepos,lastspacepos_wide=pos,wide end
            if  wide+w >= maxwide then
                if lastspacepos then
					split=lastspacepos
					wide=lastspacepos_wide
					break
				end
				split=pos
                break
			end
	    wide=wide+w

    end
	if split then
		local x=split
		local left,right=txt:sub(1,x),txt:sub(x+1,-1)
		local left=left or ""
		right=right:len()>0 and right
		return wide,left,right
	else
		return wide
	end
end

local function AddTextX(...)
	hook.Add("DrawHUD", "chatgui", HUDPaint)
	
	local txt = {...}
	local txt2 = {...}
	local txtfinal = {}
	local maxwide = render.GetScreenSize()*0.5
	local wide = 0
	local lastfont = defaultfont
	local lastcolor = Color(1,1,1,1)
	local i = 0
	local addtxt2 = false

	while i < #txt do
		i = i + 1
		local v = txt[i]

		if type(v) == "string" then 
			table.remove(txt2,1)
			local a, b, c = Wide(v, lastfont, maxwide - wide)
			
			if not c then
				wide = wide + a
				table.insert(txtfinal,v)
			else
				table.insert(txtfinal, b or "???")
				table.insert(txt2, 1 , c or "???2")
				table.insert(txt2, 1, {lastfont})
				table.insert(txt2, 1, lastcolor)
				addtxt2 = true
				break
			end
		elseif typex(v) == "player" then 
			table.remove(txt2, 1) -- TODO: Fixme. Should not be here...
			table.insert(txtfinal, Color(0.5,0.5,1,1))
			table.insert(txtfinal, v:GetNickname())
			table.insert(txtfinal, Color(1,1,1,1))
		elseif typex(v) == "color" then 
			lastcolor=v
		elseif typex(v) == "table" then 
			table.remove(txt2, 1)
			if v[1] and not v[2] and type(v[1]) == "string" then
				lastfont=v[1]
			end
			table.insert(txtfinal,v)
		else table.remove(txt2, 1)
			table.insert(txtfinal, "X"..type(v))
		end
	end


	local tbl = {txtfinal, os.clock()}
	
	table.insert(todraw, 1, tbl)
	
	if addtxt2 then
		AddTextX(unpack(txt2))
	end

end

function AddText(...)
	--local PERF=SysTime()
	local tbl={...}
	for k,v in pairs(tbl) do
		if type(v)=="string" then 
			if v:find("!!!",1,true)  then
				table.insert(tbl,1,{"Trebuchet24"}) 
				break
			elseif v:find("!!1",1,true)  then
				table.insert(tbl,1,{"HUDNumber"}) 
				break
			end
		end
	end
	AddTextX(unpack(tbl))

	return true -- also print original chat text..
end

AddText(me, "a ")

util.MonitorFileInclude()