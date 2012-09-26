#include "StdAfx.h"
#include "oohh.hpp"

#include "cairo/cairo.h" 

LUALIB_FUNCTION(_G, Cairo)
{
	auto self = new Cairo(my->ToNumber(1), my->ToNumber(2));

	auto size = (self->m_w * self->m_h) * 4;
	self->m_buffer = new unsigned char[size];

	/*for (int i = 0;i <= size; i++)
	{
		self->m_buffer[i] = 0;
	}*/

	self->m_surface = cairo_image_surface_create_for_data(
		self->m_buffer, 
		CAIRO_FORMAT_ARGB32, 
		self->m_w, 
		self->m_h, 
		cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, self->m_w)
	);

	self->m_cairo = cairo_create(self->m_surface);

	my->Push(self);
	
	return 1;
}

LUAMTA_FUNCTION(cairo, Remove)
{
	auto self = my->ToCairo(1);

	cairo_destroy(self->m_cairo);
	cairo_surface_destroy(self->m_surface);

	my->MakeNull(self);

	return 0;
}

LUAMTA_FUNCTION(cairo, Status)
{
	auto self = my->ToCairo(1);
	auto status = cairo_status(self->m_cairo);

	my->Push(cairo_status_to_string(status));

	return 1;
}

LUAMTA_FUNCTION(cairo, Flush)
{
	auto self = my->ToCairo(1);
	
	cairo_surface_flush(self->m_surface);

	return 0;
}

LUAMTA_FUNCTION(cairo, MarkDirty)
{
	auto self = my->ToCairo(1);
	
	cairo_surface_mark_dirty(self->m_surface);

	return 0;
}

LUAMTA_FUNCTION(cairo, SetOperator)
{
	auto self = my->ToCairo(1);
	
	cairo_set_operator(self->m_cairo, my->ToEnum<cairo_operator_t>(2));

	return 0;
}

LUAMTA_FUNCTION(cairo, Paint)
{
	auto self = my->ToCairo(1);
	
	cairo_paint(self->m_cairo);

	return 0;
}

LUAMTA_FUNCTION(cairo, PaintWithAlpha)
{
	auto self = my->ToCairo(1);
	
	cairo_paint_with_alpha(self->m_cairo, my->ToNumber(2, 0));

	return 0;
}


LUAMTA_FUNCTION(cairo, UpdateTexture)
{
	auto self = my->ToCairo(1);
	auto tex = my->ToTexture(2);
	auto rect = my->ToRect(3, Rect(0,0, tex->GetWidth(), tex->GetHeight()));
	
	gEnv->pRenderer->UpdateTextureInVideoMemory(
		tex->GetTextureID(), 
		self->m_buffer, 
		rect.x, 
		rect.y, 
		rect.w,
		rect.h, 
		my->ToEnum<ETEX_Format>(4, eTF_A8R8G8B8)
	);

	return 0;
}

LUAMTA_FUNCTION(cairo, SetImage)
{
	auto self = my->ToCairo(1);
	auto image = cairo_image_surface_create_from_png(my->ToString(2));
	auto w = cairo_image_surface_get_width (image);
	auto h = cairo_image_surface_get_height (image);

	self->m_surface = image;

	cairo_set_source_surface(self->m_cairo, image, my->ToNumber(3, 0), my->ToNumber(4, 0));

	my->Push(w);
	my->Push(h);

	return 2;
}

LUAMTA_FUNCTION(cairo, SelectFontFace)
{
	auto self = my->ToCairo(1);

	cairo_select_font_face(self->m_cairo, my->ToString(2), my->ToEnum<cairo_font_slant_t>(3, CAIRO_FONT_SLANT_NORMAL), my->ToEnum<cairo_font_weight_t>(4, CAIRO_FONT_WEIGHT_NORMAL));

	return 0;
}

LUAMTA_FUNCTION(cairo, SetFontSize)
{
	auto self = my->ToCairo(1);
	cairo_set_font_size(self->m_cairo, my->ToNumber(2));

	return 0;
}

