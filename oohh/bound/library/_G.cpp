#include "StdAfx.h"
#include "IIndexedMesh.h"
#include "oohh.hpp"

LUALIB_FUNCTION(_G, IsClient)
{
#ifdef CE3
	my->Push(gEnv->IsClient());
#else
	my->Push(gEnv->bClient);
#endif
	
	return 1;
}

LUALIB_FUNCTION(_G, IsServer)
{
	my->Push(gEnv->bServer);

	return 1;
}

LUALIB_FUNCTION(_G, IsMultiPlayer)
{
	my->Push(gEnv->bMultiplayer);

	return 1;
}

LUALIB_FUNCTION(_G, IsDedicated)
{
#ifdef CE3
	my->Push(gEnv->IsDedicated());
#else
	my->Push(gEnv->bServer);
#endif

	return 1;
}

LUALIB_FUNCTION(_G, IsEditor)
{
#ifdef CE3
	my->Push(gEnv->IsEditor());
#else
	my->Push(gEnv->bEditor);
#endif

	return 1;
}

LUALIB_FUNCTION(_G, DebugBreak)
{
	CryDebugBreak();

	return 0;
}



LUALIB_FUNCTION(_G, FrameTime)
{
	my->Push(gEnv->pTimer->GetFrameTime());

	return 1;
}

LUALIB_FUNCTION(_G, RealFrameTime)
{
	my->Push(gEnv->pTimer->GetRealFrameTime());

	return 1;
}

LUALIB_FUNCTION(_G, CurTime)
{
	my->Push(gEnv->pTimer->GetCurrTime());

	return 1;
}

LUALIB_FUNCTION(_G, AsyncCurTime)
{
	my->Push(gEnv->pTimer->GetAsyncCurTime());

	return 1;
}

LUALIB_FUNCTION(_G, ErrorNoHalt)
{
    CryWarning(VALIDATOR_MODULE_UNKNOWN,VALIDATOR_ERROR,my->ToString(1));
    return 0;
}

LUALIB_FUNCTION(_G, GetNULL)
{
	my_pushnull(L);

	return 1;
}

IStatObj *obj = NULL;

LUALIB_FUNCTION(_G, MeshTest)
{
	auto ent = my->ToEntity(1);
	auto entobj = ent->GetStatObj(ent->GetSlotCount());
	auto mesh = entobj->GetIndexedMesh()->GetMesh();

	obj = gEnv->p3DEngine->CreateStatObj();
	obj->GetIndexedMesh(true)->SetMesh(*mesh);

	return 0;
}

LUALIB_FUNCTION(_G, RenderMeshTest)
{
	if (!obj) return 0;
		
	SRendParams params;

	params.AmbientColor = Vec3(1,1,1);
	params.fAlpha = 1;
	params.fDistance = 100;
	params.pMatrix = my->ToMatrix34Ptr(1);

	obj->Render(params);

	return 0;
}

LUALIB_FUNCTION(_G, CastingTest)
{
	auto ent = gEnv->pEntitySystem->GetEntity(my->ToNumber(1, 1));

	if (ent)
	{
		auto cls = ent->GetClass()->GetName();
	}

	auto iact = reinterpret_cast<IActor *>(ent);
	auto ply = reinterpret_cast<CPlayer *>(ent);
	auto act = reinterpret_cast<CActor *>(ent);
	auto itm = reinterpret_cast<CItem *>(ent);
	auto wep = reinterpret_cast<CWeapon *>(ent);

	return 0;
}