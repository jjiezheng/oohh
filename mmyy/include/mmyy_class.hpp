public:
lua_State *L;

inline void Open()
{
	if (L) { Close(); }

	L = lua_open();
	my_initstate(L);
}

inline void Close()
{

}

inline void Error(const char *str, bool halt = false)
{
	OnPrint("[lua error] ");
	OnPrint(str);
	OnPrint("\n");

	if (halt)
	{
		luaL_error(L, "%s", str);
	}
}

inline void Print(const char *str)
{
	OnPrint(str);
	OnPrint("\n");
}

// wrap

	#define WRAP_CHECK(new_name, old_name) inline bool Is##new_name(int idx) { return IsType(idx, LUA_T##old_name); }
		WRAP_CHECK(None, NONE)
		WRAP_CHECK(Nil, NIL)
		WRAP_CHECK(Boolean, BOOLEAN)
		WRAP_CHECK(LightUserData, LIGHTUSERDATA)
		WRAP_CHECK(Number, NUMBER)
		WRAP_CHECK(String, STRING)
		WRAP_CHECK(Table, TABLE)
		WRAP_CHECK(Function, FUNCTION)
		WRAP_CHECK(UserData, USERDATA)
		WRAP_CHECK(Thread, THREAD)
	#undef WRAP_CHECK

// state
	inline bool RunFile(const char *path)
	{
		if (!L) { Open(); }

		auto err = my_runfile(L, path);

		if (err)
		{
			Error(err);
			return false;
		}

		return true;
	}

	inline bool RunString(const char *str)
	{
		if (!L) { Open(); }

		auto err = my_runstring(L, str);

		if (err)
		{
			Error(err);
			return false;
		}

		return true;
	}

	inline void SetPlatformName(const char *str)
	{
		if (!L) { Open(); }

		my_setplatformname(L, str);
	}

	inline const char *GetPlatformName()
	{
		return my_getplatformname(L);
	}

	inline void SetStateName(const char *str, const char *info = "")
	{
		if (!L) { Open(); }

		my_setstatename(L, str, info);
	}

// stack
	template<typename K, typename V>
	inline bool SetMember(int idx, K key, V value, bool raw = true)
	{
		Push(key);
		Push(value);

		if (raw && my_rawset(L, idx > 0 ? idx : idx-2))
		{
			return true;
		}

		if (my_settable(L, idx > 0 ? idx : idx-2))
		{
			return true;
		}

		Remove(-1);
		Remove(-1);

		return false;
	}

	template<typename K>
	inline bool GetMember(int idx, K key, bool raw = true)
	{
		Push(L, key);

		if (raw && my_rawget(L, idx > 0 ? idx : idx-1))
		{
			return true;
		}

		if (my_gettable(L, idx > 0 ? idx : idx-1))
		{			
			return true;
		}

		Remove(-1);

		return false;
	}

	inline bool SetTable(int idx)
	{
		return my_settable(L, idx);
	}

	inline bool GetTable(int idx)
	{
		return my_gettable(L, idx);
	}

	inline bool RawSet(int idx)
	{
		return my_rawset(L, idx);
	}

	inline bool RawGet(int idx)
	{
		return my_rawget(L, idx);
	}

	inline void PushValue(int idx)
	{
		lua_pushvalue(L, idx);
	}

	inline void Remove(int idx, int times = 1)
	{
		my_remove(L, idx, times);
	}

	inline bool Call(int args_to_lua = 0, int args_to_cpp = 0)
	{
		if (!L) { Open(); }

		auto err = my_call(L, args_to_lua, args_to_cpp);

		if (err)
		{
			Error(err);
			return false;
		}

		return true;
	}

	inline const char *ToString(int idx)
	{
		return luaL_checkstring(L, idx);
	}

	inline const char *ToString(int idx, const char *def)
	{
		return luaL_optstring(L, idx, def);
	}

	inline lua_Number ToNumber(int idx, bool check = true)
	{
		return check ? luaL_checknumber(L, idx) : lua_tonumber(L, idx);
	}
	
	template<typename T>
	inline lua_Number ToNumber(int idx, T def)
	{
		return luaL_optnumber(L, idx, def);
	}

	inline void MakeNil(int idx)
	{
		my_makenil(L, idx);
	}

