local Query = {}

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

local parseIdentity = function (entity, index, str)
	-- loop variables
	local i = index + 1
	local char

	-- set identity default value
	entity["identity"] = ""

	while i <= #str do
		char = str:sub(i, i)

		if char == ')' or
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

local parseEntity = function (entityType, index, str)
	-- create new entity object with current index
	local entity = { index = index }
	-- loop variables
	local i = entity.index
	local char

	-- set entity type
	if entityType == 'v' then
		entity["type"] = "vertex"
	else
		entity["type"] = "edge"
	end

	-- try to parse identity and class/label
	parseIdentity(entity, index, str)

	-- get character where identity parsing ended
	char = str:sub(entity.index, entity.index)

	-- parse also class/label if it follows
	if char == ':' then
		parseLabel(entity, entity.index, str)
	end

	while i <= #str do
		char = str:sub(i, i)

		if char == ')' then
			entity["data"] = str:sub(index + 1, i - 1)

			-- record index where did the processing ended
			entity.index = i
			break
		elseif char == ']' then
			entity["data"] = str:sub(index + 1, i - 1)

			-- record index where did the processing ended
			entity.index = i
			break
		end

		-- move forward in query string
		i = i + 1
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
		elseif char == '[' then
			-- it's an edge
			query["obj" .. count] = parseEntity('e', i, str)
		else
		end

		-- set i to the last index of parsed entity
		i = query["obj" .. count].index

		-- increment number of parsed objects
		count = count + 1

		i = i + 1
	end

	return query
end


function Query.parse(str)
	return parse(str)
end

return Query
