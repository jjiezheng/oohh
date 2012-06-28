#include "StdAfx.h"
#include "oohh.hpp"

#include "weapon.h"
#include "Actor.h"

LUAMTA_FUNCTION(weapon, __tostring)
{
	auto self = my->ToWeapon(1)->GetEntity();

	my->Push(string("").Format("weapon[%i][%s]", oohh::GetEntityId(self), self->GetClass()->GetName()));

	return 1;
}

LUAMTA_FUNCTION(weapon, SimulateActionEvent)
{
	my->ToWeapon(1)->OnAction(my->ToPlayer(2)->GetEntityId(), ActionId(my->ToString(3)), my->ToNumber(4), my->ToNumber(5));
		
	return 0;
}

LUAMTA_FUNCTION(weapon, GetEntity)
{
	my->Push(my->ToWeapon(1)->GetEntity(), false);
		
	return 1;
}

LUAMTA_FUNCTION(weapon, ActivateLamLaser)
{
	auto self = my->ToWeapon(1);

	self->ActivateLamLaser(my->ToBoolean(1), my->ToBoolean(2));

	return 0;
}

LUAMTA_FUNCTION(weapon, ActivateLamLight)
{
	auto self = my->ToWeapon(1);

	self->ActivateLamLight(my->ToBoolean(1), my->ToBoolean(2));

	return 0;
}

LUAMTA_FUNCTION(weapon, CanFire)
{
	auto self = my->ToWeapon(1);

	my->Push(self->CanFire());

	return 1;
}

LUAMTA_FUNCTION(weapon, CanMeleeAttack)
{
	auto self = my->ToWeapon(1);

	my->Push(self->CanMeleeAttack());

	return 1;
}

LUAMTA_FUNCTION(weapon, CanReload)
{
	auto self = my->ToWeapon(1);

	my->Push(self->CanReload());

	return 1;
}

LUAMTA_FUNCTION(weapon, CanZoom)
{
	auto self = my->ToWeapon(1);

	my->Push(self->CanZoom());

	return 1;
}

LUAMTA_FUNCTION(weapon, ChangeFireMode)
{
	auto self = my->ToWeapon(1);

	self->ChangeFireMode();

	return 0;
}

LUAMTA_FUNCTION(weapon, ChangeZoomMode)
{
	auto self = my->ToWeapon(1);

	self->ChangeZoomMode();

	return 0;
}

LUAMTA_FUNCTION(weapon, ExitZoom)
{
	auto self = my->ToWeapon(1);

	self->ExitZoom();

	return 0;
}

LUAMTA_FUNCTION(weapon, GetAmmoCount)
{
	auto self = my->ToWeapon(1);
	auto pClass = gEnv->pEntitySystem->GetClassRegistry()->FindClass(my->ToString( 2));

	if(!pClass) 
		return 0;

	my->Push(self->GetAmmoCount(pClass));

	return 1;
}

LUAMTA_FUNCTION(weapon, GetCrosshairOpacity)
{
	auto self = my->ToWeapon(1);

	my->Push(self->GetCrosshairOpacity());
	return 1;
}

LUAMTA_FUNCTION(weapon, GetCrosshairVisibility)
{
	auto self = my->ToWeapon(1);

	my->Push(self->GetCrosshairVisibility());
	return 1;
}

LUAMTA_FUNCTION(weapon, GetCurrentFireMode)
{
	auto self = my->ToWeapon(1);
	my->Push(self->GetCurrentFireMode());
	return 1;
}

LUAMTA_FUNCTION(weapon, GetCurrentZoomMode)
{
	auto self = my->ToWeapon(1);

	my->Push(self->GetCurrentZoomMode());

	return 1;
}

LUAMTA_FUNCTION(weapon, GetDestination)
{
	auto self = my->ToWeapon(1);

	my->Push(self->GetDestination());

	return 1;
}

