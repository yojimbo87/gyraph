local query = require './Query'

local q = query.parse('(a)(ab:)(:cd)[e:f][gh:ij]')

for k,v in pairs(q) do
	if type(v) == "table" then
		print("  " .. k)

		for k2,v2 in pairs(v) do
			print("    " .. k2 .. " -> " .. v2)
		end

		print("  end")
	else
		print("    " .. k .. " -> " .. v)
		print("obj end")
	end

	print("")
end
