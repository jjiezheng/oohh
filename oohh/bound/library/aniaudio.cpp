#include "StdAfx.h"
#include "oohh.hpp"

#include <windows.h>
#include <mmdeviceapi.h>
#include <audioclient.h>
#include <mmsystem.h>
#include <queue>

IMMDeviceEnumerator* enumerator;
IMMDevice* device;
IAudioClient* client;
IAudioRenderClient* render;
WAVEFORMATEX* format;
HANDLE event;
UINT32 buffer;

LUALIB_FUNCTION(aniaudio, Start)
{
	CoInitializeEx(NULL, COINIT_DISABLE_OLE1DDE | COINIT_SPEED_OVER_MEMORY);
	CoCreateInstance(__uuidof(MMDeviceEnumerator), NULL, CLSCTX_INPROC_SERVER, __uuidof(IMMDeviceEnumerator), reinterpret_cast<LPVOID*>(&enumerator));
	enumerator->GetDefaultAudioEndpoint(eRender, eConsole, &device);
	device->Activate(__uuidof(IAudioClient), CLSCTX_INPROC_SERVER, NULL, reinterpret_cast<void**>(&client));

	client->GetMixFormat(&format);
	client->Initialize(AUDCLNT_SHAREMODE_SHARED, AUDCLNT_STREAMFLAGS_EVENTCALLBACK, (REFERENCE_TIME)(my->ToNumber(1)*10000000), 0, format, NULL);
	event = CreateEvent(NULL, FALSE, FALSE, NULL);
	client->SetEventHandle(event);
	client->GetService(__uuidof(IAudioRenderClient), reinterpret_cast<void**>(&render));
	client->GetBufferSize(&buffer);

	client->Start();

	my->Push((double)format->nSamplesPerSec);

	return 1;
}

LUALIB_FUNCTION(aniaudio, Stop)
{
	client->Stop();
	render->Release();
	client->Release();

	return 0;
}

LUALIB_FUNCTION(aniaudio, Beep)
{
	my->Push(Beep(my->ToNumber(1), my->ToNumber(2)) == 1);

	return 1;
}

LUALIB_FUNCTION(aniaudio, Process)
{
	UINT32 padding, available;
	client->GetCurrentPadding(&padding);
	available = buffer - padding;
	BYTE* data;
	render->GetBuffer(available, &data);

	static UINT64 position;

	for(UINT32 i = 0; i < available; ++i, ++position)
	{
		my->CallHook("AudioSample", static_cast<double>(position) / format->nSamplesPerSec, (int)format->nChannels);

		for(UINT32 j = 0; j < format->nChannels; ++j)
		{
			auto wave = my->ToNumber(j+1, 0);
			reinterpret_cast<float*>(data)[i * format->nChannels + j] = wave;
		}
	}

	render->ReleaseBuffer(available, 0);

	return 0;
}