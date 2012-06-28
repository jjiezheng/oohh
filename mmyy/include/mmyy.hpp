#ifndef MMYY_HPP
#define MMYY_HPP

#include "lua/lua.hpp"
#include <string.h>

class my_ctor
{
public:
	my_ctor(const char *lib_name, const char *key, lua_CFunction func, bool is_meta);
};

#include "mmyy/wrapped.hpp"
#include "mmyy/table.hpp"
#include "mmyy/hook.hpp"
#include "mmyy/meta.hpp"
#include "mmyy/userdata.hpp"
#include "mmyy/default_meta.hpp"
#include "mmyy/state.hpp"

#include "mmyy/vector_macros.hpp"

#define MMYY_WRAP_NUMBER(friendly_name, type_name) \
    type_name To##friendly_name(int idx) { return (type_name)luaL_checknumber(L, idx); }\
    type_name To##friendly_name(int idx, type_name def) { return (type_name)luaL_optnumber(L, idx, def); }

#define MMYY_WRAP_CLASS(class_name, to_name, meta_name) \
	void Push(class_name *var) \
	{ \
		Push(var, #meta_name); \
	} \
	class_name *To##to_name(int idx, bool check = true) \
	{ \
		return ToPointer<class_name>(idx, #meta_name, check); \
	} \
	class_name *To##to_name(int idx, class_name *def) \
	{ \
		return ToPointer<class_name>(idx, #meta_name, def); \
	} \
	bool Is##to_name(int idx) \
	{ \
		return IsType(idx, #meta_name); \
	}

#define MMYY_WRAP_CLASS_NO_PUSH(class_name, to_name, meta_name) \
	class_name *To##to_name(int idx, bool check = true) \
	{ \
		return ToPointer<class_name>(idx, #meta_name, check); \
	} \
	class_name *To##to_name(int idx, class_name *def) \
	{ \
		return ToPointer<class_name>(idx, #meta_name, def); \
	} \
	bool Is##to_name(int idx) \
	{ \
		return IsType(idx, #meta_name); \
	}


#define MMYY_WRAP_STRUCT(class_name, to_name, meta_name) \
	void Push(class_name var) \
	{ \
		Push<class_name>(var, #meta_name); \
	} \
	void Push(class_name *var) \
	{ \
		Push<class_name>(var, #meta_name); \
	} \
	class_name To##to_name(int idx, bool check = true) \
	{ \
		return ToStruct<class_name>(idx, #meta_name, check); \
	} \
	class_name To##to_name(int idx, class_name def) \
	{ \
		return ToStruct<class_name>(idx, #meta_name, def); \
	} \
	class_name *To##to_name##Ptr(int idx, bool check = true) \
	{ \
		return ToStructPointer<class_name>(idx, #meta_name, check); \
	} \
	bool Is##to_name(int idx) \
	{ \
		return IsType(idx, #meta_name); \
	}

#define MMYY_FUNCTION(lib, name, is_meta) \
	int lualib_##lib##_##name(lua_State* L); \
	static my_ctor lib##name##is_meta(#lib, #name, lualib_##lib##_##name, is_meta); \
	int lualib_##lib##_##name(lua_State* L)

#define LUAMTA_FUNCTION(meta_name, func_name) MMYY_FUNCTION(meta_name, func_name, true)
#define LUALIB_FUNCTION(lib_name, func_name) MMYY_FUNCTION(lib_name, func_name, false)

#define MMYY_CLASS_HELPER template <typename T> void my_push(L, T var) { my_push(L, var); }

// disable possible loss of data warnings for numbers
#pragma warning(disable : 4244)

#endif //MMYY_HPP