#include "stdafx.h"

#include <IUIDraw.h>
#include <IEntitySystem.h>

#include "oohh.hpp"

#include <berkelium\berkelium.hpp>
#include <berkelium\Context.hpp>
#include <berkelium\WindowDelegate.hpp>

static bool opened = false;

LUALIB_FUNCTION(awesomium, Open)
{
	if (opened) return 0;

	if (!Berkelium::init(Berkelium::FileString::empty()))
		my->Error("could not initialize berkelium");

	opened = true;

	return 0;
}

LUALIB_FUNCTION(awesomium, Close)
{
	if (!opened) return 0;

	Berkelium::destroy();

	return 0;
}

LUALIB_FUNCTION(awesomium, Update)
{
	Berkelium::update();
	
	return 0;
}

LUALIB_FUNCTION(_G, WebView)
{
	Berkelium::Context *context = Berkelium::Context::create();
    Berkelium::Window *self = Berkelium::Window::create(context);
    delete context;

	self->resize(my->ToNumber(1), my->ToNumber(2));
   
	my->Push(self);

	return 1;
}

bool mapOnPaintToTexture
(
	Berkelium::Window *wini,
	const unsigned char* bitmap_in, const Berkelium::Rect& bitmap_rect,
	size_t num_copy_rects, const Berkelium::Rect *copy_rects,
	int dx, int dy,
	const Berkelium::Rect& scroll_rect,
	ITexture *dest_texture,
	unsigned int dest_texture_width,
	unsigned int dest_texture_height,
	bool ignore_partial,
	char* scroll_buffer
) 
{
    const int kBytesPerPixel = 4;

    // If we've reloaded the page and need a full update, ignore updates
    // until a full one comes in.  This handles out of date updates due to
    // delays in event processing.
    if (ignore_partial) {
        if (bitmap_rect.left() != 0 ||
            bitmap_rect.top() != 0 ||
            bitmap_rect.right() != dest_texture_width ||
            bitmap_rect.bottom() != dest_texture_height) 
		{
            return false;
        }

		gEnv->pRenderer->UpdateTextureInVideoMemory(
			dest_texture->GetTextureID(), 
			(unsigned char *)bitmap_in, 
			0, 
			0, 
			dest_texture_width, 
			dest_texture_height, 
			dest_texture->GetTextureSrcFormat()
		);

        return true;
    }


    // Now, we first handle scrolling. We need to do this first since it
    // requires shifting existing data, some of which will be overwritten by
    // the regular dirty rect update.
    if (dx != 0 || dy != 0) {
        // scroll_rect contains the Rect we need to move
        // First we figure out where the the data is moved to by translating it
        Berkelium::Rect scrolled_rect = scroll_rect.translate(-dx, -dy);
        // Next we figure out where they intersect, giving the scrolled
        // region
        Berkelium::Rect scrolled_shared_rect = scroll_rect.intersect(scrolled_rect);
        // Only do scrolling if they have non-zero intersection
        if (scrolled_shared_rect.width() > 0 && scrolled_shared_rect.height() > 0) {
            // And the scroll is performed by moving shared_rect by (dx,dy)
            Berkelium::Rect shared_rect = scrolled_shared_rect.translate(dx, dy);

            int wid = scrolled_shared_rect.width();
            int hig = scrolled_shared_rect.height();
            int inc = 1;
            char *outputBuffer = scroll_buffer;
            // source data is offset by 1 line to prevent memcpy aliasing
            // In this case, it can happen if dy==0 and dx!=0.
            char *inputBuffer = scroll_buffer+(dest_texture_width*1*kBytesPerPixel);
            int jj = 0;
            if (dy > 0) {
                // Here, we need to shift the buffer around so that we start in the
                // extra row at the end, and then copy in reverse so that we
                // don't clobber source data before copying it.
                outputBuffer = scroll_buffer+(
                    (scrolled_shared_rect.top()+hig+1)*dest_texture_width
                    - hig*wid)*kBytesPerPixel;
                inputBuffer = scroll_buffer;
                inc = -1;
                jj = hig-1;
            }

            // Copy the data out of the texture
			dest_texture->GetData32(0, 0, (unsigned char *)inputBuffer);

            // Annoyingly, OpenGL doesn't provide convenient primitives, so
            // we manually copy out the region to the beginning of the
            // buffer
            for(; jj < hig && jj >= 0; jj+=inc) {
                memcpy(
                    outputBuffer + (jj*wid) * kBytesPerPixel,
                    inputBuffer + (
                        (scrolled_shared_rect.top()+jj)*dest_texture_width
                        + scrolled_shared_rect.left()) * kBytesPerPixel,
                    wid*kBytesPerPixel
                );
            }

            // And finally, we push it back into the texture in the right
            // location
			gEnv->pRenderer->UpdateTextureInVideoMemory(
				dest_texture->GetTextureID(), 
				(unsigned char *)outputBuffer, 
				shared_rect.left(), 
				shared_rect.top(), 
				shared_rect.width(), 
				shared_rect.height(), 
				dest_texture->GetTextureSrcFormat()
			);
        }
    }

    for (size_t i = 0; i < num_copy_rects; i++) {
        int wid = copy_rects[i].width();
        int hig = copy_rects[i].height();
        int top = copy_rects[i].top() - bitmap_rect.top();
        int left = copy_rects[i].left() - bitmap_rect.left();
     
        for(int jj = 0; jj < hig; jj++) {
			memcpy(
                scroll_buffer + jj*wid*kBytesPerPixel,
                bitmap_in + (left + (jj+top)*bitmap_rect.width())*kBytesPerPixel,
                wid*kBytesPerPixel
            );
        }

        // Finally, we perform the main update, just copying the rect that is
        // marked as dirty but not from scrolled data.

		gEnv->pRenderer->UpdateTextureInVideoMemory(
			dest_texture->GetTextureID(), 
			(unsigned char *)(scroll_buffer), 
			copy_rects[i].left(), 
			copy_rects[i].top(),
			wid, 
			hig, 
			dest_texture->GetTextureSrcFormat()
		);
	}

    return true;
}

