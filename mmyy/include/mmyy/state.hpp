void my_loadfuncs(lua_State *L);

inline void my_reglibfuncs(lua_State *L, const char *lib, const char *name, lua_CFunction func)
{
	lua_settop(L, 0);

	if (strcmp(lib, "_G") == 0)
	{
		lua_pushcfunction(L, func);
		lua_setfield(L, LUA_GLOBALSINDEX, name);
	}
	else
	{
		lua_getfield(L, LUA_GLOBALSINDEX, lib);

		if (!lua_istable(L, -1))
		{
			lua_remove(L, -1);
			lua_newtable(L);
			lua_setfield(L, LUA_GLOBALSINDEX, lib);

			lua_settop(L, 0);

			lua_getfield(L, LUA_GLOBALSINDEX, lib);
		}

		lua_pushcfunction(L, func);
		lua_setfield(L, -2, name);
	}

	lua_settop(L, 0);
}
inline void my_regentfuncs(lua_State *L, const char *meta, const char *name, lua_CFunction func)
{
	luaL_getmetatable(L, meta);

	if (lua_isnoneornil(L, -1))
	{
		lua_remove(L, -1);

		luaL_newmetatable(L, meta);
			my_setmember(L, -1, "Type", meta, true);

			my_setmember(L, -1, "__eq", default_meta::__eq, true);
			my_setmember(L, -1, "__tostring", default_meta::__tostring, true);
			my_setmember(L, -1, "__index", default_meta::__index, true);
			
			my_setmember(L, -1, "IsValid", default_meta::IsValid, true);
	}

	my_setmember(L, -1, name, func, true);
}

inline const char *my_runfile(lua_State *L, const char *path)
{
	if (luaL_loadfile(L, path))
	{
		return lua_tostring(L, -1);
	}

	
	return my_call(L, 0, 0);
}

inline const char *my_runstring(lua_State *L, const char *str)
{
	if (luaL_loadstring(L, str))
	{
		return lua_tostring(L, -1);
	}
	
	return my_call(L, 0, 0);
}

inline void my_setstatename(lua_State *L, const char *key, const char *var)
{
	lua_pushvalue(L, LUA_GLOBALSINDEX);
		lua_pushstring(L, key);
		lua_pushstring(L, var);
	lua_settable(L, -3);
	lua_remove(L, -1);
}

inline void my_setplatformname(lua_State *L, const char *name)
{
	lua_pushvalue(L, LUA_GLOBALSINDEX);
		lua_pushstring(L, "MMYY_PLATFORM");
		lua_pushstring(L, name);
	lua_settable(L, -3);
	lua_remove(L, -1);
}

inline const char *my_getplatformname(lua_State *L)
{
	lua_getglobal(L, "MMYY_PLATFORM");

	auto name = lua_tostring(L, -1);
	lua_remove(L, -1);

	return name;
}

inline void my_initstate(lua_State* L)
{
	luaL_openlibs(L);
	luaopen_ffi(L);
	luaopen_bit(L);
	luaopen_jit(L);

	my_loadfuncs(L);

	lua_pushvalue(L, LUA_GLOBALSINDEX);
		lua_pushstring(L, "_R");
		lua_pushvalue(L, LUA_REGISTRYINDEX);
	lua_settable(L, -3);
	lua_remove(L, -1);
}	