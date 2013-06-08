local query = require './Query'

local q

-- test vertex identity
q = query.parse("(a)")
assert(q.obj1.type == "vertex")
assert(q.obj1.identity == "a")
assert(q.obj1.data == "a")
assert(q.obj1.index == 3)

-- test vertex identity with class
q = query.parse("(a:myclass)")
assert(q.obj1.type == "vertex")
assert(q.obj1.identity == "a")
assert(q.obj1.class == "myclass")
assert(q.obj1.data == "a:myclass")
assert(q.obj1.index == 11)

-- test vertex class
q = query.parse("(:myclass)")
assert(q.obj1.type == "vertex")
assert(q.obj1.identity == "")
assert(q.obj1.class == "myclass")
assert(q.obj1.data == ":myclass")
assert(q.obj1.index == 10)

-- test vertex document
q = query.parse("({foo:'bar',bar:'baz'})")
assert(q.obj1.type == "vertex")
assert(q.obj1.identity == "")
assert(q.obj1.document.foo == 'bar')
--assert(q.obj1.data == "{foo:'bar'}")
--assert(q.obj1.index == 13)

-- test vertex identity
q = query.parse("[a]")
assert(q.obj1.type == "edge")
assert(q.obj1.identity == "a")
assert(q.obj1.data == "a")
assert(q.obj1.index == 3)

-- test edge label
q = query.parse("[:mylabel]")
assert(q.obj1.type == "edge")
assert(q.obj1.identity == "")
assert(q.obj1.label == "mylabel")
assert(q.obj1.data == ":mylabel")
assert(q.obj1.index == 10)

-- test edge identity with label
q = query.parse("[a:mylabel]")
assert(q.obj1.type == "edge")
assert(q.obj1.identity == "a")
assert(q.obj1.label == "mylabel")
assert(q.obj1.data == "a:mylabel")
assert(q.obj1.index == 11)

print("All tests passsed")

--[[for k,v in pairs(q) do
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
end]]
