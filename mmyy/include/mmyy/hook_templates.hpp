////////////
inline const char *my_callhook(
	lua_State *L,
	const char*hook_name,
	int args_to_lua = 0
)
{
	if (!L) return false;

	my_starthook(L, hook_name);
	return my_endhook(L, 0, args_to_lua);
}
////////////
template<
	typename T1
>
inline const char *my_callhook(
	lua_State *L,
	const char*hook_name,
	T1 arg1,
	int args_to_lua = 0
)
{
	if (!L) return false;

	my_starthook(L, hook_name);
		my_push(L, arg1);
	return my_endhook(L, 1, args_to_lua);
}
//////////
template<
	typename T1,
	typename T2
>
inline const char *my_callhook(
	lua_State *L,
	const char*hook_name,
	T1 arg1,
	T2 arg2,
	int args_to_lua = 0
)
{
	if (!L) return false;

	my_starthook(L, hook_name);
		my_push(L, arg1);
		my_push(L, arg2);
	return my_endhook(L, 2, args_to_lua);
}
////////
template<
	typename T1,
	typename T2,
	typename T3
>
inline const char *my_callhook(
	lua_State *L,
	const char*hook_name,
	T1 arg1,
	T2 arg2,
	T3 arg3,
	int args_to_lua = 0
)
{
	if (!L) return false;

	my_starthook(L, hook_name);
		my_push(L, arg1);
		my_push(L, arg2);
		my_push(L, arg3);
	return my_endhook(L, 3, args_to_lua);
}
//////////
template<
	typename T1,
	typename T2,
	typename T3,
	typename T4
>
inline const char *my_callhook(
	lua_State *L,
	const char*hook_name,
	T1 arg1,
	T2 arg2,
	T3 arg3,
	T4 arg4,
	int args_to_lua = 0
)
{
	if (!L) return false;

	my_starthook(L, hook_name);
		my_push(L, arg1);
		my_push(L, arg2);
		my_push(L, arg3);
		my_push(L, arg4);
	return my_endhook(L, 4, args_to_lua);
}
///////
template<
	typename T1,
	typename T2,
	typename T3,
	typename T4,
	typename T5
>
inline const char *my_callhook(
	lua_State *L,
	const char*hook_name,
	T1 arg1,
	T2 arg2,
	T3 arg3,
	T4 arg4,
	T5 arg5,
	int args_to_lua = 0
)
{
	if (!L) return false;

	my_starthook(L, hook_name);
		my_push(L, arg1);
		my_push(L, arg2);
		my_push(L, arg3);
		my_push(L, arg4);
		my_push(L, arg5);
	return my_endhook(L, 5, args_to_lua);
}
///////
template<
	typename T1,
	typename T2,
	typename T3,
	typename T4,
	typename T5,
	typename T6
>
inline const char *my_callhook(
	lua_State *L,
	const char*hook_name,
	T1 arg1,
	T2 arg2,
	T3 arg3,
	T4 arg4,
	T5 arg5,
	T6 arg6,
	int args_to_lua = 0
)
{
	if (!L) return false;

	my_starthook(L, hook_name);
		my_push(L, arg1);
		my_push(L, arg2);
		my_push(L, arg3);
		my_push(L, arg4);
		my_push(L, arg5);
		my_push(L, arg6);
	return my_endhook(L, 6, args_to_lua);
}
///////
template<
	typename T1,
	typename T2,
	typename T3,
	typename T4,
	typename T5,
	typename T6,
	typename T7
>
inline const char *my_callhook(
	lua_State *L,
	const char*hook_name,
	T1 arg1,
	T2 arg2,
	T3 arg3,
	T4 arg4,
	T5 arg5,
	T6 arg6,
	T7 arg7,
	int args_to_lua = 0
)
{
	if (!L) return false;

	my_starthook(L, hook_name);
		my_push(L, arg1);
		my_push(L, arg2);
		my_push(L, arg3);
		my_push(L, arg4);
		my_push(L, arg5);
		my_push(L, arg6);
		my_push(L, arg7);
	return my_endhook(L, 7, args_to_lua);
}
