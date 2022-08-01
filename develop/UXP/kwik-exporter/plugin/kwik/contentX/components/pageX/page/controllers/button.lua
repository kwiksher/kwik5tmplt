-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = require("components.kwik.tabButFunction").new()
--
local _K = require "Application"
--
-- scene, layer and sceneGroup should be INPUT
-- tab{{um}} should be INPUT
-- tabja["witch"] = {"p2_witch_ja.png", 180, 262, 550, 581, 1}
--
-- UI.tSearch = tabja
--
function _M:localVars (UI)
end
--
function _M:localPos(UI)
end
--
function _M:didShow(UI)
  local sceneGroup = UI.scene.view
  local layer      = UI.layer
  local self       = UI.scene
  --
  {{#tabButFunction}}
    _M:createTabButFunction(UI, {obj=sceneGroup, btaps={{tabButFunction.btaps}}, eventName="{{myLName}}_{{layerType}}_{{triggerName}}"})
  {{/tabButFunction}}
  {{#Press}}
      local function on{{myLName}}Event(event)
        if event.phase == "began"  then
          if layer.{{myLName}}.enabled == nil or layer.{{myLName}}.enabled then
             layer.{{myLName}}.type = "press"
            -- {{bfun}}(layer.{{myLName}})
             self.scene:dispatchEvent({name="{{myLName}}_{{layerType}}_{{triggerName}}", layer=layer.{{myLName}}})
           end
      end
    end
    sceneGroup:addEventListener( "touch", on{{myLName}}Event )
  {{/Press}}
end
--
function _M:toDispose(UI)
  local sceneGroup = UI.scene.view
  {{#tabButFunction}}
    _M:removeTabButFunction(UI, {obj=sceneGroup, eventName="{{myLName}}_{{layerType}}_{{triggerName}}"})
  {{/tabButFunction}}
end
--
function _M:toDestroy(UI)
end
--
return _M