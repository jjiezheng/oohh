#include "StdAfx.h"
#include "oohh.hpp"

//standard

LUALIB_FUNCTION(_G, Vec2)
{ 
	auto x = my->ToNumber(1, 0);
	if (!NumberValid(x)) x = 0;
	auto y = my->ToNumber(2, 0);
	if (!NumberValid(y)) y = 0;

	my->Push(Vec2(x,y));

	return 1;
}

LUALIB_FUNCTION(_G, Vec2Rand)
{ 
	my->Push(Vec2((float)cry_rand()/1000000, (float)cry_rand()/1000000));

	return 1;
}

LUAMTA_FUNCTION(vec2, __tostring)
{
	auto self = my->ToVec2Ptr(1);
	
	my->Push(string("").Format("Vec2(%f, %f)", self->x, self->y));

	return 1;
}

// this defines newindex index and all the operators and such automatically
MMYY_VEC2_TEMPLATE(Vec2, Vec2, vec2, float, cry_powf, f32, x, y)

LUAMTA_FUNCTION(vec2, Area)
{
	auto self = my->ToVec2Ptr(1);
	
	self->area();

	my->PushValue(1);

	return 1;
}	

LUAMTA_FUNCTION(vec2, GetAtan2)
{
	auto self = my->ToVec2Ptr(1);
	
	self->atan2();

	return 1;
}

LUAMTA_FUNCTION(vec2, Cross)
{
	auto self = my->ToVec2Ptr(1);
	
	self->Cross(my->ToVec2(2));

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec2, Dot)
{
	auto self = my->ToVec2Ptr(1);
	
	self->Dot(my->ToVec2(2));

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec2, GetLength)
{
	auto self = my->ToVec2Ptr(1);
	
	my->Push(self->GetLength());

	return 1;
}

LUAMTA_FUNCTION(vec2, GetLength2)
{
	auto self = my->ToVec2Ptr(1);
	
	my->Push(self->GetLength2());

	return 1;
}

LUAMTA_FUNCTION(vec2, Rotate90DegCCW)
{
	auto self = my->ToVec2Ptr(1);
	
	self->rot90ccw();

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec2, Rotate90DegCW)
{
	auto self = my->ToVec2Ptr(1);
	
	self->rot90cw();

	my->PushValue(1);

	return 1;
}


LUAMTA_FUNCTION(vec2, Flip)
{
	auto self = my->ToVec2Ptr(1);
	
	self->flip();

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec2, Normalize)
{
	auto self = my->ToVec2Ptr(1);
	
	self->Normalize();

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec2, Perp)
{
	auto self = my->ToVec2Ptr(1);
	
	self->Perp();

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec2, ToWorld)
{
	auto self = my->ToVec2(1);

	float x, y, z;

	gEnv->pRenderer->UnProjectFromScreen
	(
		self.x, 
		gEnv->pRenderer->GetHeight() - self.y, 

		0.0f, 
		
		&x, 
		&y, 
		&z
	);

	my->Push((Vec3(x, y, z) -  gEnv->pSystem->GetViewCamera().GetPosition()).GetNormalizedSafe());

	return 1;
}