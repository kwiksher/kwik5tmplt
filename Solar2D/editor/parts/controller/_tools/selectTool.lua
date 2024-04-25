local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("lib.util")
--
local command = function (params)
	local e     = params.event
	local UI    = e.UI
	local selectTool = e.tool --  scenes.desktop.editToolBar-Linear
	--
	--   for create, get animtion props for default
	--   for modification, fetch .json
	--
	--  scenes/desktop/tools .lua does not create display objects until animationStore recieves props.

	--   set UI.currentTool = ToolObj
	--      destroy previous display objects by calling UI.currentTool:removeSelf()

	local path = UI.currentPage.path .."/"..UI.currentLayer.name..".json"
	print(path)

	local decoded, pos, msg = json.decodeFile( path )
	if not decoded then
		print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
	end

	local pathTool = UI.currentPage.path .."/"..UI.currentLayer.name.."-"..selectTool..".json"
	print(pathTool)
	if not util.isFile(pathTool) then
		pathTool = UI.appFolder.."/../../templates/components/layer_"..selectTool..".json"
	end

	local props, pos1, msg1 = json.decodeFile( pathTool )
	if not decoded then
		print( "Decode failed at "..tostring(pos1)..": "..tostring(msg1) )
	end

	if UI.currentTool then
		UI.currentTools:destroy()
	end

	UI.tools[selectTool]:set({layer = decoded, props = props})

end
--
local instance = AC.new(command)
return instance
