#include "StdAfx.h"
#include "oohh.hpp"

LUALIB_FUNCTION(_G, Matrix33)
{
	auto matrix = Matrix33();

	my->Push(matrix);

	return 1;
}

LUAMTA_FUNCTION(matrix33, Invert)
{
	auto self = my->ToMatrix33Ptr(1);

	self->Invert();

	return 1;
}

LUAMTA_FUNCTION(matrix33, GetInverted)
{
	auto self = my->ToMatrix33Ptr(1);

	my->Push(self->GetInverted());

	return 1;
}

LUAMTA_FUNCTION(matrix33, CreateOrthogonalBase)
{
	auto self = my->ToMatrix33Ptr(1);

	my->Push(self->CreateOrthogonalBase(my->ToVec3(2)));

	return 1;
}

LUAMTA_FUNCTION(matrix33, CreateRotationVDir)
{
	auto self = my->ToMatrix33Ptr(1);

	my->Push(self->CreateRotationVDir(my->ToVec3(2)));

	return 1;
}

LUAMTA_FUNCTION(matrix33, CreateRotationXYZ)
{
	auto self = my->ToMatrix33Ptr(1);

	my->Push(self->CreateRotationXYZ(my->ToAng3(2)));

	return 1;
}
LUAMTA_FUNCTION(matrix33, Adjoint)
{
	auto self = my->ToMatrix33Ptr(1);

	self->Adjoint();

	return 1;
}

LUAMTA_FUNCTION(matrix33, SetRotationX)
{
	auto self = my->ToMatrix33Ptr(1);

	self->SetRotationX(my->ToNumber(2));

	return 1;
}

LUAMTA_FUNCTION(matrix33, SetRotationY)
{
	auto self = my->ToMatrix33Ptr(1);

	self->SetRotationY(my->ToNumber(2));

	return 1;
}

LUAMTA_FUNCTION(matrix33, SetRotationZ)
{
	auto self = my->ToMatrix33Ptr(1);

	self->SetRotationZ(my->ToNumber(2));

	return 1;
}

LUAMTA_FUNCTION(matrix33, SetRotation)
{
	auto self = my->ToMatrix33Ptr(1);

	self->SetRotationXYZ(my->ToAng3(2));

	return 1;
}