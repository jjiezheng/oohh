namespace default_meta
{
	inline int IsValid(lua_State *L)
	{
		lua_pushboolean(L, 1);

		return 1;
	}
	inline int __tostring(lua_State *L)
	{
		auto name = my_getmetaname(L, 1);
		auto id = my_getuniqueid(L, 1);

		lua_pushfstring(L, "[%s][%li]", name, id);

		return 1;
	}
	inline int __index(lua_State *L)
	{
		// _R[metaname][key]
		if (lua_getmetatable(L, 1))
		{
			lua_pushvalue(L, 2);

			// use rawget here instead to prevent stack overflow
			if (my_rawget(L, -2) && !lua_isnoneornil(L, -1))
				return 1;

			lua_remove(L, -1);
		}
		
		return 0;
	}
	inline int __eq(lua_State *L)
	{
		auto a = my_getuniqueid(L, 1);
		auto b = my_getuniqueid(L, 2);

		lua_pushboolean(L, (a && b) && a == b);

		return 1;
	}
	inline int ___gc(lua_State *L)
	{
		//TODO
		return 0;
	}
}