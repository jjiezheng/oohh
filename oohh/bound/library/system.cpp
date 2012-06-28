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

LUALIB_FUNCTION(system, SetPhysicsTime)
{
    gEnv->pPhysicalWorld->SetPhysicsTime(my->ToNumber(1));
    
    return 0;
}

LUALIB_FUNCTION(system, GetPhysicsTime)
{
    my->Push(gEnv->pPhysicalWorld->GetPhysicsTime());
    
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

