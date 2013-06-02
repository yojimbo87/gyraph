local query = require './Query'

local q = query.parse('(ab:)(:cd)[ef][gh]')

for k,v in pairs(q) do
	if type(v) == "table" then
		for k2,v2 in pairs(v) do
			print("    " .. k2 .. " -> " .. v2)
		end
		print("  obj end")
	else
		print("    " .. k .. " -> " .. v)
		print("obj end")
	end
end
