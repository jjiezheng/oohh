// returns
// getmetatable( obj )[ "Type" ] or "uknown_metaname"
inline const char *my_getmetaname(lua_State *L, int idx)
{
	if (lua_getmetatable(L, idx)) // meta
	{
		lua_pushstring(L, "Type"); // meta, "Type"
		lua_rawget(L, -2); // meta, val

		lua_remove(L, -2); // val

		if (lua_type(L, -1) == LUA_TSTRING)
		{
			auto temp = lua_tostring(L, -1);

			lua_remove(L, -1); //

			if (temp)
			{
				return temp;
			}
		}

		lua_remove(L, -1); //
	}

	return "uknown_metaname";
}

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
	// if it's not a userdata, get the address of the non userdata
	if (lua_type(L, idx) != LUA_TUSERDATA)
		return (unsigned long long)lua_topointer(L, idx); 

	// check if the userdata's metatable has a __uniuqeid
	// function and call that to get a unique id
	if (my_callmetafunction(L, idx, "__uniqueid", LUA_TNUMBER)) // number
	{
		auto id = luaL_checkinteger(L, -1);

		lua_remove(L, -1); //

		return id;
	}

	// if it does not have ent.__uniqueid
	// just get the address which our userdata  points to
	return (unsigned long long)(*(void**)lua_touserdata(L, idx));
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
inline bool my_getuidtable(lua_State *L, unsigned long long id = 0)
{
	my_getptrtable(L); // ptrtbl
	
	// ptrtbl[id]
	lua_rawgeti(L, -1, id); // ptrtbl, val

	// is this not a table?
	if (lua_type(L, -1) != LUA_TTABLE)
	{
		// remove it
		lua_remove(L, -1); // ptrtbl

		// create it
		lua_newtable(L); // ptrtbl, table

		lua_pushvalue(L, -1); // ptrtbl, table, table

		// pops the newly created table only
		lua_rawseti(L, -3, id); // ptrtbl, table
	}

	// remove the ptr table from the stack
	lua_remove(L, -2); // table

	// push the table
	return true;
}

// returns
// _R[ "ptrtable" ][ obj:__uniqueid() ]
// if the table doesn't exist, it will create it
inline bool my_getentitytable(lua_State *L, int idx)
{
	// maybe put a warning here since this is only supposed to be called on userdata
	if (lua_type(L, idx) != LUA_TUSERDATA)
		return false;

	auto id = my_getuniqueid(L, idx);

	// does the uid table not exist?
	if (!my_getuidtable(L, id)) // uidtable
	{
		// if so create it
		my_getptrtable(L); // ptrtable 
			lua_newtable(L); // ptrtable, {}
			lua_pushvalue(L, -1); // ptrtable, {}, {}
		lua_rawseti(L, -3, id); // ptrtable, {}

		// remove the ptr table from the stack
		lua_remove(L, -2); // {}
	}

	return true;
}

// pushes
// obj[ key ]
// this won't look up in the meta table!
inline bool my_getentityfield(lua_State *L, int idx, const char *key, int expected_type)
{
	if (my_getentitytable(L, idx)) // enttbl
	{
		lua_pushstring(L, key); // enttbl, key
		lua_rawget(L, -2); // enttbl, val

		lua_remove(L, -2); // val

		if (lua_type(L, -1) == expected_type)
		{
			return true;
		}

		lua_remove(L, -1); //
	}

	return false;
}

inline bool my_istype(lua_State *L, int idx, const char *type) 
{ 
	return strcmp(my_getmetaname(L, idx), type) == 0; 
}