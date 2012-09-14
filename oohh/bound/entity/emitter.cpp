#include "StdAfx.h"
#include "oohh.hpp"

#undef min
#undef max
#include "ParticleParams.h"

LUALIB_FUNCTION(_G, ParticleEmitter)
{
	auto mat = Matrix34();
	mat.Set(my->ToVec3(1, Vec3(0,0,0)), my->ToQuat(2, Quat(Ang3(0,0,0))), my->ToVec3(3, Vec3(1,1,1)));

	auto params = ParticleParams();

	auto self = gEnv->p3DEngine->GetParticleManager()->CreateEmitter(mat, params);

	my->Push(self);

	return 1;
}

LUAMTA_FUNCTION(particle_emitter, LoadEffect)
{
	auto self = my->ToParticleEmitter(1);

	auto effect = gEnv->p3DEngine->GetParticleManager()->FindEffect(my->ToString(2));

	if (effect)
	{
		self->SetEffect(effect);

		my->Push(true);

		return 1;
	}

	my->Push(false);

	return 1;
}


LUAMTA_FUNCTION(particle_emitter, GetXML)
{
	auto self = my->ToParticleEmitter(1);

	auto xml = gEnv->pSystem->CreateXmlNode();
	self->GetParticleEffect()->Serialize(xml, false, true);
	my->Push(xml->getXMLData()->GetString());

	return 1;
}

LUAMTA_FUNCTION(particle_emitter, SetXML)
{
	auto self = my->ToParticleEmitter(1);
	auto buffer = (string)my->ToString(2);

	auto xml = gEnv->pSystem->LoadXmlFromBuffer(buffer.c_str(), buffer.size());
	if (xml)
	{
		self->GetParticleEffect()->Serialize(xml, true, true);

		my->Push(true);

		return 1;
	}

	return 0;
}

LUAMTA_FUNCTION(particle_emitter, Activate)
{
	auto self = my->ToParticleEmitter(1);
	
	self->Activate(my->ToBoolean(2));

	return 1;
}

LUAMTA_FUNCTION(particle_emitter, EmitParticle)
{
	auto self = my->ToParticleEmitter(1);
	
	self->EmitParticles(my->ToNumber(2));

	return 0;
}