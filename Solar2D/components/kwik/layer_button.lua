local M = {}
--
local widget = require("widget")
local app = require "Application"
--
function M:createButton(UI)
  local sceneGroup = UI.sceneGroup
  print(self.layerProps.name)
  local layerName = self.layerProps.name
  local obj = sceneGroup[layerName]
  local path = UI.props.imgDir .. layerName
  -- Tap
  if self.btaps  > 0 then
      local function onReleaseHandler(event)
          if event.target.enabled == nil or event.target.enabled then
              event.target.type = "press"
              if self.TV then
                  if event.target.isKey then
                      UI.scene:dispatchEvent({name = self.actions.onTap, layers = event.target})
                  end
              else
                  -- print("###", self.actions.onTap)
                  UI.scene:dispatchEvent({name = self.actions.onTap, layers = event.target})
              end
          end
      end

      obj =
          widget.newButton {
          id          = self.name,
          defaultFile = UI.props.imgDir ..self.layerProps.imagePath,
          overFile    = UI.props.imgDir ..self.over..".png",
          width       = self.imageWidth,
          height      = self.imageHeight,
          onRelease   = onReleaseHandler,
          baseDir     = UI.props.systemDir
      }
      --
      obj.on = onReleaseHandler
  end

    --
    -- kwik5/templates/Solar2D/scenes/pageXXX/images/image_renderer.lua
    --   for instance  obj.enterFrame = infinityBack
    --
    --   setImage(obj, model) then
    --


  if self.mask:len() > 0 then
      local mask = graphics.newMask(UI.props.imgDir ..UI.imagePage.. self.mask, UI.props.systemDir)
      obj:setMask(mask)
  end

  local sceneGroup = UI.sceneGroup
  local layers = UI.layers

  if self.buyProductHide then
    local storeModel = require("components.store.model")
    local IAP = require("components.store.IAP")
    local view = require("components.store.view").new()

      -- Page properties
      view:init(sceneGroup, layers)
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

  return obj
end

function M:init()
end
--
--

function M:addEventListener(UI)
    local sceneGroup = UI.sceneGroup
    local layers = UI.layers
    -- Tap
    if self.btaps and layers[self.name] then
        --
        local obj = layers[self.name]
        local eventName = self.onTap

        function obj:tap(event)
          print("tap")
          event.UI = UI
          if self.enabled or self.enabled == nil then
            if self.btaps and event.numTaps then
              if event.numTaps == self.btaps then
                  UI.scene:dispatchEvent({name=eventName, event = event})
              end
            else
              -- print("###", eventName)
                  UI.scene:dispatchEvent({name=eventName, event = event})
            end
          end
        end
        obj:addEventListener("tap",obj)
    end
    --
    if self.buyProductHide then
      local IAP = require("components.store.IAP")
        --Hide button if purchase was already made
        if IAP.getInventoryValue("unlock_" .. self.product) then
            --This page was purchased, do not show the BUY button
            layers[self.name].alpha = 0
        end
    end
end
--
function M:removeEventListener(UI)
    local layers = UI.layers
    local sceneGroup = UI.sceneGroup
    -- Tap
    if self.btaps and layers[self.name] then
      local obj = layers[self.name]
      obj:removeEventListener("tap", obj)
    end
end
--
function M:destroy(UI)
end

M.new = function(model)
  return setmetatable( model, {__index=M})
end

--
return M
