-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {timer={}}
local _K = require("Application")
---------------------
---------------------
function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  --
  UI.layerSet_{{mySet}} = {
  {{#layerSet}}
    {
      myLName = "{{myLName}}",
      x       = {{mX}},
      y       = {{mY}},
      width   = {{elW}},
      height  = {{elH}},
      frameSet = {
      {{#frameSet}}
      {
        myLName = "{{myLName}}",
        x       = {{mX}},
        y       = {{mY}},
        width   = {{elW}},
        height  = {{elH}},
      },
      {{/frameSet}}
      }
    },
  {{/layerSet}}
  }
end
---------------
--
---------------
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer = UI.layer
end
--
function _M:toDispose(UI)
  UI.scrollView:removeSelf()
  self:cancel()
end
--
function _M:localVars()
end
--
return _M