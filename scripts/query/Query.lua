local Query = {}

local parseValue = function (entity, key, index, str)
	-- loop variables
	local i = index + 1
	local char

	while i <= #str do
		char = str:sub(i, i)

		-- value parsing ends with single or double quote
		if char == '"' or char == '\'' then
			entity.document[key] = str:sub(index + 1, i - 1)
			entity.index = i
			break
		end

		-- move forward in query string
		i = i + 1
	end
end

-- parses entity document {key:value,...}
local parseDocument = function (entity, index, str)
	-- loop variables
	local i = index + 1
	local char
	local key

	-- setup document table
	entity["document"] = {}

	while i <= #str do
		char = str:sub(i, i)

		if char == '}' then
			-- end of document, so parse the last k/v pair
			--entity.document[key] = str:sub(index + 2, i - 2)

			-- record index where did the processing ended
			entity.index = i
			break
		elseif char == ',' then
			-- next k/v pair follow, so parse current k/v pair
			--entity.document[key] = str:sub(index + 2, i - 2)
			index = i
		elseif char == ':' then
			-- parse key
			key = str:sub(index + 1, i - 1)
			index = i
		elseif char == '"' or char == '\'' then
			-- parse value
			parseValue(entity, key, i, str)
			i = entity.index
		elseif char == ' ' then
			index = index + 1
		end

		-- move forward in query string
		i = i + 1
	end
end

-- parses entity class (a:myclass...) or edge label [a:mylabel...]
local parseLabel = function (entity, index, str)
	-- loop variables
	local i = index + 1
	local char

	-- set class/label default value based on the enity type
	if entity.type == "vertex" then
		entity["class"] = ""
	else
		entity["label"] = ""
	end

	while i <= #str do
		char = str:sub(i, i)

		if char == ')' or
			char == ']' or
			char == ' ' or
			char == '{' then
			-- parse class/label from string
			if entity.type == "vertex" then
				entity["class"] = str:sub(index + 1, i - 1)
			else
				entity["label"] = str:sub(index + 1, i - 1)
			end

			-- record index where did the processing ended
			entity.index = i
			break
		end

		-- move forward in query string
		i = i + 1
	end
end

-- parses entity identity (a...) or [a...]
local parseIdentity = function (entity, index, str)
	-- loop variables
	local i = index + 1
	local char

	-- set identity default value
	entity["identity"] = ""

	while i <= #str do
		char = str:sub(i, i)

		if char == ')' or
			char == ']' or
			char == ' ' or
			char == ':' or
			char == '{' then
			-- parse identity from string
			entity["identity"] = str:sub(index + 1, i - 1)

			-- record index where did the processing ended
			entity.index = i
			break
		end

		-- move forward in query string
		i = i + 1
	end
end

-- parses vertex (...) or edge [...] entity
local parseEntity = function (entityType, index, str)
	-- create new entity object with current index
	local entity = { index = index }

	-- set entity type
	if entityType == 'v' then
		entity["type"] = "vertex"
	else
		entity["type"] = "edge"
	end

	-- try to parse identity and class/label
	parseIdentity(entity, index, str)

	-- loop variables
	local i = entity.index
	local char

	while i <= #str do
		char = str:sub(i, i)

		if char == ')' then
			-- end of vertex entity
			entity["data"] = str:sub(index + 1, i - 1)

			-- record index where did the processing ended
			entity.index = i
			break
		elseif char == ']' then
			-- end of edge entity
			entity["data"] = str:sub(index + 1, i - 1)

			-- record index where did the processing ended
			entity.index = i
			break
		elseif char == ':' then
			-- label parsing follows
			parseLabel(entity, i, str)
			i = entity.index
		elseif char == '{' then
			-- document parsing follows
			parseDocument(entity, i, str)
			i = entity.index
		else
			-- move forward in query string
			i = i + 1
		end
	end

	return entity
end

local parse = function (str)
	local query = {}
	-- counter of parsed query objects
	local count = 1
	-- loop varialbes
	local i = 1
	local char

	while i <= #str do
		char = str:sub(i, i)

		if char == '(' then
			-- it's a vertex
			query["obj" .. count] = parseEntity('v', i, str)

			-- set i to the last index of parsed entity
			i = query["obj" .. count].index

			-- increment number of parsed objects
			count = count + 1
		elseif char == '[' then
			-- it's an edge
			query["obj" .. count] = parseEntity('e', i, str)

			-- set i to the last index of parsed entity
			i = query["obj" .. count].index

			-- increment number of parsed objects
			count = count + 1
		else
			-- move forward in query string
			i = i + 1
		end
	end

	return query
end


function Query.parse(str)
	return parse(str)
end

return Query
