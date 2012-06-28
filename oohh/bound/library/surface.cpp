#include "StdAfx.h"
#include "oohh.hpp"

#include "IHardwareMouse.h"
#include "Game.h"
#include "IUIDraw.h"

#include "Cry_Math.h"
#include <strsafe.h>

#define uidraw gEnv->pGame->GetIGameFramework()->GetIUIDraw()
#define render gEnv->pRenderer

static IFFont *bind_font = NULL;

static auto bind_color = ColorF(1, 1, 1, 1);
static auto pos_offset = Vec2(0,0);
static auto bind_texture = 0;
static auto white = 0;
static auto clip_rect = RectI(0,0,0,0);

void oohh::SetSurfaceClipRect(int x, int y, int w, int h)
{
	clip_rect.x = x;
	clip_rect.y = y;
	clip_rect.w = w;
	clip_rect.h = h;
}
RectI oohh::GetSurfaceClipRect()
{
	return clip_rect;
}

LUALIB_FUNCTION(surface, StartDraw)
{
	uidraw->PreRender();

	return 0;
}
LUALIB_FUNCTION(surface, EndDraw)
{
	uidraw->PostRender();

	return 0;
}

#define GETSET(func_name, my_func_name, var_name) \
LUALIB_FUNCTION(surface, Set##func_name) \
{ \
	auto var = my->my_func_name(1); \
	\
	var_name = var;\
\
	return 0;\
}\
\
LUALIB_FUNCTION(surface, Get##func_name)\
{\
	my->Push(var_name);\
\
	return 1;\
}\


//GETSET(Texture, ToInt, bind_texture)
GETSET(Font, ToFont, bind_font)

#undef GETSET

LUALIB_FUNCTION(surface, SetColor) 
{ 
	auto var = my->ToColor(1); 
	
	bind_color = var;
	//render->SetMaterialColor(var.r, var.g, var.b, var.a);

	return 0;
}

LUALIB_FUNCTION(surface, GetColor)
{
	my->Push(bind_color);

	return 1;
}


LUALIB_FUNCTION(surface, SetTexture) 
{ 
	auto var = my->ToNumber(1);
	
	bind_texture = var;
	//render->SetTexture(var);

	return 0;
}

LUALIB_FUNCTION(surface, GetTexture)
{
	my->Push(bind_texture);

	return 1;
}

LUALIB_FUNCTION(surface, SetTranslation)
{
	auto x = my->ToNumber(1); 
	auto y = my->ToNumber(2);

	pos_offset.x = x;
	pos_offset.y = y;

	return 0;
}

LUALIB_FUNCTION(surface, Translate)
{
	auto x = my->ToNumber(1); 
	auto y = my->ToNumber(2);

	pos_offset.x += x;
	pos_offset.y += y;

	return 0;
}

LUALIB_FUNCTION(surface, GetTranslation)
{
	my->Push(pos_offset.x);
	my->Push(pos_offset.y);

	return 2;
}

LUALIB_FUNCTION(surface, StartClip)
{
	auto x = my->ToNumber(1) + pos_offset.x;
	auto y = my->ToNumber(2) + pos_offset.y;
	auto w = my->ToNumber(3);
	auto h = my->ToNumber(4);

	oohh::SetSurfaceClipRect(x, y, w, h);

	render->SetScissor(x, y, w, h);

	return 0;
}

LUALIB_FUNCTION(surface, EndClip)
{
	oohh::SetSurfaceClipRect(0,0,0,0);

	render->SetScissor();

	return 0;
}

#ifdef CE3
//gEnv->pRenderer->DrawImageWithUV
LUALIB_FUNCTION(surface, DrawFilledRectEx)
{
	auto x = my->ToNumber(1) + pos_offset.x;
	auto y = my->ToNumber(2) + pos_offset.y;
	auto w = my->ToNumber(3);
	auto h = my->ToNumber(4);

	white = white ? white : uidraw->CreateTexture("textures/defaults/white.dds", true);

	static float* s = new float[4];
	static float* t = new float[4];

	s[0] = 0; t[0] = 0;
	s[1] = 1; t[1] = 0;

	s[2] = 1; t[2] = 1;
	s[3] = 1; t[3] = 1;

	gEnv->pRenderer->DrawImageWithUV(
		x,
		y,

		1.0f,

		w,
		h,

		white,

		s,
		t,

		bind_color.r,
		bind_color.g,
		bind_color.b,
		bind_color.a,

		false
	);

	return 0;
}
#endif

//uidraw->DrawQuad
LUALIB_FUNCTION(surface, DrawFilledRect)
{
	auto x = my->ToNumber(1) + pos_offset.x;
	auto y = my->ToNumber(2) + pos_offset.y;
	auto w = my->ToNumber(3);
	auto h = my->ToNumber(4);

	auto cb = bind_color.pack_argb8888();

	auto c1 = my->IsColor(5) ? my->ToColor(5).pack_argb8888() : cb;
	auto c2 = my->IsColor(6) ? my->ToColor(6).pack_argb8888() : cb;
	auto c3 = my->IsColor(7) ? my->ToColor(7).pack_argb8888() : cb;
	auto c4 = my->IsColor(8) ? my->ToColor(8).pack_argb8888() : cb;

	x /= render->ScaleCoordX(1);
	y /= render->ScaleCoordY(1);

	w /= render->ScaleCoordX(1);
	h /= render->ScaleCoordY(1);

	uidraw->DrawQuad(
		x, y,
		w, h,

		0,
		
		c1,	c2,
		c3,	c4,

		white,
		
		0,0, 1,0,
		0,1, 1,1,

		false
	);
	
	return 0;
}

//uidraw->DrawQuad
LUALIB_FUNCTION(surface, DrawTexturedRect)
{
	auto x = my->ToNumber(1) + pos_offset.x;
	auto y = my->ToNumber(2) + pos_offset.y;
	auto w = my->ToNumber(3);
	auto h = my->ToNumber(4);
	
	auto cb = bind_color.pack_argb8888();

	auto c1 = my->IsColor(5) ? my->ToColor(5).pack_argb8888() : cb;
	auto c2 = my->IsColor(6) ? my->ToColor(6).pack_argb8888() : cb;
	auto c3 = my->IsColor(7) ? my->ToColor(7).pack_argb8888() : cb;
	auto c4 = my->IsColor(8) ? my->ToColor(8).pack_argb8888() : cb;

	float xtl = my->ToNumber(9, 0);
	float ytl = my->ToNumber(10, 0);
	float xtr = my->ToNumber(11, 1);
	float ytr = my->ToNumber(12, 0);

	float xbl = my->ToNumber(13, 0);
	float ybl = my->ToNumber(14, 1);
	float xbr = my->ToNumber(15, 1);
	float ybr = my->ToNumber(16, 1);

	x /= render->ScaleCoordX(1);
	y /= render->ScaleCoordY(1);

	w /= render->ScaleCoordX(1);
	h /= render->ScaleCoordY(1);

	uidraw->DrawQuad(
		x, y,
		w, h,

		0,
		
		c1,	c2,
		c3,	c4,

		bind_texture,

		xtl, ytl,
		xtr, ytr,

		xbl, ybl,
		xbr, ybr,

		false
	);

	return 0;
}

//gEnv->pRenderer->DrawImageWithUV
LUALIB_FUNCTION(surface, DrawTexturedRectEx)
{
	auto x = my->ToNumber(1) + pos_offset.x;
	auto y = my->ToNumber(2) + pos_offset.y;
	auto w = my->ToNumber(3);
	auto h = my->ToNumber(4);
	
	auto filter = !my->ToBoolean(5);
	
	auto xtl = my->ToNumber(6, 0);
	auto ytl = my->ToNumber(7, 0);
	auto xtr = my->ToNumber(8, 1);
	auto ytr = my->ToNumber(9, 0);

	auto xbl = my->ToNumber(10, 0);
	auto ybl = my->ToNumber(11, 1);
	auto xbr = my->ToNumber(12, 1);
	auto ybr = my->ToNumber(13, 1);

	static float* s = new float[4];
	static float* t = new float[4];

	s[0] = xtl; t[0] = ytl;
	s[1] = xtr; t[1] = ytr;
	s[2] = xbr; t[2] = ybr;
	s[3] = xbl; t[3] = ybl;

	gEnv->pRenderer->DrawImageWithUV(
		x,
		y,

		1.0f,

		w,
		h,

		bind_texture,

		s,
		t,

		bind_color.r,
		bind_color.g,
		bind_color.b,
		bind_color.a
#ifdef CE3
		,filter
#endif
	);

	return 0;
}

#undef DrawText

#ifdef CE3
STextDrawContext GetFontParams(float w, float h)
{
	auto clip_rect = oohh::GetSurfaceClipRect();

	STextDrawContext params;
		params.SetSize(Vec2(w, h));
		params.SetColor(bind_color);

		if (false && clip_rect.x && clip_rect.y && clip_rect.w && clip_rect.h)
		{
			params.EnableClipping(true);
			params.SetClippingRect(clip_rect.x, clip_rect.y, clip_rect.w, clip_rect.h);
		}
	return params;
}
#endif 

LUALIB_FUNCTION(surface, GetTextSize)
{
	auto font = my->ToFont(1);
	auto str = my->ToString(2);
	auto method = my->ToNumber(3, 0);

	if (method == 0)
	{
		float w = 0;
		float h = 0;

		uidraw->GetTextDim(font, &w, &h, 1, 1, str);

		render->ScaleCoord(w, h);

		my->Push(w);
		my->Push(h);

		return 2;
	}
	else if (method == 1)
	{
		STextDrawContext params;
			params.SetSize(Vec2(1,1));
		auto siz = font->GetTextSize(str, true, params);

		my->Push(siz.x);
		my->Push(siz.y);

		return 2;
	}

	return 0;
}

#undef DrawTextEx
LUALIB_FUNCTION(surface, DrawText)
{
	if (!bind_font)
	{
		bind_font = gEnv->pCryFont->GetFont("default");
	}

	auto str = my->ToString(1);

	auto x = my->ToNumber(2) + pos_offset.x;
	auto y = my->ToNumber(3) + pos_offset.y;

	auto size = my->ToVec2(4, Vec2(1,1));

	auto hor = my->ToEnum<EUIDRAWHORIZONTAL>(5, UIDRAWHORIZONTAL_LEFT);
	auto ver = my->ToEnum<EUIDRAWVERTICAL>(6, UIDRAWVERTICAL_TOP);

	auto method = my->ToNumber(7, 0);

	if (method == 0)
	{
		x /= render->ScaleCoordX(1);
		y /= render->ScaleCoordY(1);

		x *= (render->ScaleCoordX(1)/render->ScaleCoordY(1));

		uidraw->DrawTextA(
			bind_font,
			x,y,
			size.x,size.y,
			str,
			bind_color.a,
			bind_color.r,
			bind_color.g,
			bind_color.b,
			UIDRAWHORIZONTAL_LEFT, UIDRAWVERTICAL_TOP,
			hor, ver		
		);
	}
#ifdef CE3
	else if (method == 1)
	{
		uidraw->DrawTextSimple(
			bind_font,
			x,
			y,
			size.x,
			size.y,
			str,
			bind_color,
			hor,
			ver
		);
	}
	else if (method == 2)
	{
		x /= render->ScaleCoordX(1);
		y /= render->ScaleCoordY(1);

		bind_font->DrawString(
			x,
			y,
			str,
			true,
			GetFontParams(size.x, size.y)
		);
	}
#endif
	return 0;
}
#ifdef CE3
LUALIB_FUNCTION(surface, DrawLine)
{
	auto a = my->ToNumber(1) + pos_offset.x;
	auto b = my->ToNumber(2) + pos_offset.y;

	auto x = my->ToNumber(3) + pos_offset.x;
	auto y = my->ToNumber(4) + pos_offset.y;

	uidraw->DrawLine(
		a, 
		b, 
		x, 
		y,
		
		bind_color.pack_argb8888()
	);

	return 0;
}
#endif