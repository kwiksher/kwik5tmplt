-- $weight=-1
--
local _M = {}

--
function _M:init(UI)
end
--
function _M:create(UI)
  local sceneGroup = UI.scene.view
  local obj = display.newCircle( sceneGroup, display.contentCenterX, display.contentCenterY-100, 50 )
  obj:setFillColor(0.2,0.8,0.2);
end
--
function _M:didShow(UI)
  local sceneGroup = UI.scene.view
end
--
function _M:didHide(UI)
  local sceneGroup = UI.scene.view
end
--
function  _M:destory()
end
--
return _M