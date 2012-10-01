#include "StdAfx.h"
#include "oohh.hpp"

LUALIB_FUNCTION(_G, AABB)
{ 
	if (my->IsNumber(1))
		my->Push(AABB(my->ToNumber(1)));

	if (my->IsVec3(1))
		my->Push(AABB(my->ToVec3(1), my->ToVec3(2)));

	return 1;
}

LUAMTA_FUNCTION(entity, GetLocalBounds)
{
	auto self = my->ToEntity(1);

	AABB out;

	self->GetLocalBounds(out);

	my->Push(out);

	return 1;
}

LUAMTA_FUNCTION(entity, GetWorldBounds)
{
	auto self = my->ToEntity(1);

	AABB out;

	self->GetWorldBounds(out);

	my->Push(out);

	return 1;
}

LUAMTA_FUNCTION(aabb, Add)
{
	auto self = my->ToAABBPtr(1);
	self->Add(my->ToAABB(2));

	return 0;
}

LUAMTA_FUNCTION(aabb, Augment)
{
	auto self = my->ToAABBPtr(1);
	self->Augment(my->ToAABB(2));

	return 0;
}

LUAMTA_FUNCTION(aabb, Expand)
{
	auto self = my->ToAABBPtr(1);
	self->Expand(my->ToVec3(2));

	return 0;
}

LUAMTA_FUNCTION(aabb, GetCenter)
{
	auto self = my->ToAABBPtr(1);
	my->Push(self->GetCenter());

	return 1;
}

LUAMTA_FUNCTION(aabb, GetDistance)
{
	auto self = my->ToAABBPtr(1);
	my->Push(self->GetDistance(my->ToVec3(2)));

	return 1;
}

LUAMTA_FUNCTION(aabb, GetRadius)
{
	auto self = my->ToAABBPtr(1);
	my->Push(self->GetRadius());

	return 1;
}

LUAMTA_FUNCTION(aabb, GetSize)
{
	auto self = my->ToAABBPtr(1);
	my->Push(self->GetSize());

	return 1;
}

LUAMTA_FUNCTION(aabb, GetVolume)
{
	auto self = my->ToAABBPtr(1);
	my->Push(self->GetVolume());

	return 1;
}

LUAMTA_FUNCTION(aabb, IsContainPoint)
{
	auto self = my->ToAABBPtr(1);
	my->Push(self->IsContainPoint(my->ToVec3(2)));

	return 1;
}

LUAMTA_FUNCTION(aabb, IsContainSphere)
{
	auto self = my->ToAABBPtr(1);
	my->Push(self->IsContainSphere(my->ToVec3(2), my->ToNumber(3)));

	return 1;
}

LUAMTA_FUNCTION(aabb, SetMin)
{
	auto self = my->ToAABBPtr(1);
	self->min = my->ToVec3(2);

	return 0;
}

LUAMTA_FUNCTION(aabb, SetMax)
{
	auto self = my->ToAABBPtr(1);
	self->max = my->ToVec3(2);

	return 0;
}

LUAMTA_FUNCTION(aabb, GetMin)
{
	auto self = my->ToAABBPtr(1);
	my->Push(self->min);

	return 1;
}

LUAMTA_FUNCTION(aabb, GetMax)
{
	auto self = my->ToAABBPtr(1);
	my->Push(self->max);

	return 1;
}

LUAMTA_FUNCTION(aabb, Move)
{
	auto self = my->ToAABBPtr(1);
	self->Move(my->ToVec3(2));

	return 0;
}