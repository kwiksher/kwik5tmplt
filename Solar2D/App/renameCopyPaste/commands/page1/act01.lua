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
    AC.Button:onOff("gotoBtn", true, true ) -- enable, toggle
    --
    -- target layer :sceneGroup[layerName]
    -- target animation : layer.animations[index]
    --
    AC.Animation:pause("title")
  end
  return setmetatable( command, {__index=AC})
end
--
return ActionCommand
