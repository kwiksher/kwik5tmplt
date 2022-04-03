-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = require("components.kwik.tabButFunction").new(scene)
--
local widget = require("widget")
local _K = require "Application"

local model, IAP, view = nil, nil, nil

if model.buyProductHide then
    storeModel = require("components.store.model")
    IAP = require("components.store.IAP")
    view = require("components.store.view").new()
end

function _M:localVars(UI)
    local model = UI.model

    if model.commonAsset then
        model.image = "p" .. UI.imagePage .. model.image
    end

    if model.bookTmplt then
        model.x, model.y, model.width, model.height, model.image = _K.getModel(model.name, model.image, UI.dummy)
    end

end
--
function _M:localPos(UI)
    local sceneGroup = UI.scene.view
    local layer = UI.layer

    if model.buyProductHide then
        -- Page properties
        view:init(sceneGroup, layer)
        IAP:init(
            storeModel.catalogue,
            view.restoreAlert,
            view.purchaseAlert,
            function(e)
                print("IAP cancelled")
            end,
            storeModel.debug
        )
    end

    local obj =  self:createButton(UI, model)
    if setImage(obj, model) then
        layer[model.name] = obj
        sceneGroup[model.name] = obj
        sceneGroup:insert(obj)
    end
end
--
function _M:didShow(UI)
    local sceneGroup = UI.scene.view
    local layer = UI.layer
    local self = UI.scene
    --
    if model.btaps and layer[model.name] then
        if model.mask then
            local mask = graphics.newMask(_K.imgDir .. model.mask, _K.systemDir)
            layer[model.name]:setMask(mask)
        end
        _M:addEventListenerForTap(
            UI,
            {
                obj = layer[model.name],
                btaps = model.btaps,
                eventName = model.name .. model.type .. model.trigger
            }
        )
    end
    --
    if model.buyProductHide then
        --Hide button if purchase was already made
        if IAP.getInventoryValue("unlock_" .. model.product) then
            --This page was purchased, do not show the BUY button
            layer[model.name].alpha = 0
        end
    end
end
--
function _M:toDispose(UI)
    local layer = UI.layer
    local sceneGroup = UI.scene.view

    if model.btaps and layer[model.name] then
        _M:removeEventListenerForTap(
            UI,
            {obj = layer[model.name], eventName = model.name .. model.type .. model.trigger}
        )
    end
end
--
function _M:toDestroy(UI)
end
--
function _M:createButton(UI, model)
    local obj

    if not model.commonAsset then
        model.image = "p" .. UI.imagePage .. model.image
    end
    -- Tap
    if model.btaps then 
        obj = display.newImageRect(_K.imgDir .. model.image, _K.systemDir, imageWidth, imageHeight)
    else -- Press
        local function onReleaseHandler(event)
            if event.target.enabled == nil or event.target.enabled then
                event.target.type = "press"
                if model.TV then
                    if event.target.isKey then
                        UI.scene:dispatchEvent({name = model.name .. model.type .. model.trigger, layer = event.target})
                    end
                else
                    UI.scene:dispatchEvent({name = model.name .. model.type .. model.trigger, layer = event.target})
                end
            end
        end

        obj =
            widget.newButton {
            id          = model.name,
            defaultFile = _K.imgDir .. imagePath,
            overFile    = _K.imgDir .. model.over,
            width       = imageWidth,
            height      = imageHeight,
            onRelease   = onReleaseHandler,
            baseDir     = _K.systemDir
        }
        --
        obj.on = onReleaseHandler
    end

    if model.mask then
        local mask = graphics.newMask(_K.imgDir .. model.mask, _K.systemDir)
        obj:setMask(mask)
    end

    return obj
end
--
return _M
