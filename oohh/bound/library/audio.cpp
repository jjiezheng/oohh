#include "StdAfx.h"
#include "oohh.hpp"
#include "IAudioDevice.h"

LUALIB_FUNCTION(audio, SetMasterVolume)
{
    gEnv->pSoundSystem->SetMasterVolume(my->ToNumber(1));
    
    return 0;
}

LUALIB_FUNCTION(audio, StopSounds)
{
    gEnv->pSoundSystem->Silence(my->IsFalse(1), my->IsTrue(2));
    
    return 0;
}

LUALIB_FUNCTION(audio, Mute)
{
    gEnv->pSoundSystem->Mute(my->ToBoolean(1));
    
    return 0;
}

LUALIB_FUNCTION(audio, SetFrequency)
{
	gEnv->pSoundSystem->GetIAudioDevice()->SetFrequency(my->ToNumber(1));
    
    return 0;
}