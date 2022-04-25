-- Code created by Kwik - Copyright: kwiksher.com   {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local _K = require "Application"
local composer = require("composer")
---------------------
---------------------
{{#BookShelf}}
local view          = require("components.store.view").new()
local storeFSM = require ( "components.store.storeFSM" ).getInstance()
---------------------
{{#TOC}}
function _M:resume()
--  ui:refresh(true)
end
--
local function hideOverlay()
    composer.hideOverlay("fade", 400 )
    return true
end
{{/TOC}}
{{/BookShelf}}
--
{{#simpleLock}}
local model       = require("components.store.model")
local IAP         = require ( "components.store.IAP" )
local view        = require("components.store.view").new()
{{/simpleLock}}
--
function _M:localPos(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
  -- Page properties
{{#BookShelf}}
    view:init(sceneGroup, layer, storeFSM.fsm)
    {{#TOC}}
    storeFSM:init(true, view) -- overlay
    {{/TOC}}
{{/BookShelf}}
{{#simpleLock}}
    view:init(sceneGroup, layer)
    IAP:init(model.catalogue, view.restoreAlert, view.purchaseAlert, function(e) print("IAP cancelled") end, model.debug)
{{/simpleLock}}
end
--F
function _M:localVars(UI)
end
--
function _M:didShow(UI)
  {{#BookShelf}}
  storeFSM.view = view
  {{/BookShelf}}
  {{#simpleLock}}
    {{#redirect}}
    if not IAP.getInventoryValue( "unlock_".."{{product}}" ) then
        --Page restricted. Send to pageError
        local infoString = "This page needs to be purchased."
        local function onComplete( event )
            if "clicked" == event.action then
                local i = event.index
                if 1 == i then
                    -- dispose()
                    if nil~= composer.getScene("{{pError}}") then
                      composer.removeScene("{{pError}}", true)
                    end
                    composer.gotoScene("{{pError}}", { effects = "fromLeft" } )
    -- protect_2
                end
             end
        end
        local alert = native.showAlert("Restricted Content", infoString,{ "OK" }, onComplete)
    end
    {{/redirect}}
  {{/simpleLock}}
end
--
--
function _M:toDispose(UI)
{{#BookShelf}}
    {{#TOC}}
    storeFSM:destroy()
    {{/TOC}}
{{/BookShelf}}
end
--
return _M