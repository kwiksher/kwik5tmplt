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
    obj = UI.audios["Crickets"]
    AC.Audio:play(UI, obj, nil, 1000, nil, nil, nil, "nil")
  end
  return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"eventAudio","actions":[{"command":"..audio.play","params":{"loops":"nil","volume":"nil","channel":"nil","target":"Crickets","fadein":"nil","delay":"1000","listener":"nil"}}]}
]]
--
return ActionCommand
