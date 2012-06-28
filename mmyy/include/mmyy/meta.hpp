// returns
// getmetatable( obj )[ "Type" ] or "uknown_metaname"
inline const char *my_getmetaname(lua_State *L, int idx)
{
	if (lua_getmetatable(L, idx))
	{
		lua_pushstring(L, "Type");
		lua_rawget(L, -2);

		lua_remove(L, -2);

		if (lua_type(L, -1) == LUA_TSTRING)
		{
			auto temp = lua_tostring(L, -1);

			lua_remove(L, -1);

			if (temp)
			{
				return temp;
			}
		}
	}

	return "uknown_metaname";
}

// pushes
// getmetatable( obj )[ key ]
inline bool my_getmetafield(lua_State *L, int idx, const char *key, int expected_type)
{
	if (lua_getmetatable(L, idx))
	{
		lua_pushstring(L, key);
		lua_rawget(L, -2);

		lua_remove(L, -2);

		if (lua_type(L, -1) == expected_type)
		{
			return true;
		}

		lua_remove(L, -1);
	}

	return false;
}

// pushes
// getmetatable( obj )[ key ]( obj )
inline bool my_callmetafunction(lua_State *L, int idx, const char *key, int expected_type)
{
	if (my_getmetafield(L, idx, key, LUA_TFUNCTION))
	{
		lua_pushvalue(L, idx);
		lua_call(L, 1,1);

		if (lua_type(L, -1) == expected_type)
		{
			return true;
		}

		lua_remove(L, -1);
	}

	return false;
}

// returns
// obj:__uniqueid() or string.format("%p", obj)
inline unsigned long long my_getuniqueid(lua_State *L, int idx)
{
	// if it's not a userdata, get the address of the non userdata
	if (lua_type(L, idx) != LUA_TUSERDATA)
		return (unsigned long long)lua_topointer(L, idx); 

	// check if the userdata's metatable has a __uniuqeid
	// function and call that to get a unique id
	if (my_callmetafunction(L, idx, "__uniqueid", LUA_TNUMBER))
	{
		auto id = luaL_checkinteger(L, -1);

		lua_remove(L, -1);

		return id;
	}

	// if it does not have ent.__uniqueid
	// just get the address which our userdata  points to
	return (unsigned long long)(*(void**)lua_touserdata(L, idx));
}

// returns
// _R[ "ptrtable" ]
// if the table doesn't exist it, will create it
inline bool my_getptrtable(lua_State *L)
{
	lua_getregistry(L);

	lua_pushstring(L, "ptrtable");
	lua_rawget(L, -2);
	
	if (lua_isnil(L, -1))
	{
		lua_remove(L, -1);

		lua_pushstring(L, "ptrtable");
		lua_newtable(L);
		lua_rawset(L, -3);
	}

	return true;
}

// returns
// _R[ "ptrtable" ][ id ]
// if the table doesn't exist, it pushes nothing
inline bool my_getuidtable(lua_State *L, unsigned long long id = 0)
{
	if (!my_getptrtable(L)) return false;
	
	lua_rawgeti(L, -1, id);

	if (lua_type(L, -1) != LUA_TTABLE)
	{
		lua_remove(L, -1);

		return false;
	}

	return true;
}

// returns
// _R[ "ptrtable" ][ obj:__uniqueid() ]
// if the table doesn't exist, it will create it
inline bool my_getentitytable(lua_State *L, int idx)
{
	if (lua_type(L, idx) != LUA_TUSERDATA)
		return false;

	auto id = my_getuniqueid(L, idx);

	if (!my_getuidtable(L, id))
	{
		if (!my_getptrtable(L)) return false;
			lua_newtable(L);
		lua_rawseti(L, -2, id);

		if (!my_getptrtable(L)) return false;
		lua_rawgeti(L, -1, id);
	}

	return true;
}

// pushes
// obj[ key ]
// this won't look up in the meta table!
inline bool my_getentityfield(lua_State *L, int idx, const char *key, int expected_type)
{
	if (my_getentitytable(L, idx))
	{
		lua_pushstring(L, key);
		lua_rawget(L, -2);

		lua_remove(L, -2);

		if (lua_type(L, -1) == expected_type)
		{
			return true;
		}

		lua_remove(L, -1);
	}

	return false;
}

inline bool my_istype(lua_State *L, int idx, const char *type) 
{ 
	return strcmp(my_getmetaname(L, idx), type) == 0; 
}