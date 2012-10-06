#include "StdAfx.h"
#include "oohh.hpp"

LUALIB_FUNCTION(_G, Matrix44)
{
	auto matrix = Matrix44();

	my->Push(matrix);

	return 1;
}

LUAMTA_FUNCTION(matrix44, Invert)
{
	auto self = my->ToMatrix44Ptr(1);

	self->Invert();

	return 1;
}

LUAMTA_FUNCTION(matrix44, GetTranslation)
{
	auto self = my->ToMatrix44Ptr(1);

	my->Push(self->GetTranslation());

	return 1;
}

LUAMTA_FUNCTION(matrix44, Multiply)
{
	auto self = my->ToMatrix44(1);

	self.Multiply(self, my->ToMatrix44(2));

	my->Push(self);

	return 1;
}

LUAMTA_FUNCTION(matrix44, SetTranslation)
{
	auto self = my->ToMatrix44Ptr(1);

	self->SetTranslation(my->ToVec3(2));

	return 1;
}

LUAMTA_FUNCTION(matrix44, Transpose)
{
	auto self = my->ToMatrix44Ptr(1);

	self->Transpose(my->ToMatrix34(2));

	return 1;
}

LUAMTA_FUNCTION(matrix44, TransformPoint)
{
	auto self = my->ToMatrix44Ptr(1);

	my->Push(self->TransformPoint(my->ToVec3(3)));

	return 1;
}

LUAMTA_FUNCTION(matrix44, TransformVector)
{
	auto self = my->ToMatrix44Ptr(1);

	my->Push(self->TransformVector(my->ToVec3(3)));

	return 1;
}