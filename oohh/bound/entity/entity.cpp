#include "StdAfx.h"
#include "oohh.hpp"

#include "IEntitySystem.h"
#include "IIndexedMesh.h"

LUAMTA_FUNCTION(entity, __tostring)
{
	auto self = my->ToEntity(1);

	my->Push(string("").Format("entity[%i][%s]", oohh::GetEntityId(self), self->GetClass()->GetName()));

	return 1;
}

// normally the uniqueid is the pointer of the ... pointer. 
// Since we want the actor to be the same as entity we should 
// give it the same id as entity so user data stored in its
// table will be the same

LUAMTA_FUNCTION(entity, __uniqueid)
{
	auto self = my->ToEntity(1);

	my->Push(self->GetId());

	return 1;
}

LUAMTA_FUNCTION(entity, GetId)
{
	auto self = my->ToEntity(1);
	my->Push(oohh::GetEntityId(self, my->IsTrue(2)));

	return 1;
}

LUAMTA_FUNCTION(entity, SetChannelId)
{
	auto self = my->ToEntity(1);

	auto obj = gEnv->pGame->GetIGameFramework()->GetGameObject(self->GetId());

	if (obj)
	{
		obj->SetChannelId(my->ToNumber(2));
		my->Push(obj->GetChannelId());

		return 1;
	}

	return 0;
}


LUAMTA_FUNCTION(entity, Spawn)
{
	auto self = my->ToEntity(1);

	SEntitySpawnParams params;
		params.pClass = self->GetClass();
		params.vPosition = self->GetPos();
		params.vScale = self->GetScale();
		params.qRotation = self->GetRotation();

	gEnv->pEntitySystem->InitEntity(self, params);

	my->Push(self);

	return 1;
}

LUAMTA_FUNCTION(entity, Remove)
{
	gEnv->pEntitySystem->RemoveEntity(my->ToEntity(1)->GetId(), my->ToBoolean(2));

	return 0;
}

LUAMTA_FUNCTION(entity, Activate)
{
	my->ToEntity(1)->Activate(my->ToBoolean(2));

	return 0;
}

LUAMTA_FUNCTION(entity, SetPos)
{
	auto self = my->ToEntity(1);

	self->SetPos(my->ToVec3(2));

	return 0;
}

LUAMTA_FUNCTION(entity, GetPos)
{
	auto self = my->ToEntity(1);

	my->Push(self->GetPos());

	return 1;
}

LUAMTA_FUNCTION(entity, GetName)
{
	auto self = my->ToEntity(1);
	my->Push(self->GetName());
	return 1;
}

LUAMTA_FUNCTION(entity, GetClass)
{
	auto self = my->ToEntity(1);
	my->Push(self->GetClass()->GetName());
	return 1;
}

LUAMTA_FUNCTION(entity, GetDescription)
{
	auto self = my->ToEntity(1);
	my->Push(self->GetEntityTextDescription());
	return 1;
}

LUAMTA_FUNCTION(entity, IsValid)
{
	auto self = my->ToEntity(1);
	my->Push(!self->IsGarbage());

	return 1;
}

LUAMTA_FUNCTION(entity, SetModelNoNetwork)
{
	auto self = my->ToEntity(1);
	
	int slot = 0;
	auto ext = PathUtil::GetExt(my->ToString(2));

	if ((stricmp(ext, "chr") == 0) || (stricmp(ext, "cdf") == 0) || (stricmp(ext, "cga") == 0))
	{
		slot = self->LoadCharacter(my->ToNumber(3, 0), my->ToString(2), my->ToNumber(4, 0));
	}
	else
	{
		slot = self->LoadGeometry(my->ToNumber(3, 0), my->ToString(2), 0);
	}

	self->UpdateSlotPhysics(slot);

	my->Push(slot);

	return 1;
}
	
