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
      -- ExternalCode: code
      print("hello")
    end
    return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"actPrint","actions":[{"command":"externalcode.code","params":{"line":"print("hello")"}}]}
]]
--
return ActionCommand