timer.Simple(0.1, function()
	local str = [[
	Lorem ipsum dolor sit amet, consectetur adipiscing elit.
	Cras fringilla risus ac odio facilisis posuere.
	Vivamus ullamcorper turpis sed ante aliquet ut laoreet metus molestie.
	Morbi sed urna sit amet sem dignissim fringilla in at libero.
	Pellentesque aliquam risus arcu, sit amet congue urna.
	Duis sed metus eget enim fringilla consectetur.
	Vestibulum malesuada vestibulum ligula, eget consectetur lectus imperdiet a.
	Ut mollis ante eget nulla ullamcorper aliquet.
	Ut sed arcu imperdiet mi aliquam laoreet.
	Etiam euismod ullamcorper quam, vitae sollicitudin leo feugiat a.
	Pellentesque rhoncus velit nibh, sed vulputate augue.
	Vivamus consectetur quam vel enim consequat eu malesuada velit fringilla.
	Donec iaculis lobortis libero, eu rhoncus augue hendrerit feugiat.
	Sed id libero nisi, vel dictum lorem.
	Nam ultricies lorem at mi commodo vitae porta dui malesuada.
	Fusce sed ligula eros, eu consectetur odio.
	]] 

	for k,v in pairs(str:Explode("\n")) do
		AddChatText(v)
	end

end)

