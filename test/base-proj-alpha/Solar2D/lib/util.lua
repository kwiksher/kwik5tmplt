local exports = {}

local lfs = require( "lfs" )
local isWindows = system.getInfo("platform") == "win32"


function exports.pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end


function exports.PATH (path)
	local ret = path
	if isWindows then
			ret = ret:gsub('/','\\')
	end
	return ret
end

function exports.isFile(name)
	if type(name)~="string" then return false end
	if not exports.isDir(name) then
			return os.rename(name,name) and true or false
			-- note that the short evaluation is to
			-- return false instead of a possible nil
	end
	return false
end

function exports.isFileOrDir(name)
	if type(name)~="string" then return false end
	return os.rename(name, name) and true or false
end

function exports.isDir(name)
	if type(name)~="string" then return false end
	local cd = lfs.currentdir()
	local is = lfs.chdir(name) and true or false
	lfs.chdir(cd)
	return is
end
--------
--------
local lustache = require "extlib.lustache"
local json     = require("json")
--
function exports.renderer (tmpltPath, outPath, model)
	--- .lua
	local file, errorString = io.open( tmpltPath..".lua", "r" )
	if not file then
		print( "File error: " .. errorString )
	else
		local contents = file:read( "*a" )
		io.close( file )
		local output = lustache:render(contents, model)

		local scenePath = outPath:gsub("models/", "")
		local file, errorString = io.open( scenePath..".lua", "w+" )
		if not file then
			print( "File error: " .. errorString )
		else
			output = string.gsub(output, "\r\n", "\n")
			file:write( output )
			io.close( file )
		end
	end
	-- .json
	local file, errorString = io.open( outPath..".json", "w+" )
	if not file then
		print( "File error: " .. errorString )
	else
		local output = json.encode(model)
		file:write( output )
		io.close( file )
	end
end

-- Calculates anchor points
function exports.repositionAnchor(object, newAnchorX, newAnchorY)
    local origX = object.x;
    local origY = object.y
    if object.repositionDone == nil then
        object.repositionDone = true;
        if newAnchorX ~= 0.5 or newAnchorY ~= 0.5 then
            local width = object.width;
            local height = object.height
            local xCoord = width * (newAnchorX - .5)
            local yCoord = height * (newAnchorY - .5)
            object.x = origX + xCoord;
            object.y = origY + yCoord
            object.oriX = object.x;
            object.oriY = object.y
        end
    end
end

--/Users/ymmtny/Documents/GitHub/kwik5/sandbox/Ps/react-uxp-styles/Project/Solar2D/templates/components/layer_props.lua
--/Users/ymmtny/Documents/GitHub/kwik5/sandbox/Ps/react-uxp-styles/Project/Solar2D/src/App/../templates/components/layer_props.lua: No such file or directory
return exports