#define WRAP_NUM(typ) inline void Push(typ num) { lua_pushnumber(L, (lua_Number)num); }
	WRAP_NUM(char)
	WRAP_NUM(short)
	WRAP_NUM(int)
	WRAP_NUM(long)
	WRAP_NUM(float)
	WRAP_NUM(double)
	WRAP_NUM(long double)
	WRAP_NUM(wchar_t)

	WRAP_NUM(unsigned char)
	WRAP_NUM(unsigned short)
	WRAP_NUM(unsigned int)
	WRAP_NUM(unsigned long)
	WRAP_NUM(unsigned long long)
#undef WRAP_NUM

	inline void Push(const char *str)
	{
		lua_pushstring(L, str);
	}

	inline void Push(char *str)
	{
		lua_pushstring(L, (const char*)str);
	}

	inline void Push(bool b)
	{
		lua_pushboolean(L, b == true ? 1 : 0);
	}

	inline bool ToBoolean(int idx)
	{
		return lua_toboolean(L, idx) == 1;
	}

	inline bool IsTrue(int idx)
	{
		return lua_isboolean(L, idx) && lua_toboolean(L, idx) == 1;
	}

	inline bool IsFalse(int idx)
	{
		return lua_isboolean(L, idx) && lua_toboolean(L, idx) == 0;
	}

	inline bool IsType(int idx, int type)
	{
		return lua_type(L, idx) == type;
	}

	inline bool IsType(int idx, const char *type)
	{
		return my_istype(L, idx, type);
	}

	inline bool IsNoneOrNil(int idx)
	{
		return lua_isnoneornil(L, idx);
	}

	inline void NewTable()
	{
		lua_newtable(L);
	}

// hooks

	inline bool StartHook(const char *hook_event)
	{
		return my_starthook(L, hook_event);
	}

	inline bool EndHook(int args_to_lua = 0, int args_to_cpp = 0)
	{
		auto err = my_endhook(L, args_to_lua, args_to_cpp);

		if (err)
		{
			Error(err);
			return false;
		}

		return true;
	}

	template<typename T>
	inline bool StartEntityHook(T *udata, const char *hook_event)
	{
		if (!this || !L || !udata) return false;
	
		lua_settop(L, 0);

		lua_getglobal(L, "hook");
		if (lua_type(L, -1) != LUA_TTABLE)
		{
			lua_settop(L, 0);
			return false;
		}

		lua_getfield(L, -1, "UserDataCall");
		if (lua_type(L, -1) != LUA_TFUNCTION)
		{
			lua_settop(L, 0);
			return false;
		}

		lua_remove(L, 1);

		Push(udata);
		lua_pushstring(L, hook_event);

		return true;
	}

	inline bool EndEntityHook(int args_to_lua = 0, int args_to_cpp = 0)
	{
		auto err = my_endentityhook(L, args_to_lua, args_to_cpp);

		if (err)
		{
			lua_settop(L, 0);
			Error(err);
			return false;
		}

		return true;
	}

// userdata

	// pointer
	template<typename T> inline T *ToPointer(int idx, const char *meta_name, bool check = true)
	{
		return my_topointer<T>(L, idx, meta_name, check);
	}

	template<typename T> inline T *ToPointer(int idx, const char *meta_name, T *def)
	{
		return my_topointer<T>(L, idx, meta_name, def);
	}

	template<typename T> inline void Push(T *var, const char *meta_name)
	{
		my_push(L, var, meta_name);
	}

	// struct
	template<typename T> inline T ToStruct(int idx, const char *meta_name, bool check = true)
	{
		return my_tostruct<T>(L, idx, meta_name, check);
	}

	template<typename T> inline T ToStruct(int idx, const char *meta_name, T def)
	{
		return my_tostruct<T>(L, idx, meta_name, def);
	}

	template<typename T> inline T *ToStructPointer(int idx, const char *meta_name, bool check = true)
	{
		return my_tostructpointer<T>(L, idx, meta_name, check);
	}

	template<typename T> inline void Push(T var, const char *meta_name)
	{
		return my_push(L, var, meta_name);
	}

	template<typename T> inline T ToEnum(int idx)
	{
		return my_toenum<T>(L, idx);
	}

	template<typename T> inline T ToEnum(int idx, T def)
	{
		return my_toenum< T >(L, idx, def);
	}

	inline void MakeNull(void *ptr)
	{
		my_makenull(L, ptr);
	}

