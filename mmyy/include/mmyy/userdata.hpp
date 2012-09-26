template<typename T>
inline T *my_topointer(lua_State *L, int idx, const char *meta_name, bool check = true)
{
	if (idx > 100)
	{
		lua_pushstring(L, "?!?!?!!??!?!?!!?!!?!?!?!?!!?!?!!!!!!!!!!???????????????????!?!!?!?!?!");
		lua_error(L);
	}

	if (lua_istable(L, idx))
	{
		lua_getfield(L, idx, "Type"); //val

		if (strcmp(lua_tostring(L, -1), meta_name) == 0)
		{
			lua_remove(L, -1); //

			lua_getfield(L, idx, "__ptr"); // val

			if (lua_islightuserdata(L, -1))
			{
				auto ptr = (T *)lua_touserdata(L, -1);
				if (ptr)
				{
					lua_remove(L, -1); //

					return ptr;
				}
			}
			else
			{
				lua_remove(L, -1); // 
			}
		}
		else
		{
			lua_remove(L, -1); //
		}
	}

	if (check)
	{
		luaL_typerror(L, idx, meta_name);
	}

	return nullptr;
}

template<typename T>
inline T *my_topointer(lua_State *L, int idx, const char *meta_name, T *def)
{
	auto ptr = my_topointer<T>(L, idx, meta_name, false);

	return ptr ? ptr : def;
}

template<typename T>
inline bool my_push(lua_State *L, T *ptr, const char *meta_name)
{
	if (ptr != nullptr)
	{
		my_getptrtable(L); // ptrtbl
	
		lua_pushlightuserdata(L, ptr); // ptrtbl, ptr
		lua_rawget(L, -2); // ptrtbl, val

		if (!lua_istable(L, -1))
		{
			// remove nil
			lua_remove(L, -1); // ptrtbl

			// create the table
			lua_newtable(L); // ptrtbl, {}

			// make a value with the key __ptr inside the table containing the pointer to the table for refference
			lua_pushstring(L, "__ptr"); // ptrtbl, {}, "__id"
			lua_pushlightuserdata(L, ptr); // ptrtbl, {}, "__id", ptr
			lua_rawset(L, -3); // ptrtbl, {}

			luaL_getmetatable(L, meta_name);  // ptrtbl, {}, meta
			lua_setmetatable(L, -2); // ptrtbl, {}

			lua_pushlightuserdata(L, ptr); // ptrtbl, {}, ptr
			lua_pushvalue(L, -2); // ptrtbl, {}, ptr, {}
			lua_rawset(L, -4); // ptrtbl, {}

			lua_remove(L, -2);			
		}
		else
		{
			lua_remove(L, -2);
		}
	
		return true;
	}
	
	my_pushnull(L); // udata

	return false;
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
		lua_pushlightuserdata(L, L); // _R, num
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
			lua_pushlightuserdata(L, L); // _R, num
			lua_newtable(L); // _R, num, {}
		lua_settable(L, -3); // _R

		lua_pushlightuserdata(L, L); // _R, num
		lua_gettable(L, -2); // _R, val

		luaL_getmetatable(L, "null_meta"); //, _R, val, meta
		lua_setmetatable(L, -2); // _R, val

		lua_remove(L, -2); // val
	}
}
