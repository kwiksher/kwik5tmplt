-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
---------------------
---------------------
function _M:localPos(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
end
--
function _M:didShow()
    {{#addPhysics}}
    physics.start(true)
    {{/addPhysics}}
end
--
function _M:toDispose()
  {{#addPhysics}}
    physics.pause()
  {{/addPhysics}}

end
--
function _M:willHide()
end

--
function _M:localVars()
end
--
return _M