inline bool my_starthook(lua_State *L, const char *hook_event)
{
	if (!L) return false;
	
	lua_settop(L, 0);

	lua_getglobal(L, "hook");
	if (lua_type(L, -1) != LUA_TTABLE)
	{
		lua_settop(L, 0);
		return false;
	}

	lua_getfield(L, -1, "Call");
	if (lua_type(L, -1) != LUA_TFUNCTION)
	{
		lua_settop(L, 0);
		return false;
	}

	lua_remove(L, -2);

	lua_pushstring(L, hook_event);

	return true;
}

inline const char *my_endhook(lua_State *L, int args_to_lua, int args_to_cpp)
{	
	if (!L) return false;

	return my_call(L, args_to_lua + 1, args_to_cpp);
}

template<typename T>
inline bool my_startentityhook(lua_State *L, T *udata, const char *hook_event)
{
	if (!L || !udata) return false;
		
	lua_settop(L, 0);

	if (my_getuidtable(L, udata)) // enttbl
	{
		lua_getfield(L, -1, hook_event); // enttbl, val

		if (lua_isfunction(L, -1))
		{
			my_push(udata); // enttbl, val, func, udata
			return true;
		}

		lua_remove(L, -1); // enttbl
	}

	lua_remove(L, 1); //

	return false;
}

inline const char *my_endentityhook(lua_State *L, int args_to_lua, int args_to_cpp)
{
	if (!L) return false;

	return my_call(L, args_to_lua + 1, args_to_cpp);
}
