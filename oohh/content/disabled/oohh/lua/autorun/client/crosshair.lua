do return end
if CLIENT then
	local centerx = render.GetScreenSize().w/2
	local centery = render.GetScreenSize().h/2
	hook.Add("PostHUDUpdate", "crosshair", function(delta)
		surface.StartDraw()
			surface.SetColor(Color(0.9,0.9,0.9,0.8))
			surface.DrawLine(centerx-10, centery, centerx-2, centery) --left
			surface.DrawLine(centerx+2, centery, centerx+10, centery) --right
			surface.DrawLine(centerx, centery-10, centerx, centery-2) --up
			surface.DrawLine(centerx, centery+2, centerx, centery+10) --down
		surface.EndDraw()
	end)
end