LUAMTA_FUNCTION(weapon, GetFireModeIdx)
{
	auto self = my->ToWeapon(1);

	my->Push(self->GetFireModeIdx(my->ToString( 2)));

	return 1;
}

LUAMTA_FUNCTION(weapon, GetFiringDir)
{
	auto self = my->ToWeapon(1);

	my->Push(self->GetFiringDir(my->ToVec3(2), my->ToVec3(3)));

	return 1;
}

LUAMTA_FUNCTION(weapon, GetFiringPos)
{
	auto self = my->ToWeapon(1);

	my->Push(self->GetFiringPos(my->ToVec3(2)));

	return 1;
}

LUAMTA_FUNCTION(weapon, GetOwner)
{
	auto self = my->ToWeapon(1);

	my->Push(self->GetOwner());

	return 1;
}

LUAMTA_FUNCTION(weapon, GetNumOfFireModes)
{
	auto self = my->ToWeapon(1);

	my->Push(self->GetNumOfFireModes());

	return 1;
}

LUAMTA_FUNCTION(weapon, GetSpinDownTime)
{
	auto self = my->ToWeapon(1);

	my->Push(self->GetSpinDownTime());

	return 1;
}	

LUAMTA_FUNCTION(weapon, GetSpinUpTime)
{
	auto self = my->ToWeapon(1);

	my->Push(self->GetSpinUpTime());

	return 1;
}

LUAMTA_FUNCTION(weapon, GetZoomModeIdx)
{
	auto self = my->ToWeapon(1);

	my->Push(self->GetZoomModeIdx(my->ToString( 2)));

	return 1;
}

LUAMTA_FUNCTION(weapon, IsFlashlightAttached)
{
	auto self = my->ToWeapon(1);

	my->Push(self->IsFlashlightAttached());

	return 1;
}

LUAMTA_FUNCTION(weapon, IsLamAttached)
{
	auto self = my->ToWeapon(1);

	my->Push(self->IsLamAttached());

	return 1;
}

LUAMTA_FUNCTION(weapon, IsLamLaserActivated)
{
	auto self = my->ToWeapon(1);

	my->Push(self->IsLamLaserActivated());

	return 1;
}

LUAMTA_FUNCTION(weapon, IsReloading)
{
	auto self = my->ToWeapon(1);

	my->Push(self->IsReloading());

	return 1;
}

LUAMTA_FUNCTION(weapon, IsZoomed)
{
	auto self = my->ToWeapon(1);

	my->Push(self->IsZoomed());

	return 1;
}

LUAMTA_FUNCTION(weapon, IsSelected)
{
	auto self = my->ToWeapon(1);

	my->Push(self->IsSelected());

	return 1;
}

LUAMTA_FUNCTION(weapon, IsUsed)
{
	auto self = my->ToWeapon(1);

	my->Push(self->IsUsed());

	return 1;
}

LUAMTA_FUNCTION(weapon, MeleeAttack)
{
	auto self = my->ToWeapon(1);

	self->MeleeAttack();

	return 0;
}

LUAMTA_FUNCTION(weapon, OutOfAmmo)
{
	auto self = my->ToWeapon(1);

	my->Push(self->OutOfAmmo(my->ToBoolean(2)));

	return 0;
}

LUAMTA_FUNCTION(weapon, RaiseWeapon)
{
	auto self = my->ToWeapon(1);

	self->RaiseWeapon(my->ToBoolean(2), my->ToBoolean(3));

	return 0;
}

LUAMTA_FUNCTION(weapon, Reload)
{
	auto self = my->ToWeapon(1);

	self->Reload(my->ToBoolean(2));

	return 0;
}

LUAMTA_FUNCTION(weapon, SetAmmoCount)
{
	auto self = my->ToWeapon(1);

	auto pClass = gEnv->pEntitySystem->GetClassRegistry()->FindClass(my->ToString(2));

	if (pClass)
	{
		self->SetAmmoCount(pClass, my->ToNumber(3));
	}

	return 0;
}

