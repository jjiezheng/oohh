if not CAPSADMIN then		
	local client = luasocket.Client("udp")
		client:Connect("88.90.232.18", 27015)
		
	hook.Add("PostGameUpdate", "fun", function()
		client:Send(sigh.Encode(Vec2(mouse.GetPos())))
	end)
else
	--luasocket.debug = true
end

if (fun_server or NULL):IsValid() then    
	fun_server:Remove()  
end

fun_server = luasocket.Server("udp")
fun_server:Host("10.0.0.1", 27015)

local clients = {}

function fun_server:OnReceive(data, ip, port)
	local id = ip
	
	if not clients[id] then
		clients[id] = {}
		
		if CAPSADMIN then
			local client = luasocket.Client("udp")
			client:Connect(ip, 27015)
			
			hook.Add("PostGameUpdate", "fun", function()
				client:Send(sigh.Encode(Vec2(mouse.GetPos())))
			end)
		end
	end
	
	clients[id].pos = unpack(sigh.Decode(data))
end
	
hook.Add("PostDrawMenu", "fun", function()
	for key, data in pairs(clients) do
		graphics.DrawRect(Rect(data.pos.x, data.pos.y, 5, 5))
	end
end)

util.MonitorFileInclude() 