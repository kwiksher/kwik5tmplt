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
    obj = UI.animations["snowman_tremble"]
    AC.Animation:play(obj)
  end
  return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"action_sman","actions":[{"command":"animation.play","params":{"target":"snowman_tremble"}}]}
]]
--
return ActionCommand