// hook templates
	////////////
	inline bool CallHook(
		const char*hook_name,
		int args_to_lua = 0
	)
	{
		if (!this || !L) return false;

		my_starthook(L, hook_name);

		auto err = my_endhook(L, 0, args_to_lua);

		if (err)
		{
			OnPrint(err);
			return false;
		}

		return true;
	}
	////////////
	template<
		typename T1
	>
	inline bool CallHook(
		const char*hook_name,
		T1 arg1,
		int args_to_lua = 0
	)
	{
		if (!this || !L) return false;

		my_starthook(L, hook_name);
			Push(arg1);

		auto err = my_endhook(L, 1, args_to_lua);

		if (err)
		{
			OnPrint(err);
			return false;
		}

		return true;
	}
	//////////
	template<
		typename T1,
		typename T2
	>
	inline bool CallHook(
		const char*hook_name,
		T1 arg1,
		T2 arg2,
		int args_to_lua = 0
	)
	{
		if (!this || !L) return false;

		my_starthook(L, hook_name);
			Push(arg1);
			Push(arg2);

		auto err = my_endhook(L, 2, args_to_lua);

		if (err)
		{
			OnPrint(err);
			return false;
		}

		return true;
	}
	////////
	template<
		typename T1,
		typename T2,
		typename T3
	>
	inline bool CallHook(
		const char*hook_name,
		T1 arg1,
		T2 arg2,
		T3 arg3,
		int args_to_lua = 0
	)
	{
		if (!this || !L) return false;

		my_starthook(L, hook_name);
			Push(arg1);
			Push(arg2);
			Push(arg3);

		auto err = my_endhook(L, 3, args_to_lua);

		if (err)
		{
			OnPrint(err);
			return false;
		}

		return true;
	}
	//////////
	template<
		typename T1,
		typename T2,
		typename T3,
		typename T4
	>
	inline bool CallHook(
		const char*hook_name,
		T1 arg1,
		T2 arg2,
		T3 arg3,
		T4 arg4,
		int args_to_lua = 0
	)
	{
		if (!this || !L) return false;

		my_starthook(L, hook_name);
			Push(arg1);
			Push(arg2);
			Push(arg3);
			Push(arg4);

		auto err = my_endhook(L, 4, args_to_lua);

		if (err)
		{
			OnPrint(err);
			return false;
		}

		return true;
	}
	///////
	template<
		typename T1,
		typename T2,
		typename T3,
		typename T4,
		typename T5
	>
	inline bool CallHook(
		const char*hook_name,
		T1 arg1,
		T2 arg2,
		T3 arg3,
		T4 arg4,
		T5 arg5,
		int args_to_lua = 0
	)
	{
		if (!this || !L) return false;

		my_starthook(L, hook_name);
			Push(arg1);
			Push(arg2);
			Push(arg3);
			Push(arg4);
			Push(arg5);

		auto err = my_endhook(L, 5, args_to_lua);

		if (err)
		{
			OnPrint(err);
			return false;
		}

		return true;
	}
	///////
	template<
		typename T1,
		typename T2,
		typename T3,
		typename T4,
		typename T5,
		typename T6
	>
	inline bool CallHook(
		const char*hook_name,
		T1 arg1,
		T2 arg2,
		T3 arg3,
		T4 arg4,
		T5 arg5,
		T6 arg6,
		int args_to_lua = 0
	)
	{
		if (!this || !L) return false;

		my_starthook(L, hook_name);
			Push(arg1);
			Push(arg2);
			Push(arg3);
			Push(arg4);
			Push(arg5);
			Push(arg6);

		auto err = my_endhook(L, 6, args_to_lua);

		if (err)
		{
			OnPrint(err);
			return false;
		}

		return true;
	}
	///////
	template<
		typename T1,
		typename T2,
		typename T3,
		typename T4,
		typename T5,
		typename T6,
		typename T7
	>
	inline bool CallHook(
		const char*hook_name,
		T1 arg1,
		T2 arg2,
		T3 arg3,
		T4 arg4,
		T5 arg5,
		T6 arg6,
		T7 arg7,
		int args_to_lua = 0
	)
	{
		if (!this || !L) return false;

		my_starthook(L, hook_name);
			Push(arg1);
			Push(arg2);
			Push(arg3);
			Push(arg4);
			Push(arg5);
			Push(arg6);
			Push(arg7);

		auto err = my_endhook(L, 7, args_to_lua);

		if (err)
		{
			OnPrint(err);
			return false;
		}

		return true;
	}

