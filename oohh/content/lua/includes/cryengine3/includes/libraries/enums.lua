local function enum(tbl)
	for k, v in pairs(tbl) do
		_G[k] = v
	end
end

--RayWorldIntersection

RWI_IGNORE_TERRAIN_HOLES = 0X20
RWI_IGNORE_NONCOLLIDING = 0X40
RWI_IGNORE_BACK_FACES = 0X80
RWI_IGNORE_SOLID_BACK_FACES = 0X100
RWI_PIERCEABILITY_MASK = 0X0F
RWI_PIERCEABILITY0 = 0
RWI_STOP_AT_PIERCEABLE = 0X0F
RWI_SEPARATE_IMPORTANT_HITS = 512
RWI_COLLTYPE_BIT = 16
RWI_COLLTYPE_ANY = 0X400
RWI_QUEUE = 0X800
RWI_FORCE_PIERCEABLE_NONCOLL = 0X1000
RWI_REUSE_LAST_HIT = 0X2000
RWI_UPDATE_LAST_HIT = 0X4000
RWI_ANY_HIT = 0X8000

ENT_STATIC = 1
ENT_SLEEPING_RIGID = 2
ENT_RIGID = 4
ENT_LIVING = 8
ENT_INDEPENDENT = 16
ENT_DELETED = 128
ENT_TERRAIN = 0X100
ENT_ALL = 287
ENT_FLAGGED_ONLY = 2048
ENT_SKIP_FLAGGED = 2048*2
ENT_AREAS = 32
ENT_TRIGGERS = 64
ENT_IGNORE_NONCOLLIDING = 0X10000
ENT_SORT_BY_MASS = 0X20000
ENT_ALLOCATE_LIST = 0X40000
ENT_WATER = 0X200
ENT_NO_ONDEMAND_ACTIVATION = 0X80000

--RayWorldIntersection

--Physics Entity Flag

PARTICLE_SINGLE_CONTACT=0X01 PARTICLE_CONSTANT_ORIENTATION=0X02 PARTICLE_NO_ROLL=0X04 PARTICLE_NO_PATH_ALIGNMENT=0X08 PARTICLE_NO_SPIN=0X10
LEF_PUSH_OBJECTS=0X01  LEF_PUSH_PLAYERS=0X02 	LEF_SNAP_VELOCITIES=0X04 	LEF_LOOSEN_STUCK_CHECKS=0X08  LEF_REPORT_SLIDING_CONTACTS=0X10
ROPE_FINDIFF_ATTACHED_VEL=0X01  ROPE_NO_SOLVER=0X02  ROPE_IGNORE_ATTACHMENTS=0X4 	ROPE_TARGET_VTX_REL0=0X08  ROPE_TARGET_VTX_REL1=0X10
ROPE_SUBDIVIDE_SEGS=0X100
PARTICLE_NO_SELF_COLLISIONS=0X100
SE_SKIP_LONGEST_EDGES=0X01
REF_USE_SIMPLE_SOLVER=0X01 	REF_NO_SPLASHES=0X04  REF_CHECKSUM_RECEIVED=0X04  REF_CHECKSUM_OUTOFSYNC=0X08
AEF_RECORDED_PHYSICS = 0X02
WWEF_FAKE_INNER_WHEELS = 0X10
PEF_DISABLED=0X20  PEF_NEVER_BREAK=0X40  PEF_DEFORMING=0X80  PEF_PUSHABLE_BY_PLAYERS=0X200
PEF_TRACEABLE=0X400  PARTICLE_TRACEABLE=0X400  ROPE_TRACEABLE=0X400  PEF_UPDATE=0X800
PEF_MONITOR_STATE_CHANGES=0X1000  PEF_MONITOR_COLLISIONS=0X2000  PEF_MONITOR_ENV_CHANGES=0X4000  PEF_NEVER_AFFECT_TRIGGERS=0X8000
PEF_INVISIBLE=0X10000  PEF_IGNORE_OCEAN=0X20000  PEF_FIXED_DAMPING=0X40000 	PEF_CUSTOM_POSTSTEP=0X80000  PEF_MONITOR_POSTSTEP=0X80000
PEF_ALWAYS_NOTIFY_ON_DELETION=0X100000
ROPE_COLLIDES=0X200000  ROPE_COLLIDES_WITH_TERRAIN=0X400000  ROPE_NO_STIFFNESS_WHEN_COLLIDING=0X10000000
PEF_OVERRIDE_IMPULSE_SCALE=0X200000  PEF_PLAYERS_CAN_BREAK=0X400000  PEF_CANNOT_SQUASH_PLAYERS=0X10000000
PEF_IGNORE_AREAS=0X800000
PEF_LOG_STATE_CHANGES=0X1000000  PEF_LOG_COLLISIONS=0X2000000  PEF_LOG_ENV_CHANGES=0X4000000  PEF_LOG_POSTSTEP=0X8000000

--Physics Entity Flag

--status_pos_flags
STATUS_LOCAL=1 STATUS_THREAD_SAFE=2 STATUS_ADDREF_GEOMS=4
--status_addref_geoms

--enum EBindToNetworkMode
EBTNM_NORMAL = 0
EBTNM_FORCE = 1
EBTNM_NOWINITIALIZED = 2

--enum EPrePhysicsUpdate
EPPU_NEVER = 0
EPPU_ALWAYS = 1
EPPU_WHENAIACTIVATED = 2

--enum EEntityAspects
EEA_SCRIPT            = 1
EEA_PHYSICS           = 3
EEA_GAMECLIENTSTATIC  = 4
EEA_GAMESERVERSTATIC  = 5
EEA_GAMECLIENTDYNAMIC = 6
EEA_GAMESERVERDYNAMIC = 7

--enum EAutoDisablePhysicsMode
EADPM_NEVER = 0
EADPM_WHENAIDEACTIVATED = 1
EADPM_WHENINVISIBLEANDFARAWAY = 2
EADPM_COUNT_STATES = 3

--enum constrflags
LOCAL_FRAMES=1
WORLD_FRAMES=2
CONSTRAINT_INACTIVE=0X100
CONSTRAINT_IGNORE_BUDDY=0X200

local function BIT(n)
	bit.lshift(1, n)
end

