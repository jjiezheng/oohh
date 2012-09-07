#include "stdafx.h"

#include <IUIDraw.h>
#include <IEntitySystem.h>

#include "oohh.hpp"

#include <Awesomium/WebCore.h>
#include <Awesomium/BitmapSurface.h>
#include <Awesomium/STLHelpers.h>

using namespace Awesomium;

WebCore* core = 0;

LUALIB_FUNCTION(awesomium, Open)
{
	if (core) return 0;

	WebConfig config;
	core = WebCore::Initialize(config);

	return 0;
}

LUALIB_FUNCTION(awesomium, Close)
{
	if (core) return 0;

	WebCore::Shutdown();
	
	core = nullptr;

	return 0;
}

LUALIB_FUNCTION(awesomium, Update)
{
	if (!core) return 0;
	
	core->Update();
	
	return 0;
}

LUALIB_FUNCTION(_G, WebView)
{
	auto self = core->CreateWebView(my->ToNumber(1), my->ToNumber(2));

	my->Push(self);

	return 1;
}


LUAMTA_FUNCTION(webview, LoadURL)
{
	my->ToWebView(1)->LoadURL(WebURL(WSLit(my->ToString(2))));

	return 0;
}

LUAMTA_FUNCTION(webview, SetTransparent)
{
	my->ToWebView(1)->SetTransparent(my->ToBoolean(2));

	return 0;
}

#include <string>

LUAMTA_FUNCTION(webview, UpdateTexture)
{
	auto self = my->ToWebView(1);
	auto tex = my->ToTexture(2);

	auto surface = (BitmapSurface*)self->surface();

	if (surface && surface->is_dirty())
	{
		auto buffer = (unsigned char *)surface->buffer();
		if (buffer[2])
			gEnv->pRenderer->UpdateTextureInVideoMemory(tex->GetTextureID(), buffer, 0, 0, my->ToNumber(3, surface->width()), my->ToNumber(4, surface->height()), my->ToEnum<ETEX_Format>(5, eTF_A8R8G8B8));
	}

	return 0;
}

LUAMTA_FUNCTION(webview, ExecuteJavascriptWithResult)
{
	auto val = my->ToWebView(1)->ExecuteJavascriptWithResult(WSLit(my->ToString(1)), WSLit(my->ToString(2, "")));
	
	my->Push(ToString(val.ToString()).c_str());

	return 0;
}