LUAMTA_FUNCTION(entity, GetModel)
{
	auto self = my->ToEntity(1);
	auto slot = my->ToNumber(2, 0);

	auto obj = self->GetStatObj(slot);
	
	if (obj)
	{
		my->Push(obj ? obj->GetFilePath() : "");
	}
	else
	{
		auto obj = self->GetCharacter(slot);

		my->Push(obj ? obj->GetICharacterModel()->GetModelFilePath() : "");
	}
	
	return 1;
}

LUAMTA_FUNCTION(entity, GetRotation)
{
	my->Push(my->ToEntity(1)->GetRotation());

	return 1;
}

LUAMTA_FUNCTION(entity, GetLocalTM)
{
	my->Push(my->ToEntity(1)->GetLocalTM());

	return 1;
}

LUAMTA_FUNCTION(entity, SetLocalTM)
{
	my->ToEntity(1)->SetLocalTM(my->ToMatrix34(2));

	return 1;
}

LUAMTA_FUNCTION(entity, GetWorldRotation)
{
	my->Push(my->ToEntity(1)->GetWorldRotation());

	return 1;
}

LUAMTA_FUNCTION(entity, GetWorldPos)
{
	my->Push(my->ToEntity(1)->GetWorldPos());

	return 1;
}

LUAMTA_FUNCTION(entity, SetRotation)
{
	my->ToEntity(1)->SetRotation(Quat(my->ToAng3(2)));

	return 0;
}

LUAMTA_FUNCTION(entity, GetScale)
{	
	my->Push(my->ToEntity(1)->GetScale());

	return 1;
}

LUAMTA_FUNCTION(entity, SetScale)
{
	my->ToEntity(1)->SetScale(my->ToVec3(2));

	return 0;
}

LUAMTA_FUNCTION(entity, SetParent)
{
	my->ToEntity(2)->AttachChild(my->ToEntity(1));

	return 0;
}

LUAMTA_FUNCTION(entity, GetParent)
{
	my->Push(my->ToEntity(1)->GetParent());

	return 1;
}

// flags
LUAMTA_FUNCTION(entity, SetFlags)
{
	my->ToEntity(1)->SetFlags(my->ToNumber(2));

	return 0;
}

LUAMTA_FUNCTION(entity, AddFlags)
{
	my->ToEntity(1)->AddFlags(my->ToNumber(2));

	return 0;
}

LUAMTA_FUNCTION(entity, GetFlags)
{
	my->Push((int)my->ToEntity(1)->GetFlags());

	return 1;
}

LUAMTA_FUNCTION(entity, SetName)
{
	my->ToEntity(1)->SetName(my->ToString(2));

	return 0;
}

LUAMTA_FUNCTION(entity, GetGuid)
{
	my->Push(string("").Format("%llu", my->ToEntity(1)->GetGuid()));

	return 1;
}

LUAMTA_FUNCTION(entity, UpdateNetworkPosition)
{
	auto self = my->ToEntity(1);
	
	auto framework = gEnv->pGame->GetIGameFramework();

	if (framework && framework->GetNetContext() && framework->GetNetContext()->IsBound(self->GetId()))
	{
		framework->GetNetContext()->ChangedTransform(self->GetId(), self->GetPos(), self->GetRotation(), gEnv->p3DEngine->GetMaxViewDistance());
		
		my->Push(true);

		return 1;
	}

	my->Push(false);

	return 1;
}

LUAMTA_FUNCTION(entity, SetNetworkParent)
{
	auto self = gEnv->pGame->GetIGameFramework()->GetGameObject(my->ToEntity(1)->GetId());

	if (self)
	{
		self->SetNetworkParent(my->ToEntity(2)->GetId());
	}

	return 0;
}

LUAMTA_FUNCTION(entity, IsProbablyDistant)
{
	auto self = gEnv->pGame->GetIGameFramework()->GetGameObject(my->ToEntity(1)->GetId());

	if (self)
	{
		my->Push(self->IsProbablyDistant());

		return 1;
	}

	return 0;
}

