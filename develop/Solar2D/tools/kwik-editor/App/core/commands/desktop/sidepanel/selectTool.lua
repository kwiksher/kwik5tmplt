local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("lib.util")
--
local command = function (params)
	local e     = params.event
	local UI    = e.UI

	print("selectTool", UI.currentTool)

	--[[
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
		end
	--]]

	local fooValue = {
        name = "Name",
        from = {
            x = 0,
            y = 0,
            alpha = 0,
            duration = 1000,
            xScale = 1,
            yScale = 1,
            rotation = 0
        },
        to = {
            x = 100,
            y = 100,
            alpha = 1,
            duration = 2000,
            xScale = 1.5,
            yScale = 1.5,
            rotation = 90
        },
		controls = {
			restart = false,
			easing = "Linear",
			reverse = false,
			delay = 1000,
			loop = 1,
			angle = 45,
			xSwipe=0, ySwipe=0,
			anchor = "CenterReferencePoint"
		},
		audio = {
			name="",
			volume = 5,
			channel = 1,
			loop = 1,
			fadeIn = false,
			repeatable = false
		},
		breadcrumbs = {
			dispose = true,
			shape = "",
			color = {1,0,1},
			interval = 300,
			time = 2000,
			width = 30,
			height = 30
		}
    }

	UI.currentPanel = UI.animationPanel
	UI.animationStore:set(fooValue)
	UI.actionMenu:hide()
	UI.actionPanel:destroy()

	UI.layerInstancePanel:destroy()

end
--
local instance = AC.new(command)
return instance
