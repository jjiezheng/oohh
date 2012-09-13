console.AddCommand("find_ent_class", function(ply, line, str)
	str = str or "."
	for class_name, flags in pairs(entities.GetAllRegisteredClasses()) do
		if class_name:lower():find(str) then
			print(class_name)
		end
	end
end)