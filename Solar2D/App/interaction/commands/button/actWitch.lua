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

    native.showAlert("action", "witch")

    --printKeys(event.target)
    -- local conditions = require("App." .. UI.book..".common.conditions")
    -- local expressions = require("App." .. UI.book.."common.expressions")
  end
  return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"actWitch","actions":[]}
]]
--
return ActionCommand
