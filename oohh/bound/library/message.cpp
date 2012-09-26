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

	if(my->ToBoolean(3))
	{
		INVOKE(CGameRules::oohhFromServerUDP(), CGameRules::oohhNetMsgUDP(msg), eRMI_ToClientChannel, my->ToPlayer(1)->GetChannelId());
	}
	{
		INVOKE(CGameRules::oohhFromServerTCP(), CGameRules::oohhNetMsgTCP(msg), eRMI_ToClientChannel, my->ToPlayer(1)->GetChannelId());
	}

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

	if(my->ToBoolean(2))
	{
		INVOKE(CGameRules::oohhFromClientUDP(), CGameRules::oohhNetMsgUDP(msg), eRMI_ToServer);
	}
	else
	{
		INVOKE(CGameRules::oohhFromClientTCP(), CGameRules::oohhNetMsgTCP(msg), eRMI_ToServer);
	}

	return 0;
}

IMPLEMENT_RMI(CGameRules, oohhFromClientTCP)
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

IMPLEMENT_RMI(CGameRules, oohhFromServerTCP)
{
	if (my)
	{
		my->CallHook("NetMsgReceiveFromServer", params.str);

		return true;
	}

	return false;
}


IMPLEMENT_RMI(CGameRules, oohhFromClientUDP)
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

IMPLEMENT_RMI(CGameRules, oohhFromServerUDP)
{
	if (my)
	{
		my->CallHook("NetMsgReceiveFromServer", params.str);

		return true;
	}

	return false;
}