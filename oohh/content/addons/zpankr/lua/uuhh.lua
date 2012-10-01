local size = 12
local tp = 0

local screenSize = graphics.GetScreenSize()

hook.Add("DrawHUD","Chess",function()
	graphics.DrawRect(Rect(0,0,screenSize.x,screenSize.y),Color(0,0,0,120))
	size = 12 + (1+math.sin(CurTime()))*12
	for x = 0, (screenSize.x/size) do
		for y = 0, (screenSize.y/size) do
			if ((x%2==0) and (y%2==0))or(((x-1)%2==0) and ((y-1)%2==0)) then
				graphics.DrawRect(Rect((x*size),(y*size),size,size),Color(255,0,255,100))
			end
		end
	end
end)

util.MonitorFileInclude()