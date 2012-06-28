#pragma once

#include "StdAfx.h"
#include "Weapon.h"
#include <IItemSystem.h>

#include "oohh.hpp"

class scripted_weapon : public CWeapon
{	
};

void oohh::RegisterScriptedWeapon(IGameFramework *framework)
{
	REGISTER_FACTORY(framework, "oohh_scripted_weapon", scripted_weapon, false);
}