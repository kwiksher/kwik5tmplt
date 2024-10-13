-- Code created by Kwik - Copyright: kwiksher.com 
-- Version: 
-- Project: 
--
local ActionCommand = {}
local AC           = require("commands.kwik.actionCommand")
--
-----------------------------
-----------------------------
function ActionCommand:new()
	local command = {}
	--
	function command:execute(params)
		local UI         = params.UI
		local sceneGroup = UI.sceneGroup
		local layers      = UI.layers
		local obj        = params.obj

    -- local conditions = require("App." .. UI.book..".common.conditions")
    -- local expressions = require("App." .. UI.book.."common.expressions")

    --
    -- target layer :sceneGroup[layerName]
    -- target animation : layer.animations[index]
    --
      AC.Animation:play("en_linear", )
    --
    -- target layer :sceneGroup[layerName]
    -- target animation : layer.animations[index]
    --
      AC.Animation:play("en_linear", )
	end
	return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"playFly","actions":[{"command":"animation.play","params":{"target":"en_linear"}},{"command":"animation.play","params":{"target":"en_linear"}}]}
]]
--
return ActionCommand