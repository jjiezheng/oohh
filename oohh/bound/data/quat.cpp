#include "StdAfx.h"
#include "oohh.hpp"

LUALIB_FUNCTION(_G, Quat)
{
	if (my->IsNil(1))
	{
		my->Push(Quat());

		return 1;
	}

	auto num = my->ToNumber(1, 0);
	auto vec = my->ToVec3(2, Vec3(0,0,0));

	my->Push(Quat(num, vec.x, vec.y, vec.z));

	return 1;
}

LUAMTA_FUNCTION(quat, GetAng3)
{
	auto self = my->ToQuatPtr(1);

	my->Push(Ang3(*self));

	return 1;
}

LUAMTA_FUNCTION(quat, Lerp)
{
	auto self = my->ToQuatPtr(1);

	my->Push(self->CreateNlerp(*self, my->ToQuat(2), my->ToNumber(3)));

	return 1;
}

LUAMTA_FUNCTION(quat, SetVec3Rotation)
{
	auto self = my->ToQuatPtr(1);

	self->SetRotationVDir(my->ToVec3(2), my->ToNumber(3));

	return 0;
}

LUAMTA_FUNCTION(quat, SetAng3Rotation)
{
	auto self = my->ToQuatPtr(1);

	self->SetRotationXYZ(my->ToAng3(2));

	return 1;
}

LUAMTA_FUNCTION(quat, GetLength)
{
	auto self = my->ToQuatPtr(1);

	my->Push(self->GetLength());

	return 1;
}

LUAMTA_FUNCTION(quat, GetNormalized)
{
	auto self = my->ToQuatPtr(1);

	my->Push(self->GetNormalized());

	return 1;
}

LUAMTA_FUNCTION(quat, GetColumn0)
{
	auto self = my->ToQuatPtr(1);

	my->Push(self->GetColumn0());

	return 1;
}


LUAMTA_FUNCTION(quat, GetColumn1)
{
	auto self = my->ToQuatPtr(1);

	my->Push(self->GetColumn1());

	return 1;
}

LUAMTA_FUNCTION(quat, GetColumn2)
{
	auto self = my->ToQuatPtr(1);

	my->Push(self->GetColumn2());

	return 1;
}

LUAMTA_FUNCTION(quat, GetZRotation)
{
	auto self = my->ToQuatPtr(1);

	my->Push(self->GetRotZ());

	return 1;
}

LUAMTA_FUNCTION(quat, __tostring)
{
	auto self = my->ToQuatPtr(1);

	my->Push(string("").Format("Quat(%f, Vec3(%f, %f, %f))", self->w, self->v.x, self->v.y, self->v.z));

	return 1;
}

LUAMTA_FUNCTION(quat, __eq)
{
	auto a = my->ToQuatPtr(1);
	auto b = my->ToQuatPtr(2);

	my->Push(a == b);

	return 1;
}

LUAMTA_FUNCTION(quat, __newindex)
{
	auto self = my->ToQuatPtr(1);

	string key = my->ToString(2);

	if (key == "v")
	{
		my->Push(self->v == my->ToVec3(3));
		return 1;
	}
	else
	if (key == "w")
	{
		my->Push(self->w == (f32)my->ToNumber(3));

		return 1;
	}

	return 0;
}

LUAMTA_FUNCTION(quat, __index)
{
	auto self = my->ToQuatPtr(1);
	string key = my->ToString(2);

	lua_getmetatable(L, 1);
	my->Push(key);

	if (my->RawGet(-2) != LUA_TNIL) return 1;

	my->Remove(-1);

	if (key == "w")
	{
		my->Push(self->w);
		return 1;
	}
	else
	if (key == "v")
	{
		my->Push(self->v);
		return 1;
	}

	return 0;
}

LUAMTA_FUNCTION(quat, __unm)
{
	auto self = my->ToQuatPtr(1);

	my->Push(self->GetInverted());

	return 1;
}