--enum EEntityFlags
--------------------------------------------------------------------------
-- Persistent flags (can be set from the editor).
--------------------------------------------------------------------------
ENTITY_FLAG_CASTSHADOW               = BIT(1)
ENTITY_FLAG_UNREMOVABLE              = BIT(2)   -- This entity cannot be removed using IEntitySystem::RemoveEntity until this flag is cleared.
ENTITY_FLAG_GOOD_OCCLUDER            = BIT(3)
ENTITY_FLAG_NO_DECALNODE_DECALS      = BIT(4)
--------------------------------------------------------------------------
ENTITY_FLAG_WRITE_ONLY               = BIT(5)
ENTITY_FLAG_NOT_REGISTER_IN_SECTORS  = BIT(6)
ENTITY_FLAG_CALC_PHYSICS             = BIT(7)
ENTITY_FLAG_CLIENT_ONLY              = BIT(8)
ENTITY_FLAG_SERVER_ONLY              = BIT(9)
ENTITY_FLAG_CUSTOM_VIEWDIST_RATIO    = BIT(10)  -- This entity have special custom view distance ratio (AI/Vehicles must have it).
ENTITY_FLAG_CALCBBOX_USEALL          = BIT(11)	-- use character and objects in BBOx calculations
ENTITY_FLAG_VOLUME_SOUND			 = BIT(12)  -- Entity is a volume sound (will get moved around by the sound proxy)
ENTITY_FLAG_HAS_AI         			 = BIT(13)	-- Entity has an AI object
ENTITY_FLAG_TRIGGER_AREAS            = BIT(14)  -- This entity will trigger areas when it enters them.
ENTITY_FLAG_NO_SAVE                  = BIT(15)  -- This entity will not be saved.
ENTITY_FLAG_CAMERA_SOURCE            = BIT(16)  -- This entity is a camera source.
ENTITY_FLAG_CLIENTSIDE_STATE         = BIT(17)  -- Prevents error when state changes on the client and does not sync state changes to the client.
ENTITY_FLAG_SEND_RENDER_EVENT        = BIT(18)  -- When set entity will send ENTITY_EVENT_RENDER every time its rendered.
ENTITY_FLAG_NO_PROXIMITY             = BIT(19)  -- Entity will not be registered in the partition grid and can not be found by proximity queries.
ENTITY_FLAG_ON_RADAR                 = BIT(20)  -- Entity will be relevant for radar.
ENTITY_FLAG_UPDATE_HIDDEN			 = BIT(21)  -- Entity will be update even when hidden.
ENTITY_FLAG_NEVER_NETWORK_STATIC	 = BIT(22)  -- Entity should never be considered a static entity by the network system
ENTITY_FLAG_IGNORE_PHYSICS_UPDATE    = BIT(23)	-- Used by Editor only, (dont set)
ENTITY_FLAG_SPAWNED					 = BIT(24)	-- Entity was spawned dynamically without a class
ENTITY_FLAG_SLOTS_CHANGED			 = BIT(25)	-- Entity's slots were changed dynamically
ENTITY_FLAG_MODIFIED_BY_PHYSICS		 = BIT(26)  -- Entity was procedurally modified by physics
ENTITY_FLAG_OUTDOORONLY				 = BIT(27)  -- same as Brush->Outdoor only
ENTITY_FLAG_SEND_NOT_SEEN_TIMEOUT    = BIT(28)  -- Entity will be sent ENTITY_EVENT_NOT_SEEN_TIMEOUT if it is not rendered for 30 seconds
ENTITY_FLAG_RECVWIND	    		 = BIT(29)  -- Receives wind
ENTITY_FLAG_LOCAL_PLAYER             = BIT(30)
ENTITY_FLAG_AI_HIDEABLE              = BIT(31)  -- AI can use the object to calculate automatic hide points.

PE_NONE=0
PE_STATIC=1
PE_RIGID=2
PE_WHEELEDVEHICLE=3
PE_LIVING=4
PE_PARTICLE=5
PE_ARTICULATED=6
PE_ROPE=7
PE_SOFT=8
PE_AREA=9

--enum ECharacterMoveType
ECMT_NONE = 0
ECMT_NORMAL = 1
ECMT_FLY = 2
ECMT_SWIM = 3
ECMT_ZEROG = 4

ECMT_IMPULSE = 5
ECMT_JUMPINSTANT = 6
ECMT_JUMPACCUMULATE = 7

--OnActionEvent

EAE_CHANNELCREATED = 0
EAE_CHANNELDESTROYED = 1
EAE_CONNECTFAILED = 2
EAE_CONNECTED = 3
EAE_DISCONNECTED = 4
EAE_CLIENTDISCONNECTED = 5
-- MAP RESETTING
EAE_RESETBEGIN = 6
EAE_RESETEND = 7
EAE_RESETPROGRESS = 8
EAE_PRESAVEGAME = 9  -- M_VALUE -> ESAVEGAMEREASON
EAE_POSTSAVEGAME = 10 -- M_VALUE -> ESAVEGAMEREASON, M_DESCRIPTION: 0 (FAILED), != 0 (SUCCESSFUL)
EAE_INGAME = 11

EAE_SERVERNAME = 12 --STARTED SERVER
EAE_SERVERIP = 13 --OBTAINED SERVER IP
EAE_EARLYPREUPDATE = 14 -- CALLED FROM CRYACTION'S PREUPDATE LOOP AFTER SYSTEM HAS BEEN UPDATED, BUT BEFORE SUBSYSTEMS

PE_NONE=0
PE_STATIC=1
PE_RIGID=2
PE_WHEELEDVEHICLE=3
PE_LIVING=4
PE_PARTICLE=5
PE_ARTICULATED=6
PE_ROPE=7
PE_SOFT=8
PE_AREA=9

