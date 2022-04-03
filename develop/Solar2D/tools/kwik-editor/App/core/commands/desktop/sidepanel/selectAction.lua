local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("lib.util")
--
local command = function (params)
	local e     = params.event
	local UI    = e.UI
	local path = UI.currentPage.path .."/events/"..UI.currentAction.name..".json"
	print(path)

	UI.editPropsLabel = UI.currentAction.name
	local decoded, pos, msg = json.decodeFile( path )
	if not decoded then
			print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
	else
			print( "File successfully decoded!" )
			UI.actionPropsStore:set(decoded)
			UI.actionMenu:show()
			if UI.currentPanel then
				UI.currentPanel:destroy()
			end

			UI.layerInstancePanel:destroy()
	end
end
--
local instance = AC.new(command)
return instance
