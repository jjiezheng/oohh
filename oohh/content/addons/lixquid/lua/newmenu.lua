menu = {}

-- Render Code

util.MonitorFileInclude()
function menu.Render()
	local w, h = render.GetScreenSize()
	if not entities.GetLocalPlayer():IsValid() then
		graphics.DrawFilledRect( Rect( 0, 0, w, h ), Color( 0.5, 0.5, 0.5, 1 ) )
	end
	
	graphics.DrawFilledRect( Rect( 0, 0, w, h ), Color( 0, 0, 0, 0.3 ) )
	graphics.DrawFilledRect( Rect( 0, h - 60, w, 60 ), Color( 0, 0, 0, 0.2 ) )
	
	for i = 0, 499 do
		graphics.DrawFilledRect( Rect( i, 0, 1, h ), Color( 0, 0, 0, 0.6 - 0.6 * ( i / 500 ) ) )
	end
	
end

-- Buttons'n'shite
menu.contents = {}

menu.contents.Quit = aahh.Create( "button" )
menu.contents.Quit.Layout = function(w,h)
	menu.contents.Quit:SetPos( w - 55, h - 55 )
	menu.contents.Quit:SetSize( 50, 50 )
end
menu.contents.Quit.OnDraw = function()
	local size = menu.contents.Quit:GetSize()
	graphics.DrawFilledRect( Rect( 0, 0, size.x, size.y ), Color( 0, 0, 0, 0.3 ) )
end
local w, h = render.GetScreenSize()
	menu.contents.Quit:SetPos( w - 55, h - 55 )
	menu.contents.Quit:SetSize( 50, 50 )

-- Other shit

input.Bind( "escape", "o toggle_menu" )
console.AddCommand( "toggle_menu", function()
	menu.Toggle()
end )

menu.visible = false

function menu.Open()
	menu.visible = true
	hook.Add( "PreDrawMenu", "MainMenu", menu.Render )
	mouse.ShowCursor( true )
end
function menu.Close()
	menu.visible = false
	hook.Remove( "PreDrawMenu", "MainMenu" )
	mouse.ShowCursor( false )
end

function menu.Toggle()
	if menu.visible then
		menu.Close()
	else
		menu.Open()
	end
end

if not MULTIPLAYER then
	hook.Add("SystemEvent", "mainmenu", function(event) 
		if event == ESYSTEM_EVENT_GAME_POST_INIT then
			menu.Open()
			return HOOK_DESTROY
		end
	end)
	menu.Open()
end