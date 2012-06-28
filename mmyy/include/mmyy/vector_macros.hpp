// VEC4

#define _MMYY_DECLARE_VEC4_OPERATOR(\
	_CLASS_, \
	_FUNC_NAME_, \
	_OPERATOR_, \
	_CONSTRUCTOR_, \
	_META_NAME_, \
	_NUM_TYPE_, \
	_X_, \
	_Y_, \
	_Z_, \
	_W_ \
)\
	LUAMTA_FUNCTION(_META_NAME_, _FUNC_NAME_)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		if (lua_type(L, 2) == LUA_TNUMBER)\
		{\
			auto b = luaL_checknumber(L, 2);\
\
			my_push(L, _CONSTRUCTOR_(\
				(_NUM_TYPE_)a->_X_ _OPERATOR_ (_NUM_TYPE_)b,\
				(_NUM_TYPE_)a->_Y_ _OPERATOR_ (_NUM_TYPE_)b,\
				(_NUM_TYPE_)a->_Z_ _OPERATOR_ (_NUM_TYPE_)b,\
				(_NUM_TYPE_)a->_W_ _OPERATOR_ (_NUM_TYPE_)b\
			), #_META_NAME_);\
			return 1;\
		}\
\
		if (my_istype(L, 2, #_META_NAME_))\
		{\
			auto b = my_tostructpointer<_CLASS_>(L, 2, #_META_NAME_);\
\
			my_push(L, _CONSTRUCTOR_(\
				(_NUM_TYPE_)a->_X_ _OPERATOR_ (_NUM_TYPE_)b->_X_,\
				(_NUM_TYPE_)a->_Y_ _OPERATOR_ (_NUM_TYPE_)b->_Y_,\
				(_NUM_TYPE_)a->_Z_ _OPERATOR_ (_NUM_TYPE_)b->_Z_,\
				(_NUM_TYPE_)a->_W_ _OPERATOR_ (_NUM_TYPE_)b->_W_\
			), #_META_NAME_);\
\
			return 1;\
		}\
\
		return 0;\
	}

#define MMYY_VEC4_TEMPLATE(\
	_CLASS_,\
	_CONSTRUCTOR_,\
	_META_NAME_,\
	_NUM_TYPE_,\
	_POW_FUNC_,\
	_POW_TYPE_,\
	_X_,\
	_Y_,\
	_Z_,\
	_W_\
)\
\
	_MMYY_DECLARE_VEC4_OPERATOR(_CLASS_, __add, +, _CONSTRUCTOR_, _META_NAME_, _NUM_TYPE_, \
		_X_, \
		_Y_, \
		_Z_,\
		_W_\
	)\
	_MMYY_DECLARE_VEC4_OPERATOR(_CLASS_, __sub, -, _CONSTRUCTOR_, _META_NAME_, _NUM_TYPE_, \
		_X_, \
		_Y_, \
		_Z_,\
		_W_\
	)\
	_MMYY_DECLARE_VEC4_OPERATOR(_CLASS_, __div, /, _CONSTRUCTOR_, _META_NAME_, _NUM_TYPE_, \
		_X_, \
		_Y_, \
		_Z_,\
		_W_\
	)\
	_MMYY_DECLARE_VEC4_OPERATOR(_CLASS_, __mul, *, _CONSTRUCTOR_, _META_NAME_, _NUM_TYPE_, \
		_X_, \
		_Y_, \
		_Z_,\
		_W_\
	)\
	_MMYY_DECLARE_VEC4_OPERATOR(_CLASS_, __mod, %, _CONSTRUCTOR_, _META_NAME_, int, \
		_X_, \
		_Y_, \
		_Z_,\
		_W_\
	)\
\
	LUAMTA_FUNCTION(_META_NAME_, Unpack)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		lua_pushnumber(L, a->_X_);\
		lua_pushnumber(L, a->_Y_);\
		lua_pushnumber(L, a->_Z_);\
		lua_pushnumber(L, a->_W_);\
\
		return 4;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, Copy)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		my_push(L, _CONSTRUCTOR_(\
			a->_X_, \
			a->_Y_, \
			a->_Z_,\
			a->_W_\
		), #_META_NAME_);\
\
		return 1;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, __eq)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
		auto b = my_tostructpointer<_CLASS_>(L, 2, #_META_NAME_);\
\
		my_push(L, \
				a->_X_ == b->_X_ &&\
				a->_Y_ == b->_Y_ &&\
				a->_Z_ == b->_Z_ &&\
				a->_W_ == b->_W_\
			);\
\
		return 1;\
	}\
	LUAMTA_FUNCTION(_META_NAME_, __pow)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		if (lua_type(L, 2) == LUA_TNUMBER)\
		{\
			auto b = luaL_checknumber(L, 2);\
\
			my_push(L, _CONSTRUCTOR_(\
				(_NUM_TYPE_)_POW_FUNC_(a->_X_, (_NUM_TYPE_)b),\
				(_NUM_TYPE_)_POW_FUNC_(a->_Y_, (_NUM_TYPE_)b),\
				(_NUM_TYPE_)_POW_FUNC_(a->_Z_, (_NUM_TYPE_)b),\
				(_NUM_TYPE_)_POW_FUNC_(a->_W_, (_NUM_TYPE_)b)\
			), #_META_NAME_);\
			return 1;\
		}\
		if (my_istype(L, 2, #_META_NAME_))\
		{\
			auto b = my_tostructpointer<_CLASS_>(L, 2, #_META_NAME_);\
\
			my_push(L, _CONSTRUCTOR_(\
				(_NUM_TYPE_)_POW_FUNC_(a->_X_, (_NUM_TYPE_)b->_X_),\
				(_NUM_TYPE_)_POW_FUNC_(a->_Y_, (_NUM_TYPE_)b->_Y_),\
				(_NUM_TYPE_)_POW_FUNC_(a->_Z_, (_NUM_TYPE_)b->_Z_),\
				(_NUM_TYPE_)_POW_FUNC_(a->_W_, (_NUM_TYPE_)b->_W_)\
			), #_META_NAME_);\
			return 1;\
		}\
\
		return 0;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, __unm)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		a->_X_ = -a->_X_;\
		a->_Y_ = -a->_Y_;\
		a->_Z_ = -a->_Z_;\
		a->_W_ = -a->_W_;\
\
		return 1;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, __newindex)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
		auto key = luaL_checkstring(L, 2);\
\
		if (!stricmp(key, #_X_)){ a->_X_ = luaL_checknumber(L, 3); } else \
		if (!stricmp(key, #_Y_)){ a->_Y_ = luaL_checknumber(L, 3); } else \
		if (!stricmp(key, #_Z_)){ a->_Z_ = luaL_checknumber(L, 3); } else \
		if (!stricmp(key, #_W_)){ a->_W_ = luaL_checknumber(L, 3); } \
\
		return 0;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, __index)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
		auto key = luaL_checkstring(L, 2);\
\
		if (!stricmp(key, #_X_)){ lua_pushnumber(L, a->_X_);	return 1;} else \
		if (!stricmp(key, #_Y_)){ lua_pushnumber(L, a->_Y_);	return 1;} else \
		if (!stricmp(key, #_Z_)){ lua_pushnumber(L, a->_Z_);	return 1;} else \
		if (!stricmp(key, #_W_)){ lua_pushnumber(L, a->_W_);	return 1;} \
\
		lua_getmetatable(L, 1);\
		lua_pushstring(L, key);\
		if (my_rawget(L, -2) && lua_type(L, -1) != LUA_TNIL) return 1;\
\
		return 0;\
	}

// VEC3

#define _MMYY_DECLARE_VEC3_OPERATOR(\
	_CLASS_, \
	_FUNC_NAME_, \
	_OPERATOR_, \
	_CONSTRUCTOR_, \
	_META_NAME_, \
	_NUM_TYPE_, \
	_X_, \
	_Y_, \
	_Z_\
)\
	LUAMTA_FUNCTION(_META_NAME_, _FUNC_NAME_)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		if (lua_type(L, 2) == LUA_TNUMBER)\
		{\
			auto b = luaL_checknumber(L, 2);\
\
			my_push(L, _CONSTRUCTOR_(\
				(_NUM_TYPE_)a->_X_ _OPERATOR_ (_NUM_TYPE_)b,\
				(_NUM_TYPE_)a->_Y_ _OPERATOR_ (_NUM_TYPE_)b,\
				(_NUM_TYPE_)a->_Z_ _OPERATOR_ (_NUM_TYPE_)b\
			), #_META_NAME_);\
			return 1;\
		}\
		if (my_istype(L, 2, #_META_NAME_))\
		{\
			auto b = my_tostructpointer<_CLASS_>(L, 2, #_META_NAME_);\
\
			my_push(L, _CONSTRUCTOR_(\
				(_NUM_TYPE_)a->_X_ _OPERATOR_ (_NUM_TYPE_)b->_X_,\
				(_NUM_TYPE_)a->_Y_ _OPERATOR_ (_NUM_TYPE_)b->_Y_,\
				(_NUM_TYPE_)a->_Z_ _OPERATOR_ (_NUM_TYPE_)b->_Z_\
			), #_META_NAME_);\
\
			return 1;\
		}\
\
		return 0;\
	}

#define MMYY_VEC3_TEMPLATE(\
	_CLASS_,\
	_CONSTRUCTOR_,\
	_META_NAME_,\
	_NUM_TYPE_,\
	_POW_FUNC_,\
	_POW_TYPE_,\
	_X_,\
	_Y_,\
	_Z_\
)\
\
	_MMYY_DECLARE_VEC3_OPERATOR(_CLASS_, __add, +, _CONSTRUCTOR_, _META_NAME_, _NUM_TYPE_, \
		_X_, \
		_Y_, \
		_Z_\
	)\
	_MMYY_DECLARE_VEC3_OPERATOR(_CLASS_, __sub, -, _CONSTRUCTOR_, _META_NAME_, _NUM_TYPE_, \
		_X_, \
		_Y_, \
		_Z_\
	)\
	_MMYY_DECLARE_VEC3_OPERATOR(_CLASS_, __div, /, _CONSTRUCTOR_, _META_NAME_, _NUM_TYPE_, \
		_X_, \
		_Y_, \
		_Z_\
	)\
	_MMYY_DECLARE_VEC3_OPERATOR(_CLASS_, __mul, *, _CONSTRUCTOR_, _META_NAME_, _NUM_TYPE_, \
		_X_, \
		_Y_, \
		_Z_\
	)\
	_MMYY_DECLARE_VEC3_OPERATOR(_CLASS_, __mod, %, _CONSTRUCTOR_, _META_NAME_, int, \
		_X_, \
		_Y_, \
		_Z_\
	)\
\
	LUAMTA_FUNCTION(_META_NAME_, Unpack)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		lua_pushnumber(L, a->_X_);\
		lua_pushnumber(L, a->_Y_);\
		lua_pushnumber(L, a->_Z_);\
\
		return 3;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, Copy)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		my_push(L, _CONSTRUCTOR_(\
			a->_X_, \
			a->_Y_, \
			a->_Z_\
		), #_META_NAME_);\
\
		return 1;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, __eq)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
		auto b = my_tostructpointer<_CLASS_>(L, 2, #_META_NAME_);\
\
		my_push(L, \
				a->_X_ == b->_X_ &&\
				a->_Y_ == b->_Y_ &&\
				a->_Z_ == b->_Z_\
			);\
\
		return 1;\
	}\
	LUAMTA_FUNCTION(_META_NAME_, __pow)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		if (lua_type(L, 2) == LUA_TNUMBER)\
		{\
			auto b = luaL_checknumber(L, 2);\
\
			my_push(L, _CONSTRUCTOR_(\
				(_NUM_TYPE_)_POW_FUNC_(a->_X_, (_NUM_TYPE_)b),\
				(_NUM_TYPE_)_POW_FUNC_(a->_Y_, (_NUM_TYPE_)b),\
				(_NUM_TYPE_)_POW_FUNC_(a->_Z_, (_NUM_TYPE_)b)\
			), #_META_NAME_);\
			return 1;\
		}\
		if (my_istype(L, 2, #_META_NAME_))\
		{\
			auto b = my_tostructpointer<_CLASS_>(L, 2, #_META_NAME_);\
\
			my_push(L, _CONSTRUCTOR_(\
				(_NUM_TYPE_)_POW_FUNC_(a->_X_, (_NUM_TYPE_)b->_X_),\
				(_NUM_TYPE_)_POW_FUNC_(a->_Y_, (_NUM_TYPE_)b->_Y_),\
				(_NUM_TYPE_)_POW_FUNC_(a->_Z_, (_NUM_TYPE_)b->_Z_)\
			), #_META_NAME_);\
			return 1;\
		}\
\
		return 0;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, __unm)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		a->_X_ = -a->_X_;\
		a->_Y_ = -a->_Y_;\
		a->_Z_ = -a->_Z_;\
\
		return 1;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, __newindex)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
		auto key = luaL_checkstring(L, 2);\
\
		if (!stricmp(key, #_X_)){ a->_X_ = luaL_checknumber(L, 3); } else \
		if (!stricmp(key, #_Y_)){ a->_Y_ = luaL_checknumber(L, 3); } else \
		if (!stricmp(key, #_Z_)){ a->_Z_ = luaL_checknumber(L, 3); } \
\
		return 0;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, __index)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
		auto key = luaL_checkstring(L, 2);\
\
		if (!stricmp(key, #_X_)){ lua_pushnumber(L, a->_X_);	return 1;} else \
		if (!stricmp(key, #_Y_)){ lua_pushnumber(L, a->_Y_);	return 1;} else \
		if (!stricmp(key, #_Z_)){ lua_pushnumber(L, a->_Z_);	return 1;} \
\
		lua_getmetatable(L, 1);\
		lua_pushstring(L, key);\
		if (my_rawget(L, -2) && lua_type(L, -1) != LUA_TNIL) return 1;\
\
		return 0;\
	}

// VEC2

#define _MMYY_DECLARE_VEC2_OPERATOR(\
	_CLASS_, \
	_FUNC_NAME_, \
	_OPERATOR_, \
	_CONSTRUCTOR_, \
	_META_NAME_, \
	_NUM_TYPE_, \
	_X_, \
	_Y_ \
)\
	LUAMTA_FUNCTION(_META_NAME_, _FUNC_NAME_)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		if (lua_type(L, 2) == LUA_TNUMBER)\
		{\
			auto b = luaL_checknumber(L, 2);\
\
			my_push(L, _CONSTRUCTOR_(\
				(_NUM_TYPE_)a->_X_ _OPERATOR_ (_NUM_TYPE_)b,\
				(_NUM_TYPE_)a->_Y_ _OPERATOR_ (_NUM_TYPE_)b\
			), #_META_NAME_);\
			return 1;\
		}\
		if (my_istype(L, 2, #_META_NAME_))\
		{\
			auto b = my_tostructpointer<_CLASS_>(L, 2, #_META_NAME_);\
\
			my_push(L, _CONSTRUCTOR_(\
				(_NUM_TYPE_)a->_X_ _OPERATOR_ (_NUM_TYPE_)b->_X_,\
				(_NUM_TYPE_)a->_Y_ _OPERATOR_ (_NUM_TYPE_)b->_Y_\
			), #_META_NAME_);\
\
			return 1;\
		}\
\
		return 0;\
	}

#define MMYY_VEC2_TEMPLATE(\
	_CLASS_,\
	_CONSTRUCTOR_,\
	_META_NAME_,\
	_NUM_TYPE_,\
	_POW_FUNC_,\
	_POW_TYPE_,\
	_X_,\
	_Y_\
)\
\
	_MMYY_DECLARE_VEC2_OPERATOR(_CLASS_, __add, +, _CONSTRUCTOR_, _META_NAME_, _NUM_TYPE_, \
		_X_, \
		_Y_\
	)\
	_MMYY_DECLARE_VEC2_OPERATOR(_CLASS_, __sub, -, _CONSTRUCTOR_, _META_NAME_, _NUM_TYPE_, \
		_X_, \
		_Y_\
	)\
	_MMYY_DECLARE_VEC2_OPERATOR(_CLASS_, __div, /, _CONSTRUCTOR_, _META_NAME_, _NUM_TYPE_, \
		_X_, \
		_Y_\
	)\
	_MMYY_DECLARE_VEC2_OPERATOR(_CLASS_, __mul, *, _CONSTRUCTOR_, _META_NAME_, _NUM_TYPE_, \
		_X_, \
		_Y_\
	)\
	_MMYY_DECLARE_VEC2_OPERATOR(_CLASS_, __mod, %, _CONSTRUCTOR_, _META_NAME_, int, \
		_X_, \
		_Y_\
	)\
\
	LUAMTA_FUNCTION(_META_NAME_, Unpack)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		lua_pushnumber(L, a->_X_);\
		lua_pushnumber(L, a->_Y_);\
\
		return 2;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, Copy)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		my_push(L, _CONSTRUCTOR_(\
			a->_X_, \
			a->_Y_\
		), #_META_NAME_);\
\
		return 1;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, __eq)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
		auto b = my_tostructpointer<_CLASS_>(L, 2, #_META_NAME_);\
\
		my_push(L, \
				a->_X_ == b->_X_ &&\
				a->_Y_ == b->_Y_\
			);\
\
		return 1;\
	}\
	LUAMTA_FUNCTION(_META_NAME_, __pow)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		if (lua_type(L, 2) == LUA_TNUMBER)\
		{\
			auto b = luaL_checknumber(L, 2);\
\
			my_push(L, _CONSTRUCTOR_(\
				(_NUM_TYPE_)_POW_FUNC_(a->_X_, (_NUM_TYPE_)b),\
				(_NUM_TYPE_)_POW_FUNC_(a->_Y_, (_NUM_TYPE_)b)\
			), #_META_NAME_);\
			return 1;\
		}\
		if (my_istype(L, 2, #_META_NAME_))\
		{\
			auto b = my_tostructpointer<_CLASS_>(L, 2, #_META_NAME_);\
\
			my_push(L, _CONSTRUCTOR_(\
				(_NUM_TYPE_)_POW_FUNC_(a->_X_, (_NUM_TYPE_)b->_X_),\
				(_NUM_TYPE_)_POW_FUNC_(a->_Y_, (_NUM_TYPE_)b->_Y_)\
			), #_META_NAME_);\
			return 1;\
		}\
\
		return 0;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, __unm)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
\
		a->_X_ = -a->_X_;\
		a->_Y_ = -a->_Y_;\
\
		return 1;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, __newindex)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
		auto key = luaL_checkstring(L, 2);\
\
		if (!stricmp(key, #_X_)){ a->_X_ = luaL_checknumber(L, 3); } else \
		if (!stricmp(key, #_Y_)){ a->_Y_ = luaL_checknumber(L, 3); } \
\
		return 0;\
	}\
\
	LUAMTA_FUNCTION(_META_NAME_, __index)\
	{\
		auto a = my_tostructpointer<_CLASS_>(L, 1, #_META_NAME_);\
		auto key = luaL_checkstring(L, 2);\
\
		if (!stricmp(key, #_X_)){ lua_pushnumber(L, a->_X_);	return 1;} else \
		if (!stricmp(key, #_Y_)){ lua_pushnumber(L, a->_Y_);	return 1;} \
\
		lua_getmetatable(L, 1);\
		lua_pushstring(L, key);\
		if (my_rawget(L, -2) && lua_type(L, -1) != LUA_TNIL) return 1;\
\
		return 0;\
	}
