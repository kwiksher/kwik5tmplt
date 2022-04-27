local pegasus = require("pegasus.init")
local harness = require("harness")
local json = require("json")
local yaml = require('yaml')

harness.init("../../../../sample-projects")
--local app = harness.run("src")
local app = harness.run("Misc.Transition2")

local parsers = {
	lua = function(data)
		return loadstring('return '.. data)()
	end,
	yaml = function(data)
		return yaml.eval(data)
	end,
	json = function(data)
		return json.decode(data)
	end
}

local function doGet(e)
end

local function doPost(request)
	local data = request:post()
	--print(data)
	if type(data) == "string" then
		local type = request._headers["content-type"]:sub(string.len("application/") + 1)
		print(type)
		local value = parsers[type](data)
		--
		for k, v in pairs(value[1]) do print(k, v) end
		print("-----")
		for k, v in pairs(value[2]) do print(k, v) end

		--
		local name = request._path:sub(2)

		if name == "character/Transitions" then
			app:setValue(name, value)
		elseif name =="character" then
			app:setTransition(name, value)
		end

	elseif (type(data)=="table") then
		for k, v in pairs(data) do print(k, v) end
	end
end

local path = system.pathForFile("docs", system.ResouceDirectory)
local server = pegasus:new({
	port='9090',
	location=path
})

server:start(function (request, response)
	print "It's running..."
	print(request._path)
	if request._method == "POST" then
		doPost(request)
	end

	response:write("Done"..request._path)
end)