LUAMTA_FUNCTION(cairo, TextExtents)
{
	auto self = my->ToCairo(1);
	
	cairo_text_extents_t extents;
	cairo_text_extents(self->m_cairo, my->ToString(2), &extents);

	my->Push(extents.width);
	my->Push(extents.height);

	return 2;
}

LUAMTA_FUNCTION(cairo, ShowText)
{
	auto self = my->ToCairo(1);
	cairo_show_text(self->m_cairo, my->ToString(2));

	return 0;
}

LUAMTA_FUNCTION(cairo, NewPath)
{
	auto self = my->ToCairo(1);
	cairo_new_path(self->m_cairo);

	return 0;
}

LUAMTA_FUNCTION(cairo, NewSubPath)
{
	auto self = my->ToCairo(1);
	cairo_new_sub_path(self->m_cairo);

	return 0;
}

LUAMTA_FUNCTION(cairo, SetLineWidth)
{
	auto self = my->ToCairo(1);
	cairo_set_line_width(self->m_cairo, my->ToNumber(2));

	return 0;
}

LUAMTA_FUNCTION(cairo, SetLineCap)
{
	auto self = my->ToCairo(1);
	cairo_set_line_cap(self->m_cairo, my->ToEnum<cairo_line_cap_t>(2));

	return 0;
}

LUAMTA_FUNCTION(cairo, SetLineJoin)
{
	auto self = my->ToCairo(1);
	cairo_set_line_join(self->m_cairo, my->ToEnum<cairo_line_join_t>(2));

	return 0;
}

LUAMTA_FUNCTION(cairo, SetSourceRGBA)
{
	auto self = my->ToCairo(1);
	cairo_set_source_rgba(self->m_cairo, my->ToNumber(2), my->ToNumber(3), my->ToNumber(4), my->ToNumber(5));
	
	return 0;
}

LUAMTA_FUNCTION(cairo, Rectangle)
{
	auto self = my->ToCairo(1);
	cairo_rectangle(self->m_cairo, my->ToNumber(2), my->ToNumber(3), my->ToNumber(4), my->ToNumber(5));

	return 0;
}

LUAMTA_FUNCTION(cairo, Arc)
{
	auto self = my->ToCairo(1);
	cairo_arc(self->m_cairo, my->ToNumber(2), my->ToNumber(3), my->ToNumber(4), my->ToNumber(5), my->ToNumber(6));

	return 0;
}

LUAMTA_FUNCTION(cairo, Clip)
{
	auto self = my->ToCairo(1);
	cairo_clip(self->m_cairo);

	return 0;
}

LUAMTA_FUNCTION(cairo, Fill)
{
	auto self = my->ToCairo(1);
	cairo_fill(self->m_cairo);

	return 0;
}

LUAMTA_FUNCTION(cairo, FillPreserve)
{
	auto self = my->ToCairo(1);
	cairo_fill_preserve(self->m_cairo);

	return 0;
}

LUAMTA_FUNCTION(cairo, Stroke)
{
	auto self = my->ToCairo(1);
	cairo_stroke(self->m_cairo);

	return 0;
}

LUAMTA_FUNCTION(cairo, MoveTo)
{
	auto self = my->ToCairo(1);
	cairo_move_to(self->m_cairo, my->ToNumber(2), my->ToNumber(3));

	return 0;
}

LUAMTA_FUNCTION(cairo, LineTo)
{
	auto self = my->ToCairo(1);
	cairo_line_to(self->m_cairo, my->ToNumber(2), my->ToNumber(3));

	return 0;
}

LUAMTA_FUNCTION(cairo, CurveTo)
{
	auto self = my->ToCairo(1);
	cairo_curve_to(self->m_cairo, my->ToNumber(2), my->ToNumber(3), my->ToNumber(4), my->ToNumber(5), my->ToNumber(6), my->ToNumber(7));

	return 0;
}

LUAMTA_FUNCTION(cairo, ClosePath)
{
	auto self = my->ToCairo(1);
	cairo_close_path(self->m_cairo);

	return 0;
}