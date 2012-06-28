#include "StdAfx.h"

#include "oohh.hpp"
#include "isound.h"

LUALIB_FUNCTION(_G, Sound)
{ 
	auto snd = gEnv->pSoundSystem->CreateSound(my->ToPath(1, "sounds"), my->ToNumber(2, FLAG_SOUND_DEFAULT_3D));

	my->Push(snd);

	return 1;
}

LUAMTA_FUNCTION(sound, Play)
{
	auto self = my->ToSound(1);

	self->Play();

	return 1;
}

LUAMTA_FUNCTION(sound, IsPlaying)
{
	auto self = my->ToSound(1);

	my->Push(self->IsPlaying());

	return 1;
}

/*
spNONE,
spINITIALIZED,
spSOUNDID,
spSOUNDTYPE, // ?
spSAMPLETYPE, //?
spFREQUENCY,
spPITCH,

spVOLUME,
spISPLAYING,	
spPAUSEMODE,
spLOOPMODE,
spLENGTHINMS,
spLENGTHINBYTES,
spLENGTHINSAMPLES,
spSAMPLEPOSITION,
spTIMEPOSITION,
sp3DPOSITION,
sp3DVELOCITY,
spMINRADIUS,
spMAXRADIUS,
spPRIORITY,
spFXEFFECT,
spAMPLITUDE,
spSPEAKERPAN,
spREVERBWET,
spREVERBDRY,
spSYNCTIMEOUTINSEC*/

#define GETSET(enm, func_name)\
LUAMTA_FUNCTION(sound, Set##func_name)\
{\
	auto self = my->ToSound(1);\
\
	self->GetInterfaceExtended()->SetParam(enm, my->ToNumber(2));\
	\
	return 0;\
}\
\
LUAMTA_FUNCTION(sound, Get##func_name)\
{\
	auto self = my->ToSound(1);\
\
	float val = 0;\
	self->GetInterfaceExtended()->GetParam(enm, &val);\
	\
	my->Push(val);\
\
	return 1;\
}

//GETSET("Pitch", Pitch)

LUAMTA_FUNCTION(sound, SetPitch)
{
	auto self = my->ToSound(1);

	ptParamF32 param(my->ToNumber(2));
	self->SetParam(spPITCH, &param);
	
	return 0;
}

LUAMTA_FUNCTION(sound, GetPitch)
{
	auto self = my->ToSound(1);

	ptParamF32 param(0);
	self->GetParam(spPITCH, &param);
	float val;
	param.GetValue(val);

	my->Push(val);
	
	return 1;
}


#undef GETSET

LUAMTA_FUNCTION(sound, SetVolume)
{
	auto self = my->ToSound(1);

#ifdef CE3
	self->GetInterfaceExtended()->SetVolume(my->ToNumber(2));
#else
	self->SetVolume(my->ToNumber(2));
#endif

	return 0;
}

LUAMTA_FUNCTION(sound, GetVolume)
{
	auto self = my->ToSound(1);

#ifdef CE3
	my->Push(self->GetInterfaceExtended()->GetVolume());
#else
	my->Push(self->GetVolume());
#endif

	return 1;
}

LUAMTA_FUNCTION(sound, SetPan)
{
	auto self = my->ToSound(1);
#ifdef CE3
	self->GetInterfaceExtended()->SetPan(my->ToNumber(2));
#else
	self->SetPan(my->ToNumber(2));
#endif

	return 0;
}

LUAMTA_FUNCTION(sound, GetPan)
{
	auto self = my->ToSound(1);

#ifdef CE3
	my->Push(self->GetInterfaceExtended()->GetPan());
#else
	my->Push(self->GetPan());
#endif

	return 1;
}

LUAMTA_FUNCTION(sound, SetDistanceMultiplier)
{
	auto self = my->ToSound(1);

	self->SetDistanceMultiplier(my->ToNumber(2));

	return 0;
}

LUAMTA_FUNCTION(sound, SetFlags)
{
	auto self = my->ToSound(1);

#ifdef CE3
	self->GetInterfaceExtended()->SetFlags(my->ToNumber(2));
#else
	self->SetFlags(my->ToNumber(2));
#endif

	return 0;
}

LUAMTA_FUNCTION(sound, SetPos)
{
	auto self = my->ToSound(1);

	self->SetPosition(my->ToVec3(2));

	return 0;
}

LUAMTA_FUNCTION(sound, GetPos)
{
	auto self = my->ToSound(1);

	my->Push(self->GetPosition());

	return 1;
}

LUAMTA_FUNCTION(sound, SetDir)
{
	auto self = my->ToSound(1);

	self->SetDirection(my->ToVec3(2));

	return 0;
}

// where is GetDir?

LUAMTA_FUNCTION(sound, SetVelocity)
{
	auto self = my->ToSound(1);

#ifdef CE3
	self->GetInterfaceExtended()->SetVelocity(my->ToVec3(2));
#else
	self->SetVelocity(my->ToVec3(2));
#endif

	return 0;
}

LUAMTA_FUNCTION(sound, GetVelocity)
{
	auto self = my->ToSound(1);

#ifdef CE3
	my->Push(self->GetInterfaceExtended()->GetVelocity());
#else
	my->Push(self->GetVelocity());
#endif

	return 1;
}

LUAMTA_FUNCTION(sound, SetSamplePos)
{
	auto self = my->ToSound(1);

#ifdef CE3
	self->GetInterfaceExtended()->SetCurrentSamplePos(my->ToNumber(2), my->IsTrue(3));
#else
	self->SetCurrentSamplePos(my->ToNumber(2), my->IsTrue(3);
#endif

	return 0;
}

LUAMTA_FUNCTION(sound, GetSamplePos)
{
	auto self = my->ToSound(1);

#ifdef CE3
	my->Push(self->GetInterfaceExtended()->GetCurrentSamplePos(my->IsTrue(2)));
#else
	my->Push(self->GetCurrentSamplePos(my->IsTrue(2)));
#endif

	return 1;
}

LUAMTA_FUNCTION(sound, GetLength)
{
	auto self = my->ToSound(1);
#ifdef CE3
	my->Push(my->IsTrue(2) ? self->GetLengthMs() : self->GetInterfaceExtended()->GetLengthInBytes());
#else
	my->Push(my->IsTrue(2) ? self->GetLengthMs() : self->GetLength());
#endif

	return 1;
}

LUAMTA_FUNCTION(sound, AttachToEntity)
{
	auto self = my->ToSound(1);	
	auto proxy = (IEntitySoundProxy *)my->ToEntity(2)->CreateProxy(ENTITY_PROXY_SOUND);

	if (proxy)
	{
		self->SetSemantic(eSoundSemantic_Living_Entity);
		proxy->PlaySound(self);
	}

	return 0;
}