PARTICLE_SINGLE_CONTACT=0X01
PARTICLE_CONSTANT_ORIENTATION=0X02
PARTICLE_NO_ROLL=0X04
PARTICLE_NO_PATH_ALIGNMENT=0X08
PARTICLE_NO_SPIN=0X10
LEF_PUSH_OBJECTS=0X01
LEF_PUSH_PLAYERS=0X02
LEF_SNAP_VELOCITIES=0X04
LEF_LOOSEN_STUCK_CHECKS=0X08
LEF_REPORT_SLIDING_CONTACTS=0X10
ROPE_FINDIFF_ATTACHED_VEL=0X01
ROPE_NO_SOLVER=0X02
ROPE_IGNORE_ATTACHMENTS=0X4
ROPE_TARGET_VTX_REL0=0X08
ROPE_TARGET_VTX_REL1=0X10
ROPE_SUBDIVIDE_SEGS=0X100
PARTICLE_NO_SELF_COLLISIONS=0X100
SE_SKIP_LONGEST_EDGES=0X01
REF_USE_SIMPLE_SOLVER=0X01
REF_NO_SPLASHES=0X04
REF_CHECKSUM_RECEIVED=0X04
REF_CHECKSUM_OUTOFSYNC=0X08
AEF_RECORDED_PHYSICS = 0X02
WWEF_FAKE_INNER_WHEELS = 0X10
PEF_DISABLED=0X20
PEF_NEVER_BREAK=0X40
PEF_DEFORMING=0X80
PEF_PUSHABLE_BY_PLAYERS=0X200
PEF_TRACEABLE=0X400
PARTICLE_TRACEABLE=0X400
ROPE_TRACEABLE=0X400
PEF_UPDATE=0X800
PEF_MONITOR_STATE_CHANGES=0X1000
PEF_MONITOR_COLLISIONS=0X2000
PEF_MONITOR_ENV_CHANGES=0X4000
PEF_NEVER_AFFECT_TRIGGERS=0X8000
PEF_INVISIBLE=0X10000
PEF_IGNORE_OCEAN=0X20000
PEF_FIXED_DAMPING=0X40000
PEF_CUSTOM_POSTSTEP=0X80000
PEF_MONITOR_POSTSTEP=0X80000
PEF_ALWAYS_NOTIFY_ON_DELETION=0X100000
ROPE_COLLIDES=0X200000
ROPE_COLLIDES_WITH_TERRAIN=0X400000
ROPE_NO_STIFFNESS_WHEN_COLLIDING=0X10000000
PEF_OVERRIDE_IMPULSE_SCALE=0X200000
PEF_PLAYERS_CAN_BREAK=0X400000
PEF_CANNOT_SQUASH_PLAYERS=0X10000000
PEF_IGNORE_AREAS=0X800000
PEF_LOG_STATE_CHANGES=0X1000000
PEF_LOG_COLLISIONS=0X2000000
PEF_LOG_ENV_CHANGES=0X4000000
PEF_LOG_POSTSTEP=0X8000000

ECMT_NONE = 0
ECMT_NORMAL = 1
ECMT_FLY = 2
ECMT_SWIM = 3
ECMT_ZEROG = 4

ECMT_IMPULSE = 5
ECMT_JUMPINSTANT = 6
ECMT_JUMPACCUMULATE = 7

FLAG_SOUND_LOOP=0x00000001
FLAG_SOUND_2D=0x00000002
FLAG_SOUND_3D=0x00000004
FLAG_SOUND_STEREO=0x00000008
FLAG_SOUND_16BITS=0x00000010
FLAG_SOUND_STREAM=0x00000020	-- streamed wav
FLAG_SOUND_RELATIVE=0x00000040	-- sound position moves relative to player
FLAG_SOUND_RADIUS=0x00000080	-- sound has a radius, custom attenuation calculation
FLAG_SOUND_DOPPLER=0x00000100	-- use doppler effect for this sound
FLAG_SOUND_NO_SW_ATTENUATION=0x00000200	-- doesn't use SW attenuation for this sound
FLAG_SOUND_MUSIC=0x00000400	-- pure music sound, to use to set pure music volume
FLAG_SOUND_OUTDOOR=0x00000800	-- play the sound only if the listener is in outdoor
FLAG_SOUND_INDOOR=0x00001000	-- play the sound only if the listener is in indoor
FLAG_SOUND_UNSCALABLE=0x00002000	-- for all sounds with this flag the volume can be scaled separately respect to the master volume
FLAG_SOUND_CULLING=0x00004000	-- the sound uses sound occlusion (based on VisAreas)
FLAG_SOUND_LOAD_SYNCHRONOUSLY=0x00008000	-- the loading of this sound will be synchronous (asynchronously by default).
FLAG_SOUND_MANAGED=0x00010000  -- Managed sounds life time is controlled by the sound system, when sound stops it will be deleted.
FLAG_SOUND_FADE_OUT_UNDERWATER=0x00020000	--1<<16
FLAG_SOUND_OBSTRUCTION=0x00040000	-- the sound uses sound obstruction (based on ray-world-intersects)
FLAG_SOUND_SELFMOVING=0x00080000	-- sounds will be automatically moved controlled by direction vector in m/sec
FLAG_SOUND_START_PAUSED=0x00100000  -- start the sound paused, so an additional call to unpause is needed
FLAG_SOUND_VOICE=0x00200000  -- Sound used as a voice (sub-titles and lip sync can be applied)
FLAG_SOUND_EVENT=0x00400000  -- this sound is a sound event
FLAG_SOUND_EDITOR=0x00800000	-- mark sound as being only used within the Editor (eg. Facial Editor)
FLAG_SOUND_SPREAD=0x01000000  -- this sound has a spread parameter
FLAG_SOUND_DAYLIGHT=0x02000000  -- this sound has a daylight parameter
FLAG_SOUND_SQUELCH=0x04000000  -- this sound has a radio squelch parameter
FLAG_SOUND_DOPPLER_PARAM=0x08000000  -- this sound has a doppler parameter

FLAG_SOUND_DEFAULT_3D = bit.bor( FLAG_SOUND_CULLING, FLAG_SOUND_OBSTRUCTION )

EIGS_FIRSTPERSON = 0
EIGS_THIRDPERSON = 1
EIGS_ARMS = 2
EIGS_AUX0 = 3
EIGS_OWNER = 4
EIGS_OWNERLOOPED = 5
EIGS_OFFHAND = 6
EIGS_DESTROYED = 7
EIGS_AUX1 = 8
EIGS_THIRDPERSONAUX = 9

-- E3DPARAM
E3DPARAM_HDR_DYNAMIC_POWER_FACTOR = 0

E3DPARAM_SUN_COLOR = 1
E3DPARAM_SUN_COLOR_MULTIPLIER = 2

E3DPARAM_SKY_COLOR = 3
E3DPARAM_SKY_COLOR_MULTIPLIER = 4

E3DPARAM_AMBIENT_GROUND_COLOR = 5
E3DPARAM_AMBIENT_MIN_HEIGHT = 6
E3DPARAM_AMBIENT_MAX_HEIGHT = 7
E3DPARAM_AMBIENT_AFFECT_GLOBALCUBEMAP = 8

E3DPARAM_FOG_COLOR = 9
E3DPARAM_FOG_COLOR2 = 10
E3DPARAM_FOG_RADIAL_COLOR = 11

E3DPARAM_VOLFOG_HEIGHT_DENSITY = 12
E3DPARAM_VOLFOG_HEIGHT_DENSITY2 = 13

E3DPARAM_VOLFOG_GRADIENT_CTRL = 14

E3DPARAM_VOLFOG_GLOBAL_DENSITY = 15
E3DPARAM_VOLFOG_RAMP = 16

E3DPARAM_SKYLIGHT_SUN_INTENSITY = 17
E3DPARAM_SKYLIGHT_SUN_INTENSITY_MULTIPLIER = 18

