#include "StdAfx.h"
#include "oohh.hpp"

LUAMTA_FUNCTION(entity, GetPhysics)
{
	auto self = my->ToEntity(1);

	if (self->IsGarbage() || !(IEntityPhysicalProxy *)self->GetProxy(ENTITY_PROXY_PHYSICS))
		return 0;
	
	my->Push(self->GetPhysics());
	
	return 1;
}

LUAMTA_FUNCTION(physics, IsValid)
{
	auto phys = my->ToPhysics(1);

	if (phys == nullptr)
	{
		my->Push(false);

		return 1;
	}

	auto ent = gEnv->pEntitySystem->GetEntityFromPhysics(phys);

	if (ent == nullptr || ent->IsGarbage())
	{
		my->Push(false);

		return 1;
	}

	my->Push(true);

	return 1;
}


LUAMTA_FUNCTION(entity, EnablePhysics)
{
	my->ToEntity(1)->EnablePhysics(my->ToBoolean(2));

	return 0;
}

LUAMTA_FUNCTION(entity, Physicialize)
{
	auto self = my->ToEntity(1);

	SEntityPhysicalizeParams params;
		params.type = my->ToNumber(2);
		params.nSlot = my->ToNumber(3, -1);
	self->Physicalize(params);
	
	my->Push(self->GetPhysics());

	return 1;
}

LUAMTA_FUNCTION(physics, StepBack)
{
	my->ToPhysics(1)->StepBack(my->ToNumber(2, (float)0));

	return 0;
}

LUAMTA_FUNCTION(physics, AddAngleVelocity)
{
	pe_action_impulse params;
		params.iApplyTime = 2;
		params.angImpulse = my->ToVec3(2);
		params.point = my->ToVec3(3, params.point);
		params.ipart = my->ToNumber(4, params.ipart);
	my->ToPhysics(1)->Action(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, AddVelocity)
{
	auto self = my->ToPhysics(1);
	pe_action_impulse params;
		params.iApplyTime = 2;
		params.impulse = my->ToVec3(2);
		params.point = my->ToVec3(3, params.point);
		params.ipart = my->ToNumber(4, params.ipart);
	self->Action(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, SetAngleVelocity)
{
	pe_action_set_velocity params;
		params.v = my->ToVec3(2);
		params.w = my->ToVec3(3, params.w);
		params.ipart = my->ToNumber(4, params.ipart);
#ifdef CE3
		params.bRotationAroundPivot = 1;
#endif
	my->ToPhysics(1)->Action(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, GetAngleVelocity)
{
	pe_status_dynamics params;
		my->ToPhysics(1)->GetStatus(&params);
	my->Push(params.w);

	return 1;
}

LUAMTA_FUNCTION(physics, SetVelocity)
{
	pe_action_set_velocity params;
		params.v = my->ToVec3(2);
		params.w = my->ToVec3(3, params.w);
		params.ipart = my->ToNumber(4, params.ipart);
#ifdef CE3
		params.bRotationAroundPivot = 0;
#endif
	my->ToPhysics(1)->Action(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, GetVelocity)
{
	pe_status_dynamics params;
		my->ToPhysics(1)->GetStatus(&params);
	my->Push(params.v);

	return 1;
}

/*LUAMTA_FUNCTION(physics, SetAngularSoftness)
{
	pe_simulation_params params;
		params.softnessAngular = my->ToNumber(2);
	my->ToPhysics(1)->SetParams(&params);

	return 0;
}

/*LUAMTA_FUNCTION(physics, GetAngularSoftness)
{
	pe_simulation_params params;
		my->ToPhysics(1)->GetParams(&params);
	my->Push(params.softnessAngular);

	return 1;
}

LUAMTA_FUNCTION(physics, SetSoftness)
{
	pe_simulation_params params;
		params.softness = my->ToNumber(2);
	my->ToPhysics(1)->SetParams(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, GetSoftness)
{
	pe_simulation_params params;
		my->ToPhysics(1)->GetParams(&params);
	my->Push(params.softness);

	return 1;
}*/

LUAMTA_FUNCTION(physics, SetDensity)
{
	pe_simulation_params params;
		params.density = my->ToNumber(2);
	my->ToPhysics(1)->SetParams(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, GetDensity)
{
	pe_simulation_params params;
		my->ToPhysics(1)->GetParams(&params);
	my->Push(params.density);

	return 1;
}

LUAMTA_FUNCTION(physics, SetDamping)
{
	pe_simulation_params params;
		params.damping = my->ToNumber(2);
	my->ToPhysics(1)->SetParams(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, GetDamping)
{
	pe_simulation_params params;
		my->ToPhysics(1)->GetParams(&params);
	my->Push(params.damping);

	return 1;
}

LUAMTA_FUNCTION(physics, SetMass)
{
	pe_simulation_params params;
		params.mass = my->ToNumber(2);
	my->ToPhysics(1)->SetParams(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, GetMass)
{
	pe_simulation_params params;
		my->ToPhysics(1)->GetParams(&params);
	my->Push(params.mass);

	return 1;
}

LUAMTA_FUNCTION(physics, SetPos)
{
	pe_params_pos params;
		params.pos = my->ToVec3(2);
	my->ToPhysics(1)->SetParams(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, GetPos)
{
	pe_status_pos params;
		my->ToPhysics(1)->GetStatus(&params);
	my->Push(params.pos);

	return 1;
}

LUAMTA_FUNCTION(physics, SetRotation)
{
	pe_params_pos params;
		params.q = my->ToQuat(2);
	my->ToPhysics(1)->SetParams(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, GetRotation)
{
	pe_status_pos params;
		my->ToPhysics(1)->GetStatus(&params);
	my->Push(params.q);

	return 1;
}

LUAMTA_FUNCTION(physics, GetEntity)
{
	auto phys = my->ToPhysics(1);

	if (phys == nullptr) return 0;

	auto ent = gEnv->pEntitySystem->GetEntityFromPhysics(phys);

	if (ent == nullptr || ent->IsGarbage()) return 0;

	my->Push(ent);

	return 1;
}
