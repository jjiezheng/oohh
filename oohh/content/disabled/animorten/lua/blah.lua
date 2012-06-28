
local ffi = require("ffi")

ffi.cdef([[
	typedef void (*ConsoleVarFunc)(void*);

	typedef struct {
		struct {
			void (*Destructor)(void*);
			void (*Release)(void*);
			void* (*GetGlobalEnvironment)(void*);
			const char* (*GetRootFolder)(void*);
		}* vtable;
	} ISystem;

	typedef struct {
		struct {
			void (*Destructor)(void*);
			void (*Release)(void*);
			/*void* (*RegisterString)(void*, const char*, const char*, int, const char*, void (*)(void*));
			void* (*RegisterInt)(void*, const char*, int, int, const char*, void (*)(void*));
			void* (*RegisterFloat)(void*, const char*, float, int, const char*, void (*)(void*));
			void* (*Register)(void*, const char*, float*, float, int, const char*, void (*)(void*), bool);*/
			void* nope[22];
			void (*PrintLine)(void*, const char*);
			void (*PrintLinePlus)(void*, const char*);
		}* vtable;
	} IConsole;

	typedef struct {
		ISystem* system;
		void* game;
		void* gameframework;
		void* network;
		void* renderer;
		void* input;
		void* timer;
		IConsole* console;
	} Environment;

	Environment* Blah();
]])

local module = ffi.load("CryGame.dll")
local blah = module.Blah()

env = setmetatable({}, {__index = function(self, key)
	local interface = blah[key]

	local value = setmetatable({}, {__index = function(self, key)
		local method = interface.vtable[key]
		local value = function(...) return method(interface, ...) end
		rawset(self, key, value)
		return value
	end})

	rawset(self, key, value)
	return value
end})
