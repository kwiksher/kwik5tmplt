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
    if "function" == "function" then
      AC.Var:editVar(UI, "myvar1", function(value) return print('test') end)
    elseif "function" == "string" then
      AC.Var:editVar(UI, "myvar1", "print('test')")
    else
      AC.Var:editVar(UI, "myvar1", tonumber(print('test')))
    end
  end
  return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"varAct","actions":[{"command":"variable.editVar","params":{"target":"myvar1","value":"print('test')", "valueType":"function"}}]}
]]
--
return ActionCommand
