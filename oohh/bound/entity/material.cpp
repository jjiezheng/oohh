#include "StdAfx.h"

#include "oohh.hpp"

LUALIB_FUNCTION(_G, Material)
{
	auto self = gEnv->p3DEngine->GetMaterialManager()->CreateMaterial(my->ToString(1), my->ToNumber(2, 0));

	my->Push(self);

	return 1;
}


LUAMTA_FUNCTION(entity, GetMaterial)
{
	auto self = my->ToEntity(1);
	
	my->Push(self->GetMaterial());

	return 1;
}

LUAMTA_FUNCTION(entity, SetMaterial)
{
	auto self = my->ToEntity(1);

	self->SetMaterial(my->ToMaterial(2));

	return 0;
}

LUALIB_FUNCTION(materials, FindMaterial)
{
	auto self = gEnv->p3DEngine->GetMaterialManager()->FindMaterial(my->ToString(1));

	my->Push(self);

	return 1;
}

#ifdef CE3
LUALIB_FUNCTION(materials, CreateFromXML)
{
	auto name = my->ToString(1);
	auto str = (string)my->ToString(2);
	
	auto xml = GetISystem()->LoadXmlFromBuffer(str.c_str(), str.size());

	if (xml)
	{
		my->Push(gEnv->p3DEngine->GetMaterialManager()->LoadMaterialFromXml(name, xml));
	}
	else
	{
		my->Push((IMaterial *)nullptr);
	}

	return 0;
}
#endif

LUALIB_FUNCTION(materials, CreateFromFile)
{
	my->Push(gEnv->p3DEngine->GetMaterialManager()->LoadMaterial(my->ToString(1), false, false, my->ToNumber(2, 0UL)));

	return 1;
}

LUALIB_FUNCTION(materials, GetSkymaterial)
{
	my->Push(gEnv->p3DEngine->GetSkyMaterial());

	return 1;
}

LUAMTA_FUNCTION(material, __tostring)
{
	auto self = my->ToMaterial(1);

	auto str = string("");
	str.Format("material[%s]", self->GetName());

	my->Push(str);

	return 1;
}


#ifdef CE3
LUAMTA_FUNCTION(material, Copy)
{
	auto self = my->ToMaterial(1);

	auto newself = gEnv->p3DEngine->GetMaterialManager()->CreateMaterial(self->GetName(), self->GetFlags());

	gEnv->p3DEngine->GetMaterialManager()->CopyMaterial(self, newself, my->ToEnum<EMaterialCopyFlags>(2, MTL_COPY_DEFAULT));

	my->Push(newself);

	return 1;
}
#endif

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

LUAMTA_FUNCTION(material, GetTexture)
{
	auto self = my->ToMaterial(1);

	auto res = self->GetShaderItem().m_pShaderResources;
	if (res)
	{
		auto val = res->GetTexture(my->ToNumber(2));

		if (val && val->m_Sampler.m_pITex)
			my->Push(val->m_Sampler.m_pITex);

		return 1;
	}

	return 0;
}

LUAMTA_FUNCTION(material, GetVec3)
{
	auto self = my->ToMaterial(1);
	auto str = my->ToString(2);
	
	Vec3 &out = Vec3(0,0,0);
	self->SetGetMaterialParamVec3(str, out, true);

	my->Push(out);

	return 1;
}

LUAMTA_FUNCTION(material, GetFloat)
{
	auto self = my->ToMaterial(1);
	auto str = my->ToString(2);
	
	float out = 0.0f;
	self->SetGetMaterialParamFloat(str, out, true);

	my->Push(out);

	return 1;
}

LUAMTA_FUNCTION(material, SetParam)
{
	auto self = my->ToMaterial(1);
	auto str = my->ToString(2);
	//auto params = self->GetShaderParams()

	if (my->IsVec3(3))
	{
		self->SetGetMaterialParamVec3(str, my->ToVec3(3), false);
	}
	else if (my->IsNumber(3))
	{
		float num = my->ToNumber(3);
		self->SetGetMaterialParamFloat(str, num, false);
	}

	return 0;
}

LUAMTA_FUNCTION(material, GetParamName)
{
	auto self = my->ToMaterial(1);
	auto params = self->GetShaderParams();

	if (params)
	{
		my->Push(params->Get(my->ToNumber(2)).m_Name);
	}
	else if(self->GetShaderItem().m_pShader)
	{
		my->Push(self->GetShaderItem().m_pShader->GetPublicParams().at(my->ToNumber(2)).m_Name);
	}
	else
	{
		my->Push("");
	}

	return 1;
}

LUAMTA_FUNCTION(material, GetParamCount)
{
	auto self = my->ToMaterial(1);
	auto params = self->GetShaderParams();

	if (params)
	{
		my->Push(params->size());
	}
	else if(self->GetShaderItem().m_pShader)
	{
		my->Push(self->GetShaderItem().m_pShader->GetPublicParams().size());
	}
	else
	{
		my->Push(0);
	}

	return 1;
}