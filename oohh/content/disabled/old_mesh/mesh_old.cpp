
#ifdef THISWILLNEVERBEDEFFINED_RAWR

#include "StdAfx.h"

#include "oohh.hpp"
#include "IIndexedMesh.h"

IEntity* entity = NULL;
IIndexedMesh* mesh = NULL;
IStatObj* obj = NULL;

LUALIB_FUNCTION(_G, SetMeshEntity)
{
	auto ent = my->ToEntity(1);

	entity = ent;

	return 0;
}

LUALIB_FUNCTION(_G, SetMeshActor)
{
	auto ent = my->ToActor(1);

	entity = ent->GetEntity();

	return 0;
}

LUALIB_FUNCTION(_G, LoadMesh)
{
	auto path = my->ToString(1);

	obj = gEnv->p3DEngine->CreateStatObj();
	obj->AddRef();
	obj->SetFilePath(path);
	obj->Refresh(FRO_GEOMETRY);

	return 0;
}

LUALIB_FUNCTION(_G, MakeRender)
{
	auto vec = my->ToVec3(1);

	if(obj != NULL)
	{
		IRenderNode *rendernode = gEnv->p3DEngine->CreateRenderNode(eERType_Brush);

		Matrix34A matrix;
		matrix.SetTranslationMat(vec);
		rendernode->SetEntityStatObj(0,obj,&matrix);
	}
	return 0;
}

LUALIB_FUNCTION(_G, GetMeshInfo)
{
	
	auto num = my->ToNumber(1, 0);

	if(entity != NULL)
	{
		auto statobj = entity->GetStatObj(num);
		if(statobj != NULL)
		{
			mesh = statobj->GetIndexedMesh();
			
		}else{
			my->Push("Entity's StatObj did not exist at given slot");
			return 1;
		}
	}
	if(obj != NULL)
	{
		mesh = obj->GetIndexedMesh();
		if(mesh == NULL)
		{
			mesh = obj->GetRenderMesh()->GetIndexedMesh();
		}
	}
	if(mesh != NULL)
	{
		my->NewTable();
		my->SetMember(-1, "faces", mesh->GetFacesCount());
		my->SetMember(-1, "vertices", mesh->GetVertexCount());
		return 1;
	}
	else
	{
		my->Push("Entity or Mesh did not exist");
		return 1;
	}

	my->Push("Mesh of Entity's StatObj did not exist");
	return 1;
}

LUALIB_FUNCTION(_G, DrawMeshTest)
{
	auto vec = my->ToVec3(1);

	IStatObj *myObject = gEnv->p3DEngine->CreateStatObj();
	IRenderNode *myNode = gEnv->p3DEngine->CreateRenderNode(eERType_Brush);
	IIndexedMesh *myIndexedMesh = myObject->GetIndexedMesh(true);
	//IMaterial myMat = gEnv->p3DEngine->GetMaterialManager()->LoadMaterial("drone.mtl");


	myObject->AddRef();
	CMesh *myMesh = new CMesh();

	myMesh->m_bbox = AABB(10);

	//myMesh->SetFacesCount(1);
	myMesh->SetIndexCount(3);
	myMesh->SetVertexCount(3);
    

	myMesh->m_pPositions[0] = Vec3(0.0f,0.0f,0.0f);
	myMesh->m_pPositions[1] = Vec3(0.0f,20.0f,0.0f);
	myMesh->m_pPositions[2] = Vec3(20.0f,0.0f,0.0f);

	myMesh->m_pIndices[0] = 0;
	myMesh->m_pIndices[1] = 1;
	myMesh->m_pIndices[2] = 2;

	myMesh->m_pNorms[0] = Vec3(0.0f, 0.0f, -1.0f);
	myMesh->m_pNorms[1] = Vec3(0.0f, 0.0f, -1.0f);
	myMesh->m_pNorms[2] = Vec3(0.0f, 0.0f, -1.0f);
	
	//myMesh->m_pFaceNorms[0] = Vec3(0.0f, 1.0f, 0.0f);
	/*
	SMeshSubset *mySubset = new SMeshSubset();
	mySubset->nFirstIndexId = 0;
	mySubset->nFirstVertId = 0;
	mySubset->nNumIndices = 3;
	mySubset->nNumVerts = 3;
	mySubset->fRadius = 30;
	mySubset->vCenter = Vec3(0.0f, 0.0f, 0.0f);
	
	myMesh->m_subsets.push_back(*mySubset);
    */
	const char* ppErrorDesc;
	auto success = myMesh->Validate(&ppErrorDesc);
	if(!success)
	{
		gEnv->pConsole->PrintLine(ppErrorDesc);
	}
	
	myIndexedMesh->SetMesh(*myMesh);
	myIndexedMesh->Invalidate();

	myObject->Refresh(FRO_GEOMETRY);

    

	Matrix34A myMat;
	myMat.SetTranslationMat(vec);
	myNode->SetEntityStatObj(0,myObject,&myMat);

	return 0;
}


