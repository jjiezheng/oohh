#include "StdAfx.h"

#include "oohh.hpp"
#include "isound.h"

LUALIB_FUNCTION(_G, LightSource)
{ 
	auto self = gEnv->p3DEngine->CreateLightSource();
	
	gEnv->p3DEngine->RegisterEntity(self);

	my->Push(self);

	return 1;
}

LUAMTA_FUNCTION(lightsource, Remove)
{
	auto self = my->ToLightSource(1);
	
	gEnv->p3DEngine->UnRegisterEntity(self);
	self->ReleaseNode();

	my->MakeNull(self);

	return 0;
}

LUAMTA_FUNCTION(lightsource, SetBBox)
{
	auto self = my->ToLightSource(1);

	if (my->IsVec3(3))
	{
		self->SetBBox(AABB(my->ToVec3(2), my->ToVec3(3)));
	}
	else if(my->IsNumber(2))
	{
		self->SetBBox(AABB(my->ToNumber(2)));
	}

	return 1;
}


LUAMTA_FUNCTION(lightsource, GetBBox)
{
	auto self = my->ToLightSource(1);
	
	my->Push(self->GetBBox().min);
	my->Push(self->GetBBox().max);

	return 1;
}


LUAMTA_FUNCTION(lightsource, SetPos)
{
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();

	params.SetPosition(my->ToVec3(2));

	return 0;
}

LUAMTA_FUNCTION(lightsource, GetPos)
{
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();

	my->Push(params.GetPosition());

	return 1;
}

LUAMTA_FUNCTION(lightsource, SetColor)
{
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();

	params.SetLightColor(my->ToColor(2));

	return 0;
}

LUAMTA_FUNCTION(lightsource, GetColor)
{
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();

	my->Push(params.m_Color);

	return 0;
}

// auto generated
LUAMTA_FUNCTION(lightsource, SetProjectorNearPlane)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fProjectorNearPlane = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetProjectorNearPlane)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fProjectorNearPlane);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetShadowChanMask)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_ShadowChanMask = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetShadowChanMask)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_ShadowChanMask);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetOwner)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_pOwner = my->ToLightSource(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetOwner)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_pOwner);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetX)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_sX = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetX)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_sX);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetBaseOrigin)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_BaseOrigin = my->ToVec3(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetBaseOrigin)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_BaseOrigin);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetY)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_sY = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetY)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_sY);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetFlags)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_Flags = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetFlags)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_Flags);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetCoronaDistSizeFactor)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fCoronaDistSizeFactor = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetCoronaDistSizeFactor)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fCoronaDistSizeFactor);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetShadowUpdateMinRadius)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fShadowUpdateMinRadius = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetShadowUpdateMinRadius)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fShadowUpdateMinRadius);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetLightImage)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_pLightImage = my->ToTexture(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetLightImage)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_pLightImage);
	
	return 1;
}

LUAMTA_FUNCTION(lightsource, SetShaftLength)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fShaftLength = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetShaftLength)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fShaftLength);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetName)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_sName = my->ToString(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetName)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_sName);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetShadowBias)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fShadowBias = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetShadowBias)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fShadowBias);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetLightFrustumAngle)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fLightFrustumAngle = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetLightFrustumAngle)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fLightFrustumAngle);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetCoronaShaftsMinSpec)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_nCoronaShaftsMinSpec = my->ToEnum<EShaderQuality>(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetCoronaShaftsMinSpec)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push((uint)params.m_nCoronaShaftsMinSpec);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetCoronaScale)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fCoronaScale = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetCoronaScale)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fCoronaScale);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetTimeScrubbed)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fTimeScrubbed = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetTimeScrubbed)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fTimeScrubbed);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetHDRDynamic)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fHDRDynamic = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetHDRDynamic)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fHDRDynamic);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetWidth)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_sWidth = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetWidth)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_sWidth);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetShaftBrightness)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fShaftBrightness = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetShaftBrightness)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fShaftBrightness);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetLightAttenMap)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_pLightAttenMap = my->ToTexture(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetLightAttenMap)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_pLightAttenMap);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetPostEffect)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_nPostEffect = my->ToNumber (2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetPostEffect)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_nPostEffect);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetLightPhase)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_nLightPhase = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetLightPhase)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_nLightPhase);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetShaftBlendFactor)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fShaftBlendFactor = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetShaftBlendFactor)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fShaftBlendFactor);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetLightStyle)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_nLightStyle = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetLightStyle)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_nLightStyle);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetTimeScrubbingInTrackView)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_bTimeScrubbingInTrackView = my->ToBoolean(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetTimeScrubbingInTrackView)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_bTimeScrubbingInTrackView);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetShaftSrcSize)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fShaftSrcSize = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetShaftSrcSize)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fShaftSrcSize);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, Set3DEngineUpdateFrameID)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_n3DEngineUpdateFrameID = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, Get3DEngineUpdateFrameID)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_n3DEngineUpdateFrameID);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetCoronaDistIntensityFactor)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fCoronaDistIntensityFactor = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetCoronaDistIntensityFactor)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fCoronaDistIntensityFactor);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetHeight)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_sHeight = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetHeight)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_sHeight);
	
	return 1;
}

LUAMTA_FUNCTION(lightsource, SetDeferredGeom)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_sDeferredGeom = my->ToString(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetDeferredGeom)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_sDeferredGeom);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetShadowSlopeBias)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fShadowSlopeBias = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetShadowSlopeBias)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fShadowSlopeBias);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetBaseColor)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_BaseColor = my->ToColor(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetBaseColor)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_BaseColor);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetAnimSpeed)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fAnimSpeed = my->ToNumber (2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetAnimSpeed)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fAnimSpeed);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetId)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_Id = my->ToNumber (2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetId)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_Id);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, Set3DEngineLightId)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_n3DEngineLightId = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, Get3DEngineLightId)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_n3DEngineLightId);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetBaseSpecMult)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_BaseSpecMult = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetBaseSpecMult)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_BaseSpecMult);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetRadius)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fRadius = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetRadius)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fRadius);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetDiffuseCubemap)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_pDiffuseCubemap = my->ToTexture(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetDiffuseCubemap)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_pDiffuseCubemap);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetShaftDecayFactor)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fShaftDecayFactor = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetShaftDecayFactor)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fShaftDecayFactor);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetCoronaIntensity)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_fCoronaIntensity = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetCoronaIntensity)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_fCoronaIntensity);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetLensGhostsMinSpec)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_nLensGhostsMinSpec = my->ToEnum<EShaderQuality>(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetLensGhostsMinSpec)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push((uint)params.m_nLensGhostsMinSpec);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetOrigin)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_Origin = my->ToVec3(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetOrigin)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_Origin);
	
	return 1;
}

LUAMTA_FUNCTION(lightsource, SetSpecMult)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_SpecMult = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetSpecMult)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_SpecMult);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetShadowUpdateRatio)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_nShadowUpdateRatio = my->ToNumber(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetShadowUpdateRatio)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_nShadowUpdateRatio);
	
	return 1;
}
LUAMTA_FUNCTION(lightsource, SetSpecularCubemap)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.m_pSpecularCubemap = my->ToTexture(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetSpecularCubemap)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.m_pSpecularCubemap);
	
	return 1;
}
