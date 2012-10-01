#include "StdAfx.h"
#include "oohh.hpp"

//standard

LUALIB_FUNCTION(_G, Ang3)
{ 
	if (my->IsQuat(1))
	{
		my->Push(Ang3(my->ToQuat(1)));
	}
	else
	{
		auto x = my->ToNumber(1, 0);
		if (!NumberValid(x)) x = 0;
		auto y = my->ToNumber(2, 0);
		if (!NumberValid(y)) y = 0;
		auto z = my->ToNumber(3, 0);
		if (!NumberValid(z)) z = 0;

		my->Push(Ang3(x, y, z));
	}
	
	return 1;
}

LUAMTA_FUNCTION(ang3, __tostring)
{
	auto self = my->ToAng3Ptr(1);
	
	my->Push(string("").Format("Ang3(%f, %f, %f)", self->x, self->y, self->z));

	return 1;
}

// this defines newindex index and all the operators and such automatically
MMYY_VEC3_TEMPLATE(Ang3, Ang3, ang3, f32, cry_powf, f32, x, y, z)


LUAMTA_FUNCTION(ang3, GetQuat)
{
	auto self = my->ToAng3Ptr(1);
	
	my->Push(Quat(*self));

	return 1;
}

LUAMTA_FUNCTION(ang3, GetMatrix33)
{
	auto self = my->ToAng3(1);
	
	my->Push(Matrix33(self));

	return 1;
}

LUAMTA_FUNCTION(ang3, IsInRangePI)
{
	auto self = my->ToAng3Ptr(1);
	
	my->Push(self->IsInRangePI());

	return 1;
}

LUAMTA_FUNCTION(ang3, GetRight)
{
	auto a = my->ToAng3Ptr(1);
	
	my->Push(Vec3(
		cos(a->z) * cos(a->y),
		sin(a->z) * cos(a->y),
	   -sin(a->y)
	));

	return 1;
}

LUAMTA_FUNCTION(ang3, GetForward)
{
	auto a = my->ToAng3Ptr(1);

	my->Push(Vec3(
	   -sin(a->z) * cos(a->x) + cos(a->z) * sin(a->y) * sin(a->x),
		cos(a->z) * cos(a->x) + sin(a->z) * sin(a->y) * sin(a->x),
		cos(a->y) * sin(a->x)
	));

	return 1;
}

LUAMTA_FUNCTION(ang3, GetUp)
{
	auto a = my->ToAng3Ptr(1);

	my->Push(Vec3(
		sin(a->z) * sin(a->x) + cos(a->z) * sin(a->y) * cos(a->x),
	   -cos(a->z) * sin(a->x) + sin(a->z) * sin(a->y) * cos(a->x),
		cos(a->y) * cos(a->x)
	));

	return 1;
}

