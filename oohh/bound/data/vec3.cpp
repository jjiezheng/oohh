#include "StdAfx.h"
#include "oohh.hpp"

//standard

LUALIB_FUNCTION(_G, Vec3)
{ 
	auto x = my->ToNumber(1, 0);
	if (!NumberValid(x)) x = 0;
	auto y = my->ToNumber(2, 0);
	if (!NumberValid(y)) y = 0;
	auto z = my->ToNumber(3, 0);
	if (!NumberValid(z)) z = 0;
	
	my->Push(Vec3(x,y,z));

	return 1;
}

LUALIB_FUNCTION(_G, Vec3Rand)
{ 
	auto vec = Vec3(1,1,1);
	vec.SetRandomDirection();
	my->Push(vec);

	return 1;
}

LUAMTA_FUNCTION(vec3, __tostring)
{
	auto self = my->ToVec3Ptr(1);
	
	my->Push(string("").Format("Vec3(%f, %f, %f)", self->x, self->y, self->z));

	return 1;
}

// this defines newindex index and all the operators and such automatically
MMYY_VEC3_TEMPLATE(Vec3, Vec3, vec3, f32, cry_powf, f32, x, y, z)

LUAMTA_FUNCTION(vec3, GetAng3)
{
	auto self = my->ToVec3Ptr(1);
	
	my->Push(Ang3(*self));

	return 1;
}

LUAMTA_FUNCTION(vec3, GetQuat)
{
	auto self = my->ToVec3Ptr(1);
	
	my->Push(Quat(Ang3(*self)));

	return 1;
}

LUAMTA_FUNCTION(vec3, IsUnit)
{
	auto self = my->ToVec3Ptr(1);
	
	my->Push(self->IsUnit(my->ToNumber(2, VEC_EPSILON)));

	return 1;
}

LUAMTA_FUNCTION(vec3, __len)
{
	auto self = my->ToVec3Ptr(1);
	
	my->Push(self->GetLength());

	return 1;
}

LUAMTA_FUNCTION(vec3, GetLength)
{
	auto self = my->ToVec3Ptr(1);
	
	my->Push(self->GetLength());

	return 1;
}

LUAMTA_FUNCTION(vec3, GetLengthFast)
{
	auto self = my->ToVec3Ptr(1);
	
	my->Push(self->GetLengthFast());

	return 1;
}

LUAMTA_FUNCTION(vec3, GetOrthogonal)
{
	auto self = my->ToVec3Ptr(1);
	
	my->Push(self->GetOrthogonal());

	return 1;
}

LUAMTA_FUNCTION(vec3, GetPermutated)
{
	auto self = my->ToVec3Ptr(1);
	
	my->Push(self->GetPermutated(my->ToNumber(2)));

	return 1;
}

LUAMTA_FUNCTION(vec3, GetRotated)
{
	auto self = my->ToVec3Ptr(1);
	
	my->Push(self->GetRotated(my->ToVec3(2), my->ToNumber(3)));

	return 1;
}

LUAMTA_FUNCTION(vec3, GetVolume)
{
	auto self = my->ToVec3Ptr(1);
	
	my->Push(self->GetVolume());

	return 1;
}

LUAMTA_FUNCTION(vec3, SetReflection)
{
	auto self = my->ToVec3Ptr(1);
	
	self->SetReflection(my->ToVec3(2), my->ToVec3(3));

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec3, SetProjection)
{
	auto self = my->ToVec3Ptr(1);
	
	self->SetProjection(my->ToVec3(2), my->ToVec3(3));

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec3, SetOrthogonal)
{
	auto self = my->ToVec3Ptr(1);
	
	self->SetOrthogonal(my->ToVec3(2));

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec3, SetSlerp)
{
	auto self = my->ToVec3Ptr(1);
	
	self->SetLerp(my->ToVec3(1), my->ToVec3(2), my->ToNumber(3));

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec3, NormalizeFast)
{
	auto self = my->ToVec3Ptr(1);
	
	self->NormalizeFast();

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec3, Normalize)
{
	auto self = my->ToVec3Ptr(1);
	
	self->Normalize();

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec3, Abs)
{
	auto self = my->ToVec3Ptr(1);
	
	self->abs();

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec3, ClampLength)
{
	auto self = my->ToVec3Ptr(1);
	
	self->ClampLength(my->ToNumber(2));

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec3, Cross)
{
	auto self = my->ToVec3Ptr(1);
	
	if (my->IsVec2(2))
	{
		self->Cross(my->ToVec2(2));
	}
#ifdef CE3
	else
	{
		self->cross(my->ToVec3(2));
	}
#endif

	my->PushValue(1);

	return 1;
}

LUAMTA_FUNCTION(vec3, Dot)
{
	auto self = my->ToVec3Ptr(1);
	
	my->Push(self->Dot(my->ToVec3(2)));

	return 1;
}

LUAMTA_FUNCTION(vec3, Flip)
{
	auto self = my->ToVec3Ptr(1);
	
	self->Flip();

	my->PushValue(1);

	return 1;
}