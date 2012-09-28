local height = Vec2(render.GetScreenSize()).h;
hook.Add("DrawHUD", 1, function()
	graphics.DrawRect(Rect(32, height - 256, 64, 32), Color(0.6, 0.6, 0.6, 1), 4, 1, Color(0, 0, 0, 1));
end);

util.MonitorFileInclude();