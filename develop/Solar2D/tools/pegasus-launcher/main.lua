local pegasus = require("pegasus.init")
local launcher = require("launcher")

launcher.init("/Applications/Corona/SampleCode/")

-- launcher.execute("Animation.FrameAnimation")

local function doGet(e)
end

local function doPost(request)
	local project = request._path:sub(2)
	launcher.execute(project)
end

local path = system.pathForFile("docs", system.ResouceDirectory)
local server = pegasus:new({
	port='9090',
	location=path
})

server:start(function (request, response)
	print "It's running..."
	print(request._method, request._path)
	if request._method == "POST" then
		doPost(request)
	end

	response:write("Done"..request._path)

end)


