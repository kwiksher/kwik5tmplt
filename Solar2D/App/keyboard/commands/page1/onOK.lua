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


    if UI:getVariable("LCD")  == UI:getVariable("numDica")       then






      obj = UI.sceneGroup["Win"]
      AC.Layer:showHide(obj,  false, false, 0, 0)










    end

  end
  return setmetatable( command, {__index=AC})
end
--
ActionCommand.model = [[
{"name":"onOK","actions":[{"command":"condition.__if","params":{"A1_":"UI:getVariable("LCD")","A2_Operand":"==","A3_":"UI:getVariable("numDica")"}},{"command":"layer.showHide","params":{"time":0,"target":"Win","toggle":"false","delay":0,"hide":"false"}},{"command":"condition._end","params":[]}]}
]]
--
return ActionCommand