LUAMTA_FUNCTION(entity, IsProbablyVisible)
{
	auto self = gEnv->pGame->GetIGameFramework()->GetGameObject(my->ToEntity(1)->GetId());

	if (self)
	{
		my->Push(self->IsProbablyVisible());

		return 1;
	}

	return 0;
}

LUAMTA_FUNCTION(entity, SetKeyValue)
{
	auto self = my->ToEntity(1);
	
	if (my->IsString(3))
	{
		self->GetScriptTable()->SetValue(my->ToString(2), my->ToString(3));
	}
	else 
	if (my->IsNumber(3))
	{
		self->GetScriptTable()->SetValue(my->ToString(2), (float)my->ToNumber(3));
	}

	return 0;
}

LUAMTA_FUNCTION(entity, GetKeyValues)
{
	auto self = my->ToEntity(1);
	
	auto iter = self->GetScriptTable()->BeginIteration();
	
	my->NewTable();
	

	while(self->GetScriptTable()->MoveNext(iter))
	{
#ifdef CE3
		if (iter.key.type == ANY_TSTRING)
		{	
			if (iter.value.type == ANY_TSTRING)
				my->SetMember(-1, iter.key.str, iter.value.str);
			else
			if (iter.value.type == ANY_TNUMBER)
				my->SetMember(-1, iter.key.str, iter.value.number);
		}
		else
		if (iter.key.type == ANY_TNUMBER)
		{	
			if (iter.value.type == ANY_TSTRING)
				my->SetMember(-1, iter.key.number, iter.value.str);
			else
			if (iter.value.type == ANY_TNUMBER)
				my->SetMember(-1, iter.key.number, iter.value.number);
		}
#else
		my->SetMember(-1, iter.sKey, iter.value.str);
#endif
	}
	
	return 1;
}

LUAMTA_FUNCTION(entity, GetBoneNameFromId)
{
	auto self = my->ToEntity(1);
	auto chr = self->GetCharacter(my->ToNumber(3, 0));

	if (chr)
	{
		my->Push(chr->GetICharacterModel()->GetICharacterModelSkeleton()->GetJointNameByID(my->ToNumber(2)));

		return 1;
	}

	return 0;
}


LUAMTA_FUNCTION(entity, GetBoneIdFromName)
{
	auto self = my->ToEntity(1);
	auto chr = self->GetCharacter(my->ToNumber(3, 0));

	if (chr)
	{
		my->Push(chr->GetICharacterModel()->GetICharacterModelSkeleton()->GetJointIDByName(my->ToString(2)));

		return 1;
	}

	return 0;
}


LUAMTA_FUNCTION(entity, GetBoneCount)
{
	auto self = my->ToEntity(1);
	auto chr = self->GetCharacter(my->ToNumber(2, 0));

	if (chr)
	{
		my->Push(chr->GetICharacterModel()->GetICharacterModelSkeleton()->GetJointCount());

		return 1;
	}

	my->Push(0);

	return 1;
}

LUAMTA_FUNCTION(entity, GetPhysicsFromBoneId)
{
	auto self = my->ToEntity(1);

	auto chr = self->GetCharacter(my->ToNumber(3, 0));

	if (chr)
	{
		my->Push(chr->GetISkeletonPose()->GetPhysEntOnJoint(my->ToNumber(2)));

		return 1;
	}

	my_pushnull(L);

	return 1;
}

#define PTR_ISVALID(obj) if(obj == NULL){my->Push(false); my->Push("Pointer invalid: "#obj); return 2;}
#define SHOULD_EXPECT(expect) if(!my->Is##expect(-1)){my->Push(false); my->Push("Expected format for a vertex is {Vec3 vertex, Vec3 norm}"); return 2;}

