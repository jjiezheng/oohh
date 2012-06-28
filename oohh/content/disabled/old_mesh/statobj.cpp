
#include "StdAfx.h"

#include "oohh.hpp"
#include "IIndexedMesh.h"

LUALIB_FUNCTION(_G, StatObj)
{
	auto obj = gEnv->p3DEngine->CreateStatObj();

	//obj->AddRef();
	obj->SetFilePath(my->ToString(1, "Objects/box.cgf"));
	obj->Refresh(FRO_GEOMETRY);
	
	my->Push(obj);
	
	return 1;
}

LUAMTA_FUNCTION(statobj, Render)
{
	auto self = my->ToStatObj(1);

	SRendParams params = SRendParams();
	params.pMatrix = my->ToMatrix34Ptr(2);
	self->Render(params);

	return 0;
}

LUAMTA_FUNCTION(statobj, NodeRender)
{
	auto self = my->ToStatObj(1);

	auto rendernode = gEnv->p3DEngine->CreateRenderNode(eERType_Brush);
	
	Matrix34A matrix;
	matrix.SetTranslationMat(my->ToVec3(2));

	rendernode->SetEntityStatObj(0, self, &matrix);

	return 0;
}

LUAMTA_FUNCTION(statobj, SetMesh)
{
	auto self = my->ToStatObj(1);
	auto mesh = my->ToMesh(2);

	auto imesh = mesh->mesh;
	auto cmesh = imesh->GetMesh();

	self->GetRenderMesh()->SetMesh(*cmesh);

	return 0;
}

#define PTR_ISVALID(obj) if(obj == NULL){my->Push(false); my->Push("Pointer invalid: "#obj); rmesh->LockForThreadAccess(); return 2;}
#define SHOULD_EXPECT(expect) if(!my->Is##expect(-1)){my->Push(false); my->Push("Expected format for a vertex is {Vec3 vertex, Vec3 norm}"); return 2;}

LUAMTA_FUNCTION(statobj, GetMeshInfo)
{
	auto self = my->ToStatObj(1);

	auto rmesh = self->GetRenderMesh();
	PTR_ISVALID(rmesh);

	rmesh->UnLockForThreadAccess();

	auto imesh = rmesh->GetIndexedMesh();
	PTR_ISVALID(imesh);
	auto cmesh = imesh->GetMesh();
	PTR_ISVALID(cmesh);

	auto vertices = cmesh->GetVertexCount();
	auto indices = cmesh->GetVertexCount();
	auto faces = cmesh->GetVertexCount();
	auto textcoords = cmesh->GetVertexCount();
	
	auto str = string("").Format("mesh[v:%i][i:%i][f:%i][t:%i]", vertices, indices, faces, textcoords);

	my->Push(str);

	rmesh->LockForThreadAccess();

	return 1;
}

