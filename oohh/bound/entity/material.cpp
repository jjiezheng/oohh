#include "StdAfx.h"

#include "oohh.hpp"

LUAMTA_FUNCTION(entity, GetMaterial)
{
	auto self = my->ToEntity(1);
	auto obj = self->GetStatObj(my->ToNumber(2, 0));
	
	if (obj)
	{
		my->Push(obj->GetMaterial());
		return 1;
	}

	return 0;
}

LUAMTA_FUNCTION(entity, SetMaterial)
{
	auto self = my->ToEntity(1);
	auto obj = self->GetStatObj(my->ToNumber(3, 0));

	if (obj)
	{
		obj->SetMaterial(my->ToMaterial(2));
		return 1;
	}


	return 1;
}

LUALIB_FUNCTION(materials, FindMaterial)
{
	auto self = gEnv->p3DEngine->GetMaterialManager()->FindMaterial(my->ToString(1));

	my->Push(self);

	return 1;
}

#ifdef CE3
LUALIB_FUNCTION(materials, CopyMaterial)
{
	gEnv->p3DEngine->GetMaterialManager()->CopyMaterial(my->ToMaterial(1), my->ToMaterial(2), my->ToEnum<EMaterialCopyFlags>(3, MTL_COPY_DEFAULT));

	return 1;
}
#endif

#ifdef CE3
LUALIB_FUNCTION(materials, CreateFromXML)
{
	auto name = my->ToString(1);
	auto str = my->ToString(2);
	
	auto xml = GetISystem()->LoadXmlFromBuffer(str, sizeof(str));

	if (xml)
		gEnv->p3DEngine->GetMaterialManager()->LoadMaterialFromXml(name, xml);

	return 0;
}
#endif

LUALIB_FUNCTION(_G, Material)
{
	auto self = gEnv->p3DEngine->GetMaterialManager()->CreateMaterial(my->ToPath(1, "materials"), 
#ifdef CE3
		my->ToEnum<EMaterialCopyFlags>(2, MTL_COPY_DEFAULT));
#else
		my->ToNumber(2));
#endif


	my->Push(self);

	return 1;
}

LUAMTA_FUNCTION(material, SetName)
{
	auto self = my->ToMaterial(1);

	gEnv->p3DEngine->GetMaterialManager()->RenameMaterial(self, my->ToString(2));

	return 0;
}

LUAMTA_FUNCTION(material, GetName)
{
	auto self = my->ToMaterial(1);

	my->Push(self->GetName());

	return 1;
}

LUAMTA_FUNCTION(material, SetParam)
{
	auto self = my->ToMaterial(1);
	
	if (my->IsType(2, LUA_TNUMBER))
	{
		auto arg = my->ToNumber(3);
		self->SetGetMaterialParamFloat(my->ToString(2), (float&)arg, false);
	}
	else
	{
		auto arg = my->ToVec3(3);
		self->SetGetMaterialParamVec3(my->ToString(2), (Vec3&)arg, false);
	}

	return 0;
}

LUAMTA_FUNCTION(material, GetParam)
{
	auto self = my->ToMaterial(1);
	
	if (my->IsTrue(3))
	{
		auto var = 0.0f;

		if (!self->SetGetMaterialParamFloat(my->ToString(2), var, true)) return 0;

		my->Push(var);
	}
	else
	{
		auto var = Vec3(0, 0, 0);

		if (!self->SetGetMaterialParamVec3(my->ToString(2), var, true)) return 0;

		my->Push(var);
	}

	return 1;
}