LUAMTA_FUNCTION(entity, SetMeshTableEx) 
{
	auto self = my->ToEntity(1);

	luaL_checktype(L, 2, LUA_TTABLE);
	auto vertexcount = lua_objlen(L, 2);
	
	auto proxy = static_cast<IEntityRenderProxy *>(self->GetProxy(ENTITY_PROXY_RENDER));
	PTR_ISVALID(proxy)

	auto node = proxy->GetRenderNode();
	PTR_ISVALID(node)
	
	auto statobj = node->GetEntityStatObj(my->ToNumber(3, 0));
	PTR_ISVALID(statobj)

	auto imesh = statobj->GetIndexedMesh(true);
	PTR_ISVALID(imesh)

	auto rmesh = statobj->GetRenderMesh();
	PTR_ISVALID(rmesh)

	imesh->SetVertexCount(vertexcount);

	int     vtxCount    = rmesh->GetVerticesCount();
	int     vtxStride   = 0;
	byte*   vtxData     = rmesh->GetPosPtr(vtxStride, FSL_SYSTEM_UPDATE);
	PTR_ISVALID(vtxData);     
 
	int     nrmStride   = 0;
	byte*   nrmData     = rmesh->GetNormPtr(nrmStride, FSL_SYSTEM_UPDATE);
	PTR_ISVALID(nrmData);
		
	int     idxCount    = rmesh->GetIndicesCount();
	int     idxStride   = 0;
	uint16* idxData     = rmesh->GetIndexPtr(FSL_SYSTEM_UPDATE, 0);
	PTR_ISVALID(idxData);
 
	auto spVtx = strided_pointer<Vec3>((Vec3*)vtxData, vtxStride);
	auto spNrm = strided_pointer<Vec3>((Vec3*)nrmData);
	auto spIdx = strided_pointer<uint16>(idxData);

	for(int i = 0; i < vtxCount; i++)
	{
		lua_rawgeti(L, 2, i + 1);
		
		// TODO: Check for duplicate vertices. Faces share many of the same vertices.
		if (my->IsType(-1, LUA_TTABLE))
		{
			// Vertices - Position of vertex.
			lua_rawgeti(L, -1, 1);
				SHOULD_EXPECT(Vec3);
				spVtx[i] = my->ToVec3(-1);
			my->Remove(-1);

			// Normals - The outwards or visible direction of the vertex.
			//		   - The direction of which the vertex faces
			lua_rawgeti(L, -1, 2);
				SHOULD_EXPECT(Vec3);
				spNrm[i] = my->ToVec3(-1);
			my->Remove(-1);

			// Indicies - Not completely sure but I believe this tells the mesh what vertex to use.
			//            This is probably useful for using the same vertex for 2 or more different places.
			//            ie: A box has 12 triangles, 2 on each side (6 * 2). It has 8 vertices, but 36 indices (12 * 3).
			//            Actually box.cgf has 24 vertices, and 24 indices. May just be more complex than a box though.
			//            box.cfg could be using square faces instead of triangle faces. Wonder how that's done. (6 * 4)
			lua_rawgeti(L, -1, 3);
				spIdx[i] = my->ToNumber(-1, i);
			my->Remove(-1);
		}
		
		my->Remove(-1);
	}
		
	imesh->Invalidate();
	statobj->UpdateVertices(spVtx, spNrm, 0, vtxCount);
	
	my->Push(true);

	return 1;
}


