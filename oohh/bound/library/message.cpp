#include "StdAfx.h"
#include "oohh.hpp"

#include "Game.h"
#include "IGameObject.h"
#include "GameRules.h"

#define INVOKE gEnv->pGame->GetIGameFramework()->GetIGameRulesSystem()->GetCurrentGameRules()->GetGameObject()->InvokeRMI

LUALIB_FUNCTION(message, RawSendToClient)
{
	if (!gEnv->bServer)
		return 0;

	auto msg = (string)my->ToString(2);

	// null fix hmm
	msg = "" + msg; 

	INVOKE(CGameRules::oohhFromServer(), CGameRules::oohhNetMsg(msg), eRMI_ToClientChannel, my->ToPlayer(1)->GetChannelId());

	return 0;
}

LUALIB_FUNCTION(message, RawSendToServer)
{
#ifdef CE3
	if (!gEnv->IsClient())
#else
	if (!gEnv->bClient)
#endif
		return 0;

	if (!gEnv->pGame->GetIGameFramework()->GetClientActor())
		return 0;

	auto msg = (string)my->ToString(1);

	// null fix hmm
	msg = "" + msg; 

	INVOKE(CGameRules::oohhFromClient(), CGameRules::oohhNetMsg(msg), eRMI_ToServer);

	return 0;
}

IMPLEMENT_RMI(CGameRules, oohhFromClient)
{
	if (my)
	{
		auto ply = (CPlayer *)GetActorByChannelId(gEnv->pGame->GetIGameFramework()->GetGameChannelId(pNetChannel));
		
		if (ply)
		{
			my->CallHook("NetMsgReceiveFromClient", ply, params.str);

			return true;
		}		
	}

	return false;
}

IMPLEMENT_RMI(CGameRules, oohhFromServer)
{
	if (my)
	{
		my->CallHook("NetMsgReceiveFromServer", params.str);

		return true;
	}

	return false;
}