LUAMTA_FUNCTION(mesh, DrawMeshTest)
{
	auto self = my->ToMesh(1);

	IStatObj *myObject = self->obj;
	IRenderNode *myNode = self->renderNode;
	IIndexedMesh *myIndexedMesh = myObject->GetIndexedMesh(true);
	//IMaterial myMat = gEnv->p3DEngine->GetMaterialManager()->LoadMaterial("drone.mtl");

	CMesh *myMesh = new CMesh();

	myMesh->SetIndexCount(3);
	myMesh->SetVertexCount(3);
    

	myMesh->m_pPositions[0] = Vec3(0.0f,0.0f,0.0f);
	myMesh->m_pPositions[1] = Vec3(0.0f,20.0f,0.0f);
	myMesh->m_pPositions[2] = Vec3(20.0f,0.0f,0.0f);

	myMesh->m_pIndices[0] = 0;
	myMesh->m_pIndices[1] = 1;
	myMesh->m_pIndices[2] = 2;


	SMeshSubset *mySubset = new SMeshSubset();
	mySubset->nFirstIndexId = 0;
	mySubset->nFirstVertId = 0;
	mySubset->nNumIndices = 3;
	mySubset->nNumVerts = 3;
	mySubset->fRadius = 30;


	myMesh->m_subsets.push_back(*mySubset);
    
	myIndexedMesh->SetMesh(*myMesh);
	myIndexedMesh->Invalidate();
	
	//myObject->SetMaterial(myMat);

	myObject->Refresh(FRO_GEOMETRY);

	myNode->SetEntityStatObj(0,myObject,&(self->matrix));
	
	return 0;
}

LUAMTA_FUNCTION(entity, GetMesh)
{
	auto obj = new Mesh(my->ToEntity(1)->GetStatObj(my->ToNumber(2, 0)));

	if (!obj->obj) return 0;

	my->Push(obj);

	return 1;
}

LUAMTA_FUNCTION(entity, SetMesh)
{
	auto self = my->ToEntity(1);
	auto mesh = my->ToMesh(2);

	my->Push(self->SetStatObj(mesh->obj, my->ToNumber(2, 0), true));

	return 1;
}

LUALIB_FUNCTION(_G, Mesh)
{
	if (my->IsString(1))
	{
		auto obj = new Mesh(my->ToString(1));

		my->Push(obj);
	}
	else
	{
		auto obj = new Mesh();

		my->Push(obj);
	}	

	return 1;
}

LUAMTA_FUNCTION(mesh, Render)
{
	auto self = my->ToMesh(1);
	
	self->renderNode->Render(self->renderparams);

	return 0;
}

LUAMTA_FUNCTION(mesh, SetMatrix)
{
	auto self = my->ToMesh(1);

	self->renderparams.pMatrix = my->ToMatrix34Ptr(2);	
	self->renderNode->SetMatrix(my->ToMatrix34(2));

	return 0;
}


