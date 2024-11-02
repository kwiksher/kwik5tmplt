local M = {}

local App = require("controller.Application")
local util = require("lib.util")

function M:create(UI)
  local sceneGroup  = UI.sceneGroup
  local layerProps = self.layerProps

  local mVar = UI:getVariable(self.properties.variable) or ""
  if self.properties.type == "global" then
    local app = App.get()
    myVar = app:getVariable(self.properties.variable) or ""
  end
  ---
  --- we need the link information for setVar to update dynamictext
  local tbl = UI.dynmictexts[self.properties.variable] or {}
  tbl[#tbl+1] = self.name

  local _font = native.systemFont
  if self.properties.font:len() > 0 then
    _font = self.properties.font
  end
  --
  local options = {
    text = mVar,
    x = self.x + self.properties.offsetX, -- + layerProps.imageWidth/2,
    y = self.y + self.properties.offsetY,
    fontSize = self.properties.fontSize,
    font = _font,
    align = self.properties.align }

  local obj = display.newText(options)
  if obj == nil then return end
  obj:setFillColor( unpack(self.properties.color) )
  obj.anchorX = 0.5
  obj.anchorY = 0.25
  util.repositionAnchor(obj,0.5,0)

  obj.alpha     = layerProps.oriAlpha
  obj.oldAlpha  = layerProps.oriAlpha
  obj.blendMode = layerProps.blendMode
  --
  obj.layerAsBg = layerProps.layerAsBg
  obj.isSharedAsset = layerProps.isSharedAsset
  ---
  obj.shapedWith  = layerProps.shapedWith
  obj.randXStart  = layerProps.randXStart
  obj.randXEnd    = layerProps.randXEnd
  obj.randYStart  = layerProps.randYStart
  obj.randYEnd    = layerProps.randYEnd
  obj.type        = layerProps.type
  obj.kind        = layerProps.kind

 if layerProps.randXStart and layerProps.randXStart > 0 then
  obj.x = math.random( layerProps.randXStart, layerProps.randXEnd)
 end
 if layerProps.randYStart and layerProps.randYStart > 0  then
    obj.y = math.random( layerProps.randYStart, layerProps.randYEnd)
 end
 if layerProps.xScale then
   obj.xScale = layerProps.xScale
 end
 if layerProps.yScale then
   obj.yScale = layerProps.yScale
 end
 if layerProps.rotation then
   obj:rotate( layerProps.rotation )
 end

  obj.oriX     = obj.x
  obj.oriY     = obj.y
  obj.oriXs    = obj.xScale
  obj.oriYs    = obj.yScale
  obj.alpha    = layerProps.oriAlpha
  obj.oldAlpha = layerProps.oriAlpha

  local targetObj = sceneGroup[self.name]
  sceneGroup:remove(targetObj)
  ---
  sceneGroup:insert( obj)
  sceneGroup[self.name] = obj
  self.obj = obj
  self.UI = UI
end

function M:didShow(UI)
end
--
function M:didHide(UI)
end

function  M:destroy(UI)
end

function M:update(value)
  local UI = self.UI
  local name = self.properties.variable
  local mVar = UI:getVariable(name) or ""
  if self.properties.type == "global" then
    local app = App.get()
    myVar = app:getVariable(name) or ""
    if value then
      app:setVariable(name, value)
    end
  else
    if value then
      print("@@@", self.name, name, value)
      UI:setVariable(name, value)
    end
  end
  self.obj.text = value or myVar
end
---------------------------
M.new = function(instance)
	return setmetatable(instance, {__index=M})
end

return M
