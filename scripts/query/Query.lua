local Query = {}

local parseIdentity = function (entity, index, length, queryString)
	local char
	local i = index + 1

	-- set identity default value
	entity["identity"] = ""

	while i <= length do
		char = queryString:sub(i, i)

		if char == ')' or
			char == ':' or
			char == '{' then
			-- parse identity out of the query string
			entity["identity"] = queryString:sub(index + 1, i - 1)

			-- record index where did the processing ended
			entity["index"] = i
			break
		end

		-- move forward in query string
		i = i + 1
	end
end

local parseEntity = function (entityType, index, length, queryString)
	local entity = {}
	local i = index + 1
	local char

	-- determine type of the entity
	if entityType == 'v' then
		entity["type"] = "vertex"
	else
		entity["type"] = "edge"
	end

	parseIdentity(entity, index, length, queryString)

	while i <= length do
		char = queryString:sub(i, i)

		if char == ')' then
			entity["data"] = queryString:sub(index + 1, i - 1)

			-- record index where did the processing ended
			entity["index"] = i
			break
		elseif char == ']' then
			entity["data"] = queryString:sub(index + 1, i - 1)

			-- record index where did the processing ended
			entity["index"] = i
			break
		--[[elseif char == ':' then
			-- parse entity identity if present
			if index ~= i and index ~= (i - 1) then
				entity["identity"] = queryString:sub(index + 1, i - 1)
			end]]
		end

		-- move forward in query string
		i = i + 1
	end

	return entity
end

local parse = function (qs)
	local count = 1
	local query = {}
	local index = 1
	local length = #qs
	local char

	while index <= length do
		char = qs:sub(index, index)

		-- it's a vertex
		if char == '(' then
			query["obj" .. count] = parseEntity('v', index, length, qs)
		-- it's an edge
		elseif char == '[' then
			query["obj" .. count] = parseEntity('e', index, length, qs)
		else
		end

		-- set i to the last index of parsed entity
		index = query["obj" .. count].index

		-- increment number of parsed objects
		count = count + 1

		index = index + 1
	end

	return query
end


function Query.parse(qs)
	return parse(qs)
end

return Query
