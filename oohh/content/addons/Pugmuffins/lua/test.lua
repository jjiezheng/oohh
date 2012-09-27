local ScrH = Vec2(render.GetScreenSize()).h;
local health = entities.GetLocalPlayer():GetHealth();

hook.Add("DrawHUD", 1, function()
	health = entities.GetLocalPlayer():GetHealth();
	graphics.DrawRect( Rect(32, ScrH - 256, (health / 100) * 128, 16), Color(0.75, 0.4, 0.4, 1) );

	--graphics.DrawRect(x, y, w, h, c)
end);

util.MonitorFileInclude();