E3DPARAM_SKYLIGHT_KM = 19
E3DPARAM_SKYLIGHT_KR = 20
E3DPARAM_SKYLIGHT_G = 21

E3DPARAM_SKYLIGHT_WAVELENGTH_R = 22
E3DPARAM_SKYLIGHT_WAVELENGTH_G = 23
E3DPARAM_SKYLIGHT_WAVELENGTH_B = 24

E3DPARAM_NIGHSKY_HORIZON_COLOR = 25
E3DPARAM_NIGHSKY_ZENITH_COLOR = 26
E3DPARAM_NIGHSKY_ZENITH_SHIFT = 27

E3DPARAM_NIGHSKY_STAR_INTENSITY = 28

E3DPARAM_NIGHSKY_MOON_DIRECTION = 29
E3DPARAM_NIGHSKY_MOON_COLOR = 30
E3DPARAM_NIGHSKY_MOON_SIZE = 31
E3DPARAM_NIGHSKY_MOON_INNERCORONA_COLOR = 32
E3DPARAM_NIGHSKY_MOON_INNERCORONA_SCALE = 33
E3DPARAM_NIGHSKY_MOON_OUTERCORONA_COLOR = 34
E3DPARAM_NIGHSKY_MOON_OUTERCORONA_SCALE = 35

E3DPARAM_CLOUDSHADING_MULTIPLIERS = 36
E3DPARAM_CLOUDSHADING_SUNCOLOR = 37
E3DPARAM_CLOUDSHADING_SKYCOLOR = 38

E3DPARAM_CORONA_SIZE = 39

E3DPARAM_OCEANFOG_COLOR = 40
E3DPARAM_OCEANFOG_COLOR_MULTIPLIER = 41
E3DPARAM_OCEANFOG_DENSITY = 42

-- Sky highlight (ex. From Lightning)
E3DPARAM_SKY_HIGHLIGHT_COLOR = 43
E3DPARAM_SKY_HIGHLIGHT_SIZE = 44
E3DPARAM_SKY_HIGHLIGHT_POS = 45

E3DPARAM_SKY_SUNROTATION = 46
E3DPARAM_SKY_MOONROTATION = 47

E3DPARAM_SKY_SKYBOX_ANGLE = 48
E3DPARAM_SKY_SKYBOX_STRETCHING = 49

EPARAM_SUN_SHAFTS_VISIBILITY = 50

E3DPARAM_SKYBOX_MULTIPLIER = 51

E3DPARAM_DAY_NIGHT_INDICATOR = 52

-- Tone mapping tweakables
E3DPARAM_HDR_FILMCURVE_SHOULDER_SCALE = 53
E3DPARAM_HDR_FILMCURVE_LINEAR_SCALE = 54
E3DPARAM_HDR_FILMCURVE_TOE_SCALE = 55
E3DPARAM_HDR_FILMCURVE_WHITEPOINT = 56
E3DPARAM_HDR_BLUE_SHIFT = 57
E3DPARAM_HDR_BLUE_SHIFT_THRESHOLD = 58
E3DPARAM_HDR_COLORGRADING_COLOR_SATURATION = 59
E3DPARAM_HDR_COLORGRADING_COLOR_CONTRAST = 60
E3DPARAM_HDR_COLORGRADING_COLOR_BALANCE = 61

E3DPARAM_COLORGRADING_COLOR_SATURATION = 62
E3DPARAM_COLORGRADING_FILTERS_PHOTOFILTER_COLOR = 63
E3DPARAM_COLORGRADING_FILTERS_PHOTOFILTER_DENSITY = 64
E3DPARAM_COLORGRADING_FILTERS_GRAIN = 65

DOCK_NONE = 0
DOCK_LEFT = 2
DOCK_RIGHT = 4
DOCK_TOP = 8
DOCK_BOTTOM = 16
DOCK_CENTERV = 32
DOCK_CENTERH = 64
DOCK_FILL = 128
DOCK_CENTER = 96

ALIGN_LEFT = Vec2(0, -1)
ALIGN_RIGHT = Vec2(1, -1)
ALIGN_CENTERX = Vec2(0.5, -1)

ALIGN_TOP = Vec2(-1, 0)
ALIGN_BOTTOM = Vec2(-1, 1)
ALIGN_CENTERY = Vec2(-1, 0.5)

ALIGN_TOPLEFT = Vec2(0, 0)
ALIGN_CENTERLEFT = Vec2(0, 0.5)
ALIGN_TOPRIGHT = Vec2(1, 0)
ALIGN_CENTERRIGHT = Vec2(1, 0.5)


ALIGN_BOTTOMLEFT = Vec2(0, 1)
ALIGN_BOTTOMRIGHT = Vec2(1, 1)
ALIGN_CENTER = Vec2(0.5, 0.5)

EIPAF_OWNERLOOPED = 32
EIPAF_DESTROYED = 64
EIPAF_THIRDPERSON = 2
EIPAF_AUX0 = 8
EIPAF_NOBLEND = 131072
EIPAF_FORCETHIRDPERSON = 65536
EIPAF_RESTARTANIMATION = 8388608
EIPAF_FIRSTPERSON = 1
EIPAF_DEFAULT = 35127347
EIPAF_SOUND = 1048576
EIPAF_EFFECT = 33554432
EIPAF_FORCEFIRSTPERSON = 32768
EIPAF_ARMS = 4
EIPAF_SOUNDSTARTPAUSED = 4194304
EIPAF_OWNER = 16
EIPAF_SOUNDLOOPED = 2097152
EIPAF_ANIMATION = 524288
EIPAF_CLEANBLENDING = 262144
EIPAF_REPEATLASTFRAME = 16777216