LUAMTA_FUNCTION(weapon, SetCurrentFireMode)
{
	auto self = my->ToWeapon(1);

	self->SetCurrentFireMode(my->ToString( 2));

	return 0;
}

LUAMTA_FUNCTION(weapon, SetCurrentZoomMode)
{
	auto self = my->ToWeapon(1);

	self->SetCurrentZoomMode(my->ToString( 2));

	return 0;
}

LUAMTA_FUNCTION(weapon, SetDestination)
{
	auto self = my->ToWeapon(1);

	self->SetDestination(my->ToVec3(2));

	return 0;
}

LUAMTA_FUNCTION(weapon, SetDestinationEntity)
{
	auto self = my->ToWeapon(1);

	self->SetDestinationEntity(my->ToEntity(2)->GetId());

	return 0;
}

LUAMTA_FUNCTION(weapon, SetHost)
{
	auto self = my->ToWeapon(1);

	self->SetHostId(my->ToEntity(2)->GetId());

	return 1;
}

LUAMTA_FUNCTION(weapon, StartFire)
{
	auto self = my->ToWeapon(1);

	self->StartFire();

	return 0;
}

LUAMTA_FUNCTION(weapon, StartZoom)
{
	auto self = my->ToWeapon(1);

	self->StartZoom(self->GetHostId(), my->ToNumber(2, 1));

	return 0;
}

LUAMTA_FUNCTION(weapon, StopFire)
{
	auto self = my->ToWeapon(1);

	self->StopFire();

	return 0;
}

LUAMTA_FUNCTION(weapon, StopZoom)
{
	auto self = my->ToWeapon(1);

	self->StopZoom(self->GetHostId());

	return 0;
}

LUAMTA_FUNCTION(weapon, Drop)
{
	auto self = my->ToWeapon(1);
	
	self->Drop(my->ToNumber(2, 1));

	return 0;
}

LUAMTA_FUNCTION(weapon, Remove)
{
	auto self = my->ToWeapon(1);
	
	self->Drop(1);
	self->RemoveEntity();

	return 0;
}

LUAMTA_FUNCTION(weapon, PlayAnimation)
{
	auto self = my->ToWeapon(1);
	
	self->PlayAnimationEx(
		my->ToString(2), 
#ifdef CE3
		my->ToEnum<eGeometrySlot>(3, eIGS_FirstPerson), 
#else
		my->ToNumber(3, 0),
#endif
		my->ToNumber(4, 0), 
		my->IsTrue(5), 
		my->ToNumber(6, 0.175f), 
		my->ToNumber(7, 1)
	);

	return 0;
}

LUAMTA_FUNCTION(weapon, PlayAction)
{
	auto self = my->ToWeapon(1);

	self->PlayAction(
		(ItemString)my->ToString(2),
		my->ToNumber(3, 0),
		my->IsTrue(4),
		CItem::eIPAF_Default,
		my->ToNumber(5, -1)
	);

	return 0;
}

LUAMTA_FUNCTION(weapon, SetViewModel)
{
	auto self = my->ToWeapon(1);
	auto slot = my->ToNumber(3, 0);

//	self->GetFPGeometry(slot).name = my->ToString(2);
//	self->GetFPGeometry(slot).position = my->ToVec3(4, self->GetFPGeometry(slot).position);
//	self->GetFPGeometry(slot).angles = my->ToAng3Ptr(5, self->GetFPGeometry(slot).angles);
	
	// self->GetFPGeometry(slot).scale = my->ToNumber(6, self->GetFPGeometry(slot).scale);
	// error C2106: '=' : left operand must be l-value
	// huh

	return 0;
}

LUAMTA_FUNCTION(weapon, SetModel)
{
	auto self = my->ToWeapon(1);
	
	self->SetGeometry(my->ToNumber(3, 0), (ItemString)my->ToString(2), my->ToVec3(4, Vec3(0,0,0)), my->ToAng3(5, Ang3(0,0,0)), my->ToNumber(6, 1));

	return 0;
}