#include "StdAfx.h"
#include "oohh.hpp"

typedef ColorF Color;

LUALIB_FUNCTION(_G, Color)
{
	my->Push(Color(my->ToNumber(1, 0), my->ToNumber(2, 0), my->ToNumber(3, 0), my->ToNumber(4, 1)));

	return 1;
}

LUAMTA_FUNCTION(color, __tostring)
{
	auto self = my->ToColorPtr(1);

	my->Push(string("").Format("Color(%f, %f, %f, %f)", self->r, self->g, self->b, self->a));

	return 1;
}

// this defines newindex index and all the operators and such automatically
// we normally don't want to edit the alpha. hmm
MMYY_VEC4_TEMPLATE(Color, Color, color, float, cry_powf, f32, r, g, b, a)