GS_BLSRC_MASK = 15
GS_BLSRC_ZERO = 1
GS_BLSRC_ONE = 2
GS_BLSRC_DSTCOL = 3
GS_BLSRC_ONEMINUSDSTCOL = 4
GS_BLSRC_SRCALPHA = 5
GS_BLSRC_ONEMINUSSRCALPHA = 6
GS_BLSRC_DSTALPHA = 7
GS_BLSRC_ONEMINUSDSTALPHA = 8
GS_BLSRC_ALPHASATURATE = 9
GS_BLSRC_SRCALPHA_A_ZERO = 10
GS_BLDST_MASK = 240
GS_BLDST_ZERO = 16
GS_BLDST_ONE = 32
GS_BLDST_SRCCOL = 48
GS_BLDST_ONEMINUSSRCCOL = 64
GS_BLDST_SRCALPHA = 80
GS_BLDST_ONEMINUSSRCALPHA = 96
GS_BLDST_DSTALPHA = 112
GS_BLDST_ONEMINUSDSTALPHA = 128
GS_BLDST_ONE_A_ZERO = 144
GS_DEPTHWRITE = 256
GS_COLMASK_RT1 = 512
GS_COLMASK_RT2 = 1024
GS_COLMASK_RT3 = 2048
GS_NOCOLMASK_R = 4096
GS_NOCOLMASK_G = 8192
GS_NOCOLMASK_B = 16384
GS_NOCOLMASK_A = 32768
GS_COLMASK_SHIFT = 12
GS_WIREFRAME = 65536
GS_POINTRENDERING = 131072
GS_NODEPTHTEST = 262144
GS_BLEND_OP_MASK = 524288
GS_BLOP_MAX = 524288
GS_BLEND_MASK = 524543
GS_DEPTHFUNC_LEQUAL = 0
GS_DEPTHFUNC_EQUAL = 1048576
GS_DEPTHFUNC_GREAT = 2097152
GS_DEPTHFUNC_LESS = 3145728
GS_DEPTHFUNC_GEQUAL = 4194304
GS_DEPTHFUNC_NOTEQUAL = 5242880
GS_DEPTHFUNC_MASK = 7340032
GS_STENCIL = 8388608
GS_ALPHATEST_MASK = 4026531840
GS_ALPHATEST_GREATER = 268435456
GS_ALPHATEST_LESS = 536870912
GS_ALPHATEST_GEQUAL = 1073741824
GS_ALPHATEST_LEQUAL = 2147483648
FORMAT_8_BIT = 8
FORMAT_24_BIT = 24
FORMAT_32_BIT = 32

IDC_APPSTARTING = 0 -- Standard arrow and small hourglass.
IDC_ARROW = 1 -- Standard arrow.
IDC_CROSS = 2 -- Crosshair.
IDC_HAND = 3 -- Hand.
IDC_HELP = 4 -- Arrow and question mark.
IDC_ICON = 5 -- Obsolete.
IDC_NO = 6 -- Slashed circle.
IDC_SIZE = 7 -- Obsolete; use IDC_SIZEALL.
IDC_SIZEALL = 8 -- Four-pointed arrow pointing north, south, east, and west.
IDC_SIZENESW = 9 -- Double-pointed arrow pointing northeast and southwest.
IDC_SIZENS = 10 -- Double-pointed arrow pointing north and south.
IDC_SIZENWSE = 11 -- Double-pointed arrow pointing northwest and southeast.
IDC_SIZEWE = 12 -- Double-pointed arrow pointing west and east.
IDC_UPARROW = 13 -- Vertical arrow.
IDC_WAIT = 14 -- Hourglass.

-- BASS
BASS_DEVICE_8BITS		=	1	 -- use 8 bit resolution, else 16 bit
BASS_DEVICE_MONO		=	2	 -- use mono, else stereo
BASS_DEVICE_3D			=	4	 -- enable 3D functionality
BASS_DEVICE_LATENCY		=	256	 -- calculate device latency (BASS_INFO struct)
BASS_DEVICE_CPSPEAKERS	=	1024 -- detect speakers via Windows control panel
BASS_DEVICE_SPEAKERS	=	2048 -- force enabling of speaker assignment
BASS_DEVICE_NOSPEAKER	=	4096 -- ignore speaker arrangement
-- Error codes returned by BASS_ErrorGetCode
BASS_OK				=0	-- all is OK
BASS_ERROR_MEM		=1	-- memory error
BASS_ERROR_FILEOPEN	=2	-- can't open the file
BASS_ERROR_DRIVER	=3	-- can't find a free/valid driver
BASS_ERROR_BUFLOST	=4	-- the sample buffer was lost
BASS_ERROR_HANDLE	=5	-- invalid handle
BASS_ERROR_FORMAT	=6	-- unsupported sample format
BASS_ERROR_POSITION	=7	-- invalid position
BASS_ERROR_INIT		=8	-- BASS_Init has not been successfully called
BASS_ERROR_START	=9	-- BASS_Start has not been successfully called
BASS_ERROR_ALREADY	=14	-- already initialized/paused/whatever
BASS_ERROR_NOCHAN	=18	-- can't get a free channel
BASS_ERROR_ILLTYPE	=19	-- an illegal type was specified
BASS_ERROR_ILLPARAM	=20	-- an illegal parameter was specified
BASS_ERROR_NO3D		=21	-- no 3D support
BASS_ERROR_NOEAX	=22	-- no EAX support
BASS_ERROR_DEVICE	=23	-- illegal device number
BASS_ERROR_NOPLAY	=24	-- not playing
BASS_ERROR_FREQ		=25	-- illegal sample rate
BASS_ERROR_NOTFILE	=27	-- the stream is not a file stream
BASS_ERROR_NOHW		=29	-- no hardware voices available
BASS_ERROR_EMPTY	=31	-- the MOD music has no sequence data
BASS_ERROR_NONET	=32	-- no internet connection could be opened
BASS_ERROR_CREATE	=33	-- couldn't create the file
BASS_ERROR_NOFX		=34	-- effects are not available
BASS_ERROR_NOTAVAIL	=37	-- requested data is not available
BASS_ERROR_DECODE	=38	-- the channel is a "decoding channel"
BASS_ERROR_DX		=39	-- a sufficient DirectX version is not installed
BASS_ERROR_TIMEOUT	=40	-- connection timedout
BASS_ERROR_FILEFORM	=41	-- unsupported file format
BASS_ERROR_SPEAKER	=42	-- unavailable speaker
BASS_ERROR_VERSION	=43	-- invalid BASS version (used by add-ons)
BASS_ERROR_CODEC	=44	-- codec is not available/supported
BASS_ERROR_ENDED	=45	-- the channel/file has ended
BASS_ERROR_BUSY		=46	-- the device is busy
BASS_ERROR_UNKNOWN	=-1	-- some other mystery problem

ETF_R8G8B8 = 1 -- MAY BE SAVED INTO FILE
ETF_A8R8G8B8 = 2 -- MAY BE SAVED INTO FILE
ETF_X8R8G8B8 = 3
ETF_A8 = 4
ETF_A8L8 = 5
ETF_L8 = 6
ETF_A4R4G4B4 = 7
ETF_R5G6B5 = 8
ETF_R5G5B5 = 9
ETF_V8U8 = 10
ETF_CXV8U8 = 11
ETF_X8L8V8U8 = 12
ETF_L8V8U8 = 13
ETF_L6V5U5 = 14
ETF_V16U16 = 15
ETF_A16B16G16R16 = 16
ETF_A16B16G16R16F = 17
ETF_A32B32G32R32F = 18
ETF_G16R16F = 19
ETF_R16F = 20
ETF_R32F = 21
ETF_DXT1 = 22 -- MAY BE SAVED INTO FILE
ETF_DXT3 = 23 -- MAY BE SAVED INTO FILE
ETF_DXT5 = 24 -- MAY BE SAVED INTO FILE
ETF_3DC = 25

