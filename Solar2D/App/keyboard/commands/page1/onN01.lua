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
     if "function" == "function" then
      AC.Var:editVar(UI, "LED", function(value) return UI.mycode.checkLCD(value.."1") end)
     elseif "function" == "string" then
      AC.Var:editVar(UI, "LED", 'UI.mycode.checkLCD(value.."1")')
     else
      AC.Var:editVar(UI, "LED", UI.mycode.checkLCD(value.."1"))
     end

	end
	return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"onN01","actions":[{"command":"variable.editVar","params":{"target":"LED","type":"function","value":"UI.mycode.checkLCD(value.."1")"}}]}
]]
--
return ActionCommand