setfenv(
	1,
	{
		pcall = pcall,
		print = print,
		table = table,
		surface = 
		{
			CreateFont = function(name)
				
			end,
			SetFont = function() end,
			GetTextSize = function(font, str) return str and (#str*12) or 12, 12  end, 
			SetTextColor = function(...) c = Color(...)/255 surface.SetColor(c) end,
			SetTextPos = function(x,y) CHAT_TEXT_POS_X = x CHAT_TEXT_POS_Y = y end,
			DrawText = function(str) surface.DrawText(str, CHAT_TEXT_POS_X or 0, CHAT_TEXT_POS_Y or 0, Vec2()+12) end,
		},
		Color = function(...) return Color(...) / 255 end,
		CreateConVar = function(name, var)
			console.CreateVariable(name, var)
			return 
			{
				GetBool = function(self)
					local var = console.GetVariable(name)
					return var == "1" or var == true
				end,
			}
		end,
		math = 
		{
			Approach = function( cur, target, inc )

				inc = math.abs( inc )

				if (cur < target) then
					
					return math.clamp( cur + inc, cur, target )

				elseif (cur > target) then

					return math.clamp( cur - inc, target, cur )

				end

				return target
				
			end, 
			Clamp = math.clamp,
		},
		chat = 
		{
			AddText = print
		},
		hook = 
		{
			Add = function(event, id, func)
				if event == "HUDPaint" then
					hook.Add("PostDrawMenu", id, func, print)
				end
				if event == "ChatText" then
					_G.AddChatText = function(line) func(_,_,line) end
				end
			end,
			Remove = function(event, ...)
				if event == "HUDPaint" then
					hook.Remove("PostDrawMenu", ...)
				end
			end,
		},
		_G = _G,
		tostring = tostring,
		ScrW = function() return select(1, render.GetScreenSize()) end,
		ScrH = function() return select(2, render.GetScreenSize()) end,
		type = type,
		string = string, 
		RealTime = CurTime,
		SysTime = CurTime,
		pairs = pairs,
		FrameTime = FrameTime,
		unpack = unpack,
	}
) 

print(pcall(function()

local insert=table.insert
local Now=RealTime
local surface=surface
local Tag="chathud"

-- Fonts
	-- Normal font
	local defaultfont=Tag..""--..math.Round(CurTime())
	surface.CreateFont("Tahoma",17,700,false,false,defaultfont,true,false)

	-- ChatPrint font
	local chatprint_color = Color( 201,255,41, 255) -- lime green. EEK!
	local chatprint_font  = "chattextalt2"
	surface.CreateFont("Tahoma",15, 600,true,false,chatprint_font,true,false)


local cl_shownewhud=CreateConVar("cl_shownewhud","1",true,false)
local bigfont="BudgetLabel" --Tag..'2'..math.Round(CurTime()+1)
--surface.CreateFont("Tahoma",32,700,false,false,bigfont,true,false)
--surface.CreateFont("Tahoma",17,700,false,false,font_smooth,false,false,1)
local todraw={}

local function DrawText(txtdata,frac,drawoffset)
	local _a=SysTime()
	local x,y=10,drawoffset
    surface.SetTextPos(x,y)

	local fx,fy=x,y
	local maxtall = 0

	-- grab maxtall and etc.
	for k,v in pairs(txtdata) do
        if type(v) == "string" then
            local w,h=surface.GetTextSize(v)
            maxtall=maxtall<h and h or maxtall
			fx,fy=fx+w,fy+h     
        elseif v[1] and type(v[1])=="string" then
			surface.SetFont(v[1])
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
            local w,h=surface.GetTextSize(v)
            maxtall=maxtall<h and h or maxtall
			fx,fy=fx+w,fy+h
            surface.DrawText(v)
        elseif v.r then
			surface.SetTextColor( v.r,v.g,v.b,v.a and v.a*frac or 255*frac)            
		elseif v[1] and type(v[1])=="string" then
			surface.SetFont(v[1])
		end
    end

	return maxtall
end


local length=4
local startpadding=11
local startfade=.2
local function DoDraw(i,txtdata,start,drawoffset)
	local frac=((start-(Now()-length-startpadding))/length)
	local frac2=(Now()-start)/startfade
	frac=frac>1 and 1 or frac<0 and 0 or frac
	if frac<=0 then 
		table.remove(todraw,i)
		return 0
	end
	frac2=frac2>1 and 1 or frac2<0 and 0 or frac2
	frac=frac*frac2

	surface.SetTextColor( 255,255,255,255*frac)
    surface.SetFont(defaultfont)
	local maxtall=DrawText(txtdata,frac,drawoffset)

	return maxtall+2
end
local sys=SysTime
local FrameTime=FrameTime
local ScrH=ScrH
local approach=math.Approach

local first=5
local function HUDPaint() 
	-- spamcheck..
	local remove=true

	local drawoffset=ScrH()*0.5

	local data,i=true,0
	while data do
		i=i+1
		data = todraw[i]
		if not data then break end

		remove=false
        data[3]=data[3] or ScrH()*0.5
		drawoffset=drawoffset - ( DoDraw( i, data[1], data[2], data[3] )  )
		data[3]=approach(data[3],drawoffset,FrameTime()*150)
	end

	if remove then
		hook.Remove("HUDPaint",Tag)
	end



end


local function unitochartable(ustring)
	local tbl={}
	local len=0
	for uchar in string.gmatch(ustring, "([%z\1-\127\194-\244][\128-\191]*)") do
          tbl[#tbl+1]=uchar
		  len=len+#uchar
    end
	return tbl
end

local function Wide(txt,font,maxwide)
	local wide = 0
	if font then
            surface.SetFont(font)
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
			local w,h=surface.GetTextSize(char=="&" and "%" or char)
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
	if  not cl_shownewhud:GetBool() then return end

	hook.Add("HUDPaint",Tag,HUDPaint)
	local txt={...}
	local txt2={...}
	local txtfinal={}
	local maxwide=ScrW()*0.5
	local wide=0
	local lastfont=defaultfont
	local lastcolor=Color(255,255,255,255)
	local i=0
	local addtxt2=false

	while i < #txt do
		i = i + 1
		local v = txt[i]

		if type(v)=="string" then table.remove(txt2,1)
			local a,b,c=Wide(v,lastfont,maxwide-wide)
			if not c then
				wide=wide+a
				insert(txtfinal,v)
			else
				insert(txtfinal,b or "???")
				insert(txt2,1,c or "???2")
				insert(txt2,1,{lastfont})
				insert(txt2,1,lastcolor)
				addtxt2=true
				--print"ADDTXT"
				break
			end
		elseif type(v)=="Player" then table.remove(txt2,1) -- TODO: Fixme. Should not be here...
			insert(txtfinal,team.GetColor(v:Team()))
			insert(txtfinal,v:Name())
			insert(txtfinal,Color(255,255,255,255))
		elseif type(v)=="table" then table.remove(txt2,1)
			if v[1] and not v[2] and type(v[1])=="string" then
				lastfont=v[1]
			elseif v.r and type(v.r)=="number" then
				lastcolor=v
			end
			insert(txtfinal,v)
		else table.remove(txt2,1)
			insert(txtfinal,"X"..type(v))
		end

	end


	local tbl={txtfinal,Now()}
	insert(todraw,1,tbl)
	if addtxt2 then
		AddTextX(unpack(txt2))
	end

end
chat.AddTextX=AddTextX

hook.Add("ChatText", Tag, function( _, _, msg, msg_type )	
	AddTextX({chatprint_font},chatprint_color,tostring(msg))
end)


local function AddTextNew(...)
	--local PERF=SysTime()
	local tbl={...}
	for k,v in pairs(tbl) do
		if type(v)=="string" then 
			if v:find("!!!",1,true)  then
				insert(tbl,1,{"Trebuchet24"}) 
				break
			elseif v:find("!!1",1,true)  then
				insert(tbl,1,{"HUDNumber"}) 
				break
			end
		end
	end
	AddTextX(unpack(tbl))

	return true -- also print original chat text..
end
-- helperfunctions/lua/includes/extensions/chat_addtext_hack.lua
_G.PrimaryChatAddText=AddTextNew

hook.Add( "HUDShouldDraw", Tag, function ( name )
	if cl_shownewhud:GetBool() and name == "CHudChat" then
			 return false
	end
end )

end))