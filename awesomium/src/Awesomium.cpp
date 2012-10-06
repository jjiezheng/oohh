#include "stdafx.h"

#include <IUIDraw.h>
#include <IEntitySystem.h>

#include "oohh.hpp"

#include <Awesomium/WebCore.h>
#include <Awesomium/BitmapSurface.h>
#include <Awesomium/STLHelpers.h>

Awesomium::WebCore* core = 0;

LUALIB_FUNCTION(awesomium, Open)
{
	if (!core)
	{
		Awesomium::WebConfig config;
		core = Awesomium::WebCore::Initialize(config);
	}

	my_suppress_lock();
	my->RunString("hook.Add(\"PostGameUpdate\", \"awesomium\", function() awesomium.Update() end, print)");
	my_allow_lock();
	return 0;
}

LUALIB_FUNCTION(awesomium, Close)
{
	// awesomium hates being shut down and opened again..

	/*if (core)
	{
		Awesomium::WebCore::Shutdown();
	 
		core = nullptr;
	}*/

	return 0;
}

LUALIB_FUNCTION(awesomium, Update)
{
	if (!core) return 0;
	
	core->Update();
	
	return 0;
}

#define tostring(var) ToString(var).c_str()

class MyWebViewListener : 
	public Awesomium::WebViewListener::Dialog, 
	public Awesomium::WebViewListener::Load, 
	public Awesomium::WebViewListener::Menu, 
	public Awesomium::WebViewListener::Print, 
	public Awesomium::WebViewListener::Process, 
	public Awesomium::WebViewListener::View	
{
public:

	void OnChangeTitle
	(
		Awesomium::WebView* caller,
		const Awesomium::WebString& title
	)
	{
		my->CallEntityHook(
			caller, 
			"OnChangeTitle", 
			tostring(title)
		);
	}

	
	void OnChangeAddressBar
	(
		Awesomium::WebView* caller,
		const Awesomium::WebURL& url
	)
	{
		my->CallEntityHook(
			caller, 
			"OnChangeAddressBar", 
			tostring(url.path())
		);
	}
	

	void OnChangeTooltip
	(
		Awesomium::WebView* caller,
		const Awesomium::WebString& tooltip
	)
	{
		my->CallEntityHook(
			caller, 
			"OnChangeTooltip", 
			tostring(tooltip)
		);
	}
	

	void OnChangeTargetURL
	(
		Awesomium::WebView* caller,
		const Awesomium::WebURL& url
	)
	{
		my->CallEntityHook(
			caller, 
			"OnChangeTargetURL", 
			tostring(url.path())
		);
	}
	

	void OnChangeCursor
	(
		Awesomium::WebView* caller,
		Awesomium::Cursor cursor
	)
	{
		my->CallEntityHook(
			caller, 
			"OnChangeCursor", 
			cursor
		);
	}
	

	void OnChangeFocus(Awesomium::WebView* caller,
		Awesomium::FocusedElementType focused_type
	)
	{
		my->CallEntityHook(
			caller, 
			"OnChangeFocus", 
			focused_type
		);
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
		my->CallEntityHook(
			caller, 
			"OnShowCreatedWebView", 
			tostring(opener_url.path()), 
			tostring(target_url.path()), 
			initial_pos.x, 
			initial_pos.x, 
			initial_pos.width, 
			initial_pos.height, 
			is_popup
		);
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
		my->CallEntityHook(
			caller, 
			"OnBeginLoadingFrame",
			(double)frame_id,
			is_main_frame,
			tostring(url.path()),
			is_error_page
		);
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
		my->CallEntityHook(
			caller, 
			"OnFailLoadingFrame",
			(double)frame_id,
			is_main_frame,
			tostring(url.path()),
			tostring(error_desc)
		);
	}

	
	void OnFinishLoadingFrame
	(
		Awesomium::WebView* caller,
		int64 frame_id,
		bool is_main_frame,
		const Awesomium::WebURL& url
	) 
	{
		my->CallEntityHook(
			caller, 
			"OnFinishLoadingFrame",
			(double)frame_id,
			is_main_frame,
			tostring(url.path())
		);
	}

	void OnDocumentReady
	(
		Awesomium::WebView* caller,
		const Awesomium::WebURL& url
	) 
	{
		my->CallEntityHook(
			caller, 
			"OnDocumentReady", 
			tostring(url.path())
		);
	}


	void OnUnresponsive
	(
		Awesomium::WebView* caller
	) 
	{
		my->CallEntityHook(
			caller, 
			"OnUnresponsive"
		);
	}


	void OnResponsive
	(
		Awesomium::WebView* caller
	) 
	{
		my->CallEntityHook(
			caller, 
			"OnResponsive"
		);
	}


	void OnCrashed
	(
		Awesomium::WebView* caller,
		Awesomium::TerminationStatus status
	) 
	{
		my->CallEntityHook(
			caller, 
			"OnCrashed",
			tostring(status)
		);
	}


	void OnShowPopupMenu
	(
		Awesomium::WebView* caller,
		const Awesomium::WebPopupMenuInfo& menu_info
	) 
	{
		/*my->CallEntityHook(
			caller, 
			"OnShowPopupMenu",
			menu_info.items.
		);*/
	}


	void OnShowContextMenu
	(
		Awesomium::WebView* caller,
		const Awesomium::WebContextMenuInfo& menu_info
	) 
	{

	}


	void OnShowFileChooser
	(
		Awesomium::WebView* caller,
		const Awesomium::WebFileChooserInfo& chooser_info
	) 
	{
		
	}


	void OnShowLoginDialog
	(
		Awesomium::WebView* caller,
		const Awesomium::WebLoginDialogInfo& dialog_info
	) 
	{

	}


	void OnRequestPrint
	(
		Awesomium::WebView* caller
	) 
	{
		my->CallEntityHook(
			caller, 
			"OnRequestPrint"
		);
	}


	void OnFailPrint
	(
		Awesomium::WebView* caller,
		int request_id
	) 
	{
		my->CallEntityHook(
			caller, 
			"OnFailPrint",
			request_id,
			0
		);
	}


	void OnFinishPrint
	(
		Awesomium::WebView* caller,
		int request_id,
		const Awesomium::WebStringArray& file_list)
	{
		my->CallEntityHook(
			caller, 
			"OnFinishPrint",
			request_id
		);
	}
};

using namespace Awesomium;

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
	self->set_dialog_listener(listener);
	self->set_menu_listener(listener);
	self->set_process_listener(listener);
	self->set_print_listener(listener);

	my->Push(self);

	return 1;
}

LUAMTA_FUNCTION(webview, Remove)
{
	auto self = my->ToWebView(1);
	self->Destroy();
	my->MakeNull(self);

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
	auto val = my->ToWebView(1)->ExecuteJavascriptWithResult(WSLit(my->ToString(2)), WSLit(my->ToString(3, "")));
	
	my->Push(ToString(val.ToString()).c_str());

	return 0;
}

LUAMTA_FUNCTION(webview, GetAudioBuffer)
{
	/*auto val = my->ToWebView(1)->session()->preferences().
	
	my->Push(ToString(val.ToString()).c_str());*/

	return 0;
}