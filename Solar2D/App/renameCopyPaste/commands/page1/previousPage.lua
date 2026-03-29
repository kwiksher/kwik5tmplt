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
    AC.Page:gotoPage("PREVIOUS", "fromLeft", 0, 0);
    obj = UI.sceneGroup["title3"]
    AC.Layer:showHide(obj,  true, true, nil, nil)
  end
  return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"previousPage","actions":[{"command":"page.gotoPage","params":{"duration":0,"pageName":"PREVIOUS","delay":0,"effect":"fromLeft"}},{"command":"layer.showHide","params":{"time":"nil","target":"title3","toggle":"true","delay":"nil","hide":"true"}}]}
]]
--
return ActionCommand
