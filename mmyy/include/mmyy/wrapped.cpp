#ifdef _DEBUG
#undef _ITERATOR_DEBUG_LEVEL
#define _ITERATOR_DEBUG_LEVEL 0
#endif

#include "..\mmyy.hpp"

#include <concrt.h>

#ifdef _DEBUG
#undef _ITERATOR_DEBUG_LEVEL
#define _ITERATOR_DEBUG_LEVEL 0
#endif

static bool supress = false;

void my_suppress_lock()
{
	supress = true;
}

void my_allow_lock()
{
	supress = false;
}

Concurrency::details::_ReentrantBlockingLock lock;

const char *my_call(lua_State *L, int arguments, int results)
{
	Concurrency::details::_ReentrantBlockingLock::_Scoped_lock slock(lock);

		if (!lua_isfunction(L, -(arguments+1)))
		{
			auto err = lua_tostring(L, -1);
			lua_remove(L, -1);
			return err;
		}

		if (lua_pcall(L, arguments, results, 0) != 0)
		{	
			auto err = lua_tostring(L, -1);
			lua_remove(L, -1);
			return err;
		}


	return 0;
}