ETF_G16R16 = 26

ETF_NULL = 27

--HARDWARE DEPTH BUFFERS
ETF_DF16 = 28
ETF_DF24 = 29
ETF_D16 = 30
ETF_D24S8 = 31
ETF_D32F = 32
ETF_DEPTH16 = 33
ETF_DEPTH24 = 34
ETF_A2R10G10B10 = 35
ETF_CTX1 = 36 -- 4BPP NORMAL MAP FORMAT FOR XBOX 360
ETF_YUV = 37
ETF_YUVA = 38

SHDF_ALLOW_AO = 256
SHDF_DO_NOT_CLEAR_Z_BUFFER = 16
SHDF_ZPASS_ONLY = 8
SHDF_ALLOW_WATER = 512
SHDF_ALLOWPOSTPROCESS = 32
SHDF_NOASYNC = 1024
SHDF_ZPASS = 4
SHDF_NO_DRAWNEAR = 2048
SHDF_NO_DRAWCAUSTICS = 16384
SHDF_ALLOWHDR = 1
SHDF_STREAM_SYNC = 8192

enum --ESystemEvent
{
	-- Description:
	-- Seeds all random number generators to the same seed number, WParam will hold seed value.
	--##@{
	ESYSTEM_EVENT_RANDOM_SEED = 1,
	ESYSTEM_EVENT_RANDOM_ENABLE = 2,
	ESYSTEM_EVENT_RANDOM_DISABLE = 3,
	--##@}

	-- Description:
	--	 Changes to main window focus.
	--	 wparam is not 0 is focused, 0 if not focused
	ESYSTEM_EVENT_CHANGE_FOCUS = 10,

	-- Description:
	--	 Moves of the main window.
	--	 wparam=x, lparam=y
	ESYSTEM_EVENT_MOVE = 11,

	-- Description:
	--	 Resizes of the main window.
	--	 wparam=width, lparam=height
	ESYSTEM_EVENT_RESIZE = 12,

	-- Description:
	--	 Activation of the main window.
	--	 wparam=1/0, 1=active 0=inactive
	ESYSTEM_EVENT_ACTIVATE = 13,

	-- Description:
	--	 Main window position changed.
	ESYSTEM_EVENT_POS_CHANGED = 14,

	-- Description:
	--	 Main window style changed.
	ESYSTEM_EVENT_STYLE_CHANGED = 15,

	-- Description:
	--	 Sent before starting level, before game rules initialization and before ESYSTEM_EVENT_LEVEL_LOAD_START event
	--	 Used mostly for level loading profiling
	ESYSTEM_EVENT_LEVEL_LOAD_PREPARE = 16,

	-- Description:
	--	 Sent to start the active loading screen rendering.
	--	 wparam = ILevelInfo* ptr
	ESYSTEM_EVENT_LEVEL_LOAD_START_LOADINGSCREEN = 17,

	-- Description:
	--	 Sent before starting loading a new level.
	--	 Used for a more efficient resource management.
	ESYSTEM_EVENT_LEVEL_LOAD_START = 18,

	-- Description:
	--	 Sent after loading a level finished.
	--	 Used for a more efficient resource management.
	ESYSTEM_EVENT_LEVEL_LOAD_END = 19,

	-- Description:
	--	 Sent after precaching of the streaming system has been done
	ESYSTEM_EVENT_LEVEL_PRECACHE_START = 20,

	-- Description:
	--	Sent when level loading is completely finished with no more onscreen 
	--	movie or info rendering, and when actual gameplay can start
	ESYSTEM_EVENT_LEVEL_GAMEPLAY_START = 21,

	-- Level is unloading.
	ESYSTEM_EVENT_LEVEL_UNLOAD = 22,

	-- Summary:
	--	 Sent after level have been unloaded. For cleanup code.
	ESYSTEM_EVENT_LEVEL_POST_UNLOAD = 23,

	-- Summary:
	--	 Called when the game framework has been initialized.
	ESYSTEM_EVENT_GAME_POST_INIT = 24,

	-- Summary:
	--	 Called when the game framework has been initialized, not loading should happen in this event.
	ESYSTEM_EVENT_GAME_POST_INIT_DONE = 25,

	-- Summary:
	--	 Sent when system is shutting down.
	ESYSTEM_EVENT_SHUTDOWN = 26,

	-- Summary:
	--	 When keyboard layout changed.
	ESYSTEM_EVENT_LANGUAGE_CHANGE = 27,

	-- Description:
	--	 Toggled fullscreen.
	--	 wparam is 1 means we switched to fullscreen, 0 if for windowed
	ESYSTEM_EVENT_TOGGLE_FULLSCREEN = 28,
	ESYSTEM_EVENT_SHARE_SHADER_COMBINATIONS = 29,

	-- Summary:
	--	 Start 3D post rendering
	ESYSTEM_EVENT_3D_POST_RENDERING_START = 30,

	-- Summary:
	--	 End 3D post rendering
	ESYSTEM_EVENT_3D_POST_RENDERING_END = 31,

	-- Summary:
	--	 Called before switching to level memory heap
	ESYSTEM_EVENT_SWITCHING_TO_LEVEL_HEAP = 32,

	-- Summary:
	--	 Called after switching to level memory heap
	ESYSTEM_EVENT_SWITCHED_TO_LEVEL_HEAP = 33,

	-- Summary:
	--	 Called before switching to global memory heap
	ESYSTEM_EVENT_SWITCHING_TO_GLOBAL_HEAP = 34,

	-- Summary:
	--	 Called after switching to global memory heap
	ESYSTEM_EVENT_SWITCHED_TO_GLOBAL_HEAP = 35,

	-- Description:
	--	 Sent after precaching of the streaming system has been done
	ESYSTEM_EVENT_LEVEL_PRECACHE_END = 36,

	-- Description:
	--	 Video notifications
	--	 wparam=[0/1/2/3] : [stop/play/pause/resume]
	ESYSTEM_EVENT_VIDEO = 37,

	-- Description:
	--	 Sent if the game is paused
	ESYSTEM_EVENT_GAME_PAUSED = 38,

	-- Description:
	--	 Sent if the game is resumed
	ESYSTEM_EVENT_GAME_RESUMED = 39,

	ESYSTEM_EVENT_USER = 0x1000,
};

