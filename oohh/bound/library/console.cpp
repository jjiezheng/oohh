#include "StdAfx.h"
#include "oohh.hpp"

LUALIB_FUNCTION(console, RunString)
{
	gEnv->pConsole->ExecuteString(my->ToString(1), my->ToBoolean(2), my->ToBoolean(3));

    return 0;
}
LUALIB_FUNCTION(console, FindKeyBind)
{
    my->Push(gEnv->pConsole->FindKeyBind(my->ToString(1)));

    return 1;
}
LUALIB_FUNCTION(console, Show)
{
	gEnv->pConsole->ShowConsole(my->ToBoolean(1), my->ToNumber(2, -1));

    return 0;
}
LUALIB_FUNCTION(console, IsVisible)
{
    my->Push(gEnv->pConsole->GetStatus());

    return 1;
}
LUALIB_FUNCTION(console, GetCVarNumber)
{
    auto var = gEnv->pConsole->GetCVar(my->ToString(1));

    if(var)
    {
        my->Push(var->GetFVal());
        return 1;
    }

    return 0;
}
LUALIB_FUNCTION(console, GetCVarString)
{
    auto var = gEnv->pConsole->GetCVar(my->ToString(1));

    if(var)
    {
        my->Push(var->GetString());
        return 1;
    }

    return 0;
}
LUALIB_FUNCTION(console, SetCVarValue)
{
    auto var = gEnv->pConsole->GetCVar(my->ToString(1));

    if(var)
    {
        var->Set(my->ToString(2));
    }

    return 0;
}

LUALIB_FUNCTION(console, SetCVarFlag)
{
    auto var = gEnv->pConsole->GetCVar(my->ToString(1));

    if(var)
    {
		var->SetFlags(my->ToNumber(2));
    }

    return 0;
}

LUALIB_FUNCTION(console, GetCVarFlag)
{
    auto var = gEnv->pConsole->GetCVar(my->ToString(1));

    if(var)
    {
		my->Push(var->GetFlags());

		return 1;
    }

    return 0;
}

LUALIB_FUNCTION(console, RemoveCVarFlags)
{
    auto var = gEnv->pConsole->GetCVar(my->ToString(1));

    if(var)
    {
		var->ClearFlags(my->ToNumber(2));
    }

    return 0;
}

#undef GetCommandLine

void CMD_OnCommand(IConsoleCmdArgs *args)
{
	my->CallHook("LuaCommand", args->GetCommandLine());
}

LUALIB_FUNCTION(console, AddInternalConsoleCommand)
{
	auto str = my->ToString(1);

	gEnv->pConsole->RemoveCommand(str);
    gEnv->pConsole->AddCommand(str, CMD_OnCommand);

    return 0;
}

LUALIB_FUNCTION(console, RemoveInternalConsoleCommand)
{    
	gEnv->pConsole->RemoveCommand(my->ToString(1));

	return 0;
}

LUALIB_FUNCTION(console, AddInternalCommandToHistory)
{
	auto str = my->ToString(1);

	gEnv->pConsole->AddCommandToHistory(str);

    return 0;
}