LUAMTA_FUNCTION(mesh, GetMatrix)
{
	auto self = my->ToMesh(1);

	my->Push(self->renderparams.pMatrix);

	return 1;
}


LUAMTA_FUNCTION(mesh, SetColor)
{
	auto self = my->ToMesh(1);
	auto color = my->ToColor(2);

	self->renderparams.AmbientColor = color;
	self->renderparams.fAlpha = color.a;

	return 0;
}

LUAMTA_FUNCTION(mesh, GetColor)
{
	auto self = my->ToMesh(1);
	
	ColorF color(self->renderparams.AmbientColor);
	color.a = self->renderparams.fAlpha;

	my->Push(color);

	return 1;
}


LUAMTA_FUNCTION(mesh, SaveToCGF)
{
	auto self = my->ToMesh(1);
	
	my->Push(self->obj->SaveToCGF(my->ToString(2)));

	return 1;
}

LUAMTA_FUNCTION(mesh, LoadFromCGF)
{
	auto self = my->ToMesh(1);
	
	self->obj->SetFilePath(my->ToString(2));

	return 0;
}

LUAMTA_FUNCTION(mesh, SetMaterial)
{
	auto self = my->ToMesh(1);
	
	self->obj->SetMaterial(my->ToMaterial(2));

	return 0;
}

LUAMTA_FUNCTION(mesh, SetMeshTable)
{
	auto self = my->ToMesh(1);
	luaL_checktype(L, 2, LUA_TTABLE);

	auto mesh = self->obj->GetIndexedMesh(true);
	auto cmesh = mesh->GetMesh();

	auto vertexcount = lua_objlen(L, 2);

	// Faces consist of 3 verteces each.
	if(vertexcount%3 != 0){return 0;}

	// Allocates number of verteces based on the count.
	mesh->SetVertexCount(vertexcount);
	mesh->SetIndexCount(vertexcount);
	mesh->SetFacesCount(vertexcount/3);

	for(int i=0; i<vertexcount; i++)
	{
		lua_rawgeti(L, 2, i + 1);
		
		if (my->IsType(-1, LUA_TTABLE))
		{
			if (my->GetMember(-1, "position"))
			{
				if (my->IsVec3(-1))
				{
					cmesh->m_pPositions[i] = my->ToVec3(-1);
					cmesh->m_pIndices[i] = i;
				}

				my->Remove(-1);
			}
						
			if (my->GetMember(-1, "normal"))
			{
				if (my->IsVec3(-1))
				{
					cmesh->m_pNorms[i] = my->ToVec3(-1);					
				}

				my->Remove(-1);
			}
		}
	}

	// Invalidate for it to update new verteces and such.
	mesh->Invalidate();

	self->obj->Refresh(FRO_GEOMETRY);

	return 0;
}


LUAMTA_FUNCTION(mesh, GetMeshTable)
{
	auto self = my->ToMesh(1);
	auto mesh = self->obj->GetIndexedMesh(true)->GetMesh();

	my->NewTable();

	for (int i = 0; i < mesh->GetIndexCount(); i ++)
	{
		my->NewTable();
			if(mesh->m_pPositions[i])
				my->SetMember(-1, "position", Vec3(mesh->m_pPositions[i]));

			if (mesh->m_pNorms[i])
				my->SetMember(-1, "normal", Vec3(mesh->m_pNorms[i]));
		lua_rawseti(L, -2, i + 1);		
	}

	return 1;
}

