template<typename K, typename V>
inline bool my_setmember(lua_State *L, int idx, K key, V value, bool raw = true)
{
	my_push(L, key);
	my_push(L, value);

	if (raw && my_rawset(L, idx-2))
	{
		return true;
	}

	return my_settable(L, idx-2);
}

template<typename K>
inline bool my_getmember(lua_State *L, int idx, K key, bool raw = true)
{
	my_push(L, key);

	if (raw && my_rawget(L, idx > 0 ? idx : idx-2))
	{
		return true;
	}

	return my_gettable(L, idx-2);
}

inline bool my_settable(lua_State *L, int idx)
{
	if (lua_istable(L, idx) || lua_isuserdata(L, idx))
	{
		lua_settable(L, idx);

		return true;
	}

	return false;
}
inline bool my_gettable(lua_State *L, int idx)
{
	if (lua_istable(L, idx) || lua_isuserdata(L, idx))
	{
		lua_gettable(L, idx);

		return true;
	}

	return false;
}
inline bool my_rawset(lua_State *L, int idx)
{
	if (lua_istable(L, idx) || lua_isuserdata(L, idx))
	{
		lua_rawset(L, idx);

		return true;
	}

	return false;
}
inline bool my_rawget(lua_State *L, int idx)
{
	if (lua_istable(L, idx) || lua_isuserdata(L, idx))
	{
		lua_rawget(L, idx);

		return true;
	}

	return false;
}