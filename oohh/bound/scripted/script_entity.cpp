#include "stdafx.h"
#include "oohh.hpp"
#include <IGameObject.h>

class PropNetworked : public CGameObjectExtensionHelper<PropNetworked, IGameObjectExtension>
{	
	bool Init(IGameObject * obj)
	{
		SetGameObject(obj);

		obj->EnablePrePhysicsUpdate(ePPU_Always);
		obj->EnablePhysicsEvent(true, eEPE_OnPostStepImmediate);

		obj->SetAspectProfile(eEA_Physics, ePT_Rigid);

		if (!obj->BindToNetwork())
			return false;

		return true;
	}
	
	void PostInit(IGameObject * obj)
	{
		obj->EnableUpdateSlot(this, 0);
	}
	
	void InitClient(int channelId)
	{
	}
	
	void PostInitClient(int channelId)
	{
	}
	
	void Release()
	{
		//delete this;
	}
	
	void FullSerialize(TSerialize ser)
	{
	}
	
	bool NetSerialize(TSerialize ser, EEntityAspects aspect, uint8 profile, int pflags)
	{
		return true;
	}
	
	void PostSerialize()
	{
	}

	void SerializeSpawnInfo(TSerialize ser)
	{
	}
	
	ISerializableInfoPtr GetSpawnInfo()
	{
		return 0;
	}
	
	void Update(SEntityUpdateContext& ctx, int updateSlot)
	{
	}
	
	void HandleEvent(const SGameObjectEvent& event)
	{
	}
	
	void ProcessEvent(SEntityEvent& event)
	{
	}
	
	void SetChannelId(uint16 id)
	{
	}
	
	void SetAuthority(bool auth)
	{
	}
	
	void PostUpdate(float frameTime)
	{
	}
	
	void PostRemoteSpawn()
	{
	}

	bool ReloadExtension(IGameObject * pGameObject, const SEntitySpawnParams &params)
	{
		return true;
	}

	void PostReloadExtension(IGameObject * pGameObject, const SEntitySpawnParams &params)
	{
	}

	bool GetEntityPoolSignature(TSerialize signature)
	{
		return true;
	}

	void GetMemoryUsage(ICrySizer *pSizer) const 
	{
		pSizer->Add(this);
	}
};

#define REGISTER_GAME_OBJECT(framework, name, script)\
	{\
		IEntityClassRegistry::SEntityClassDesc clsDesc;\
		clsDesc.sName = #name;\
		clsDesc.sScriptFile = script;\
		struct name##Creator : public IGameObjectExtensionCreatorBase\
		{\
			name *Create()\
			{\
				return new name();\
			}\
			void GetGameObjectExtensionRMIData(void ** ppRMI, size_t * nCount)\
			{\
			name::GetGameObjectExtensionRMIData(ppRMI, nCount);\
			}\
		};\
		static name##Creator _creator;\
		framework->GetIGameObjectSystem()->RegisterExtension(#name, &_creator, &clsDesc);\
	}

void oohh::RegisterScriptedEntity(IGameFramework *framework)
{
	REGISTER_GAME_OBJECT(framework, PropNetworked, "scripts/entities/PropNetworked.lua");
}