LUAMTA_FUNCTION(statobj, SetMeshTable)
{
	auto self = my->ToStatObj(1);

	luaL_checktype(L, 2, LUA_TTABLE);
	auto vertexcount = lua_objlen(L, 2);

	auto rmesh = self->GetRenderMesh();
	PTR_ISVALID(rmesh);
	
	strided_pointer<Vec3> vertices;
	strided_pointer<Vec3> normals;
	strided_pointer<uint16> indices;

	rmesh->UnLockForThreadAccess();

	auto indmesh = rmesh->GetIndexedMesh();
	PTR_ISVALID(indmesh);

	auto cmesh = indmesh->GetMesh();
	PTR_ISVALID(cmesh);
	
	//cmesh->ReallocStream(cmesh->POSITIONS, vertexcount);
	//cmesh->ReallocStream(cmesh->NORMALS, vertexcount);
	//cmesh->ReallocStream(cmesh->INDICES, vertexcount);

	// Hope this hack does not fail me :(
	cmesh->m_pPositions = (Vec3*)   calloc(vertexcount, sizeof(Vec3)  );
	cmesh->m_pNorms     = (Vec3*)   calloc(vertexcount, sizeof(Vec3)  );
	cmesh->m_pIndices   = (uint16*) calloc(vertexcount, sizeof(uint16));

	PTR_ISVALID(cmesh->m_pPositions);
	PTR_ISVALID(cmesh->m_pNorms);
	PTR_ISVALID(cmesh->m_pIndices);

	cmesh->m_numVertices = vertexcount;
	cmesh->m_nIndexCount = vertexcount;
	
	vertices = cmesh->m_pPositions;
	normals = cmesh->m_pNorms;
	indices = cmesh->m_pIndices;
	
	for(int i = 0; i < vertexcount; i++)
	{
		lua_rawgeti(L, 2, i + 1);
		
		// TODO: Check for duplicate vertices. Faces share many of the same vertices.
		if (my->IsType(-1, LUA_TTABLE))
		{

			// Vertices - Position of vertex.
			lua_rawgeti(L, -1, 1);
				SHOULD_EXPECT(Vec3);
				vertices[i] = my->ToVec3(-1);
			my->Remove(-1);

			// Normals - The outwards or visible direction of the vertex.
			//		   - The direction of which the vertex faces
			lua_rawgeti(L, -1, 2);
				SHOULD_EXPECT(Vec3);
				normals[i] = my->ToVec3(-1);
			my->Remove(-1);

			// Indicies - Not completely sure but I believe this tells the mesh what vertex to use.
			//            This is probably useful for using the same vertex for 2 or more different places.
			//            ie: A box has 12 triangles, 2 on each side (6 * 2). It has 8 vertices, but 36 indices (12 * 3).
			//            Actually box.cgf has 24 vertices, and 24 indices. May just be more complex than a box though.
			//            box.cfg could be using square faces instead of triangle faces. Wonder how that's done. (6 * 4)
			lua_rawgeti(L, -1, 3);
				indices[i] = my->ToNumber(-1, i);
			my->Remove(-1);
		}
		
		my->Remove(-1);
	}
	

	auto newobj = self->UpdateVertices(vertices, normals, 0, vertexcount);
	PTR_ISVALID(newobj);
	
	my->Push(true);
	my->Push(newobj);

	rmesh->LockForThreadAccess();

	return 2;
}


// Depricated: Was a hack setting the render mesh this way. It was giving errors about mismatched meshes.
LUAMTA_FUNCTION(statobj, _SetMeshTable)
{
	auto self = my->ToStatObj(1);
	luaL_checktype(L, 2, LUA_TTABLE);
	
	auto rmesh = self->GetRenderMesh();
	PTR_ISVALID(rmesh);
	
	auto imesh = rmesh->GetIndexedMesh();
	PTR_ISVALID(imesh);

	auto mesh = imesh->GetMesh();
	PTR_ISVALID(mesh);

	auto vertexcount = lua_objlen(L, 2);
	// Faces consist of 3 verteces each.
	if(vertexcount%3 != 0){return 0;}

	mesh->SetVertexCount(vertexcount);
	mesh->SetIndexCount(vertexcount);
	
	for(int i = 0; i < vertexcount; i++)
	{
		lua_rawgeti(L, 2, i + 1);
		
		if (my->IsType(-1, LUA_TTABLE))
		{
			lua_rawgeti(L, -1, 1);
				SHOULD_EXPECT(Vec3);
				mesh->m_pPositions[i] = my->ToVec3(-1);
			my->Remove(-1);
						
			lua_rawgeti(L, -1, 2);
				SHOULD_EXPECT(Vec3);
				mesh->m_pNorms[i] = my->ToVec3(-1);					
			my->Remove(-1);

			lua_rawgeti(L, -1, 3);
				SHOULD_EXPECT(Number);
				mesh->m_pIndices[i] = my->ToNumber(-1);
			my->Remove(-1);
		}

		my->Remove(-1);
	}

	imesh->Invalidate();

	rmesh->LockForThreadAccess();

	return 0;
}

LUAMTA_FUNCTION(statobj, GetMeshTable)
{
	auto self = my->ToStatObj(1);
	auto cmesh = self->GetRenderMesh()->GetIndexedMesh()->GetMesh();

	my->NewTable();

	for (int i = 0; i < cmesh->GetIndexCount(); i++)
	{
		my->NewTable();
			if(cmesh->m_pPositions[i])
			{
				my->Push(Vec3(cmesh->m_pPositions[i]));
				lua_rawseti(L, -2, 1);
			}

			if(cmesh->m_pNorms[i])
			{
				my->Push(Vec3(cmesh->m_pNorms[i]));
				lua_rawseti(L, -2, 2);
			}


			if (cmesh->m_pIndices[i])
			{
				my->Push(cmesh->m_pIndices[i]);
				lua_rawseti(L, -2, 3);
			}
		lua_rawseti(L, -2, i + 1);		
	}

	return 1;
}



