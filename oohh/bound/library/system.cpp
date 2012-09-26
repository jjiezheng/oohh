#include "StdAfx.h"
#include "oohh.hpp"

#include "Game.h"
#include "GameRules.h"

#undef GetCommandLine
LUALIB_FUNCTION(system, GetCommandLine)
{
	my->NewTable();

	for (int i =1; i < gEnv->pSystem->GetICmdLine()->GetArgCount(); i++)
	{
		auto arg = gEnv->pSystem->GetICmdLine()->GetArg(i);

		my->SetMember(-1, arg->GetName(), arg->GetValue());
	}

	return 1;
}

LUALIB_FUNCTION(system, RunCryScriptString)
{
    string script = my->ToString(1);
    my->Push(gEnv->pScriptSystem->ExecuteBuffer(script.c_str(), script.size(), "oohh"));

    return 1;
}

LUALIB_FUNCTION(system, ConsolePrint)
{
	printf("%s", my->ToString(1));

	return 0;
}

LUALIB_FUNCTION(system, EnableRendering)
{
	oohh::EnableRender(my->ToBoolean(1));

	return 0;
}

LUALIB_FUNCTION(system, IsRendering)
{
	my->Push(oohh::IsRendering());

	return 1;
}

LUALIB_FUNCTION(system, EnableFocus)
{
	oohh::EnableFocus(my->ToBoolean(1));

	return 0;
}

LUALIB_FUNCTION(system, IsFocused)
{
	my->Push(oohh::IsFocused());

	return 1;
}

LUALIB_FUNCTION(system, ResetGame)
{
	gEnv->pGameFramework->Reset(!my->ToBoolean(1));

	return 1;
}

LUALIB_FUNCTION(system, GetHostName)
{
	my->Push(gEnv->pNetwork->GetHostName());

	return 1;
}