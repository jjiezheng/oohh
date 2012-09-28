local height = Vec2(render.GetScreenSize()).h;
hook.Add("DrawHUD", 1, function()
	graphics.DrawRect(Rect(32, height - 256, 32, 32));
end);

util.MonitorFileInclude();