enum --EVarFlags
{
	VF_NULL =									0x00000000,			-- just to have one recognizable spot where the flags are located in the Register call
	VF_CHEAT =								0x00000002,			-- stays in the default state when cheats are disabled
	VF_DUMPTODISK	=						0x00000100,
	VF_READONLY	=							0x00000800,			-- can not be changed by the user
	VF_REQUIRE_LEVEL_RELOAD = 0x00001000,
	VF_REQUIRE_APP_RESTART =	0x00002000,
	VF_WARNING_NOTUSED	=			0x00004000,			-- shows warning that this var was not used in config file
	VF_COPYNAME	=							0x00008000,			-- otherwise the const char * to the name will be stored without copying the memory
	VF_MODIFIED	=							0x00010000,			-- Set when variable value modified.
	VF_WASINCONFIG	=					0x00020000,			-- Set when variable was present in config file.
	VF_BITFIELD =							0x00040000,			-- Allow bitfield setting syntax.
	VF_RESTRICTEDMODE =				0x00080000,			-- is visible and usable in restricted (normal user) console mode
	VF_INVISIBLE     =				0x00100000,			-- Invisible to the user in console
	VF_ALWAYSONCHANGE =				0x00200000,			-- Always accept variable value and call on change callback even if variable value didnt change
	VF_BLOCKFRAME =						0x00400000,			-- Blocks the execution of console commands for one frame
	VF_CONST_CVAR =					  0x00800000,			-- Set if it is a const cvar not to be set inside cfg-files
	VF_CHEAT_ALWAYS_CHECK =  	0x01000000,			-- This variable is critical to check in every hash, since it's extremely vulnerable
	VF_CHEAT_NOCHECK =  			0x02000000,		  -- This variable is set as VF_CHEAT but doesn't have to be checked/hashed since it's harmless to workaround

	-- These flags should never be set during cvar creation, and probably never set manually.
	VF_INTERNAL_FLAGS_START = 0x00000080,
	VF_NOT_NET_SYNCED_INTERNAL	= 0x00000080,			-- can be changed on client and when connecting the var not sent to the client (is set for all vars in Game/scripts/Network/cvars.txt)
	VF_INTERNAL_FLAGS_END = 0x00000080,

};

-- Whether or not a Shift key is down
kModShiftKey = 1

-- Whether or not a Control key is down
kModControlKey = 2

-- Whether or not an ALT key is down
kModAltKey = 4

-- Whether or not a meta key (Command-key on Mac, Windows-key on Win) is down
kModMetaKey = 8

-- Whether or not the key pressed is on the keypad
kModIsKeypad = 16

-- Whether or not the character input is the result of an auto-repeat timer.
kModIsAutorepeat = 32

-- Key-Down type
kTypeKeyDown = 0

-- Key-Up type
kTypeKeyUp = 1

-- Character input type
kTypeChar = 2


enum --EEfResTextures
{
	EFTT_DIFFUSE,
	EFTT_BUMP, 
	EFTT_GLOSS,
	EFTT_ENV,
	EFTT_DETAIL_OVERLAY,
	EFTT_BUMP_DIFFUSE,
	EFTT_BUMP_HEIGHT,
	EFTT_DECAL_OVERLAY,
	EFTT_SUBSURFACE,
	EFTT_CUSTOM,
	EFTT_CUSTOM_SECONDARY,
	EFTT_OPACITY,
};

enum
{
    CAIRO_OPERATOR_CLEAR = 0,

    CAIRO_OPERATOR_SOURCE = 1,
    CAIRO_OPERATOR_OVER = 2,
    CAIRO_OPERATOR_IN = 3,
    CAIRO_OPERATOR_OUT = 4,
    CAIRO_OPERATOR_ATOP = 5,

    CAIRO_OPERATOR_DEST = 6,
    CAIRO_OPERATOR_DEST_OVER = 7,
    CAIRO_OPERATOR_DEST_IN = 8,
    CAIRO_OPERATOR_DEST_OUT = 9,
    CAIRO_OPERATOR_DEST_ATOP = 10,

    CAIRO_OPERATOR_XOR = 11,
    CAIRO_OPERATOR_ADD = 12,
    CAIRO_OPERATOR_SATURATE = 13
}	--cairo operator


BASS_SAMPLE_8BITS = 1 -- 8 bit
BASS_SAMPLE_FLOAT = 256 -- 32-bit floating-point
BASS_SAMPLE_MONO = 2 -- mono
BASS_SAMPLE_LOOP = 4 -- looped
BASS_SAMPLE_3D = 8 -- 3D functionality
BASS_SAMPLE_SOFTWARE = 16 -- not using hardware mixing
BASS_SAMPLE_MUTEMAX = 32 -- mute at max distance (3D only)
BASS_SAMPLE_VAM = 64 -- DX7 voice allocation & management
BASS_SAMPLE_FX = 128 -- old implementation of DX8 effects
BASS_SAMPLE_OVER_VOL = 0x10000 -- override lowest volume
BASS_SAMPLE_OVER_POS = 0x20000 -- override longest playing
BASS_SAMPLE_OVER_DIST = 0x30000 -- override furthest from listener (3D only)

BASS_STREAM_PRESCAN = 0x20000 -- enable pin-point seeking/length (MP3/MP2/MP1)
BASS_MP3_SETPOS = BASS_STREAM_PRESCAN 
BASS_STREAM_AUTOFREE = 0x40000 -- automatically free the stream when it stop/ends
BASS_STREAM_RESTRATE = 0x80000 -- restrict the download rate of internet file streams
BASS_STREAM_BLOCK = 0x100000 -- download/play internet file stream in small blocks
BASS_STREAM_DECODE = 0x200000 -- don't play the stream, only decode (BASS_ChannelGetData)
BASS_STREAM_STATUS = 0x800000 -- give server status info (HTTP/ICY tags) in DOWNLOADPROC

BASS_MUSIC_FLOAT = BASS_SAMPLE_FLOAT 
BASS_MUSIC_MONO = BASS_SAMPLE_MONO 
BASS_MUSIC_LOOP = BASS_SAMPLE_LOOP 
BASS_MUSIC_3D = BASS_SAMPLE_3D 
BASS_MUSIC_FX = BASS_SAMPLE_FX 
BASS_MUSIC_AUTOFREE = BASS_STREAM_AUTOFREE 
BASS_MUSIC_DECODE = BASS_STREAM_DECODE 
BASS_MUSIC_PRESCAN = BASS_STREAM_PRESCAN -- calculate playback length
BASS_MUSIC_CALCLEN = BASS_MUSIC_PRESCAN 
BASS_MUSIC_RAMP = 0x200 -- normal ramping
BASS_MUSIC_RAMPS = 0x400 -- sensitive ramping
BASS_MUSIC_SURROUND = 0x800 -- surround sound
BASS_MUSIC_SURROUND2 = 0x1000 -- surround sound (mode 2)
BASS_MUSIC_FT2MOD = 0x2000 -- play .MOD as FastTracker 2 does
BASS_MUSIC_PT1MOD = 0x4000 -- play .MOD as ProTracker 1 does
BASS_MUSIC_NONINTER = 0x10000 -- non-interpolated sample mixing
BASS_MUSIC_SINCINTER = 0x800000 -- sinc interpolated sample mixing
BASS_MUSIC_POSRESET = 0x8000 -- stop all notes when moving position
BASS_MUSIC_POSRESETEX = 0x400000 -- stop all notes and reset bmp/etc when moving position
BASS_MUSIC_STOPBACK = 0x80000 -- stop the music on a backwards jump effect
BASS_MUSIC_NOSAMPLE = 0x100000 -- don't load the samples

