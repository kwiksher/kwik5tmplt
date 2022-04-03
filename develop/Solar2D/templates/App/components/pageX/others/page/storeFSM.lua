-- Code created by Kwik - Copyright: kwiksher.com 2016
-- Version: 4.0.3 01
-- Project: BookShelfTmplt
--
local _M = {}
---------------------
-- External libraries
local _K = require "Application"
local view          = require("components.store.view").new()
local storeFSM = require ( "components.store.storeFSM" ).getInstance() -- Available in Corona build #261 or later

  --
function _M:localVars(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
    end
--
function _M:localPos(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
  view:init(sceneGroup, layer, storeFSM.fsm)
end
--
function _M:didShow(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
  storeFSM.view = view
end
--
function _M:toDispose(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
    storeFSM:destroy()
end
--
return _M