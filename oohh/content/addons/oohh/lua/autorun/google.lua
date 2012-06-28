if CLIENT then
    message.Hook("google_say", function(str)
		chatgui.AddLine(chatgui.GetTimeStamp() .. "Google: " ..  str)
		
		--A(Color(1, 64, 202)) A("G")
		--A(Color(221, 24, 18)) A("o")
		--A(Color(252, 202, 3)) A("o")
		--A(Color(1, 64, 202))  A("g")
		--A(Color(22, 166, 30)) A("l")
		--A(Color(221, 24, 18)) A("e")
		--A(color_white) A(": ")
		--A(str)		
    end)
end

if SERVER then

    local function GoogleSay(msg)
		message.SendToClient("google_say", nil, msg)
		print("google: ", msg)
    end

    hook.Add("PlayerSay", "google", function(ply, question)
		question = question:lower()
		if question:find("google.+?") then
			question = question:match("google.-(%a.+)?")

			if not question then return end

			local _q = question
			question = question:gsub("(%A)", function(char) return "%"..("%x"):format(char:byte()) end)
			--print("QUESTION: ", question)
			http.Get(
				"http://suggestqueries.google.com/complete/search?client=firefox&q=" .. question .. "%20",
				function(data)
				local str = data.content
				:gsub("%[%[", "")
				:gsub("%]%]", "")
				:gsub('"', "")
				:gsub("[^%a, ]", "")
				:gsub(_q:lower() .. " ", "")
				local tbl = str:Explode(',')
				table.remove(tbl, 1)

				GoogleSay(table.random(tbl))
				end
			)
		end
	end)

end