#include "stdafx.h"
#include "oohh.hpp"
#include <IGameObject.h>

class scripted_entity : public CGameObjectExtensionHelper<scripted_entity, IGameObjectExtension>
{	
	bool Init( IGameObject * pGameObject )
	{
		SetGameObject(pGameObject);

		GetGameObject()->EnablePhysicsEvent(true, eEPE_AllImmediate);
		GetGameObject()->BindToNetwork();
		GetGameObject()->EnableAspect(eEA_Physics, true);
		GetGameObject()->EnablePrePhysicsUpdate(ePPU_Always);

		return true;
	}
	
	void PostInit( IGameObject * pGameObject )
	{
	}
	
	void InitClient(int channelId)
	{
	}
	
	void PostInitClient(int channelId)
	{
	}
	
	void Release()
	{
		delete this;
	}
	
	void FullSerialize( TSerialize ser )
	{
	}
	
	bool NetSerialize( TSerialize ser, EEntityAspects aspect, uint8 profile, int pflags )
	{
		return true;
	}
	
	void PostSerialize()
	{
	}

	void SerializeSpawnInfo( TSerialize ser )
	{
	}
	
	ISerializableInfoPtr GetSpawnInfo()
	{
		return 0;
	}
	
	void Update( SEntityUpdateContext& ctx, int updateSlot )
	{
	}
	
	void HandleEvent( const SGameObjectEvent& event )
	{
	}
	
	void ProcessEvent( SEntityEvent& event )
	{
	}
	
	void SetChannelId(uint16 id)
	{
	}
	
	void SetAuthority( bool auth )
	{
	}
	
	void PostUpdate( float frameTime )
	{
	}
	
	void PostRemoteSpawn()
	{
	}

	bool ReloadExtension( IGameObject * pGameObject, const SEntitySpawnParams &params )
	{
		return true;
	}

	void PostReloadExtension( IGameObject * pGameObject, const SEntitySpawnParams &params )
	{
	}

	bool GetEntityPoolSignature( TSerialize signature )
	{
		return true;
	}

	void GetMemoryUsage(ICrySizer *pSizer) const 
	{
		pSizer->Add(this);
	}
};

void oohh::RegisterScriptedEntity(IGameFramework *framework)
{
	REGISTER_FACTORY(framework, "oohh_scripted_entity", scripted_entity, false);
}