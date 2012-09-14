#include "StdAfx.h"
#include "oohh.hpp"

LUALIB_FUNCTION(engine3d, GetMaxViewDistance)
{
	my->Push(gEnv->p3DEngine->GetMaxViewDistance());

	return 1;
}

LUALIB_FUNCTION(engine3d, ApplyForceToEnvironment)
{
	gEnv->p3DEngine->ApplyForceToEnvironment(my->ToVec3(1), my->ToNumber(2), my->ToNumber(3));
	
	return 0;
}

LUALIB_FUNCTION(engine3d, CheckIntersectClouds)
{
	my->Push(gEnv->p3DEngine->CheckIntersectClouds(my->ToVec3(1), my->ToVec3(2)));
	
	return 1;
}

LUALIB_FUNCTION(engine3d, EnableOceanRendering)
{
	gEnv->p3DEngine->EnableOceanRendering(my->ToBoolean(1));
	
	return 0;
}

LUALIB_FUNCTION(engine3d, GetAmbientColorFromPosition)
{
	my->Push(gEnv->p3DEngine->GetAmbientColorFromPosition(my->ToVec3(1), my->ToNumber(2)));
	
	return 1;
}

LUALIB_FUNCTION(engine3d, GetHeightMapUnitSize)
{
	my->Push(gEnv->p3DEngine->GetHeightMapUnitSize());
	
	return 1;
}

LUALIB_FUNCTION(engine3d, GetLightAmountInRange)
{
	my->Push(gEnv->p3DEngine->GetLightAmountInRange(my->ToVec3(1), my->ToNumber(2), my->ToBoolean(3)));
	
	return 1;
}

LUALIB_FUNCTION(engine3d, GetRealtimeSunDirNormalized)
{
	my->Push(gEnv->p3DEngine->GetRealtimeSunDirNormalized());
	
	return 1;
}

LUALIB_FUNCTION(engine3d, GetSSAOAmount)
{
	my->Push(gEnv->p3DEngine->GetSSAOAmount());
	
	return 1;
}

LUALIB_FUNCTION(engine3d, GetSunDirNormalized)
{
	my->Push(gEnv->p3DEngine->GetSunDirNormalized());
	
	return 1;
}

LUALIB_FUNCTION(engine3d, GetTerrainSurfaceNormal)
{
	my->Push(gEnv->p3DEngine->GetTerrainSurfaceNormal(my->ToVec3(1)));
	
	return 1;
}

LUALIB_FUNCTION(engine3d, GetTerrainZ)
{
	my->Push(gEnv->p3DEngine->GetTerrainZ(my->ToNumber(1), my->ToNumber(2)));
	
	return 1;
}

LUALIB_FUNCTION(engine3d, GetWind)
{
	AABB aabb;

	my->Push(gEnv->p3DEngine->GetWind(aabb, my->IsTrue(1)));

	my->Push(aabb.min);
	my->Push(aabb.max);

	return 3;
}

LUALIB_FUNCTION(engine3d, IsUnderWater)
{
	my->Push(gEnv->p3DEngine->IsUnderWater(my->ToVec3(1)));
	
	return 1;
}

LUALIB_FUNCTION(engine3d, ResetParticlesAndDecals)
{
	gEnv->p3DEngine->ResetParticlesAndDecals();
	
	return 0;
}

LUALIB_FUNCTION(engine3d, SetWind)
{
	gEnv->p3DEngine->SetWind(my->ToVec3(1));
	
	return 0;
}

LUALIB_FUNCTION(engine3d, SetTOD)
{
	gEnv->p3DEngine->GetTimeOfDay()->SetTime(my->ToNumber(1), my->ToBoolean(2));
    
    return 0;
}

LUALIB_FUNCTION(engine3d, GetTOD)
{
    my->Push(gEnv->p3DEngine->GetTimeOfDay()->GetTime());
    
    return 1;
}	

LUALIB_FUNCTION(engine3d, PauseTOD)
{
	gEnv->p3DEngine->GetTimeOfDay()->SetPaused(my->ToBoolean(1));

	return 0;
}

LUALIB_FUNCTION(engine3d, SetOceanLevel)
{
	gEnv->p3DEngine->GetITerrain()->SetOceanWaterLevel(my->ToNumber(1));
	
	return 0;
}

LUALIB_FUNCTION(engine3d, GetOceanLevel)
{
	my->Push(gEnv->p3DEngine->GetWaterLevel());
	
	return 1;
}

LUALIB_FUNCTION(engine3d, SetGlobalParameter)
{
	if (my->IsNumber(2))
		gEnv->p3DEngine->SetGlobalParameter(my->ToEnum<E3DEngineParameter>(1), my->ToNumber(2));
	else
		gEnv->p3DEngine->SetGlobalParameter(my->ToEnum<E3DEngineParameter>(1), my->ToVec3(2));
	
	return 0;
}

LUALIB_FUNCTION(engine3d, GetGlobalParameter)
{
	if (my->IsTrue(2))
	{
		my->Push(gEnv->p3DEngine->GetGlobalParameter(my->ToEnum<E3DEngineParameter>(1)));

		return 1;
	}
	else
	{
		Vec3 data;
		gEnv->p3DEngine->GetGlobalParameter(my->ToEnum<E3DEngineParameter>(1), data);
		my->Push(data);
		
		return 1;
	}

	return 0;
}

LUALIB_FUNCTION(engine3d, SetRainParams)
{
	gEnv->p3DEngine->SetRainParams(
		my->ToNumber(1),
		my->ToNumber(2),
		my->ToNumber(3),
		my->ToBoolean(4),
		my->ToNumber(5),
		my->ToNumber(6)
	);

	return 0;
}

LUALIB_FUNCTION(engine3d, GetRainParams)
{
	float fReflAmount = 0;
	float fFakeGlossiness = 0;
	float fPuddlesAmount = 0;
	bool bRainDrops = 0;
	float fRainDropsSpeed = 0;
	float fUmbrellaRadius = 0;

	gEnv->p3DEngine->GetRainParams(
		fReflAmount,
		fFakeGlossiness,
		fPuddlesAmount,
		bRainDrops,
		fRainDropsSpeed,
		fUmbrellaRadius
	);

	my->Push(fReflAmount);
	my->Push(fFakeGlossiness);
	my->Push(fPuddlesAmount);
	my->Push(bRainDrops);
	my->Push(fRainDropsSpeed);
	my->Push(fUmbrellaRadius);

	return 6;
}


LUALIB_FUNCTION(engine3d, UpdateSky)
{
	gEnv->p3DEngine->GetTimeOfDay()->Update(false, true);

	return 0;
}

LUALIB_FUNCTION(engine3d, RayObjectsIntersection2D)
{
	Vec3 hitpos;
	if (gEnv->p3DEngine->RayObjectsIntersection2D(my->ToVec3(1), my->ToVec3(2), hitpos, my->ToEnum<EERType>(3, eERType_Brush)))
	{
		my->Push(hitpos);

		return 1;
	}

	return 0;
}