// entity hook templates
	////////////
	template<
		typename T
	>
	inline bool CallEntityHook(
		T udata,
		const char*hook_name,
		int args_to_lua = 0
	)
	{
		if (!this || !L || !udata) return false;

		if (!StartEntityHook(udata, hook_name)) return false;

		EndEntityHook(0, args_to_lua);

		return true;
	}
	////////////
	template<
		typename T,
		typename T1
	>
	inline bool CallEntityHook(
		T udata,
		const char*hook_name,
		T1 arg1,
		int args_to_lua = 0
	)
	{
		if (!this || !L || !udata) return false;

		if (!StartEntityHook(udata, hook_name)) return false;
			Push(arg1);

		EndEntityHook(1, args_to_lua);

		return true;
	}
	//////////
	template<
		typename T,
		typename T1,
		typename T2
	>
	inline bool CallEntityHook(
		T udata,
		const char*hook_name,
		T1 arg1,
		T2 arg2,
		int args_to_lua = 0
	)
	{
		if (!this || !L || !udata) return false;

		if (!StartEntityHook(udata, hook_name)) return false;
			Push(arg1);
			Push(arg2);

		EndEntityHook(2, args_to_lua);

		return true;
	}
	////////
	template<
		typename T,
		typename T1,
		typename T2,
		typename T3
	>
	inline bool CallEntityHook(
		T udata,
		const char*hook_name,
		T1 arg1,
		T2 arg2,
		T3 arg3,
		int args_to_lua = 0
	)
	{
		if (!this || !L || !udata) return false;

		if (!StartEntityHook(udata, hook_name)) return false;
			Push(arg1);
			Push(arg2);
			Push(arg3);

		EndEntityHook(3, args_to_lua);

		return true;
	}
	//////////
	template<
		typename T,
		typename T1,
		typename T2,
		typename T3,
		typename T4
	>
	inline bool CallEntityHook(
		T udata,
		const char*hook_name,
		T1 arg1,
		T2 arg2,
		T3 arg3,
		T4 arg4,
		int args_to_lua = 0
	)
	{
		if (!this || !L || !udata) return false;

		if (!StartEntityHook(udata, hook_name)) return false;
			Push(arg1);
			Push(arg2);
			Push(arg3);
			Push(arg4);

		EndEntityHook(4, args_to_lua);

		return true;
	}
	///////
	template<
		typename T,
		typename T1,
		typename T2,
		typename T3,
		typename T4,
		typename T5
	>
	inline bool CallEntityHook(
		T udata,
		const char*hook_name,
		T1 arg1,
		T2 arg2,
		T3 arg3,
		T4 arg4,
		T5 arg5,
		int args_to_lua = 0
	)
	{
		if (!this || !L || !udata) return false;

		if (!StartEntityHook(udata, hook_name)) return false;
			Push(arg1);
			Push(arg2);
			Push(arg3);
			Push(arg4);
			Push(arg5);

		EndEntityHook(5, args_to_lua);

		return true;
	}
	///////
	template<
		typename T,
		typename T1,
		typename T2,
		typename T3,
		typename T4,
		typename T5,
		typename T6
	>
	inline bool CallEntityHook(
		T udata,
		const char*hook_name,
		T1 arg1,
		T2 arg2,
		T3 arg3,
		T4 arg4,
		T5 arg5,
		T6 arg6,
		int args_to_lua = 0
	)
	{
		if (!this || !L || !udata) return false;

		if (!StartEntityHook(udata, hook_name)) return false;
			Push(arg1);
			Push(arg2);
			Push(arg3);
			Push(arg4);
			Push(arg5);
			Push(arg6);

		EndEntityHook(6, args_to_lua);

		return true;
	}
	///////
	template<
		typename T,
		typename T1,
		typename T2,
		typename T3,
		typename T4,
		typename T5,
		typename T6,
		typename T7
	>
	inline bool CallEntityHook(
		T udata,
		const char*hook_name,
		T1 arg1,
		T2 arg2,
		T3 arg3,
		T4 arg4,
		T5 arg5,
		T6 arg6,
		T7 arg7,
		int args_to_lua = 0
	)
	{
		if (!this || !L || !udata) return false;

		if (!StartEntityHook(udata, hook_name)) return false;
			Push(arg1);
			Push(arg2);
			Push(arg3);
			Push(arg4);
			Push(arg5);
			Push(arg6);
			Push(arg7);

		EndEntityHook(7, args_to_lua);

		if (err)
		{
			OnPrint(err);
			lua_settop(L, 0);
			return false;
		}

		return true;
	}