LUAMTA_FUNCTION(entity, SetMeshTable)
{
	auto self = my->ToEntity(1);

	luaL_checktype(L, 2, LUA_TTABLE);
	auto vertexcount = lua_objlen(L, 2);
	
	auto proxy = static_cast<IEntityRenderProxy *>(self->GetProxy(ENTITY_PROXY_RENDER));
	PTR_ISVALID(proxy)

	auto node = proxy->GetRenderNode();
	PTR_ISVALID(node)
	
	auto statobj = node->GetEntityStatObj(my->ToNumber(3, 0));
	PTR_ISVALID(statobj)

	auto imesh = statobj->GetIndexedMesh(true);
	PTR_ISVALID(imesh)
	
	CMesh mesh;
	mesh.Copy(*imesh->GetMesh());

	mesh.m_subsets.clear();

	mesh.SetIndexCount(vertexcount);
	mesh.SetVertexCount(vertexcount);
	mesh.SetFacesCount(vertexcount);
	
	for(int i = 0; i < vertexcount; i++)
	{
		lua_rawgeti(L, 2, i + 1);
		
		// TODO: Check for duplicate vertices. Faces share many of the same vertices.
		if (my->IsType(-1, LUA_TTABLE))
		{
			// Vertices - Position of vertex.
			lua_rawgeti(L, -1, 1);
				SHOULD_EXPECT(Vec3);
				mesh.m_pPositions[i] = my->ToVec3(-1);
			my->Remove(-1);

			// Normals - The outwards or visible direction of the vertex.
			//		   - The direction of which the vertex faces
			lua_rawgeti(L, -1, 2);
				SHOULD_EXPECT(Vec3);
				mesh.m_pNorms[i] = my->ToVec3(-1);
			my->Remove(-1);

			// Indicies - Not completely sure but I believe this tells the mesh what vertex to use.
			//            This is probably useful for using the same vertex for 2 or more different places.
			//            ie: A box has 12 triangles, 2 on each side (6 * 2). It has 8 vertices, but 36 indices (12 * 3).
			//            Actually box.cgf has 24 vertices, and 24 indices. May just be more complex than a box though.
			//            box.cfg could be using square faces instead of triangle faces. Wonder how that's done. (6 * 4)
			lua_rawgeti(L, -1, 3);
				mesh.m_pIndices[i] = my->ToNumber(-1, i);
			my->Remove(-1);
		}
		
		my->Remove(-1);
	}

	//if (mesh.m_bbox.min.GetDistance(mesh.m_bbox.max) < 0.001f)
		mesh.m_bbox = AABB(10);


	const char *error_desc[1] = {"HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH"};

	if (mesh.Validate(error_desc))
	{
		auto new_obj = statobj->UpdateVertices(mesh.m_pPositions, mesh.m_pNorms, vertexcount, vertexcount);
		new_obj->SetBBoxMin(mesh.m_bbox.min);
		new_obj->SetBBoxMax(mesh.m_bbox.max);
		self->SetStatObj(new_obj, my->ToNumber(3, 0), true);

		imesh->SetMesh(mesh);
		new_obj->Invalidate(true);

		my->Push(true);

		return 1;
	}

	my->Push(false);
	my->Push(error_desc[0]);

	return 2;
}

LUAMTA_FUNCTION(entity, GetMeshTable)
{
	auto self = my->ToEntity(1);
	auto proxy = static_cast<IEntityRenderProxy *>(self->GetProxy(ENTITY_PROXY_RENDER));
	
	auto node = proxy->GetRenderNode();
	PTR_ISVALID(node)
	
	auto statobj = node->GetEntityStatObj(my->ToNumber(2, 0));
	PTR_ISVALID(statobj)

	auto imesh = statobj->GetIndexedMesh(true);
	PTR_ISVALID(imesh)

	auto mesh = imesh->GetMesh();
	PTR_ISVALID(mesh)

	CMesh cmesh;
	cmesh.Copy(*mesh);

	my->NewTable();

	for (int i = 0; i < cmesh.GetVertexCount(); ++i)
	{
		my->NewTable();
			if(cmesh.m_pPositions[i])
			{
				my->Push(Vec3(cmesh.m_pPositions[i]));
				lua_rawseti(L, -2, 1);
			}

			if(cmesh.m_pNorms[i])
			{
				my->Push(Vec3(cmesh.m_pNorms[i]));
				lua_rawseti(L, -2, 2);
			}

			if (cmesh.m_pIndices[i])
			{
				my->Push(cmesh.m_pIndices[i]);
				lua_rawseti(L, -2, 3);
			}

		lua_rawseti(L, -2, i + 1);		
	}

	return 1;
}



