#include "StdAfx.h"
#include "oohh.hpp"

#include "IEntitySystem.h"

EntityId oohh::GetEntityId(IEntity *ent, bool local)
{	
	if (ent == nullptr) return -1;
		
	auto localid = ent->GetId(); 

	if (local) return localid;

#ifdef CE3
	auto framework = gEnv->pGame->GetIGameFramework();
	if (!framework || !framework->GetNetContext()) return localid;

	auto params = framework->GetNetContext()->GetNetID(localid);
	
	if (!params.IsLegal())
		return localid;

	return params.id;
#else
	return ent->GetId(); // temp
#endif
}
IEntity *oohh::GetEntityFromId(uint16 id, bool local)
{
	if (!gEnv->pEntitySystem) return NULL;
		
	if (!local)
	{
		auto framework = gEnv->pGame->GetIGameFramework();

		if (framework && framework->GetNetContext())
		{
#ifdef CE3
			SNetObjectID params;
			params.id = id;
			framework->GetNetContext()->Resaltify(params);

			auto entid = framework->GetNetContext()->GetEntityID(params);
			auto ent = gEnv->pEntitySystem->GetEntity(entid);

			return ent;
#else
			return gEnv->pEntitySystem->GetEntity((EntityId)id); // temp
#endif
		}
	}

	return gEnv->pEntitySystem->GetEntity(id);
}

IEntityClass *oohh::FindEntityClass(string name)
{
	IEntityClass *pClass = NULL;
	for (gEnv->pEntitySystem->GetClassRegistry()->IteratorMoveFirst(); pClass = gEnv->pEntitySystem->GetClassRegistry()->IteratorNext();)
	{
		if (name.compareNoCase(pClass->GetName()) == 0)
			break;
	}
		
	return pClass;
}

#undef UnregisterClass

LUALIB_FUNCTION(entities, GetAllRegisteredClasses)
{
	my->NewTable();

	for (gEnv->pEntitySystem->GetClassRegistry()->IteratorMoveFirst(); auto pClass = gEnv->pEntitySystem->GetClassRegistry()->IteratorNext();)
	{
		my->SetMember(-1, pClass->GetName(), pClass->GetFlags());
	}
		
	return 1;
}

LUALIB_FUNCTION(entities, RegisterClass)
{
	auto reg = gEnv->pEntitySystem->GetClassRegistry();

    auto prevclass = reg->FindClass(my->ToString(1));
    if (prevclass)
       reg->UnregisterClass(prevclass);

    IEntityClassRegistry::SEntityClassDesc info;
        info.sName = my->ToString(1);
    reg->RegisterStdClass(info);

    return 0;
}

LUALIB_FUNCTION(entities, Create)
{
	auto ent_class = oohh::FindEntityClass((string)my->ToString(1));

	if (ent_class)
	{
		SEntitySpawnParams params;
			params.pClass = ent_class;
			params.nFlags = my->ToNumber(3, 0);
			params.id = gEnv->pEntitySystem->GetNumEntities() + 1;
			
		
		/*{
			auto framework = gEnv->pGame->GetIGameFramework();

			if (framework && framework->GetNetContext())
			{
				framework->GetNetContext()->BindObject(params.id, NET_ASPECT_ALL, false);
			}
		}*/

		auto ent = gEnv->pEntitySystem->SpawnEntity(params, false);

		my->Push(ent); 

		return 1;
	}

    return 0;
}

LUALIB_FUNCTION(entities, GetByName)
{
    my->Push(gEnv->pEntitySystem->FindEntityByName(my->ToString(1)));
    
    return 1;
}

LUALIB_FUNCTION(entities, GetAll)
{
    //Initialize the table of entities we're going to return to L
    //Stack is now: {}
    my->NewTable();

    //Initialize the entity iterator that we're going to use to loop through all entities
    auto iterator = gEnv->pEntitySystem->GetEntityIterator();

    //Loop until there are no entities left to iterate
    while (!iterator->IsEnd())
    {
        //Get the entity from the iterator
        if (auto entity = iterator->Next())
        {
			if (!entity->IsGarbage())
			{
				//Set the key to the entity's ID and the value to the entity pointer
				//Stack is now: 1
				my->Push(oohh::GetEntityId(entity));
            
				//Push the entity onto the stack
				//Stack is now: 1, entity
				my->Push(entity);

				//Push the key and entity onto the table
				//Stack is now: {[1] = entity, ...}
				my->SetTable(-3);
			}
        }
    }

    return 1;
}

LUALIB_FUNCTION(entities, GetLocalPlayer)
{
	auto ply = gEnv->pGame ? gEnv->pGame->GetIGameFramework()->GetClientActor() : NULL;

	my->Push((CPlayer *)ply);

	return 1;
}

LUALIB_FUNCTION(entities, GetById)
{
	my->Push(oohh::GetEntityFromId(my->ToNumber(1), my->IsTrue(2)));

    return 1;
}
