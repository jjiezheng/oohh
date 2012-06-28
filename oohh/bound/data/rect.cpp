#include "StdAfx.h"
#include "oohh.hpp"

//standard

LUALIB_FUNCTION(_G, Rect)
{
	if (my->IsNoneOrNil(2) && my->IsNoneOrNil(3) && my->IsNoneOrNil(4))
	{
		auto num = my->ToNumber(1, 0);
		
		my->Push(Rect(num, num, num, num));

		return 1;
	}

	if (my->IsType(1, "vec2") && my->IsType(2, "vec2"))
	{
		auto pos = my->ToVec2(1);
		auto siz = my->ToVec2(2);

		my->Push(Rect(pos.x, pos.y, siz.x, siz.y));

		return 1;
	}
	
	my->Push(Rect(my->ToNumber(1, 0), my->ToNumber(2, 0), my->ToNumber(3, 0), my->ToNumber(4, 0)));

	return 1;
}

LUAMTA_FUNCTION(rect, __tostring)
{
	auto self = my->ToRectPtr(1);

	my->Push(string("").Format("Rect(%f, %f, %f, %f)", self->x, self->y, self->w, self->h));

	return 1;
}

// this defines newindex index and all the operators and such automatically
MMYY_VEC4_TEMPLATE(Rect, Rect, rect, float, cry_powf, f32, x, y, w, h)


LUAMTA_FUNCTION(rect, Shrink)
{
	auto self = my->ToRectPtr(1);
	auto amt = my->ToNumber(2);

	self->x += amt;
	self->y += amt;
	self->w -= amt*2;
	self->h -= amt*2;

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(rect, Expand)
{
	auto self = my->ToRectPtr(1);
	auto amt = -my->ToNumber(2);

	self->x += amt;
	self->y += amt;
	self->w -= amt*2;
	self->h -= amt*2;

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(rect, Center)
{
	auto self = my->ToRectPtr(1);

	self->x -= self->w / 2;
	self->y -= self->h / 2;

	my->PushValue(1);
	
	return 1;
}

LUAMTA_FUNCTION(rect, SetPos)
{
	auto self = my->ToRectPtr(1);

	if (my->IsNumber(2))
	{
		auto num = my->ToNumber(2);

		self->x = num;
		self->y = num;
	}
	else
	{
		auto pos = my->ToVec2Ptr(2);

		self->x = (int)pos->x;
		self->y = (int)pos->y;
	}

	my->PushValue(1);
	
	return 1;
}

LUAMTA_FUNCTION(rect, SetSize)
{
	auto self = my->ToRectPtr(1);

	if (my->IsNumber(2))
	{
		auto num = my->ToNumber(2);

		self->w = num;
		self->h = num;
	}
	else
	{
		auto pos = my->ToVec2Ptr(2);

		self->w = (int)pos->x;
		self->h = (int)pos->y;
	}

	my->PushValue(1);
	
	return 1;
}

LUAMTA_FUNCTION(rect, GetPos)
{
	auto self = my->ToRectPtr(1);
	
	my->Push(Vec2(self->x, self->y));

	return 1;
}

LUAMTA_FUNCTION(rect, GetSize)
{
	auto self = my->ToRectPtr(1);
	
	my->Push(Vec2(self->w, self->h));

	return 1;
}

LUAMTA_FUNCTION(rect, GetPosSize)
{
	auto self = my->ToRectPtr(1);
	
	my->Push(Vec2(self->x + self->w, self->y + self->h));

	return 1;
}

LUAMTA_FUNCTION(rect, GetXW)
{
	auto self = my->ToRectPtr(1);
	
	my->Push(self->x + self->w);

	return 1;
}

LUAMTA_FUNCTION(rect, GetYH)
{
	auto self = my->ToRectPtr(1);
	
	my->Push(self->y + self->h);

	return 1;
}

LUAMTA_FUNCTION(rect, GetUV4)
{
	auto self = my->ToRectPtr(1);
	auto siz = my->ToVec2Ptr(2);

	my->Push(self->x / siz->x);
	my->Push(self->y / siz->y);
	my->Push((self->x + self->w) / siz->x);
	my->Push((self->y + self->h) / siz->y);

	return 4;
}

LUAMTA_FUNCTION(rect, GetUV8)
{
	auto R = my->ToRectPtr(1);
	auto S = my->ToVec2Ptr(2);

	float xtl = R->x;
	float ytl = R->y;
	float xtr = R->x + R->w;
	float ytr = R->y;

	xtl /= S->x; ytl /= S->y;
	xtr /= S->x; ytr /= S->y;

	float xbl = R->x;
	float ybl = R->y + R->h;
	float xbr = R->x + R->w;
	float ybr = R->y + R->h;
	
	xbl /= S->x; ybl /= S->y;
	xbr /= S->x; ybr /= S->y;

	my->Push(xtl); my->Push(ytl);
	my->Push(xtr); my->Push(ytr);

	my->Push(xbl); my->Push(ybl);
	my->Push(xbr); my->Push(ybr);

	return 8;
}

