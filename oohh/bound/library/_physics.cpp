#include "StdAfx.h"
#include "oohh.hpp"

#include "game.h"

LUALIB_FUNCTION(physics, RayWorldIntersection)
{
    //Declare all the arguments cause I think this pop push thing is a pain to keep track of
    auto origin = my->ToVec3(1);
    auto end_pos = my->ToVec3(2);
    auto type = my->ToNumber(3);
    auto mask = my->ToNumber(4);
    auto skip = my->ToPhysics(5, nullptr);

    auto direction = end_pos - origin;

    //Create the lua table that we're going to return
    my->NewTable();

    //Create the params that we store the RayIntersection data in
    ray_hit params;

    //Setup the hits integer to store how many times the RayIntersection hit
    //For now, only data from one hit is possible to retrieve
    //So it will be the first hit
    auto hits = gEnv->pPhysicalWorld->RayWorldIntersection(origin, direction, type, mask, &params, 1, skip);
    
    my->SetMember(-1, "StartPos", origin);
    my->SetMember(-1, "EndPos", end_pos);
    my->SetMember(-1, "HitPos", params.pt);
    my->SetMember(-1, "HitNormal", params.n);
    my->SetMember(-1, "Length", params.dist);
    my->SetMember(-1, "HitTerrain", params.bTerrain);
    my->SetMember(-1, "Node", params.iNode);
    my->SetMember(-1, "ForeignIndex", params.foreignIdx);
    my->SetMember(-1, "OriginalMaterialID", params.idmatOrg);
    my->SetMember(-1, "PartID", params.partid);
    my->SetMember(-1, "SurfaceIndex", params.surface_idx); 
    my->SetMember(-1, "Hit", hits > 0);
	my->SetMember(-1, "HitPhysics", params.pCollider);
   
    my->PushValue(-1);

    return 1;
}

LUALIB_FUNCTION(physics, SetTime)
{
	gEnv->pPhysicalWorld->SetPhysicsTime(my->ToNumber(1));

	return 1;
}

LUALIB_FUNCTION(physics, GetTime)
{
	my->Push(gEnv->pPhysicalWorld->GetPhysicsTime());

	return 1;
}

LUALIB_FUNCTION(physics, SetSnapshotTime)
{
	gEnv->pPhysicalWorld->SetSnapshotTime(my->ToNumber(1));

	return 1;
}

LUALIB_FUNCTION(physics, SetGravity)
{
	gEnv->pPhysicalWorld->GetPhysVars()->gravity = my->ToVec3(1);

	return 1;
}

LUALIB_FUNCTION(physics, GetGravity)
{
	my->Push(Vec3(gEnv->pPhysicalWorld->GetPhysVars()->gravity));

	return 1;
}