class MyDelegate : public Berkelium::WindowDelegate 
{
	ITexture *m_tex;
	int m_w;
	int m_h;
	ETEX_Format m_format;

	//bool needs_full_refresh;
	//char* scroll_buffer;
public:

	MyDelegate(ITexture *tex, int w, int h, ETEX_Format format)
	{
		m_tex = tex;
		m_w = w;
		m_h = h;
		m_format = format;
		
		//scroll_buffer = new char[w*(h+1)*4];
		//needs_full_refresh = true;
	}

	virtual void onPaint
	(
		Berkelium::Window* wini,
		const unsigned char *bitmap_in, 
		const Berkelium::Rect &bitmap_rect,
		size_t num_copy_rects, 
		const Berkelium::Rect* copy_rects,
		int dx, 
		int dy, 
		const Berkelium::Rect& scroll_rect
	) 
	{
		for( int i = 0; i < num_copy_rects; i++) 
		{
			auto rect = copy_rects[i];
			auto x = rect.x(); 
			auto y = rect.y();
			auto w = rect.width();
			auto h = rect.height();

			auto maxw = m_tex->GetWidth();
			auto maxh = m_tex->GetHeight();

			if 
			(
				x < maxw &&
				y < maxh &&

				x + w < maxw &&
				y + h < maxh
			)
			{
				gEnv->pRenderer->UpdateTextureInVideoMemory(
					m_tex->GetTextureID(), 
					(unsigned char *)bitmap_in, 
					x, 
					y, 
					w, 
					h, 
					m_format
				);
			}
		}

	/*bool updated = mapOnPaintToTexture
		(
			wini, 
			bitmap_in, 
			bitmap_rect, 
			num_copy_rects, 
			copy_rects,
			dx, 
			dy,
			scroll_rect,
			m_tex, 
			m_tex->GetWidth(), 
			m_tex->GetHeight(), 
			false,//needs_full_refresh, 
			scroll_buffer
		);

		if (updated) 
		{
			needs_full_refresh = false;
		}*/
	/*	auto uh = IRenderer::SUpdateRect();
			uh.srcX = dx;
			uh.srcY = dy;
			uh.width = m_w ? m_w : bitmap_rect.width();
			uh.height = m_h ? m_h : bitmap_rect.height();

		gEnv->pRenderer->SF_UpdateTexture(
			m_tex->GetTextureID(),
			0,
			1,
			&uh,
			const_cast<unsigned char*>(bitmap_in),
			uh.width * 4 * sizeof(unsigned char),
			m_tex->GetTextureSrcFormat()
		);

		m_tex->SaveJPG("c:/test.jpg");*/
	}
};

LUAMTA_FUNCTION(webview, LoadURL)
{
    std::string url = my->ToString(2);
    my->ToWebView(1)->navigateTo(Berkelium::URLString::point_to(url.data(), url.length()));

	return 0;
}

LUAMTA_FUNCTION(webview, SetSize)
{
	my->ToWebView(1)->resize(my->ToNumber(2), my->ToNumber(3));

	return 0;
}

LUAMTA_FUNCTION(webview, MouseMoved)
{
	my->ToWebView(1)->mouseMoved(my->ToNumber(2), my->ToNumber(3));

	return 0;
}

LUAMTA_FUNCTION(webview, MouseEvent)
{
	my->ToWebView(1)->mouseButton(my->ToNumber(2), my->ToBoolean(3));

	return 0;
}

LUAMTA_FUNCTION(webview, MouseWheel)
{
	my->ToWebView(1)->mouseWheel(my->ToNumber(2), my->ToNumber(3));

	return 0;
}


LUAMTA_FUNCTION(webview, KeyEvent)
{
	my->ToWebView(1)->keyEvent(my->ToBoolean(3), my->ToNumber(3), my->ToNumber(2, 0), 0);

	return 0;
}

LUAMTA_FUNCTION(webview, SetTransparent)
{
	my->ToWebView(1)->setTransparent(my->ToBoolean(2));

	return 0;
}

LUAMTA_FUNCTION(webview, SetTexture)
{
	auto self = my->ToWebView(1);
	auto tex = my->ToTexture(2);
	
	auto dlg = new MyDelegate(tex, my->ToNumber(3, 0), my->ToNumber(4, 0), my->ToEnum<ETEX_Format>(5, eTF_A8R8G8B8));

	self->setDelegate(dlg);

	return 0;
}

#include <berkelium\StringUtil.hpp>

LUAMTA_FUNCTION(webview, ExecuteJavascriptWithResult)
{	
	my->ToWebView(1)->executeJavascript(Berkelium::UTF8ToWide(Berkelium::UTF8String::point_to(my->ToString(1))));

	return 0;
}