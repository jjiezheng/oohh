#include "..\mmyy.hpp"

struct my_reg
{
	const char *lib;
	const char *key;
	lua_CFunction func;
	bool meta;
}; 

static my_reg functions[5000]; // eek
static int reg_count = 1;

my_ctor::my_ctor(const char *lib_name, const char *key, lua_CFunction func, bool is_meta)
{
	my_reg lib;
		lib.lib = lib_name;
		lib.key = key;
		lib.func = func;
		lib.meta = is_meta;
	functions[reg_count] = lib;

	reg_count++;
}

void my_loadfuncs(lua_State *L)
{
	for (int i = 1; i < reg_count; i++)
	{
		auto lib = functions[i];

		if (lib.meta)
		{
			my_regentfuncs(L, lib.lib, lib.key, lib.func);
		}
		else
		{
			my_reglibfuncs(L, lib.lib, lib.key, lib.func);
		}
	}
}