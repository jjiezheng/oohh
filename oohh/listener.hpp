#pragma once

#include "Game.h"
#include "GameActions.h"
#include "IActionMapManager.h"
#include "IUIDraw.h"
#include "IFlashUI.h"
#include "IHardwareMouse.h"
#include "IFileChangeMonitor.h"

namespace oohh
{
	class CListener
		: public ISystemEventListener

		, public IOutputPrintSink
		, public IHostMigrationEventListener

		, public IHardwareMouseEventListener
		, public IInputEventListener
		, public IActionListener
		
		, public IEntitySystemSink
		, public IEntityEventListener
		, public IWeaponEventListener

		, public IMaterialManagerListener
	{
	public:

		#pragma region materialmanager
		virtual IMaterial* OnLoadMaterial(const char *sMtlName,bool bForceCreation=false,unsigned long nLoadingFlags=0 )
		{
			if (my->CallHook("OnLoadMaterial", sMtlName, bForceCreation, nLoadingFlags) && my->IsMaterial(-1))
				return my->ToMaterial(-1);

			return nullptr;
		}
		virtual void OnCreateMaterial( IMaterial *pMaterial )
		{
			my->CallHook("OnCreateMaterial", pMaterial);
		}
		virtual void OnDeleteMaterial( IMaterial *pMaterial )
		{
			my->CallHook("OnDeleteMaterial", pMaterial);
		}
		#pragma endregion

		#pragma region framework
			// eFLPriority_Game, "PreGameRender", "PostGameUpdate", "oohh_game"
			// template <EFrameworkListenerPriority priority, const char *pre, const char *post, const char *id>
			#define framework_listener(class_name, event_name)\
			class class_name : public IGameFrameworkListener\
			{\
			public:\
				class_name(){ g_pGame->GetIGameFramework()->RegisterListener(this, "oohh_"#event_name, eFLPriority_##event_name); }\
				~class_name(){ g_pGame->GetIGameFramework()->UnregisterListener(this); }\
					\
				virtual void OnPreRender() { my->CallHook("Pre"#event_name"Render"); }\
				virtual void OnPostUpdate(float fDeltaTime){ my->CallHook("Post"#event_name"Update", fDeltaTime); }\
				\
				virtual void OnSaveGame(ISaveGame* pSaveGame){}\
				virtual void OnLoadGame(ILoadGame* pLoadGame){}\
				virtual void OnLevelEnd(const char* nextLevel){}\
				virtual void OnActionEvent(const SActionEvent& event){}\
			};

			framework_listener(menu_listener, Menu);
			framework_listener(hud_listener, HUD);
			framework_listener(game_listener, Game);

			menu_listener *menu_hook;
			hud_listener *hud_hook;
			game_listener *game_hook;
		#pragma endregion framework update hooks

		#pragma region entity
			virtual bool OnBeforeSpawn( SEntitySpawnParams &params )
			{
				my->CallHook("EntitySpawn", params.pClass->GetName(), params.sName, 1);

				return !my->IsFalse(-1);
			}

			virtual void OnSpawn( IEntity *ent, SEntitySpawnParams &params )
			{
				auto item = (CItem *)gEnv->pGame->GetIGameFramework()->GetIItemSystem()->GetItem(ent->GetId());
				if (item)
				{
					auto wep = (CWeapon *)item->GetIWeapon();
					if(wep)
					{
						wep->AddEventListener(this, "oohh");
					}
				}

				for ( int flag = 0; flag != ENTITY_EVENT_LAST; flag++ )
				{
					gEnv->pEntitySystem->AddEntityEventListener(ent->GetId(), (EEntityEvent)flag, this);
				}

				//my->CallHook("EntitySpawned", ent, params.sName);
				//my->CallEntityHook(ent, "Initialize", params.sName);
			}

			virtual bool OnRemove(IEntity *ent)
			{
				if (
					!gEnv->pGame || 
					!gEnv->pGame->GetIGameFramework() || 
					!gEnv->pGame->GetIGameFramework()->GetClientActor() ||
					!gEnv->pGame->GetIGameFramework()->GetClientActor()->GetEntity() ||
					!gEnv->pGame->GetIGameFramework()->GetClientActor()->GetEntity()->IsInitialized()
					)
				return true;

				my->CallHook("EntityRemoved", ent, 1);
			
				if (my->IsFalse(-1))
					return false;

				my->CallEntityHook(ent, "OnRemove");

				for ( int flag = 0; flag != ENTITY_EVENT_LAST; flag++ )
				{
					gEnv->pEntitySystem->RemoveEntityEventListener(ent->GetId(), (EEntityEvent)flag, this);
				}

				my->MakeNull(ent);

				return true;
			}
		
			virtual void OnEvent( IEntity *ent, SEntityEvent &event ) { }

			virtual void OnEntityEvent( IEntity *ent, SEntityEvent &event )
			{
				if (ent->IsGarbage()) return;

				switch(event.event)
				{
					case ENTITY_EVENT_RESET:
					{
						my->CallEntityHook(ent, "OnReset");
					}
					case ENTITY_EVENT_HIDE:
					{
						my->CallEntityHook(ent, "OnHide");
					}
					case ENTITY_EVENT_UNHIDE:
					{
						my->CallEntityHook(ent, "OnUnHide");
					}
					case ENTITY_EVENT_VISIBLE:
					{
						my->CallEntityHook(ent, "OnVisible");
					}
					case ENTITY_EVENT_INVISIBLE:
					{ 
						my->CallEntityHook(ent, "OnInvisible"); 
					}
					case ENTITY_EVENT_PREPHYSICSUPDATE:
					{
						my->CallEntityHook(ent, "PrePhysicsUpdate", ent->GetPhysics(), gEnv->pSystem->GetITimer()->GetFrameTime());
					}
					case ENTITY_EVENT_PHYS_POSTSTEP:
					{
						my->CallEntityHook(ent, "PostPhysicsUpdate", ent->GetPhysics(), gEnv->pSystem->GetITimer()->GetFrameTime());
					}
					case ENTITY_EVENT_PHYS_BREAK:
					{
						my->CallEntityHook(ent, "PhysBreak");
						//OnRemove(ent); 
					}
					case ENTITY_EVENT_COLLISION:
					{
						if (event.nParam[0] <= 1) return;

						auto data = (EventPhysCollision *)(event.nParam[0]);

						if (!data ) return;

						IPhysicalEntity *phys = 0;
						if (data->pEntity[0] == ent->GetPhysics())
						{
							phys = data->pEntity[1];
						}
						else if (data->pEntity[1] == ent->GetPhysics())
						{
							phys = data->pEntity[0];
						}

						if (phys)
						{
							my->CallEntityHook(ent, "OnCollision", ent->GetPhysics(), phys);
						}
					}
					case ENTITY_EVENT_RENDER:
					{
						my->CallEntityHook(ent, "OnRender");
					}
				}
			}

			virtual void OnReused( IEntity *pEntity, SEntitySpawnParams &params )
			{
				my->CallEntityHook(pEntity, "OnReused", params.sName);
			}
		#pragma endregion entity hooks

		#pragma region weapon
			virtual void OnShoot(IWeapon *pWeapon, EntityId shooterId, EntityId ammoId, IEntityClass* pAmmoType, const Vec3 &pos, const Vec3 &dir, const Vec3 &vel) 
			{
				my->CallEntityHook(
					pWeapon, 
					"OnShoot", 
					oohh::GetEntityFromId(shooterId, true), 
					oohh::GetEntityFromId(ammoId, true), 
					pAmmoType ? pAmmoType->GetName() : "", 
					(Vec3)pos, 
					(Vec3)dir, 
					(Vec3)vel
				);
			}

			virtual void OnStartFire(IWeapon *pWeapon, EntityId shooterId) 
			{
				my->CallEntityHook(pWeapon, "OnStartFire", oohh::GetEntityFromId(shooterId, true));
			}

			virtual void OnStopFire(IWeapon *pWeapon, EntityId shooterId) 
			{
				my->CallEntityHook(pWeapon, "OnStopFire", oohh::GetEntityFromId(shooterId, true));
			}

			virtual void OnFireModeChanged(IWeapon *pWeapon, int currentFireMode) 
			{
				my->CallEntityHook(pWeapon, "OnFireModeChanged", currentFireMode, 0);
			}

			virtual void OnStartReload(IWeapon *pWeapon, EntityId shooterId, IEntityClass* pAmmoType) 
			{
				my->CallEntityHook(pWeapon, "OnStartReload", oohh::GetEntityFromId(shooterId, true), pAmmoType->GetName());
			}

			virtual void OnEndReload(IWeapon *pWeapon, EntityId shooterId, IEntityClass* pAmmoType) 
			{
				my->CallEntityHook(pWeapon, "OnEndReload", oohh::GetEntityFromId(shooterId, true), pAmmoType->GetName());
 			}

			virtual void OnSetAmmoCount(IWeapon *pWeapon, EntityId shooterId) 
			{
				my->CallEntityHook(pWeapon, "OnSetAmmoCount", oohh::GetEntityFromId(shooterId, true));
 			}

			virtual void OnOutOfAmmo(IWeapon *pWeapon, IEntityClass* pAmmoType) 
			{
				my->CallEntityHook(pWeapon, "OnOutOfAmmo", pAmmoType->GetName());
 			}

			virtual void OnReadyToFire(IWeapon *pWeapon) 
			{
				my->CallEntityHook(pWeapon, "OnReadyToFire");
			}


			virtual void OnPickedUp(IWeapon *pWeapon, EntityId actorId, bool destroyed) 
			{
				my->CallEntityHook(pWeapon, "OnPickedUp", oohh::GetEntityFromId(actorId, false), destroyed);
 			}

			virtual void OnDropped(IWeapon *pWeapon, EntityId actorId) 
			{
				my->CallEntityHook(pWeapon, "OnDropped", oohh::GetEntityFromId(actorId, true));
 			}


			virtual void OnMelee(IWeapon* pWeapon, EntityId shooterId) 
			{
				my->CallEntityHook(pWeapon, "OnMelee", oohh::GetEntityFromId(shooterId, true));
 			}


			virtual void OnStartTargetting(IWeapon *pWeapon) 
			{
				my->CallEntityHook(pWeapon, "OnStartTargetting");
			}

			virtual void OnStopTargetting(IWeapon *pWeapon) 
			{
				my->CallEntityHook(pWeapon, "OnStopTargetting");
			}


			virtual void OnSelected(IWeapon *pWeapon, bool selected) 
			{
				my->CallEntityHook(pWeapon, "OnSelected", selected);
 			}


			virtual void OnZoomChanged(IWeapon* pWeapon, bool zoomed, int idx) 
			{
				my->CallEntityHook(pWeapon, "OnZoomChanged", zoomed, idx, 0);
 			}
		#pragma endregion weapon hooks

		#pragma region network
			char PushMigrationInfo(const char *name, SHostMigrationInfo& info, uint32& state)
			{
				my->StartHook(name);
					my->NewTable();

					my->SetMember(-1, "IsHost", info.m_isHost);
					my->SetMember(-1, "IsNetNubSession", info.m_isNetNubSession);
					my->SetMember(-1, "LogProgress", info.m_logProgress);
					my->SetMember(-1, "MigratedPlayerName", info.m_migratedPlayerName.c_str());
					my->SetMember(-1, "NewServer", info.m_newServer.c_str());
					//my->SetMember(-1, "", info.m_pGameSpecificData);
					my->SetMember(-1, "PlayerID", info.m_playerID);
					//my->SetMember(-1, "ServerChannel", info.m_pServerChannel);
					my->SetMember(-1, "Session", info.m_session);
					my->SetMember(-1, "State", info.m_state);
					my->SetMember(-1, "TaskID", info.m_taskID);

					my->Push(state);
				if (my->EndHook(2, 1) && my->IsType(-1, LUA_TBOOLEAN))
				{
					return my->IsTrue(-1) ? 2 : 1;
				}

				return 0;
			}

			#define DECLARE(name) \
			virtual bool name(SHostMigrationInfo& info, uint32& state)\
			{\
				auto b = PushMigrationInfo(#name, info, state);\
				if (b != 0)\
				{\
					return b == 1 ? true : false;\
				}\
	\
				return true;\
			}

			DECLARE(OnInitiate)
			DECLARE(OnDisconnectClient)
			DECLARE(OnDemoteToClient)
			DECLARE(OnPromoteToServer)
			DECLARE(OnReconnectClient)
			DECLARE(OnFinalise)
			DECLARE(OnTerminate)
			DECLARE(OnReset)

			#undef DECLARE
		#pragma endregion see DECLARE for what hooks this adds and PushMigrationInfo for what it reuturns

		virtual void Print( const char *str )
		{
			my->CallHook("ConsolePrint", str);
		}

		virtual void OnSystemEvent(ESystemEvent event, UINT_PTR wparam, UINT_PTR lparam)
		{
			// hmmmm, if last arg is int, you need to specify the args from lua argument
			my->CallHook("SystemEvent", (int)event, (int)wparam, (int)lparam, 0);
		}
		
		#pragma region input events
			virtual void OnAction(const ActionId& action, int activationMode, float value)
			{
				my->CallHook("ActionEvent", action.c_str(), activationMode, value);
			}

			virtual bool OnInputEvent(const SInputEvent &event )
			{	
				if (!(event.keyId == eKI_SYS_Commit || event.keyId == eKI_MouseX || event.keyId == eKI_MouseY || event.keyId == eKI_MouseZ))
				{
					my->CallHook(
						"InputEvent", 
						event.keyName.c_str(), 
						event.value, 
						gEnv->pInput->GetInputCharAscii(event),
						1
					);

					if (my->IsFalse(-1))
						return true;
				}

				return false;
			}
			virtual void OnHardwareMouseEvent(int x, int y, EHARDWAREMOUSEEVENT eHardwareMouseEvent, int wheelDelta = 0)
			{
				my->CallHook("MouseMoved", Vec2((float)x,(float)y), wheelDelta, (int)eHardwareMouseEvent);
			}
		#pragma endregion mouse and keyboard input hooks

		void Start()
		{
			gEnv->p3DEngine->GetMaterialManager()->SetListener(this);

			gEnv->pSystem->GetISystemEventDispatcher()->RegisterListener(this);

			gEnv->pConsole->AddOutputPrintSink(this);
			gEnv->pNetwork->AddHostMigrationEventListener(this, "oohh");

			gEnv->pHardwareMouse->AddListener(this);
			gEnv->pInput->AddEventListener(this);
			gEnv->pInput->SetExclusiveListener(this);
			gEnv->pGame->GetIGameFramework()->GetIActionMapManager()->AddExtraActionListener(this);

			menu_hook = new menu_listener();
			hud_hook = new hud_listener();
			game_hook = new game_listener();
			
			#pragma region entities
				gEnv->pEntitySystem->AddSink(this, IEntitySystem::AllSinkEvents, IEntitySystem::AllSinkEvents);
			
				auto iterator = gEnv->pEntitySystem->GetEntityIterator();

				while (!iterator->IsEnd())
				{
					if (auto ent = iterator->Next())
					{
						for ( int flag = 0; flag != ENTITY_EVENT_LAST; flag++ )
						{
							gEnv->pEntitySystem->AddEntityEventListener(ent->GetId(), (EEntityEvent)flag, this);
						}

						auto item = (CItem *)gEnv->pGame->GetIGameFramework()->GetIItemSystem()->GetItem(ent->GetId());
						if (item)
						{
							auto wep = (CWeapon *)item->GetIWeapon();
							if(wep)
							{
								wep->AddEventListener(this, "oohh");
							}
						}
					}
				}
			#pragma endregion
		}

		void Stop()
		{
			gEnv->p3DEngine->GetMaterialManager()->SetListener(nullptr);

			gEnv->pSystem->GetISystemEventDispatcher()->RemoveListener(this);
			
			gEnv->pConsole->RemoveOutputPrintSink(this);
			gEnv->pNetwork->RemoveHostMigrationEventListener(this);

			gEnv->pHardwareMouse->RemoveListener(this);
			gEnv->pInput->RemoveEventListener(this);
			gEnv->pGame->GetIGameFramework()->GetIActionMapManager()->RemoveExtraActionListener(this);

			SAFE_DELETE(menu_hook);
			SAFE_DELETE(hud_hook);
			SAFE_DELETE(game_hook);

			#pragma region entities
				gEnv->pEntitySystem->RemoveSink(this);

				auto iterator = gEnv->pEntitySystem->GetEntityIterator();

				while (!iterator->IsEnd())
				{
					if (auto ent = iterator->Next())
					{
						for ( int flag = 0; flag != ENTITY_EVENT_LAST; flag++ )
						{
							gEnv->pEntitySystem->RemoveEntityEventListener(ent->GetId(), (EEntityEvent)flag, this);
						}

						auto item = (CItem *)gEnv->pGame->GetIGameFramework()->GetIItemSystem()->GetItem(ent->GetId());
						if (item)
						{
							auto wep = (CWeapon *)item->GetIWeapon();
							if(wep)
							{
								wep->RemoveEventListener(this);
							}
						}
					}
				}
			#pragma endregion
		}
	};
}