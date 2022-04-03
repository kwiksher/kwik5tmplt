local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("lib.util")
--
local command = function (params)
	local e     = params.event
	local UI    = e.UI
	local currentPage = UI.currentPage
	print(currentPage.path)

	local decoded, pos, msg = json.decodeFile( currentPage.path.."/index.json" )
	--
	-- layer.types is decoded in layerTable.lua while parsing layers to display
	--
	if not decoded then
			print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
	else
			print( "File successfully decoded!", json.encode(decoded) )
			UI.layerStore:set(decoded.layers)
			UI.actionStore:set(decoded.events)
	end
end
--
local instance = AC.new(command)
return instance
