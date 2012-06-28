#include "StdAfx.h"
#include "oohh.hpp"

#include "IHardwareMouse.h"

LUALIB_FUNCTION(mouse, SetPos)
{
	auto x = my->ToNumber(1);
	auto y = my->ToNumber(2);

	gEnv->pHardwareMouse->SetHardwareMouseClientPosition(x, y);

	return 0;
}

LUALIB_FUNCTION(mouse, GetPos)
{
	float x, y = 0;

	gEnv->pHardwareMouse->GetHardwareMouseClientPosition(&x, &y);

	my->Push(x);
	my->Push(y);

	return 2;
}

static int counter = 0;

LUALIB_FUNCTION(mouse, IsVisible)
{
	my->Push(counter > 0);

	return 1;
}

LUALIB_FUNCTION(mouse, ShowCursor)
{
	auto show = my->ToBoolean(1);
	
	if(show)
	{
		gEnv->pHardwareMouse->IncrementCounter();
		++counter;

		g_pGame->GetIGameFramework()->GetIActionMapManager()->Enable(true);
		g_pGame->GetIGameFramework()->GetIActionMapManager()->EnableFilter("only_ui", true);
		//gEnv->pHardwareMouse->ConfineCursor(false);
	}
	else
	{
		while(counter > 0)
		{
			gEnv->pHardwareMouse->DecrementCounter();
			counter--;
		}

		//g_pGame->GetIGameFramework()->GetIActionMapManager()->Enable(false);
		g_pGame->GetIGameFramework()->GetIActionMapManager()->EnableFilter("only_ui", false);
		//gEnv->pHardwareMouse->ConfineCursor(true);
	}

	return 0;
}

static LPCSTR cursor_table[15] =
{
	IDC_APPSTARTING, // Standard arrow and small hourglass.
	IDC_ARROW, // Standard arrow.
	IDC_CROSS, // Crosshair.
	IDC_HAND, // Hand.
	IDC_HELP, // Arrow and question mark.
	IDC_ICON, // Obsolete.
	IDC_NO, // Slashed circle.
	IDC_SIZE, // Obsolete; use IDC_SIZEALL.
	IDC_SIZEALL, // Four-pointed arrow pointing north, south, east, and west.
	IDC_SIZENESW, // Double-pointed arrow pointing northeast and southwest.
	IDC_SIZENS, // Double-pointed arrow pointing north and south.
	IDC_SIZENWSE, // Double-pointed arrow pointing northwest and southeast.
	IDC_SIZEWE, // Double-pointed arrow pointing west and east.
	IDC_UPARROW, // Vertical arrow.
	IDC_WAIT, // Hourglass.
};

LUALIB_FUNCTION(mouse, SetCursor)
{
	oohh::SetCursor(LoadCursor(NULL, cursor_table[(int)my->ToNumber(1)]));

	return 0;
}