menu = menu or {}
menu.backgrounds = menu.backgrounds or {}

local tab = {}
menu.backgrounds.pixelgrid = tab
tab.name = "Pixel Grid"
tab.desc = "The plural of bocks is bockzi."
tab.author = "Lixquid"
tab.func = function( size )
	local mpos = Vec2(mouse.GetPos()) - size.w / 20
	for i = 0, 9 do
		for j = 0, math.ceil( 9 * size.h / size.w ) do
			local a = 0.2 + math.clamp( 1 - ( ( mpos.x - size.x * i / 10 )^2 + ( mpos.y - size.w * j / 10 )^2 ) ^ 0.5 / 800, 0, 1 ) * 0.7
			graphics.DrawFilledRect( Rect( i * size.w / 10, j * size.w / 10, size.w / 10, size.w / 10 ), Color( a, a, a, 1 ) )
		end
	end
end