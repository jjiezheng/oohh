#include "StdAfx.h"

#include "oohh.hpp"

LUALIB_FUNCTION(_G, RenderNode)
{
	auto self = gEnv->p3DEngine->CreateRenderNode(my->ToEnum<EERType>(1));

	my->Push(self);

	return 1;
}

LUAMTA_FUNCTION(render_node, Remove)
{
	auto self = my->ToRenderNode(1);

	gEnv->p3DEngine->DeleteRenderNode(self);
	self->ReleaseNode();
	my->MakeNull(self);

	return 0;
}

LUAMTA_FUNCTION(render_node, SetMaterial)
{
	auto self = my->ToRenderNode(1);

	self->SetMaterial(my->ToMaterial(2));

	return 0;
}

LUAMTA_FUNCTION(render_node, GetMaterial)
{
	auto self = my->ToRenderNode(1);

	my->Push(self->GetMaterial(&my->ToVec3(2, Vec3(0,0,0))));

	return 1;
}

LUAMTA_FUNCTION(render_node, Clone)
{
	auto self = my->ToRenderNode(1);

	my->Push(self->Clone());

	return 1;
}

LUAMTA_FUNCTION(render_node, GetBBox)
{
	auto self = my->ToRenderNode(1);

	my->Push(self->GetBBox());

	return 1;
}

LUAMTA_FUNCTION(render_node, FillBBox)
{
	auto self = my->ToRenderNode(1);

	self->FillBBox(my->ToAABB(2));

	return 1;
}

LUAMTA_FUNCTION(render_node, GetBBoxVirtual)
{
	auto self = my->ToRenderNode(1);

	my->Push(self->GetBBoxVirtual());

	return 1;
}

LUAMTA_FUNCTION(render_node, CopyRenderNodeData)
{
	auto self = my->ToRenderNode(1);

	self->CopyIRenderNodeData(my->ToRenderNode(2));

	return 0;
}

LUAMTA_FUNCTION(render_node, GetMaxViewDist)
{
	auto self = my->ToRenderNode(1);

	my->Push(self->GetMaxViewDist());

	return 1;
}

LUAMTA_FUNCTION(render_node, SetMatrix)
{
	auto self = my->ToRenderNode(1);

	self->SetMatrix(my->ToMatrix34(2));

	return 0;
}

LUAMTA_FUNCTION(render_node, Hide)
{
	auto self = my->ToRenderNode(1);
	
	self->Hide(my->ToBoolean(2));

	return 0;
}

LUAMTA_FUNCTION(render_node, SetViewDistUnlimited)
{
	auto self = my->ToRenderNode(1);
	
	self->SetViewDistUnlimited();

	return 0;
}

LUAMTA_FUNCTION(render_node, SetViewDistRatio)
{
	auto self = my->ToRenderNode(1);
	
	self->SetViewDistRatio(my->ToNumber(2));

	return 0;
}

LUAMTA_FUNCTION(render_node, GetPos)
{
	auto self = my->ToRenderNode(1);
	
	my->Push(self->GetPos());

	return 1;
}

LUAMTA_FUNCTION(render_node, GetPhysics)
{
	auto self = my->ToRenderNode(1);
	
	my->Push(self->GetPhysics());

	return 1;
}

LUAMTA_FUNCTION(render_node, GetEntityClassName)
{
	auto self = my->ToRenderNode(1);
	
	my->Push(self->GetEntityClassName());

	return 1;
}

LUAMTA_FUNCTION(render_node, GetName)
{
	auto self = my->ToRenderNode(1);
	
	my->Push(self->GetName());

	return 1;
}

LUAMTA_FUNCTION(render_node, GetMaterialOverride)
{
	auto self = my->ToRenderNode(1);
	
	my->Push(self->GetMaterialOverride());

	return 1;
}

LUAMTA_FUNCTION(render_node, GetSortPriority)
{
	auto self = my->ToRenderNode(1);
	
	my->Push(self->GetSortPriority());

	return 1;
}

LUAMTA_FUNCTION(render_node, IsMovableByGame)
{
	auto self = my->ToRenderNode(1);
	
	my->Push(self->IsMovableByGame());

	return 1;
}