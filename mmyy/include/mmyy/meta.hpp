// pushes
// getmetatable( obj )[ key ]
inline bool my_getmetafield(lua_State *L, int idx, const char *key, int expected_type)
{
	if (lua_getmetatable(L, idx)) // meta
	{
		lua_pushstring(L, key); // meta, key
		lua_rawget(L, -2); // meta, val

		lua_remove(L, -2); // val

		if (lua_type(L, -1) == expected_type)
		{
			return true;
		}

		lua_remove(L, -1); //
	}

	return false;
}

// returns
// getmetatable( obj )[ "Type" ] or "uknown_metaname"
inline const char *my_getmetaname(lua_State *L, int idx)
{
	if (lua_getmetatable(L, idx)) // meta
	{
		lua_pushstring(L, "Type"); // meta, key
		lua_rawget(L, -2); // meta, val

		lua_remove(L, -2); // val

		if (lua_type(L, -1) == LUA_TSTRING)
		{
			auto str = lua_tostring(L, -1);

			lua_remove(L, -1);

			return str;
		}

		lua_remove(L, -1); //
	}

	return "unknown_metaname";
}

// pushes
// getmetatable( obj )[ key ]( obj )
inline bool my_callmetafunction(lua_State *L, int idx, const char *key, int expected_type)
{
	if (my_getmetafield(L, idx, key, LUA_TFUNCTION)) // func
	{
		lua_pushvalue(L, idx); // func, self
		if (auto msg = my_call(L, 1, 1)) // res
		{
			lua_remove(L, -1); // res

			return false;
		}

		if (lua_type(L, -1) == expected_type)
		{
			return true;
		}

		lua_remove(L, -1); //		
	}

	return false;
}

// returns
// obj:__uniqueid() or string.format("%p", obj)
inline unsigned long long my_getuniqueid(lua_State *L, int idx)
{
	// check if the userdata's metatable has a __uniuqeid
	// function and call that to get a unique id
	if (my_callmetafunction(L, idx, "__uniqueid", LUA_TNUMBER)) // number
	{
		auto id = luaL_checkinteger(L, -1);

		lua_remove(L, -1); //

		return id;
	}

	if (lua_isuserdata(L, idx))
		return (unsigned long long int)(*(void**)lua_touserdata(L, idx));

	return (unsigned long long int)lua_topointer(L, idx);
}

// returns
// _R[ "ptrtable" ]
// if the table doesn't exist it, will create it
inline void my_getptrtable(lua_State *L)
{
	// get the registry table
	lua_getregistry(L); // _R

	// get _R["ptrtable"]
	lua_pushstring(L, "ptrtable"); // _R, "ptrtable"
	lua_rawget(L, -2); // _R, val
	
	// does it not exist?
	if (!lua_istable(L, -1))
	{
		// remove the nil value
		lua_remove(L, -1); // _R

		// create the table
		lua_pushstring(L, "ptrtable"); // _R, "ptrtable"
		lua_newtable(L); // _R, "ptrtable", {}
		lua_rawset(L, -3); // _R
		
		// rawset pops the table so we have to get it again, but this time we know it exists
		lua_pushstring(L, "ptrtable"); // _R, "ptrtable"
		lua_rawget(L, -2); // _R, val
	}

	// remove _R
	lua_remove(L, -2); // val
}

// returns
// _R[ "ptrtable" ][ id ]
// if the table doesn't exist, it pushes nothing
inline bool my_getuidtable(lua_State *L, void *udata)
{
	my_getptrtable(L); // ptrtbl
	
	lua_pushlightuserdata(L, udata); // ptrtbl, udata
	lua_rawget(L, -2); // ptrtbl, val
	
	// remove the ptr table from the stack
	lua_remove(L, -2); // val
	
	return lua_istable(L, -1);
}

inline bool my_istype(lua_State *L, int idx, const char *type) 
{ 
	return lua_type(L, idx) == 10 || strcmp(my_getmetaname(L, idx), type) == 0;
}

inline void my_makenull(lua_State *L, void *ptr)
{
	if (my_getuidtable(L, ptr))
	{
		luaL_getmetatable(L, "null_meta");
		lua_setmetatable(L, -2);	

		my_getptrtable(L);
		lua_pushlightuserdata(L, ptr);
		lua_pushnil(L);
		lua_rawset(L, -3);					
					
		lua_remove(L, -1);
	}
}