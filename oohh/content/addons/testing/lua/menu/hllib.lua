MONITOR_ME()

require("hllib")

local m = hllib.module

m.hlInitialize()

hllib.package_cache = hllib.package_cache or {} 

function hllib.ReadFromPackage(path, file, callback, speed)
	path = path:lower()
	
	if hllib.current_stream then
		m.hlStreamClose(hllib.current_stream)
		hllib.current_stream = nil
	end
	
	local id
	
	if hllib.package_cache[path] then
		id = hllib.package_cache[path]
		m.hlBindPackage(id)
	else
		
		-- get the package type (gcf, ncf, ...)
		-- atm we don't care about the type
		local type = m.hlGetPackageTypeFromName(path)

		-- tell hllib we're going to use a package
		local id = ffi.new("unsigned int[1]", 0)
		m.hlCreatePackage(type, id)
		m.hlBindPackage(id[0])
		
		
		hllib.package_cache[path] = id[0]
	end
	
	if m.hlPackageOpenFile(path, m.HL_MODE_READ + m.HL_MODE_VOLATILE + m.HL_MODE_QUICK_FILEMAPPING) == 1 then 

		-- get the file we're looking for
		local pItem = m.hlFolderGetItemByPath(m.hlPackageGetRoot(), file, m.HL_FIND_ALL)

		-- create a stream for the file for reading
		local pStream = ffi.new("void *[1]")
		
		if m.hlPackageCreateStream(pItem, pStream) == 1 and m.hlStreamOpen(pStream[0], m.HL_MODE_READ) == 1 then
			
			hllib.current_stream = pItem
			
			local str = ""

			-- read the stream until hllib says we're done reading
			-- this is the wrong way to write the wav but it's just an example
			
			if callback then
				local i = 0
				
				local size = ffi.new("unsigned int[1]")
				m.hlItemGetSize(pItem, size)
				size = size[0]
								
				Thinker(function()
					-- stream will be output to this char
					local pChar = ffi.new("char[1]", 0)
			
					if m.hlStreamReadChar(pStream[0], pChar) == 0 then
						callback(str)
						
						m.hlStreamClose(pItem)
						m.hlPackageClose()
						hllib.current_stream = nil
						
						print("reading ... " .. math.ceil((i / size)*100) .. "%")
						
						return true
					end
					
					if INTERVAL(1) then
						print("reading ... " .. math.ceil((i / size)*100) .. "%")
					end
					
					--local byte = pChar[0] + 128
					--str = str .. string.char(byte)
					 
					i = i + 1 
				end, speed)
			else
				local start = os.clock()

				local tbl = {}
				
				local pChar = ffi.new("char[1]", 0)
				local byte
				for i = 0, math.huge do
					if m.hlStreamReadChar(pStream[0], pChar) == 1 then
						tbl[i] = pChar[0]
					else
						break
					end
				end
				print("took " .. (os.clock() - start) .. " seconds to read")

				---local start = os.clock()
				--str = table.concat(tbl, "")
				--print("took " .. (os.clock() - start) .. " seconds to concat")
						
				m.hlStreamClose(pItem) 
				m.hlPackageClose()
				hllib.current_stream = nil
			
				return tbl
			end
		end
	end
end
  
local wav = hllib.ReadFromPackage(
	"I:/steam/steamapps/source sounds.gcf", 
	"hl2/sound/buttons/button8.wav"--[[,
	function(str)  
		file.Write("test.wav", str, nil, "b") 
	end, 
	1000  ]] 
)

hook.Add("PostGameUpdate",1, function()
	aniaudio.Process()
end)

hook.Add("AudioSample", 1, function(pos)	
	local l = wav[math.ceil((pos-1)*41000%#wav)]
	local r = wav[math.ceil((pos+1)*41000%#wav)]
	
	l = l / 255
	r = r / 255
	
	l = math.clamp(l, -1, 1) * 0.5
	r = math.clamp(r, -1, 1) * 0.5
	
	return l, r
end)

aniaudio.Start(0.1)