/*#ifdef CE3
#define LOG_PTR_VALID(v) if (!v) return 0

LUAMTA_FUNCTION(mesh, SetMeshTable) 
{
	gEnv->pConsole->PrintLine("Setting Render Mesh Table");

	auto self = my->ToMesh(1);
	luaL_checktype(L, 2, LUA_TTABLE);

	auto pRenderMesh = self->obj->GetRenderMesh();
	if(pRenderMesh)
	{
		int     vtxCount    = pRenderMesh->GetVerticesCount();
		int     vtxStride   = 0;
		byte*   vtxData     = pRenderMesh->GetPosPtr(vtxStride, FSL_SYSTEM_UPDATE);
		//LOG_PTR_VALID(vtxData);     
 
		int     nrmStride   = 0;
		byte*   nrmData     = pRenderMesh->GetNormPtr(nrmStride, FSL_SYSTEM_UPDATE);
		//LOG_PTR_VALID(nrmData);
		
		int     idxCount    = pRenderMesh->GetIndicesCount();
		int     idxStride   = 0;
		uint16* idxData     = pRenderMesh->GetIndexPtr(FSL_SYSTEM_UPDATE, 0);
		//LOG_PTR_VALID(idxData);
 
		auto spVtx = strided_pointer<Vec3>((Vec3*)vtxData, vtxStride);
		auto spNrm = strided_pointer<Vec3>((Vec3*)nrmData);
		auto spIdx = strided_pointer<uint16>(idxData);

		char buffer[33];
		gEnv->pConsole->PrintLine("Vertex Count:");
		gEnv->pConsole->PrintLine(itoa(vtxCount, buffer, 10));

		return 0;

		for(int i = 0; i < vtxCount; ++i)
		{
			lua_rawgeti(L, 2, i + 1);

			if (my->IsType(-1, LUA_TTABLE))
			{
				if (spVtx && my->GetMember(-1, "position"))
				{
					if (my->IsVec3(-1))
					{
						auto vec = my->ToVec3(-1);
						Vec3& vertex = spVtx[i];
						
						vertex.x = vec.x;
						vertex.y = vec.y;
						vertex.z = vec.z;
					}

					my->Remove(-1);
				}
						
				if (spNrm && my->GetMember(-1, "normal"))
				{
					if (my->IsVec3(-1))
					{
						auto vec = my->ToVec3(-1);
						Vec3& vertex = spNrm[i];
						
						vertex.x = vec.x;
						vertex.y = vec.y;
						vertex.z = vec.z;
					}

					my->Remove(-1);
				}
			}

			my->Remove(-1);
		}

		self->obj->UpdateVertices(spVtx, spNrm, 0, vtxCount);
	}
	
	return 0;
}

LUAMTA_FUNCTION(mesh, GetMeshTable)
{
	auto self = my->ToMesh(1);

	my->NewTable();

	auto pRenderMesh = self->obj->GetRenderMesh();
	if(pRenderMesh)
	{
		int     vtxCount    = pRenderMesh->GetVerticesCount();

		int     vtxStride   = 0;
		byte*   vtxData     = pRenderMesh->GetPosPtr(vtxStride, FSL_READ);
		//LOG_PTR_VALID(vtxData);     
 
		int     nrmStride   = 0;
		byte*   nrmData     = pRenderMesh->GetNormPtr(nrmStride, FSL_READ);
		//LOG_PTR_VALID(nrmData);
     
 
		int     idxCount    = pRenderMesh->GetIndicesCount();
		int     idxStride   = 0;
		uint16* idxData     = pRenderMesh->GetIndexPtr(FSL_READ, 0);
		//LOG_PTR_VALID(idxData);
 
		auto spVtx = strided_pointer<Vec3>((Vec3*)vtxData, vtxStride);
		auto spNrm = strided_pointer<Vec3>((Vec3*)nrmData);
		auto spIdx = strided_pointer<uint16>(idxData);

		if(spVtx)
		{
			for(int i = 0; i < vtxCount; ++i)
			{
				my->NewTable();
					if(spVtx)
						my->SetMember(-1, "position", spVtx[i]);
					if (spNrm)
						my->SetMember(-1, "normal", spNrm[i]);
				lua_rawseti(L, -2, i + 1);							
			}

			return 1;
		}
	}

	return 0;
}
#endif*/

#endif
