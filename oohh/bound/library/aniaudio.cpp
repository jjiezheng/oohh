#include "StdAfx.h"
#include "oohh.hpp"

#include <windows.h>
#include <mmdeviceapi.h>
#include <audioclient.h>
#include <mmsystem.h>
#include <queue>

IAudioClient* client;
IAudioRenderClient* render;
WAVEFORMATEX* format;
UINT32 buffer;

LUALIB_FUNCTION(rawaudio, Open)
{
	IMMDeviceEnumerator* enumerator;
	IMMDevice* device;

	// this needs to be called once before we're about to use the COM api
	CoInitializeEx(nullptr, COINIT_DISABLE_OLE1DDE | COINIT_SPEED_OVER_MEMORY);

	// get the MMDeviceEnumerator class
	if (CoCreateInstance(__uuidof(MMDeviceEnumerator), nullptr, CLSCTX_INPROC_SERVER, __uuidof(IMMDeviceEnumerator), reinterpret_cast<LPVOID*>(&enumerator)) == S_OK)
	{
		// get the IMMDevice of this program
		if (enumerator->GetDefaultAudioEndpoint(eRender, eMultimedia, &device) == S_OK)
		{
			// and finally get the IAudioClient
			if (device->Activate(__uuidof(IAudioClient), CLSCTX_INPROC_SERVER, nullptr, reinterpret_cast<void**>(&client)) == S_OK)
			{
				// buffer size in seconds
				auto buffer_size = (REFERENCE_TIME)(my->ToNumber(1)*10000000);

				client->GetMixFormat(&format);
				client->Initialize(AUDCLNT_SHAREMODE_SHARED, AUDCLNT_STREAMFLAGS_EVENTCALLBACK, buffer_size, 0, format, nullptr);
				auto event = CreateEvent(nullptr, FALSE, FALSE, nullptr);
				client->SetEventHandle(event);
				client->GetService(__uuidof(IAudioRenderClient), reinterpret_cast<void**>(&render));
				client->GetBufferSize(&buffer);

				client->Start();

				my->Push((double)format->nSamplesPerSec);
			}
		}
	}

	my->RunString("hook.Add(\"PostGameUpdate\", \"rawaudio\", rawaudio.Update)");

	return 1;
}

LUALIB_FUNCTION(rawaudio, Close)
{
	client->Stop();
	render->Release();
	client->Release();

	my->RunString("hook.Remove(\"PostGameUpdate\", \"rawaudio\")");

	return 0;
}

LUALIB_FUNCTION(rawaudio, Update)
{
	UINT32 padding;
	BYTE* data;
	client->GetCurrentPadding(&padding);
	auto available = buffer - padding;
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