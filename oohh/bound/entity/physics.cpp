#include "StdAfx.h"
#include "oohh.hpp"

LUAMTA_FUNCTION(entity, GetPhysics)
{
	auto self = my->ToEntity(1);

	if (self->IsGarbage() || !(IEntityPhysicalProxy *)self->GetProxy(ENTITY_PROXY_PHYSICS))
	{
		my_pushnull(L);
		return 1;
	}
	
	my->Push(self->GetPhysics());
	
	return 1;
}

LUAMTA_FUNCTION(physics, IsValid)
{
	auto phys = my->ToPhysics(1);

	my->Push(phys != nullptr);

	return 1;
}

LUAMTA_FUNCTION(entity, EnablePhysics)
{
	my->ToEntity(1)->EnablePhysics(my->ToBoolean(2));

	return 0;
}

LUAMTA_FUNCTION(entity, Physicalize)
{
	auto self = my->ToEntity(1);

	SEntityPhysicalizeParams params;
		params.type = my->ToNumber(2);
		params.mass = my->ToNumber(3, 1);
		params.nSlot = my->ToNumber(4, -1);
	self->Physicalize(params);
	
	my->Push(self->GetPhysics());

	return 1;
}

LUAMTA_FUNCTION(physics, Wake)
{
	pe_action_awake action;
	action.bAwake = !my->ToBoolean(2);
	my->ToPhysics(1)->Action(&action);

	return 0;
}

LUAMTA_FUNCTION(physics, StepBack)
{
	my->ToPhysics(1)->StepBack(my->ToNumber(2, (float)0));

	return 0;
}

LUAMTA_FUNCTION(physics, AddAngleVelocity)
{
	pe_action_impulse params;
		params.iApplyTime = 0;
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
		params.iApplyTime = 0;
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
		params.bRotationAroundPivot = 1;
	my->ToPhysics(1)->Action(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, SetVelocity)
{
	pe_action_set_velocity params;
 		params.v = my->ToVec3(2);
		params.w = my->ToVec3(3, params.w);
		params.ipart = my->ToNumber(4, params.ipart);
		params.bRotationAroundPivot = 0;
	my->ToPhysics(1)->Action(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, GetAngleVelocity)
{
	pe_status_dynamics params;
		int err = my->ToPhysics(1)->GetStatus(&params);
	my->Push(err ? Vec3(0,0,0) : params.w);

	return 1;
}

LUAMTA_FUNCTION(physics, GetVelocity)
{
	pe_status_dynamics params;
		int err = my->ToPhysics(1)->GetStatus(&params);
	my->Push(err ? Vec3(0,0,0) : params.v);

	return 1;
}

LUAMTA_FUNCTION(physics, Reset)
{
	pe_action_reset params;
		params.bClearContacts = my->ToBoolean(2) ? 0 : 1;
	my->ToPhysics(1)->Action(&params);

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
		int err = my->ToPhysics(1)->GetParams(&params);
	my->Push(err ? 0 : params.density);

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
		int err = my->ToPhysics(1)->GetParams(&params);
	my->Push(err ? 0 : params.damping);

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
		int err = my->ToPhysics(1)->GetParams(&params);
	my->Push(err ? 1 : params.mass);

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
		int err = my->ToPhysics(1)->GetStatus(&params);
	my->Push(err ? Vec3(0,0,0) : params.pos);

	return 1;
}

LUAMTA_FUNCTION(physics, SetNetworkAuthority)
{
	my->ToPhysics(1)->SetNetworkAuthority(my->ToBoolean(2));

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
		int err = my->ToPhysics(1)->GetStatus(&params);
	my->Push(err ? Quat(0,0,0,0) : params.q);

	return 1;
}

LUAMTA_FUNCTION(physics, SetAngles)
{
	pe_params_pos params;
		params.q = Quat(my->ToAng3(2));
	my->ToPhysics(1)->SetParams(&params);

	return 0;
}

LUAMTA_FUNCTION(physics, GetAngles)
{
	pe_status_pos params;
		int err = my->ToPhysics(1)->GetStatus(&params);
	my->Push(err ? Ang3(0,0,0) : Ang3(params.q));

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

LUAMTA_FUNCTION(physics, GetSnapshot)
{
	auto self = my->ToPhysics(1);

	char buffer[256] = {0};

	if (self->GetStateSnapshotTxt(buffer, 256, my->ToNumber(2, 0.0f)))
	{
		my->Push(buffer);
	}
	else
	{
		my->Push(false);
	}


	return 1;
}

LUAMTA_FUNCTION(physics, SetSnapshot)
{
	auto self = my->ToPhysics(1);
	auto buffer = my->ToString(2);

	self->SetStateFromSnapshotTxt(buffer, sizeof(buffer));

	return 0;
}