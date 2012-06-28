#include "StdAfx.h"
#include "oohh.hpp"

#include <windows.h>
#include <windef.h>

LUALIB_FUNCTION(window, SetResolution)
{
#ifdef CE3
	gEnv->pRenderer->ChangeResolution(0, 0, my->ToNumber(1, 800), my->ToNumber(2, 600), my->IsTrue(3), my->IsTrue(4));
#else
	gEnv->pRenderer->ChangeResolution(my->ToNumber(1), my->ToNumber(2), 0, 0, my->ToBoolean(3));
#endif

	return 0;
}

LUALIB_FUNCTION(window, SetNoBorder)
{
	auto window = (HWND)gEnv->pRenderer->GetHWND();

	if (window)
	{
		auto style = GetWindowLong(window, GWL_STYLE);

		if (((style & WS_BORDER) != 0) && gEnv->pConsole->GetCVar("r_fullscreen")->GetIVal() < 1)
		{
			if(my->IsTrue(1))
			{
				style &= ~WS_OVERLAPPEDWINDOW;
				style |= WS_POPUP | WS_MINIMIZEBOX;
			}
			else
			{
				style |= WS_OVERLAPPEDWINDOW;
				style &= ~(WS_POPUP | WS_MINIMIZEBOX);
			}

			SetWindowPos(window, NULL, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE | SWP_FRAMECHANGED);
			SetWindowLong(window, GWL_STYLE, style);
			UpdateWindow(window);
		}
	}

	return 0;
}

LUALIB_FUNCTION(window, SetRect)
{
	auto rect = my->ToRect(1);

	auto window = (HWND)gEnv->pRenderer->GetHWND();

	if (window)
	{
		MoveWindow(window, rect.x, rect.y, rect.w, rect.h, true);

		gEnv->pConsole->GetCVar("r_width")->Set(rect.w);
		gEnv->pConsole->GetCVar("r_height")->Set(rect.h);
	}

	return 0;
}

LUALIB_FUNCTION(window, GetRect)
{
	auto rect = Rect();
	auto window = (HWND)gEnv->pRenderer->GetHWND();

	if (window)
	{
		RECT windowrect;

		if (GetWindowRect(window, &windowrect))
		{
			rect.x = windowrect.left;
			rect.y = windowrect.top;
			rect.w = windowrect.right - windowrect.left;
			rect.h = windowrect.bottom - windowrect.top;
		}
	}

	my->Push(rect);

	return 1;
}

LUALIB_FUNCTION(window, GetWorkingRect)
{
	auto rect = Rect();

	RECT workarea;

	if (SystemParametersInfo(SPI_GETWORKAREA, 0, &workarea, 0))
	{
		rect.x = workarea.left;
		rect.y = workarea.top;
		rect.w = workarea.right - workarea.left;
		rect.h = workarea.bottom - workarea.top;
	}

	my->Push(rect);

	return 1;
}

LUALIB_FUNCTION(window, SetSize)
{
	auto x = my->ToNumber(1);
	auto y = my->ToNumber(2);

	gEnv->pConsole->GetCVar("r_width")->Set((int)x);
	gEnv->pConsole->GetCVar("r_height")->Set((int)y);

	return 0;
}

LUALIB_FUNCTION(window, SetPos)
{
	auto x = my->ToNumber(1);
	auto y = my->ToNumber(2);

	auto window = (HWND)gEnv->pRenderer->GetHWND();

	if (window)
	{
		auto w = gEnv->pConsole->GetCVar("r_width")->GetIVal();
		auto h = gEnv->pConsole->GetCVar("r_height")->GetIVal();

		MoveWindow(window, x, y, w, h, true);
	}

	return 0;
}


LUALIB_FUNCTION(window, IsFocused)
{
	my->Push(GetActiveWindow() == (HWND)gEnv->pRenderer->GetHWND());

	return 1;
}

LUALIB_FUNCTION(window, SetTitle)
{
	my->Push(SetWindowText((HWND)gEnv->pRenderer->GetHWND(), my->ToString(1)));

	return 1;
}

LUALIB_FUNCTION(window, GetClipboard)
{
	if (OpenClipboard((HWND)gEnv->pRenderer->GetHWND()))
	{
		auto handle = GetClipboardData(CF_TEXT);

		if (handle)
		{
			auto str = (const char *)GlobalLock(handle);

			my->Push(str);
		}

		GlobalUnlock(handle);

		CloseClipboard();
	}

	return 1;
}

LUALIB_FUNCTION(window, SetClipboard)
{
	auto str = my->ToString(1);

	if (OpenClipboard((HWND)gEnv->pRenderer->GetHWND()))
	{
		EmptyClipboard();
		
		auto clipbuffer = GlobalAlloc(GMEM_DDESHARE, strlen(str) * sizeof(str));
		auto buffer = (char *) GlobalLock(clipbuffer);
			strcpy(buffer, str);
		GlobalUnlock(clipbuffer);

		SetClipboardData(CF_TEXT, clipbuffer);
		CloseClipboard();

		my->Push(true);

		return 1;
	}

	my->Push(false);

	return 1;
}
