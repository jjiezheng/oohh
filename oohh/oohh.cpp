#include "StdAfx.h"
#include "oohh.hpp"

#include "Game.h"
#include "listener.hpp"
#include <Windows.h>

#undef GetCommandLine

oohhState *my = NULL;
 
namespace oohh
{
	bool m_bFocus = true;
	bool m_bRender = true;

	bool IsFocused() { return m_bFocus; }
	bool IsRendering() { return m_bRender; }
	void EnableFocus(bool b) { m_bFocus = b; }
	void EnableRender(bool b) { m_bRender = b; }

	void CMD_RunLua(IConsoleCmdArgs *args)
	{
		if (!my)
		{
			CryWarning(VALIDATOR_MODULE_UNKNOWN, VALIDATOR_ERROR, "oohh is not initialized!");
		}
		else
		{
			//LockDirect3d();
			auto str = (string)args->GetCommandLine();
			str = str.substr(2);
			my->RunString(str.c_str());
			//UnlockDirect3d();
		}
	}

	void CMD_Callback(IConsoleCmdArgs *args)
	{
		if (!my)
		{
			CryWarning(VALIDATOR_MODULE_UNKNOWN, VALIDATOR_ERROR, "oohh is not initialized!");
		}
		else
		{
			//LockDirect3d();
			my->CallHook("LuaCommand", args->GetCommandLine());
			//UnlockDirect3d();
		}
	}
	void CMD_Restart(IConsoleCmdArgs *args)
	{
		//LockDirect3d();
		Close();
		Open();
	}

	bool add_cmds_once = true;
	void AddCommands()
	{
		if (add_cmds_once)
		{
			gEnv->pConsole->AddCommand("l", CMD_RunLua); // debugging purposes in case something breaks
			gEnv->pConsole->AddCommand("o", CMD_Callback);
			gEnv->pConsole->AddCommand("reoh", CMD_Restart);
			add_cmds_once = false;
		}
	}
	void RegisterFactory(IGameFramework *framework)
	{
		RegisterScriptedWeapon(framework);
		RegisterScriptedEntity(framework);
	}

	static CListener *listener;
	static bool initialized = false;
	void Open(bool once)
	{
		if (!gEnv->pGame || !gEnv->pGame->GetIGameFramework())
		{
			CryFatalError("cannot init oohh if the framework is not initialized, init oohh after it's initialized!!!");
		}

		if (once && initialized)
		{
			initialized = true;
			return;
		}
		
		//InitializeDirect3D();
		AddCommands();

		my = new oohhState();

		my->SetPlatformName("CRYENGINE3");

		if (!my->RunFile("!/../lua/init.lua"))
		{
			CryWarning(VALIDATOR_MODULE_UNKNOWN, VALIDATOR_ERROR, "oohh failed to initialize!");
		}

		if (!listener)
			listener = new CListener();
		
		listener->Start();

		oohh::SetCursor(LoadCursor(NULL, IDC_ARROW));

		//UnlockDirect3d();
		my->CallHook("LuaOpen");
	}

	void Close()
	{
		my->CallHook("LuaClose");

		listener->Stop();

		delete my;
		my = NULL;
	}

	HCURSOR cursor;

	void SetCursor(HCURSOR cur)
	{
		 cursor = cur;
	}

	HCURSOR GetCursor()
	{
		return cursor;
	}
}

LUALIB_FUNCTION(_G, Msg)
{
	auto str = my->ToString(1);
	
	gEnv->pConsole->PrintLinePlus(str);
	OutputDebugString(str);

	return 0;
}

LUALIB_FUNCTION(_G, MsgN)
{
	auto str = my->ToString(1);

	gEnv->pConsole->PrintLine(str);
	OutputDebugString(str);
	OutputDebugString("\n");

	return 0;
}