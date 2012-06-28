#include "mmyy.hpp"
#include <stdio.h>

#define _AFXDLL 1

#include "afxwin.h"

#pragma comment(lib, "lua51.lib")

class State
{
	// this is called from the engine, not lua. it has to be declared
	void OnPrint(const char *str)
	{
		printf("%s", str);
	}

	// include the wrapped mmyy functions for a class
	#include "mmyy_class.hpp"

	// lets use CWnd as an example
	MMYY_WRAP_CLASS(CWnd, Window, window);
};

// we only have 1 state so let's make it easy to access during lua calls
State *my;

// make a global called GetWindow which returns a new window object
LUALIB_FUNCTION(_G, GetWindow)
{
	// get the window by title
	auto self = CWnd::FindWindow(0, my->ToString(1));

	// since we used MMYY_WRAP_CLASS we can now push a CWnd pointer
	my->Push(self);

	return 1;
}

// create a meta function called SetPos in the window meta
LUAMTA_FUNCTION(window, SetPos)
{
	// ToWindow is also created by MMYY_WRAP_CLASS
	auto self = my->ToWindow(1);

	self->SetWindowPos(0, my->ToNumber(2), my->ToNumber(3), 0, 0, SWP_NOSIZE);

	return 0;
}

LUAMTA_FUNCTION(window, SetSize)
{
	auto self = my->ToWindow(1);

	self->SetWindowPos(0, 0, 0, my->ToNumber(2), my->ToNumber(3), SWP_NOMOVE);

	return 0;
}

// there is a base meta table which handles for instance 
// __index and __newindex so you can store variables in the object. 
// to override this, simply define __index and or __newindex
// with LUAMTA_*

// lets override the default __tostring give it a nicer name instead of the default [window][*pointer address*]
LUAMTA_FUNCTION(window, __tostring)
{
	auto self = my->ToWindow(1);

	CString str;
	self->GetWindowText(str);
	
	lua_pushfstring(L, "[window][%s]", str);

	return 1;
}

int main()
{
	my = new State();

	// this function is used to load the proper lua library for the platform
	my->SetPlatformName("test");

	// this file should always be called as it load the
	// standard lua library that comes with mmyy
	my->RunFile("../lua/init.lua");
	
	// make sure you have the windows task manager opened
	my->RunString
	(
		"local wnd = GetWindow('Windows Task Manager')"
		"print(wnd)"
		"wnd:SetPos(0,0)"
		"wnd:SetSize(100,100)"
	);

	return 0;
}