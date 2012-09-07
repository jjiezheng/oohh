namespace default_meta
{
	inline int IsValid(lua_State *L)
	{
		lua_pushboolean(L, 1);

		return 1;
	}
	inline int GetUniqueID(lua_State *L)
	{
		lua_pushinteger(L, my_getuniqueid(L, 1));

		return 1;
	}
	inline int SetTable(lua_State *L)
	{
		lua_pushinteger(L, my_getuniqueid(L, 1));
		lua_pushvalue(L, 2);
		lua_rawset(L, LUA_REGISTRYINDEX);

		return 0;
	}
	inline int GetTable(lua_State *L)
	{
		my_getentitytable(L, 1);

		return 1;
	}

	inline int __tostring(lua_State *L)
	{
		auto name = my_getmetaname(L, 1);
		auto id = my_getuniqueid(L, 1);

		lua_pushfstring(L, "[%s][%i]", name, id);

		return 1;
	}
	inline int __index(lua_State *L)
	{
		// self, key
		// _R[touniqueid(self)]
		if (my_getentitytable(L, 1))
		{
			// self, key, ent table
			// push the key
			lua_pushvalue(L, 2);
			
			// self, key, ent table, key
			// use gettable here to trigger __index on the entity's user table!
			lua_gettable(L, -2);
			
			// self, key, ent table, value
			if (!lua_isnil(L, -1))
				return 1;

			// remove nil from stack
			lua_remove(L, -1);
	
			// self, key, ent table
			// check for null
			if (lua_getmetatable(L, -1))
			{
				// self, key, ent table, ent meta
				luaL_getmetatable(L, "null_meta");

				// self, key, ent table, ent meta, null meta
				// if this usertable has the null meta, don't continue
				if (lua_equal(L, -1, -2))
				{
					return 0;
				}

				// self, key, ent table, ent meta, null meta
				// if not remove the null meta from stack
				lua_remove(L, -1);

				// self, key, ent table, ent meta
				// remove the metatable from stack
				lua_remove(L, -1);
			}

			// self, key
			// remove the entity table from stack
			lua_remove(L, -1);
		}
		
		// _R[metaname][key]
		if (lua_getmetatable(L, 1))
		{
			lua_pushvalue(L, 2);

			// use rawget here instead to prevent stack overflow
			if (my_rawget(L, -2) && !lua_isnoneornil(L, -1))
				return 1;

			lua_remove(L, -1);
		}

		// __luaindex
		if (my_getentitytable(L, 1))
		{
			lua_pushstring(L, "__luaindex");

			if (my_rawget(L, -2) && !lua_isnoneornil(L, -1))
				return 1;

			lua_remove(L, -1);
		}

		return 0;
	}
	inline int __newindex(lua_State *L)
	{
		if (my_getentitytable(L, 1))
		{
			lua_pushvalue(L, 2);
			lua_pushvalue(L, 3);
			lua_settable(L, -3);
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