-- Speaker assignment flags
BASS_SPEAKER_FRONT = 0x1000000 -- front speakers
BASS_SPEAKER_REAR = 0x2000000 -- rear/side speakers
BASS_SPEAKER_CENLFE = 0x3000000 -- center & LFE speakers (5.1)
BASS_SPEAKER_REAR2 = 0x4000000 -- rear center speakers (7.1)
BASS_SPEAKER_LEFT = 0x10000000 -- modifier: left
BASS_SPEAKER_RIGHT = 0x20000000 -- modifier: right

BASS_UNICODE = 0x80000000 

BASS_RECORD_PAUSE = 0x8000 -- start recording paused

-- DX7 voice allocation & management flags
BASS_VAM_HARDWARE = 1 
BASS_VAM_SOFTWARE = 2 
BASS_VAM_TERM_TIME = 4 
BASS_VAM_TERM_DIST = 8 
BASS_VAM_TERM_PRIO = 16   

BASS_MUSIC = 1
BASS_FILE = 2
BASS_URL = 3


-- BASS_ChannelIsActive return values
BASS_ACTIVE_STOPPED = 0 
BASS_ACTIVE_PLAYING = 1 
BASS_ACTIVE_STALLED = 2 
BASS_ACTIVE_PAUSED = 3 

-- Channel attributes
BASS_ATTRIB_FREQ = 1 
BASS_ATTRIB_VOL = 2 
BASS_ATTRIB_PAN = 3 
BASS_ATTRIB_EAXMIX = 4 
BASS_ATTRIB_NOBUFFER = 5 
BASS_ATTRIB_CPU = 7 
BASS_ATTRIB_SRC = 8 
BASS_ATTRIB_MUSIC_AMPLIFY = 0x100 
BASS_ATTRIB_MUSIC_PANSEP = 0x101 
BASS_ATTRIB_MUSIC_PSCALER = 0x102 
BASS_ATTRIB_MUSIC_BPM = 0x103 
BASS_ATTRIB_MUSIC_SPEED = 0x104 
BASS_ATTRIB_MUSIC_VOL_GLOBAL = 0x105 
BASS_ATTRIB_MUSIC_VOL_CHAN = 0x200 -- + channel #
BASS_ATTRIB_MUSIC_VOL_INST = 0x300 -- + instrument #

-- BASS_ChannelGetData flags
BASS_DATA_AVAILABLE = 0 -- query how much data is buffered
BASS_DATA_FLOAT = 0x40000000 -- flag: return floating-point sample data
BASS_DATA_FFT256 = 0x80000000 -- 256 sample FFT
BASS_DATA_FFT512 = 0x80000001 -- 512 FFT
BASS_DATA_FFT1024 = 0x80000002 -- 1024 FFT
BASS_DATA_FFT2048 = 0x80000003 -- 2048 FFT
BASS_DATA_FFT4096 = 0x80000004 -- 4096 FFT
BASS_DATA_FFT8192 = 0x80000005 -- 8192 FFT
BASS_DATA_FFT16384 = 0x80000006 -- 16384 FFT
BASS_DATA_FFT_INDIVIDUAL = 0x10 -- FFT flag: FFT for each channel, else all combined
BASS_DATA_FFT_NOWINDOW = 0x20 -- FFT flag: no Hanning window
BASS_DATA_FFT_REMOVEDC = 0x40 -- FFT flag: pre-remove DC bias

-- BASS_ChannelGetTags types : what's returned
BASS_TAG_ID3 = 0 -- ID3v1 tags : TAG_ID3 structure
BASS_TAG_ID3V2 = 1 -- ID3v2 tags : variable length block
BASS_TAG_OGG = 2 -- OGG comments : series of null-terminated UTF-8 strings
BASS_TAG_HTTP = 3 -- HTTP headers : series of null-terminated ANSI strings
BASS_TAG_ICY = 4 -- ICY headers : series of null-terminated ANSI strings
BASS_TAG_META = 5 -- ICY metadata : ANSI string
BASS_TAG_APE = 6 -- APE tags : series of null-terminated UTF-8 strings
BASS_TAG_MP4 = 7 -- MP4/iTunes metadata : series of null-terminated UTF-8 strings
BASS_TAG_VENDOR = 9 -- OGG encoder : UTF-8 string
BASS_TAG_LYRICS3 = 10 -- Lyric3v2 tag : ASCII string
BASS_TAG_CA_CODEC = 11 -- CoreAudio codec info : TAG_CA_CODEC structure
BASS_TAG_MF = 13 -- Media Foundation tags : series of null-terminated UTF-8 strings
BASS_TAG_WAVEFORMAT = 14 -- WAVE format : WAVEFORMATEEX structure
BASS_TAG_RIFF_INFO = 0x100 -- RIFF "INFO" tags : series of null-terminated ANSI strings
BASS_TAG_RIFF_BEXT = 0x101 -- RIFF/BWF "bext" tags : TAG_BEXT structure
BASS_TAG_RIFF_CART = 0x102 -- RIFF/BWF "cart" tags : TAG_CART structure
BASS_TAG_RIFF_DISP = 0x103 -- RIFF "DISP" text tag : ANSI string
BASS_TAG_APE_BINARY = 0x1000 -- + index #, binary APE tag : TAG_APE_BINARY structure
BASS_TAG_MUSIC_NAME = 0x10000 -- MOD music name : ANSI string
BASS_TAG_MUSIC_MESSAGE = 0x10001 -- MOD message : ANSI string
BASS_TAG_MUSIC_ORDERS = 0x10002 -- MOD order list : BYTE array of pattern numbers
BASS_TAG_MUSIC_INST = 0x10100 -- + instrument #, MOD instrument name : ANSI string
BASS_TAG_MUSIC_SAMPLE = 0x10300 -- + sample #, MOD sample name : ANSI string  