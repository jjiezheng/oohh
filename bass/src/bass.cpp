#include "StdAfx.h"
#include "oohh.hpp"

#include "bass.h"

LUALIB_FUNCTION(bass, Open)
{        
	if (!BASS_Init(-1, 44100, my->ToNumber(1, BASS_DEVICE_DEFAULT | BASS_DEVICE_3D), (HWND)gEnv->pRenderer->GetHWND(), NULL))
    {
		int error = BASS_ErrorGetCode();

		my->Print("bass failed to open");
    }

    BASS_SetConfig(BASS_CONFIG_FLOATDSP, true);
    BASS_SetConfig(BASS_CONFIG_NET_PLAYLIST, 1);

    return 0;
}

LUALIB_FUNCTION(bass, Close)
{
    BASS_Stop();
    BASS_Free();

    return 0;
}

LUALIB_FUNCTION(bass, Status)
{
	my->Push(BASS_ErrorGetCode());

	return 1;
}

#define BASS_MUSIC 1
#define BASS_FILE 2
#define BASS_URL 3

class StreamThread : public CryThread<>
{
public:
	Channel *m_channel;
	char * m_url;
	double m_offset;
	double m_flags;

	StreamThread(Channel *channel, const char *url, double offset, double flags)
	{
		m_channel = channel;
		m_url = (char *)url;
		m_offset = offset;
		m_flags = flags;
	}

	void Run()
	{
		if (my)
		{
			m_channel->handle = BASS_StreamCreateURL(m_url, m_offset, m_flags, NULL, 0);
			my->CallEntityHook(m_channel, "OnStreamLoaded");
		}
	}
};

LUALIB_FUNCTION(_G, Channel)
{
	auto type = my->ToNumber(1);
	Channel *self = nullptr;

	if (type == BASS_FILE)
	{
		self = new Channel(BASS_StreamCreateFile(false, my->ToString(2), my->ToNumber(3, 0), 0, my->ToNumber(4, BASS_SAMPLE_3D)));
	}
	else if (type == BASS_MUSIC)
	{
		self = new Channel(BASS_MusicLoad(false, my->ToString(2), my->ToNumber(3, 0), 0, my->ToNumber(4, BASS_MUSIC_FLOAT | BASS_MUSIC_PRESCAN), my->ToNumber(5, 0)));
	}
	else if (type == BASS_URL)
	{
		auto url = my->ToString(2);
		auto offset =  my->ToNumber(3, 0);
		auto flags = my->ToNumber(4, BASS_SAMPLE_3D);

		self = new Channel(0);

		auto thread = new StreamThread(self, url, offset, flags);
		//thread->Start(); // crashing..
		thread->Run();
	}

	my->Push(self);

    return 1;
}

LUALIB_FUNCTION(bass, SetPosition)
{
	auto pos = (BASS_3DVECTOR *)my->ToVec3Ptr(1);
    auto vel = (BASS_3DVECTOR *)my->ToVec3Ptr(2);
    auto front = (BASS_3DVECTOR *)my->ToVec3Ptr(3);
    auto up = (BASS_3DVECTOR *)my->ToVec3Ptr(4);

    BASS_Set3DFactors(0.5, 0.01, -1.0);
    BASS_Set3DPosition(pos, vel, front, up);

    BASS_Apply3D();

    return 0;
}

LUAMTA_FUNCTION(channel, Play)
{
	auto self = my->ToChannel(1);

    BASS_ChannelPlay((DWORD)self->handle, true);

    return 0;
}

LUAMTA_FUNCTION(channel, Remove)
{
	auto self = my->ToChannel(1);

    BASS_StreamFree((DWORD)self->handle);
	my->MakeNull(self);

    return 0;
}

LUAMTA_FUNCTION(channel, Pause)
{
	auto self = my->ToChannel(1);

	BASS_ChannelPause((DWORD)self->handle);

    return 0;
}

LUAMTA_FUNCTION(channel, Stop)
{
	auto self = my->ToChannel(1);

    BASS_ChannelStop((DWORD)self->handle);
    return 0;
}

LUAMTA_FUNCTION(channel, GetLength)
{
	auto self = my->ToChannel(1);

    auto siz = BASS_ChannelGetLength((DWORD)self->handle, BASS_POS_BYTE);
	auto sec = BASS_ChannelBytes2Seconds((DWORD)self->handle, siz);
	
	my->Push(sec);
	my->Push(siz);

    return 2;
}

