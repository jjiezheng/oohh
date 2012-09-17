if not ffi then return end

structs = structs or {}

function structs.Register(META)
	local base = util.FindMetaTable(META.ClassName)
	
	if base then
		for key, value in pairs(base) do
			if key:sub(1, 1) ~= "_" and not META[key] then
				printf("merging base function %s to %s", key, META.ClassName)
				META[key] = value
			end
		end
	end

	local arg_line = ""
	local translation = {}
	
	for i, trans in pairs(META.Args) do
		local arg = trans
		
		if type(trans) == "table" then
			arg = trans[1]
			table.remove(trans, 1)
			for _, val in pairs(trans) do
				translation[val] = arg
			end
		end
		
		arg_line = arg_line .. arg
		
		if i ~= #META.Args then
			arg_line = arg_line .. ", "
		end
	end
		
	local tr
	META.__index = function(self, key)
		if META[key] then
			return META[key]
		end
		
		tr = translation[key]
		if tr then
			return self[tr]
		end
	end
	
	META.Type = META.ClassName:lower()
	
	ffi.cdef("typedef struct {" .. META.NumberType .. " " .. arg_line .. ";}" .. META.ClassName .. ";")
	structs[META.ClassName] = ffi.metatype(META.ClassName, META)
	
	_G[META.ClassName] = structs[META.ClassName]
end 
 
-- helpers

function structs.AddGetFunc(META, name, name2)
	META["Get"..(name2 or name)] = function(self, ...)
		return self[name](self:Copy(), ...)
	end
end

structs.OperatorTranslate = 
{
	["+"] = "__add",
	["-"] = "__sub",
	["*"] = "__mul",
	["/"] = "__div",
	["^"] = "__pow",
	["%"] = "__mod",
}
 
local function parse_args(META, lua, sep, protect)
	sep = sep or ", "
	
	local str = ""
	
	local count = #META.Args
	
	for _, line in pairs(lua:explode("\n")) do
		if line:find("KEY") then
			local str = ""
			for i, trans in pairs(META.Args) do
				local arg = trans
				
				if type(trans) == "table" then
					arg = trans[1]
				end
								
				if protect and META.ProtectedFields and META.ProtectedFields[arg] then
					str = str .. "PROTECT " .. arg
				else
					str = str .. line:gsub("KEY", arg)	
				end
				
				if i ~= count then
					str = str .. sep
				end	
				
				str = str .. "\n"
			end		
			line = str
		end
		str = str .. line .. "\n"
	end
	
	return str
end
 
function structs.AddOperator(META, operator)
	if operator == "tostring" then
		local lua = [==[
		local META = ({...})[1]
		META["__tostring"] = function(a)
				return 
				string.format(
					"%s(LINE)", 
					META.ClassName, 
					a.KEY
				)
			end
		]==]
		
		local str = ""
		for i in pairs(META.Args) do
			str = str .. "%%s"
			if i ~= #META.Args then
				str = str .. ", "
			end
		end

		lua = lua:gsub("LINE", str)
		
		lua = parse_args(META, lua, ", ")
		
		table.print(lua:explode("\n"))
		
		assert(loadstring(lua, META.ClassName .. " operator " .. operator))(META)
	elseif operator == "unpack" then
		local lua = [==[
		local META = ({...})[1]
		META["Unpack"] = function(a)
				return
				a.KEY
			end
		]==]
		
		lua = parse_args(META, lua, ", ")
		
		assert(loadstring(lua, META.ClassName .. " operator " .. operator))(META)
	elseif operator == "==" then
		local lua = [==[
		local META = ({...})[1]
		META["__eq"] = function(a, b)
				return
				typex(a) == META.Type and
				typex(b) == META.Type and
				a.KEY == b.KEY
			end
		]==]
		
		lua = parse_args(META, lua, " and ")

		assert(loadstring(lua, META.ClassName .. " operator " .. operator))(META)
	elseif operator == "-" then
		local lua = [==[
		local META = ({...})[1]
		META["__unm"] = function(a)
				return
				CTOR(
					-a.KEY
				)
			end
		]==]
		
		lua = parse_args(META, lua, ", ", true)
		lua = lua:gsub("PROTECT", "a.")

		
		lua = lua:gsub("CTOR", "structs."..META.ClassName)
		
		assert(loadstring(lua, META.ClassName .. " operator " .. operator))(META)
	elseif operator == "zero" then
		local lua = [==[
		local META = ({...})[1]
		META["Zero"] = function(a)
				a.KEY = 0
			end
		]==]
		
		lua = parse_args(META, lua, "")
		
		lua = lua:gsub("CTOR", "structs."..META.ClassName)
		
		assert(loadstring(lua, META.ClassName .. " operator " .. operator))(META)
	elseif operator == "copy" then
		local lua = [==[
		local META = ({...})[1]
		META["copy"] = function(a)
				return
				CTOR(
					a.KEY
				)
			end
		]==]
		
		lua = parse_args(META, lua, ", ")
		
		lua = lua:gsub("CTOR", "structs."..META.ClassName)
		
		assert(loadstring(lua, META.ClassName .. " operator " .. operator))(META)
	else
		local lua = [==[
		local META = ({...})[1]
		META[structs.OperatorTranslate["OPERATOR"]] = function(a, b)
			if type(b) == "number" then
				return CTOR(
					a.KEY OPERATOR b
				)
			elseif type(a) == "number" then
				return CTOR(
					a OPERATOR b.KEY
				)
			elseif typex(a) == META.Type and typex(b) == META.Type then
				return CTOR(
					a.KEY OPERATOR b.KEY
				)
			end
		end
		]==]
		
		lua = parse_args(META, lua, ", ", true)
				
		lua = lua:gsub("CTOR", "structs."..META.ClassName)
		lua = lua:gsub("OPERATOR", operator)
		lua = lua:gsub("PROTECT", "a.")
		
		assert(loadstring(lua, META.ClassName .. " operator " .. operator))(META)
	end
end

function structs.AddAllOperators(META)
	structs.AddOperator(META, "+")
	structs.AddOperator(META, "-")
	structs.AddOperator(META, "*")
	structs.AddOperator(META, "/")
	structs.AddOperator(META, "^")
	structs.AddOperator(META, "-")
	structs.AddOperator(META, "%")
	structs.AddOperator(META, "==")
	structs.AddOperator(META, "copy")
	structs.AddOperator(META, "unpack")
	structs.AddOperator(META, "tostring")
	structs.AddOperator(META, "zero")
end

include("structs/Vec3.lua")
include("structs/Ang3.lua")
include("structs/Color.lua")
--include("structs/Quat.lua")