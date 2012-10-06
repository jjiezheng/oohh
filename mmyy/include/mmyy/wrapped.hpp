#define WRAP_NUM(typ) inline void my_push(lua_State *L, typ num) { lua_pushnumber(L, (lua_Number)num); }
	WRAP_NUM(char)
	WRAP_NUM(short)
	WRAP_NUM(int)
	WRAP_NUM(long)
	WRAP_NUM(float)
	WRAP_NUM(double)
	WRAP_NUM(long double)
	WRAP_NUM(wchar_t)

	WRAP_NUM(unsigned char)
	WRAP_NUM(unsigned short)
	WRAP_NUM(unsigned int)
	WRAP_NUM(unsigned long)
#undef WRAP_NUM

inline void my_push(lua_State *L, bool b) { lua_pushboolean(L, b ? 1 : 0); }
inline void my_push(lua_State *L, const char *str) { lua_pushstring(L, str); }
inline void my_push(lua_State *L, lua_CFunction var) { lua_pushcfunction(L, var); }

template<typename T>inline T my_toenum(lua_State *L, int idx) { return (T)luaL_checkinteger(L, idx); }
template<typename T>inline T my_toenum(lua_State *L, int idx, T def) { return (T)luaL_optinteger(L, idx, def); }

inline void my_remove(lua_State *L, int idx, int times = 1)
{
	if (times > 1)
	{
		for (int i=1; i <= times; i++)
		{
			lua_remove(L, idx);
		}
	}
	else
	{
		lua_remove(L, idx);
	}
}

const char *my_call(lua_State *L, int arguments, int results);
void my_suppress_lock();
void my_allow_lock();