LUAMTA_FUNCTION(channel, GetPosition)
{
	auto self = my->ToChannel(1);

	auto siz = BASS_ChannelGetPosition((DWORD)self->handle, BASS_POS_BYTE);
	auto sec = BASS_ChannelBytes2Seconds((DWORD)self->handle, siz);
	
	my->Push(sec);
	my->Push(siz);

    return 2;
}

LUAMTA_FUNCTION(channel, IsPlaying)
{
	auto self = my->ToChannel(1);

    my->Push((bool)(BASS_ChannelIsActive((DWORD)self->handle) == BASS_ACTIVE_PLAYING));

    return 1;
}

LUAMTA_FUNCTION(channel, GetLevel)
{
	auto self = my->ToChannel(1);

    auto level = BASS_ChannelGetLevel((DWORD)self->handle);

    my->Push((float)HIWORD(level));
    my->Push((float)LOWORD(level));

    return 2;
}

LUAMTA_FUNCTION(channel, GetFFT)
{
	auto self = my->ToChannel(1);

    float fft[1024];
    BASS_ChannelGetData((DWORD)self->handle, fft, my->ToNumber(2, BASS_DATA_FFT2048));
    
	my->NewTable();

    for(int x = 0; x < 1024; x++)
    {
		my->SetMember(-1, x+1, fft[x]);
    }

    return 1;
}

LUAMTA_FUNCTION(channel, GetTags)
{
	auto self = my->ToChannel(1);
	auto tags = BASS_ChannelGetTags((DWORD)self->handle, my->ToNumber(2));
	
	if (tags)
	{
		my->NewTable();
		int i = 1;

		while(*tags)
		{
			lua_pushstring(L, tags);
			lua_rawseti(L, -2, i);

			tags += strlen(tags) + 1;
			i++;
		}
	}

    return 1;
}

/*LUAMTA_FUNCTION(channel, GetTag)
{
	auto self = my->ToChannel(1);

	my->Push(TAGS_Read((DWORD)self->handle, my->ToString(2)));

    return 1;
}*/

LUAMTA_FUNCTION(channel, SetPosition)
{
	auto self = my->ToChannel(1);

	QWORD pos;

	if (my->ToBoolean(3))
	{
		pos = BASS_ChannelSeconds2Bytes((DWORD)self->handle, my->ToNumber(2));
	}
	else
	{
		pos = my->ToNumber(2);
	}

	BASS_ChannelSetPosition((DWORD)self->handle, pos, BASS_POS_BYTE);

    return 0;
}

LUAMTA_FUNCTION(channel, SetVolume)
{
	auto self = my->ToChannel(1);

	BASS_ChannelSetAttribute((DWORD)self->handle, BASS_ATTRIB_VOL, my->ToNumber(2));

    return 0;
}
LUAMTA_FUNCTION(channel, SetPan)
{
	auto self = my->ToChannel(1);

	BASS_ChannelSetAttribute((DWORD)self->handle, BASS_ATTRIB_PAN, my->ToNumber(2));

    return 0;
}
LUAMTA_FUNCTION(channel, SetFrequency)
{
	auto self = my->ToChannel(1);

	BASS_ChannelSetAttribute((DWORD)self->handle, BASS_ATTRIB_FREQ, my->ToNumber(2));

    return 0;
}


LUAMTA_FUNCTION(channel, GetVolume)
{
	auto self = my->ToChannel(1);

	float num = 0;

	BASS_ChannelGetAttribute((DWORD)self->handle, BASS_ATTRIB_VOL, &num);

	my->Push(num);

    return 1;
}
LUAMTA_FUNCTION(channel, GetPan)
{
	auto self = my->ToChannel(1);

	float num = 0;

	BASS_ChannelGetAttribute((DWORD)self->handle, BASS_ATTRIB_PAN, &num);

	my->Push(num);

    return 1;
}
LUAMTA_FUNCTION(channel, GetFrequency)
{
	auto self = my->ToChannel(1);

	float num = 0;

	BASS_ChannelGetAttribute((DWORD)self->handle, BASS_ATTRIB_FREQ, &num);

	my->Push(num);

    return 1;
}

LUAMTA_FUNCTION(channel, Set3DPos)
{	
	auto self = my->ToChannel(1);

	auto pos = (BASS_3DVECTOR *)my->ToVec3Ptr(2);
    auto orient = (BASS_3DVECTOR *)my->ToVec3Ptr(3);
    auto vel = (BASS_3DVECTOR *)my->ToVec3Ptr(4);

    BASS_ChannelSet3DAttributes((DWORD)self->handle, BASS_3DMODE_NORMAL, 0, 0, 360, 360, 0);
    BASS_ChannelSet3DPosition((DWORD)self->handle, pos, orient, vel);

    BASS_Apply3D();

    return 0;
}