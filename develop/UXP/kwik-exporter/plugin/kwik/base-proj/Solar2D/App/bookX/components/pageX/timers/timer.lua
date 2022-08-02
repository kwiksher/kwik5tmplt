-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local _K = require("Application")
---------------------
---------------------
function _M:localPos(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
end
--
function _M:didShow(UI)
  _K.timerStash.{{gname}} = timer.performWithDelay({{gdelay}}*1000 ,
  	function()
      UI.scene:dispatchEvent({name = "{{gcomplete}}" })
  	end,
  	{{gloop}} )
end
--
function _M:toDispose()
end

function _M:willHide()
end

--
function _M:localVars()
end
--
return _M