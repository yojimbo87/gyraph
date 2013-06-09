local query = require './Query'

local q
local s

-- test vertex identity
s = "(a)"
q = query.parse(s)
assert(q.obj1.type == "vertex")
assert(q.obj1.identity == "a")
assert(q.obj1.data == s:sub(2, #s - 1))
assert(q.obj1.index == #s)

-- test vertex identity with class
s = "(a:myclass)"
q = query.parse(s)
assert(q.obj1.type == "vertex")
assert(q.obj1.identity == "a")
assert(q.obj1.class == "myclass")
assert(q.obj1.data == s:sub(2, #s - 1))
assert(q.obj1.index == #s)

-- test vertex class
s = "(:myclass)"
q = query.parse(s)
assert(q.obj1.type == "vertex")
assert(q.obj1.identity == "")
assert(q.obj1.class == "myclass")
assert(q.obj1.data == s:sub(2, #s - 1))
assert(q.obj1.index == #s)

-- test vertex document
s = "({ foo: 'bar', bar: 'baz' })"
q = query.parse(s)
assert(q.obj1.type == "vertex")
assert(q.obj1.identity == "")
assert(q.obj1.document.foo == 'bar')
assert(q.obj1.document.bar == 'baz')
assert(q.obj1.data == s:sub(2, #s - 1))
assert(q.obj1.index == #s)

-- test vertex identity
s = "[a]"
q = query.parse(s)
assert(q.obj1.type == "edge")
assert(q.obj1.identity == "a")
assert(q.obj1.data == s:sub(2, #s - 1))
assert(q.obj1.index == #s)

-- test edge label
s = "[:mylabel]"
q = query.parse(s)
assert(q.obj1.type == "edge")
assert(q.obj1.identity == "")
assert(q.obj1.label == "mylabel")
assert(q.obj1.data == s:sub(2, #s - 1))
assert(q.obj1.index == #s)

-- test edge identity with label
s = "[a:mylabel]"
q = query.parse(s)
assert(q.obj1.type == "edge")
assert(q.obj1.identity == "a")
assert(q.obj1.label == "mylabel")
assert(q.obj1.data == s:sub(2, #s - 1))
assert(q.obj1.index == #s)

-- test edge document
s = "[{ foo: 'bar', bar: 'baz' }]"
q = query.parse(s)
assert(q.obj1.type == "edge")
assert(q.obj1.identity == "")
assert(q.obj1.document.foo == 'bar')
assert(q.obj1.document.bar == 'baz')
assert(q.obj1.data == s:sub(2, #s - 1))
assert(q.obj1.index == #s)

-- test complex example which includes vertex and edge entities with documents
s = "(a:myclass { foo1: 'whoa' }) [b:mylabel { bar2: 'bazx' }]"
q = query.parse(s)

assert(q.obj1.type == "vertex")
assert(q.obj1.identity == "a")
assert(q.obj1.class == "myclass")
assert(q.obj1.document.foo1 == 'whoa')

assert(q.obj2.type == "edge")
assert(q.obj2.identity == "b")
assert(q.obj2.label == "mylabel")
assert(q.obj2.document.bar2 == 'bazx')

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
