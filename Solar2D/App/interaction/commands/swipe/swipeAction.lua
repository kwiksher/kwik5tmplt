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
    local event      = params.event
    local obj        = event.target
    --
    local alert = native.showAlert("Alert", "direction is "..event.direction, { "OK" } )

    printKeys(event)
    -- local conditions = require("App." .. UI.book..".common.conditions")
    -- local expressions = require("App." .. UI.book.."common.expressions")
  end
  return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"swipeAction","actions":[]}
]]
--
return ActionCommand
