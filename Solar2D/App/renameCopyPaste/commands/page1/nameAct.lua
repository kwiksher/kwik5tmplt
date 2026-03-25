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
    local event      = params.event or {}
    local obj        = event.target
    --
    -- local alert = native.showAlert("Alert", "Hello", { "OK" } )
    -- printKeys(event.target)
    -- local conditions = require("App." .. UI.book..".common.conditions")
    -- local expressions = require("App." .. UI.book.."common.expressions")
    --
    if "string" == "function" then
      AC.Var:editVar(UI, "myText", function(value) return Hello end)
    elseif "string" == "string" then
      AC.Var:editVar(UI, "myText", "Hello")
    else
      AC.Var:editVar(UI, "myText", tonumber(Hello))
    end
  end
  return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"nameAct","actions":[{"command":"variable.editVar","params":{"value":"Hello","valueType":"string","target":"myText"}}]}
]]
--
return ActionCommand
