#include "StdAfx.h"
#include "oohh.hpp"

LUAMTA_FUNCTION(actor, __tostring)
{
	auto self = my->ToActor(1);

	my->Push(string("").Format("actor[%s][%i]", self->GetEntity()->GetClass()->GetName(), oohh::GetEntityId(self->GetEntity())));

	return 1;
}

LUAMTA_FUNCTION(actor, GetPlayer)
{
	auto ply = static_cast<CPlayer*>(my->ToActor(1));

	my->Push(ply);

	return 1;
}

LUAMTA_FUNCTION(actor, GetEntity)
{
	my->Push(my->ToActor(1)->GetEntity(), false);

	return 1;
}

LUAMTA_FUNCTION(actor, GetArmor)
{
	my->Push(my->ToActor(1)->GetArmor());

	return 1;
}

LUAMTA_FUNCTION(actor, GetChannelId)
{
	my->Push(my->ToActor(1)->GetChannelId());

	return 1;
}

LUAMTA_FUNCTION(actor, GetHealth)
{
	my->Push(my->ToActor(1)->GetHealth());

	return 1;
}

LUAMTA_FUNCTION(actor, GetGrabbedEntityId)
{
	my->Push(my->ToActor(1)->GetGrabbedEntityId());

	return 1;
}

LUAMTA_FUNCTION(actor, GetLinkedEntity)
{
	my->Push(my->ToActor(1)->GetLinkedEntity());

	return 1;
}

LUAMTA_FUNCTION(actor, GetLocalEyePos)
{
	my->Push(my->ToActor(1)->GetLocalEyePos());

	return 1;
}

LUAMTA_FUNCTION(actor, GetMaxArmor)
{
	my->Push(my->ToActor(1)->GetMaxArmor());

	return 1;
}

LUAMTA_FUNCTION(actor, GetMaxHealth)
{
	my->Push(my->ToActor(1)->GetMaxHealth());

	return 1;
}

LUAMTA_FUNCTION(actor, GetViewAngleOffset)
{
	my->Push(my->ToActor(1)->GetViewAngleOffset());

	return 1;
}

LUAMTA_FUNCTION(actor, IsFallen)
{
	my->Push(my->ToActor(1)->IsFallen());

	return 1;
}

LUAMTA_FUNCTION(actor, IsGod)
{
	my->Push(my->ToActor(1)->IsGod());

	return 1;
}

LUAMTA_FUNCTION(actor, IsPlayer)
{
	my->Push(my->ToActor(1)->IsPlayer());

	return 1;
}

LUAMTA_FUNCTION(actor, IsThirdPerson)
{
	my->Push(my->ToActor(1)->IsThirdPerson());

	return 1;
}

LUAMTA_FUNCTION(actor, SetAuthority)
{
	my->ToActor(1)->SetAuthority(my->ToBoolean(2));

	return 1;
}

LUAMTA_FUNCTION(actor, SetChannelId)
{
	my->ToActor(1)->SetChannelId(my->ToNumber(2, 0));

	return 0;
}

LUAMTA_FUNCTION(actor, SetFacialAlertnessLevel)
{
	my->ToActor(1)->SetFacialAlertnessLevel(my->ToNumber(2, 0));

	return 0;
}

LUAMTA_FUNCTION(actor, SetHealth)
{
	my->ToActor(1)->SetHealth(my->ToNumber(2, 0));

	return 0;
}

LUAMTA_FUNCTION(actor, SetIKPos)
{
	my->ToActor(1)->SetIKPos(my->ToString(2, ""), my->ToVec3(3), my->ToNumber(4));

	return 0;
}

LUAMTA_FUNCTION(actor, SetViewInVehicle)
{
	my->ToActor(1)->SetViewInVehicle(my->ToQuat(2));

	return 0;
}

LUAMTA_FUNCTION(actor, GetViewRotation)
{
	my->Push(my->ToActor(1)->GetViewRotation());

	return 1;
}

LUAMTA_FUNCTION(actor, SetViewRotation)
{
	my->ToActor(1)->SetViewRotation(my->ToQuat(2));

	return 0;
}

LUAMTA_FUNCTION(actor, GetEyeAngles)
{
	my->Push(Ang3(my->ToActor(1)->GetViewRotation()));

	return 1;
}

LUAMTA_FUNCTION(actor, SetEyeAngles)
{
	my->ToActor(1)->SetViewRotation(Quat(my->ToAng3(2)));

	return 0;
}

LUAMTA_FUNCTION(actor, EnableThirdPerson)
{
	auto self = my->ToActor(1);
	auto enable = my->ToBoolean(2);

	if (self->IsThirdPerson() && enable)
	{
		self->ToggleThirdPerson();
	}
	else if (!self->IsThirdPerson() && !enable)
	{
		self->ToggleThirdPerson();
	}

	return 0;
}

LUAMTA_FUNCTION(actor, GetMovementState)
{
	SMovementState params;

	my->ToActor(1)->GetMovementController()->GetMovementState(params);

	my->NewTable();

	my->SetMember(-1, "AnimationEyeDirection", params.animationEyeDirection);
	my->SetMember(-1, "AtMoveTarget", params.atMoveTarget);
	my->SetMember(-1, "DesiredSpeed", params.desiredSpeed);
	my->SetMember(-1, "EyeDirection", params.eyeDirection);
	my->SetMember(-1, "EyePosition", params.eyePosition);
	my->SetMember(-1, "FireDirection", params.fireDirection);
	my->SetMember(-1, "FireTarget", params.fireTarget);
	my->SetMember(-1, "IsAiming", params.isAiming);
	my->SetMember(-1, "IsAlive", params.isAlive);
	my->SetMember(-1, "IsFiring", params.isFiring);
	my->SetMember(-1, "IsVisible", params.isVisible);
	my->SetMember(-1, "Lean", params.lean);
	my->SetMember(-1, "MaxSpeed", params.maxSpeed);
	my->SetMember(-1, "MinSpeed", params.minSpeed);
	my->SetMember(-1, "MovementDirection", params.movementDirection);
	my->SetMember(-1, "NormalSpeed", params.normalSpeed);
	my->SetMember(-1, "Pos", params.pos);
	my->SetMember(-1, "SlopeAngle", params.slopeAngle);
	my->SetMember(-1, "UpDirection", params.upDirection);
	my->SetMember(-1, "WeaponPosition", params.weaponPosition);

	return 1;
}