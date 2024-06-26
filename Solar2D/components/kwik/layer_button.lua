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
  local props = self.properties
  if props.type == "touch"   then
      local function onReleaseHandler(event)
        print("onReleaseHandler")
          if event.target.enabled == nil or event.target.enabled then
              event.target.type = "touch"
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

      local path1 = system.pathForFile( UI.props.imgDir ..self.layerProps.imagePath, system.ResourceDirectory)
      local path2 = system.pathForFile( UI.props.imgDir ..UI.page.."/"..props.over..".png", system.ResourceDirectory)

      local path1 =  UI.props.imgDir ..self.layerProps.imagePath
      local path2 =  UI.props.imgDir ..UI.page.."/"..props.over..".png"

      if path1 and path2 then
        print("------- widget.newButton")

        local posX, posY = obj.x, obj.y
        local alpha = obj.alpha
        obj.alpha = 0 -- remove?

        obj =
            widget.newButton {
            id          = self.name,
            defaultFile = path1,
            overFile    = path2,
            width       = self.layerProps.imageWidth,
            height      = self.layerProps.imageHeight,
            onRelease   = onReleaseHandler,
            baseDir     =  system.ResourceDirectory, -- UI.props.systemDir
        }
        --
        if obj == nil then
          print ("@@@@ Error create widget @@@@", path1, path2)
        end
        obj.x, obj.y  = posX, posY
        obj.alpha = alpha
        sceneGroup:insert(obj)
        sceneGroup[self.name] = obj
        obj.on = onReleaseHandler
      else
          print ("@@@@ Error@@@@", path1, path2)
      end
  end

    --
    -- kwik5/templates/Solar2D/scenes/pageXXX/images/image_renderer.lua
    --   for instance  obj.enterFrame = infinityBack
    --
    --   setImage(obj, model) then
    --


  if props.mask:len() > 0 and UI.imagePage then
      local path = system.pathForFile(  UI.props.imgDir ..UI.imagePage.. props.mask, system.ResourceDirectory)
      if path then
        local mask = graphics.newMask( UI.props.imgDir ..UI.imagePage.. props.mask, UI.props.systemDir)
        obj:setMask(mask)
      end
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
    local props = self.properties
    -- Tap
    if props.type  == "tap" and props.btaps and sceneGroup[self.name] then
        --
        local obj = sceneGroup[self.name]
        local eventName = props.onTap

        function obj:tap(event)
          print("tap")
          event.UI = UI
          if props.enabled or props.enabled == nil then
            if props.btaps and event.numTaps then
              if event.numTaps == props.btaps then
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
    if props.buyProductHide then
      local IAP = require("components.store.IAP")
        --Hide button if purchase was already made
        if IAP.getInventoryValue("unlock_" .. props.product) then
            --This page was purchased, do not show the BUY button
            sceneGroup[self.name].alpha = 0
        end
    end
end
--
function M:removeEventListener(UI)
    local layers = UI.layers
    local sceneGroup = UI.sceneGroup
    local props = self.properties
    -- Tap
    if props.btaps and sceneGroup[self.name] then
      local obj = sceneGroup[self.name]
      obj:removeEventListener("tap", obj)
    end
end
--
function M:destroy(UI)
end

M.set = function(model)
  return setmetatable( model, {__index=M})
end

--
return M
