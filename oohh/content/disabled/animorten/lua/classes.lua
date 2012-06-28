local classes = {}

for k, v in ipairs(entities.GetAll()) do
	local class = v:GetClass()
	classes[class] = (classes[class] or 0) + 1
end

local sorted = {}

for k, v in pairs(classes) do
	table.insert(sorted, {k, v})
end

table.sort(sorted, function(a, b) return a[2] > b[2] end)

for k, v in ipairs(sorted) do
	print(v[1] .. ": " .. v[2])
end

--for k, v in pairs(classes) do
--	print(k .. ": " .. v)
--end
