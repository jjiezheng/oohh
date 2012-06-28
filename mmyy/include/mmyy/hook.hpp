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
	if (!L) return false;
	
	lua_settop(L, 0);

	lua_getglobal(L, "hook");
	if (my_istype(L, -1) != LUA_TTABLE)
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

	my_push(L, udata);
	lua_pushstring(L, hook_event);

	return true;
}

inline const char *my_endentityhook(lua_State *L, int args_to_lua, int args_to_cpp)
{
	if (!L) return false;

	return my_call(L, args_to_lua + 2, args_to_cpp);
}
