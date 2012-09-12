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

class MyWebViewListener : 
	public WebViewListener::Dialog, 
	public WebViewListener::Load, 
	public WebViewListener::Menu, 
	public WebViewListener::Print, 
	public WebViewListener::Process, 
	public WebViewListener::View	
{
public:

	void OnChangeTitle
	(
		Awesomium::WebView* caller,
		const Awesomium::WebString& title
	)
	{
		my->CallEntityHook(caller, "OnChangeTitle", ToString(title).c_str());
	}

	
	void OnChangeAddressBar
	(
		Awesomium::WebView* caller,
		const Awesomium::WebURL& url
	)
	{
		my->CallEntityHook(caller, "OnChangeAddressBar", ToString(url.path()).c_str());
	}
	

	void OnChangeTooltip
	(
		Awesomium::WebView* caller,
		const Awesomium::WebString& tooltip
	)
	{
		my->CallEntityHook(caller, "OnChangeTooltip", ToString(tooltip).c_str());
	}
	

	void OnChangeTargetURL
	(
		Awesomium::WebView* caller,
		const Awesomium::WebURL& url
	)
	{
		my->CallEntityHook(caller, "OnChangeTargetURL", ToString(url.path()).c_str());
	}
	

	void OnChangeCursor
	(
		Awesomium::WebView* caller,
		Awesomium::Cursor cursor
	)
	{
		my->CallEntityHook(caller, "OnChangeCursor", cursor);
	}
	

	void OnChangeFocus(Awesomium::WebView* caller,
		Awesomium::FocusedElementType focused_type
	)
	{
		my->CallEntityHook(caller, "OnChangeFocus", focused_type);
	}

	
	void OnShowCreatedWebView
	(
		Awesomium::WebView* caller,
		Awesomium::WebView* new_view,
		const Awesomium::WebURL& opener_url,
		const Awesomium::WebURL& target_url,
		const Awesomium::Rect& initial_pos,
		bool is_popup
	)
	{

	}

	
	void OnBeginLoadingFrame
	(
		Awesomium::WebView* caller,
		int64 frame_id,
		bool is_main_frame,
		const Awesomium::WebURL& url,
		bool is_error_page
	) 
	{

	}

	
	void OnFailLoadingFrame
	(
		Awesomium::WebView* caller,
		int64 frame_id,
		bool is_main_frame,
		const Awesomium::WebURL& url,
		int error_code,
		const Awesomium::WebString& error_desc
	) 
	{

	}

	
	void OnFinishLoadingFrame
	(
		Awesomium::WebView* caller,
		int64 frame_id,
		bool is_main_frame,
		const Awesomium::WebURL& url
	) 
	{

	}

	void OnDocumentReady
	(
		Awesomium::WebView* caller,
		const Awesomium::WebURL& url
	) 
	{
		my->CallEntityHook(caller, "OnDocumentReady", ToString(url.path()).c_str());
	}


	void OnUnresponsive
	(
		Awesomium::WebView* caller
	) 
	{

	}


	void OnResponsive
	(
		Awesomium::WebView* caller
	) 
	{

	}


	void OnCrashed
	(
		Awesomium::WebView* caller,
		Awesomium::TerminationStatus status
	) 
	{

	}


	void OnShowPopupMenu
	(
		Awesomium::WebView* caller,
		const WebPopupMenuInfo& menu_info
	) 
	{

	}


	void OnShowContextMenu
	(
		Awesomium::WebView* caller,
		const WebContextMenuInfo& menu_info
	) 
	{

	}


	void OnShowFileChooser
	(
		Awesomium::WebView* caller,
		const WebFileChooserInfo& chooser_info
	) 
	{

	}


	void OnShowLoginDialog
	(
		Awesomium::WebView* caller,
		const WebLoginDialogInfo& dialog_info
	) 
	{

	}


	void OnRequestPrint
	(
		Awesomium::WebView* caller
	) 
	{

	}


	void OnFailPrint
	(
		Awesomium::WebView* caller,
		int request_id
	) 
	{

	}


	void OnFinishPrint
	(
		Awesomium::WebView* caller,
		int request_id,
		const WebStringArray& file_list)
	{

	}
};

LUALIB_FUNCTION(_G, WebView)
{
	WebPreferences params;
	params.enable_web_gl = true;
	params.enable_web_audio = true;
	params.allow_running_insecure_content = true;
	params.enable_plugins = true;
	auto session = core->CreateWebSession(WSLit(""), params);

	auto self = core->CreateWebView(my->ToNumber(1), my->ToNumber(2));
	auto listener = new MyWebViewListener();
	self->set_view_listener(listener);

	my->Push(self);

	return 1;
}

LUAMTA_FUNCTION(webview, Remove)
{
	my->ToWebView(1)->Destroy();

	return 0;
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

LUAMTA_FUNCTION(webview, SetSize)
{
	my->ToWebView(1)->Resize(my->ToNumber(2), my->ToNumber(3));

	return 0;
}

LUAMTA_FUNCTION(webview, InjectMouseMove)
{
	my->ToWebView(1)->InjectMouseMove(my->ToNumber(2), my->ToNumber(3));

	return 0;
}

LUAMTA_FUNCTION(webview, InjectMouseButton)
{
	if (my->ToBoolean(3))
	{
		my->ToWebView(1)->InjectMouseDown(my->ToEnum<Awesomium::MouseButton>(2));
	}
	else
	{
		my->ToWebView(1)->InjectMouseUp(my->ToEnum<Awesomium::MouseButton>(2));
	}

	return 0;
}

LUAMTA_FUNCTION(webview, InjectMouseWheel)
{
	my->ToWebView(1)->InjectMouseWheel(my->ToNumber(2), my->ToNumber(3));
	
	return 0;
}

LUAMTA_FUNCTION(webview, InjectKeyboardEvent)
{
	Awesomium::WebKeyboardEvent params;
		params.text[0] = my->ToNumber(2);
		params.type = my->ToEnum<Awesomium::WebKeyboardEvent::Type>(3);
		params.modifiers = my->ToEnum<Awesomium::WebKeyboardEvent::Modifiers>(4);
	my->ToWebView(1)->InjectKeyboardEvent(params);
	
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
		{
			gEnv->pRenderer->UpdateTextureInVideoMemory(tex->GetTextureID(), buffer, 0, 0, my->ToNumber(3, surface->width()), my->ToNumber(4, surface->height()), my->ToEnum<ETEX_Format>(5, eTF_A8R8G8B8));
			my->Push(true);
			return 1;
		}
	}

	my->Push(false);

	return 1;
}

LUAMTA_FUNCTION(webview, ExecuteJavascriptWithResult)
{
	auto val = my->ToWebView(1)->ExecuteJavascriptWithResult(WSLit(my->ToString(1)), WSLit(my->ToString(2, "")));
	
	my->Push(ToString(val.ToString()).c_str());

	return 0;
}