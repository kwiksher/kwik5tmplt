-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local _K = require "Application"

--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
    _K.shakeMe = function(e)
     if(e.isShake == true) then
           UI.scene:dispatchEvent({name="action_{{gcomplete}}", shake=e })
     end
     return true
    end
    Runtime:addEventListener("accelerometer", _K.shakeMe)
end
--
return _M