local template = 
[[
LUAMTA_FUNCTION(lightsource, SetMEMBER)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	params.MEMBER = my->ToTYPE(2);
	
	self->SetLightProperties(params);
	
	return 0;
}

LUAMTA_FUNCTION(lightsource, GetMEMBER)
{ 
	auto self = my->ToLightSource(1);
	auto params = self->GetLightProperties();
	
	my->Push(params.MEMBER);
	
	return 1;
}
]]

local params = 
{
	m_pOwner = "LightSource",
	m_pDiffuseCubemap = "Texture",
	m_pSpecularCubemap = "Texture",
	m_pLightImage = "Texture",
	m_pLightAttenMap = "Texture",
	m_sName = "String",
	m_sDeferredGeom = "String",
	m_Color = "Color",
	m_BaseColor = "Color",
	m_Origin = "Vec3",
	m_BaseOrigin = "Vec3",
	m_fShadowBias = "Number",
	m_fShadowSlopeBias = "Number",
	m_fRadius = "Number",
	m_SpecMult = "Number",
	m_BaseSpecMult = "Number",
	m_fHDRDynamic = "Number",
	m_fAnimSpeed = "Number ",
	m_fCoronaScale = "Number",
	m_fCoronaIntensity = "Number",
	m_fCoronaDistSizeFactor = "Number",
	m_fCoronaDistIntensityFactor = "Number",
	m_fShaftSrcSize = "Number",
	m_fShaftLength = "Number",
	m_fShaftBrightness = "Number",
	m_fShaftBlendFactor = "Number",
	m_fShaftDecayFactor = "Number",
	m_nCoronaShaftsMinSpec = "Number",
	m_nLensGhostsMinSpec = "Number",
	m_fLightFrustumAngle = "Number",
	m_fProjectorNearPlane = "Number",
	m_fShadowUpdateMinRadius = "Number",
	m_Flags = "Number",
	m_Id = "Number ",
	m_n3DEngineLightId = "Number",
	m_n3DEngineUpdateFrameID = "Number",
	m_sX = "Number",
	m_sY = "Number",
	m_sWidth = "Number",
	m_sHeight = "Number",
	m_lightAnimationName = "Number",
	m_bTimeScrubbingInTrackView = "Boolean",
	m_fTimeScrubbed = "Number",
	m_AnimRotation = "Number",
	m_nShadowUpdateRatio = "Number",
	m_nLightStyle = "Number",
	m_nLightPhase = "Number",
	m_nPostEffect = "Number ",
	m_ShadowChanMask = "Number",
}

local out = ""

for member, type in pairs(params) do
	print(type, member)
	out = out .. template
	:gsub("MEMBER", member)
	:gsub("TYPE", type)
	:gsub("Setm_", "Set")
	:gsub("Getm_", "Get")
	:gsub("Set%l", "Set")
	:gsub("Get%l", "Get")
end

window.SetClipboard(out)