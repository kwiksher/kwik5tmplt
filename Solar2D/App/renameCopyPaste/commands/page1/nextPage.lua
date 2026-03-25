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
    -- local alert = native.showAlert("Alert", "Hello", { "OK" } )
    -- printKeys(event.target)
    -- local conditions = require("App." .. UI.book..".common.conditions")
    -- local expressions = require("App." .. UI.book.."common.expressions")
    AC.Page:gotoPage("NEXT", "fromRight", 0, 0);
  end
  return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"nextPage","actions":[{"command":"page.gotoPage","params":{"pageName":"NEXT","duration":0,"delay":0,"effect":"fromRight"}}]}
]]
--
return ActionCommand
