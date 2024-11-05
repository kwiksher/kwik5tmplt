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

    print("tap")

     if "string" == "function" then
      AC.Var:editVar(UI, "LED", function(value) return  end)
     elseif "string" == "string" then
      AC.Var:editVar(UI, "LED", '')
     else
      AC.Var:editVar(UI, "LED", tonumber())
     end

	end
	return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"onClear","actions":[{"command":"variable.editVar","params":{"target":"LED","type":"string"}}]}
]]
--
return ActionCommand