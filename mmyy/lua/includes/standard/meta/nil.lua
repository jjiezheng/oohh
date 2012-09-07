local NULL = {}

NULL.ClassName = "NULL"
NULL.IsNull = true

local function FALSE()
	return false
end

function NULL:__tostring()
	return "NULL"
end
	
function NULL:__index(key)
	if key == "ClassName" then
		return "NULL"
	end
	
	if key == "IsValid" then	
		return FALSE
	end
	
	if type(key) == "string" and key:sub(0, 2) == "Is" then
		return FALSE
	end

	error(("tried to index %q on a NULL value"):format(key), 2)
end

util.DeclareMetaTable("null_meta", NULL)

function MakeNULL(var)
	setmetatable(var, getmetatable(GetNULL()))
end

_G.NULL = GetNULL()

do return end

-- ugh hacks 
local function safecall_ify(meta_name, func_name)
	local meta = _R[meta_name]

	local old = meta[func_name]
	meta[func_name] = function(s, ...)
		if getmetatable(_R.ptrtbl[meta.GetUniqueID(s)]) == NULL then
			return GetNULL()
		end
		return old(s, ...)
	end
end

safecall_ify("actor", "GetEntity")
safecall_ify("player", "GetEntity")
safecall_ify("weapon", "GetEntity")
safecall_ify("physics", "GetEntity")

safecall_ify("actor", "__tostring")
safecall_ify("entity", "__tostring")
safecall_ify("physics", "__tostring")
safecall_ify("weapon", "__tostring")