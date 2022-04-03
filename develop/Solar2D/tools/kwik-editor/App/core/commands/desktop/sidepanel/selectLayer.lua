local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("lib.util")
--
local command = function (params)
	local e     = params.event
	local UI    = e.UI
	local path = UI.currentPage.path .."/layers/"..UI.currentLayer.name..".json"
	print(path)
	UI.editPropsLabel = UI.currentLayer.name
	local decoded, pos, msg = json.decodeFile( path )
	if not decoded then
			print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
	else
			print( "File successfully decoded!" )
			UI.propsStore:set(decoded)
	end
	-----
	-- types
	---
	if UI.currentLayer.types then
		for i=1, #UI.currentLayer.types do
			local path = UI.currentPage.path .."/layers/"..UI.currentLayer.name.."_"..UI.currentLayer.types[i]..".json"
			print(path)
		end
	end
end
--
local instance = AC.new(command)
return instance
