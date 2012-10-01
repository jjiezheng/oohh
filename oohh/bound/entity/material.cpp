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

LUAMTA_FUNCTION(material, GetParam)
{
	auto self = my->ToMaterial(1);
	auto str = my->ToString(2);

	auto shader_item = self->GetShaderItem();
	if (!shader_item.m_pShader) return 0;
	auto params = shader_item.m_pShader->GetPublicParams();

	auto it = params.begin();
	auto end = params.end();
	for (it; it != end; ++it)
	{
		auto val = *it;
		
		if(strcmp(str, val.m_Name) == 0)
		{
			if (val.m_Type == eType_FLOAT)
			{
				my->Push(val.m_Value.m_Float);

				return 1;
			}
			else if (val.m_Type == eType_VECTOR)
			{
				auto v = val.m_Value.m_Vector;
				my->Push(Vec3(v[0], v[1], v[2]));

				return 1;
			}
			else if (val.m_Type == eType_FCOLOR)
			{
				auto v = val.m_Value.m_Color;
				my->Push(ColorF(v[0], v[1], v[2], v[4]));

				return 1;
			}
			else if (val.m_Type == eType_BOOL)
			{
				my->Push(val.m_Value.m_Bool);

				return 1;
			}

			break;
		}
	}

	return 0;
}

LUAMTA_FUNCTION(material, SetParam)
{
	auto self = my->ToMaterial(1);
	auto str = my->ToString(2);

	auto shader_item = self->GetShaderItem();
	if (!shader_item.m_pShader) return 0;
	auto params = shader_item.m_pShader->GetPublicParams();

	auto it = params.begin();
	auto end = params.end();
	for (it; it != end; ++it)
	{
		auto val = *it;

		if(strcmp(str, val.m_Name) == 0)
		{
			UParamVal value;

			if (my->IsNumber(3))
			{
				value.m_Float = my->ToNumber(3);
			}
			else if (my->IsVec3(3))
			{
				auto vec = my->ToVec3(3);

				value.m_Vector[0] = vec.x;
				value.m_Vector[1] = vec.y;
				value.m_Vector[2] = vec.z;
			}
			else if (my->IsColor(3))
			{
				auto col = my->ToColor(3);

				value.m_Color[0] = col.r;
				value.m_Color[1] = col.g;
				value.m_Color[2] = col.b;
				value.m_Color[3] = col.a;
			}			
			else if (my->IsVec3(3))
			{
				value.m_Bool = my->ToBoolean(3);
			}

			val.SetParam(str, &params, value);

			SInputShaderResources results;
			shader_item.m_pShaderResources->ConvertToInputResource(&results);
			results.m_ShaderParams = params;
			shader_item.m_pShaderResources->SetShaderParams(&results, shader_item.m_pShader);

			break;
		}
	}

	return 0;
}
