template<typename T>
inline T *my_topointer(lua_State *L, int idx, const char *meta_name, bool check = true)
{
	if (check)
	{
		auto ptr = (T **)luaL_checkudata(L, idx, meta_name);
		if(*ptr != nullptr)
			return *ptr;

		luaL_typerror(L, idx, meta_name);
	}
	else
	{
		auto ptr = (T **)lua_touserdata(L, idx);
		if(*ptr != nullptr)
			return *ptr;
	}

	return nullptr;
}

template<typename T>
inline T *my_topointer(lua_State *L, int idx, const char *meta_name, T *def)
{
	auto ptr = my_topointer<T>(L, idx, meta_name, false);

	return ptr ? ptr : def;
}


namespace null_meta
{
	inline int false_func(lua_State *L)
	{
		lua_pushboolean(L, 0);

		return 1;
	}

	inline int __tostring(lua_State *L)
	{
		lua_pushstring(L, "NULL");

		return 1;
	}

	inline int __index(lua_State *L)
	{
		auto key = lua_tostring(L, 2);

		if (key && strcmp(key, "IsValid") == 0)
		{
			lua_pushcfunction(L, false_func);

			return 1;
		}

		luaL_error(L, "tried to index %s on a NULL value", key);

		return 0;
	}
}

inline void my_pushnull(lua_State *L)
{
	lua_pushvalue(L, LUA_REGISTRYINDEX); // _R
		lua_pushinteger(L, (long int)L); // _R, num
	lua_gettable(L, -2); // _R, val
	
	lua_remove(L, -2); // val

	if (lua_isnil(L, -1))
	{
		lua_remove(L, -1); //

		luaL_newmetatable(L, "null_meta"); // meta
			my_setmember(L, -1, "__index", null_meta::__index, true);
			my_setmember(L, -1, "__tostring", null_meta::__tostring, true);
		lua_remove(L, -1); //

		lua_pushvalue(L, LUA_REGISTRYINDEX); // _R
			lua_pushinteger(L, (long int)L); // _R, num
			lua_newtable(L); // _R, num, {}
		lua_settable(L, -3); // _R

		lua_pushinteger(L, (long int)L); // _R, num
		lua_gettable(L, -2); // _R, val

		luaL_getmetatable(L, "null_meta"); //, _R, val, meta
		lua_setmetatable(L, -2); // _R, val

		lua_remove(L, -2); // val
	}
}

template<typename T>
inline bool my_push(lua_State *L, T *ptr, const char *meta_name)
{
	if (ptr != nullptr)
	{
		auto box = (T **)lua_newuserdata(L, sizeof(void *)); // udata
		*box = ptr;

		luaL_getmetatable(L, meta_name); // udata, meta
		lua_setmetatable(L, -2); // udata

		return true;
	}
	
	my_pushnull(L); // udata

	return false;
}

inline bool my_pushentity(lua_State *L, const char *meta_name, unsigned long long id = 0)
{
	my_getptrtable(L); // ptrtbl
	
	lua_rawgeti(L, -1, id); // ptrtbl, val

	// doesn't exist? create it
	if (!lua_istable(L, -1))
	{
		lua_remove(L, -1); // ptrtbl

		lua_newtable(L); // ptrtbl, {}

		lua_pushstring(L, "___id"); // ptrtbl, {}, "__id"
		lua_pushinteger(L, id); // ptrtbl, {}, "__id", id
		lua_rawset(L, -3); // ptrtbl, {}

		// _R.ptrtbl[id] = {___id = id}
		lua_rawseti(L, -2, id); // ptrtbl

		lua_remove(L, -1); //
	}

	lua_newtable(L); // {}
	luaL_getmetatable(L, meta_name);  // {}, meta
	lua_setmetatable(L, -2); // {}
		
	return true;
}

template<typename T>
inline T my_tostruct(lua_State *L, int idx, const char *meta_name, bool check = true)
{
	T var;

	if (check)
	{
		if (lua_type(L, idx) == 10)
		{
			var = *(T *)lua_topointer(L, idx);
		}
		else
		{
			var = *(T *)luaL_checkudata(L, idx, meta_name);
		}
	}
	else
	{
		if (lua_type(L, idx) == 10)
		{
			var = *(T *)lua_topointer(L, idx);
		}
		else
		{
			var = *(T *)lua_touserdata(L, idx);
		}
	}

	return var;
}

template<typename T>
inline T my_tostruct(lua_State *L, int idx, const char *meta_name, T def)
{
	if (my_istype(L, idx, meta_name))
		return my_tostruct<T>(L, idx, meta_name, false);

	return def;
}

template<typename T>
inline T *my_tostructpointer(lua_State *L, int idx, const char *meta_name, bool check = true)
{
	if (check)
	{
		if (lua_type(L, idx) == 10)
		{
			auto ptr = (T *)lua_topointer(L, idx);

			if(ptr != nullptr)
				return ptr;
		}
		else
		{
			auto ptr = (T *)luaL_checkudata(L, idx, meta_name);

			if(ptr != nullptr)
				return ptr;
		}

		luaL_typerror(L, idx, meta_name);
	}
	else
	{
		if (lua_type(L, idx) == 10)
		{
			return (T *)lua_topointer(L, idx);
		}
		else
		{
			return (T *)lua_touserdata(L, idx);
		}
	}

	return nullptr;
}

template<typename T>
inline T *my_tostructpointer(lua_State *L, int idx, const char *meta_name, T *def)
{
	if (my_istype(L, idx, meta_name))
		return my_tostructpointer<T>(L, idx, meta_name, false);

	return def;
}

template<typename T>
inline void my_push(lua_State *L, T var, const char *meta_name)
{
	T *ptr = (T *)lua_newuserdata(L, sizeof(T));
	*ptr = var;

	luaL_getmetatable(L, meta_name);
	lua_setmetatable(L, -2);

	//lua_pushlightuserdata(L, &var);
}
