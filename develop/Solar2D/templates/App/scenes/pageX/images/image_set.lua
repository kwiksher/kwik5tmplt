-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
{{#mySet}}
local layerSet_{{mySet}} = {
  {{#layerSet}}
    {
      myLName = "{{myLName}}",
      x       = {{mX}},
      y       = {{mY}},
      width   = {{elW}},
      height  = {{elH}},
      frameSet = {
      {{#frameSet}}
      {
        myLName = "{{myLName}}",
        x       = {{mX}},
        y       = {{mY}},
        width   = {{elW}},
        height  = {{elH}},
      },
      {{/frameSet}}
      }
    },
  {{/layerSet}}
  }
{{/mySet}}

{{#infinity}}
-- Infinity background animation
local function infinityBack(self, event)
     local xd, yd = self.x,self.y
     if (self.direction == "left" or self.direction == "right") then
         xd = self.width
         if (self.distance ~= nil) then
            xd = self.width + self.distance
        end
     elseif (self.direction == "up" or self.direction == "down") then
         yd = self.height
         if (self.distance ~= nil) then
            yd = self.height + self.distance
        end
     end
     if (self.direction == "left") then  --horizontal loop
        if self.x < (-xd + (self.speed*2)) then
           self.x = xd
        else
           self.x = self.x - self.speed
        end
     elseif (self.direction == "right") then  --horizontal loop
        if self.x > (xd - (self.speed*2)) then
           self.x = -xd
        else
           self.x = self.x + self.speed
        end
     elseif (self.direction == "up") then  --vertical loop
        if self.y < (-yd + (self.speed*2)) then
           self.y = yd
        else
           self.y = self.y - self.speed
        end
     elseif (self.direction == "down") then  --vertical loop
        if self.y > (yd - (self.speed*2)) then
           self.y = -yd
        else
           self.y = self.y + self.speed
        end
     end
end
{{/infinity}}
--
function _M:myMain()
end
-- not

{{#ultimate}}
local imageWidth             = {{elW}}/4
local imageHeight            = {{elH}}/4
local mX, mY                 = _K.ultimatePosition({{mX}}, {{mY}})
{{#randX}}
local randXStart = _K.ultimatePosition({{randXStart}})
local randXEnd = _K.ultimatePosition({{randXEnd}})
{{/randX}}
{{#randY}}
local dummy, randYStart = _K.ultimatePosition(0, {{randYStart}})
local dummy, randYEnd     = _K.ultimatePosition(0, {{randYEnd}})
{{/randY}}
{{#idist}}
local idist     = {{idist}}/4
{{/idist}}
{{/ultimate}}
{{^ultimate}}
local imageWidth = {{elW}}
local imageHeight = {{elH}}
local mX = {{mX}}
local mY = {{mY}}
{{#randX}}
local randXStart = {{randXStart}}
local randXEnd = {{randXEnd}}
{{/randX}}
{{#randY}}
local randYStart = {{randYStart}}
local randYEnd = {{randYEnd}}
{{/randY}}
{{#idist}}
local idist     = {{idist}}
{{/idist}}
{{/ultimate}}
local oriAlpha = {{oriAlpha}}
--
{{#kwk}}
local imagePath = "{{bn}}.{{fExt}}"
{{/kwk}}
{{^kwk}}
local imagePath = "p{{docNum}}/{{bn}}.{{fExt}}"
{{/kwk}}
--
function _M:localVars(UI)
  {{#multLayers}}
    UI.tab{{um}}["{{dois}}"] = {imagePath, imageWidth, imageHeight, mX, mY, oriAlpha}
  {{/multLayers}}
  {{^multLayers}}
  {{/multLayers}}
end
--
--[[
local info     = require ("assets.sprites.".."page{{docNum}}")
local sheet    = graphics.newImageSheet ( _K.spriteDir.."page{{docNum}}.png", info:getSheet() )
local sequence = {start=1, count= #info:getSheet().frames }
function newImageRect(name, width, height)
  local image
  if string.find(name, "background") == nil then
      image = display.newSprite(sheet, sequence)
      image.name = name
      image:setFrame (info:getFrameIndex (name))
      image.width, image.height = width, height
      else
       image = display.newImageRect(_K.imgDir..name.."."..{{fExt}}, width, height)
      end
   return image
end
--]]
--
function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
{{#mySet}}
  local options = {
   frames ={},
    sheetContentWidth = imageWidth,
    sheetContentHeight = imageHeight
  }
  local widthDiff = options.sheetContentWidth - 681/2
  local heightDiff = options.sheetContentHeight - 964/2
  --
  for i=1, #layerSet_{{mySet}} do
    local target = layerSet_{{mySet}}[i]
    local _x = (target.x - target.width/2)/4 + widthDiff/2
    local _y = (target.y - target.height/2)/4 + heightDiff/2
    -- print(_x, _y)
    options.frames[i] = {
      x = _x,
      y = _y,
      width = target.width/4,
      height = target.height/4
    }
    -- print(target.width/4, target.height/4)
  end
  layer.{{mySet}} = display.newGroup()
  local sheet = graphics.newImageSheet(_K.imgDir..imagePath, options )
  for i=1, #layerSet_{{mySet}} do
    local target = layerSet_{{mySet}}[i]
    local frame = options.frames[i]
    local frame1 = display.newImageRect( sheet, i, frame.width, frame.height )
    frame1.x, frame1.y = _K.ultimatePosition(target.x, target.y)
    frame1.name = target.myLName
    frame1.oriX              = frame1.x
    frame1.oriY              = frame1.y
    frame1.oriXs             = 1
    frame1.oriYs             = 1
    frame1.oldAlpha          = 1
    frame1.anim              = {}
    target.panel = frame1
    UI.layer[target.myLName] = frame1
    layer.{{mySet}}:insert(frame1)
  end
  --
  layer.{{myLName}}.imagePath = imagePath
  -- layer.{{myLName}}.x = mX
  -- layer.{{myLName}}.y = mY
  layer.{{myLName}}.alpha = oriAlpha
  layer.{{myLName}}.oldAlpha = oriAlpha
  layer.{{myLName}}.blendMode = "{{bmode}}"
  {{#scaleW}}
    layer.{{myLName}}.xScale = {{scaleW}}
  {{/scaleW}}
  {{#scaleH}}
    layer.{{myLName}}.yScale = {{scaleH}}
  {{/scaleH}}
  {{#rotate}}
    layer.{{myLName}}:rotate( {{rotate}} )
  {{/rotate}}
  layer.{{myLName}}.oriX = layer.{{myLName}}.x
  layer.{{myLName}}.oriY = layer.{{myLName}}.y
  layer.{{myLName}}.oriXs = layer.{{myLName}}.xScale
  layer.{{myLName}}.oriYs = layer.{{myLName}}.yScale
  layer.{{myLName}}.name = "{{myLName}}"
  sceneGroup.{{myLName}} = layer.{{myLName}}
  sceneGroup:insert( layer.{{myLName}})
{{/mySet}}
{{^mySet}}
  {{^multLayers}}
    layer.{{myLName}} = display.newImageRect( _K.imgDir..imagePath, imageWidth, imageHeight)
    -- layer.{{myLName}} = newImageRect({{bn}}, imageWidth, imageHeight )
    layer.{{myLName}}.imagePath = imagePath
    layer.{{myLName}}.x = mX
    layer.{{myLName}}.y = mY
    layer.{{myLName}}.alpha = oriAlpha
    layer.{{myLName}}.oldAlpha = oriAlpha
    layer.{{myLName}}.blendMode = "{{bmode}}"
    {{#randX}}
      layer.{{myLName}}.x = math.random( randXStart, randXEnd)
    {{/randX}}
    {{#randY}}
      layer.{{myLName}}.y = math.random( randYStart, randYEnd)
    {{/randY}}
    {{#scaleW}}
      layer.{{myLName}}.xScale = {{scaleW}}
    {{/scaleW}}
    {{#scaleH}}
      layer.{{myLName}}.yScale = {{scaleH}}
    {{/scaleH}}
    {{#rotate}}
      layer.{{myLName}}:rotate( {{rotate}} )
    {{/rotate}}
    layer.{{myLName}}.oriX = layer.{{myLName}}.x
    layer.{{myLName}}.oriY = layer.{{myLName}}.y
    layer.{{myLName}}.oriXs = layer.{{myLName}}.xScale
    layer.{{myLName}}.oriYs = layer.{{myLName}}.yScale
    layer.{{myLName}}.name = "{{myLName}}"
    sceneGroup.{{myLName}} = layer.{{myLName}}
    {{#layerAsBg}}
      sceneGroup:insert( 1, layer.{{myLName}})
    {{/layerAsBg}}
    {{^layerAsBg}}
      sceneGroup:insert( layer.{{myLName}})
    {{/layerAsBg}}
    --
    {{#infinity}}
      layer.{{myLName}}_2 = display.newImageRect( _K.imgDir..imagePath, imageWidth, imageHeight)
        -- layer.{{myLName}}_2 = newImageRect({{bn}}, imageWidth, imageHeight )
      layer.{{myLName}}_2.blendMode = "{{bmode}}"

      sceneGroup:insert( layer.{{myLName}}_2)
      sceneGroup.{{myLName}}_2 = layer.{{myLName}}_2
      layer.{{myLName}}.anchorX = 0
      layer.{{myLName}}.anchorY = 0;
      _K.repositionAnchor(layer.{{myLName}}, 0,0)
      layer.{{myLName}}_2.anchorX = 0
      layer.{{myLName}}_2.anchorY = 0;
      _K.repositionAnchor(layer.{{myLName}}_2, 0,0)
      {{#up}}
        layer.{{myLName}}.x = layer.{{myLName}}.oriX
        layer.{{myLName}}.y = 0;
        {{#idist}}
          layer.{{myLName}}_2.y = layer.{{myLName}}.height + {{idist}}
          layer.{{myLName}}_2.x = layer.{{myLName}}.oriX;
          layer.{{myLName}}.distance = {{idist}}
          layer.{{myLName}}_2.distance = {{idist}}
        {{/idist}}
        {{^idist}}
          layer.{{myLName}}_2.y = layer.{{myLName}}.height
          layer.{{myLName}}_2.x = layer.{{myLName}}.oriX;
        {{/idist}}
          layer.{{myLName}}.enterFrame = infinityBack
          layer.{{myLName}}.speed = {{infinitySpeed}}
          layer.{{myLName}}.direction = "{{idir}}"
          layer.{{myLName}}_2.enterFrame = infinityBack
          layer.{{myLName}}_2.speed = {{infinitySpeed}}
          layer.{{myLName}}_2.direction = "{{idir}}"
      {{/up}}
      {{#down}}
        layer.{{myLName}}.x = layer.{{myLName}}.oriX
        layer.{{myLName}}.y = 0;
        {{#idist}}
          layer.{{myLName}}_2.y = -layer.{{myLName}}.height - {{idist}}
          layer.{{myLName}}_2.x = layer.{{myLName}}.oriX;
          layer.{{myLName}}.distance = idist
          layer.{{myLName}}_2.distance = idist
        {{/idist}}
        {{^idist}}
          layer.{{myLName}}_2.y = -layer.{{myLName}}.height
          layer.{{myLName}}_2.x = layer.{{myLName}}.oriX;
        {{/idist}}
          layer.{{myLName}}.enterFrame = infinityBack
          layer.{{myLName}}.speed = {{infinitySpeed}}
          layer.{{myLName}}.direction = "{{idir}}"
          layer.{{myLName}}_2.enterFrame = infinityBack
          layer.{{myLName}}_2.speed = {{infinitySpeed}}
          layer.{{myLName}}_2.direction = "{{idir}}"
      {{/down}}
      {{#right}}
        layer.{{myLName}}.x = 0
        layer.{{myLName}}.y = layer.{{myLName}}.oriY;
        {{#idist}}
          layer.{{myLName}}_2.x = -layer.{{myLName}}.width + {{idist}}
          layer.{{myLName}}_2.y = layer.{{myLName}}.oriY;
          layer.{{myLName}}.distance = idist
          layer.{{myLName}}_2.distance = idist
        {{/idist}}
        {{^idist}}
          layer.{{myLName}}_2.x = -layer.{{myLName}}.width
          layer.{{myLName}}_2.y = layer.{{myLName}}.oriY;
        {{/idist}}
        layer.{{myLName}}.enterFrame = infinityBack
        layer.{{myLName}}.speed = {{infinitySpeed}}
        layer.{{myLName}}.direction = "{{idir}}"
        layer.{{myLName}}_2.enterFrame = infinityBack
        layer.{{myLName}}_2.speed = {{infinitySpeed}}
        layer.{{myLName}}_2.direction = "{{idir}}"
      {{/right}}
      {{#left}}
        layer.{{myLName}}.x = 0
        layer.{{myLName}}.y = layer.{{myLName}}.oriY;
        {{#idist}}
          layer.{{myLName}}_2.x = layer.{{myLName}}.width + {{idist}}
          layer.{{myLName}}_2.y = layer.{{myLName}}.oriY;
                layer.{{myLName}}.distance = idist
                layer.{{myLName}}_2.distance = idist
        {{/idist}}
        {{^idist}}
          layer.{{myLName}}_2.x = layer.{{myLName}}.width
          layer.{{myLName}}_2.y = layer.{{myLName}}.oriY;
        {{/idist}}
          layer.{{myLName}}.enterFrame = infinityBack
          layer.{{myLName}}.speed = {{infinitySpeed}}
          layer.{{myLName}}.direction = "{{idir}}"
          layer.{{myLName}}_2.enterFrame = infinityBack
          layer.{{myLName}}_2.speed = {{infinitySpeed}}
          layer.{{myLName}}_2.direction = "{{idir}}"
      {{/left}}
    {{/infinity}}
  {{/multLayers}}
{{/mySet}}
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{^multLayers}}
    {{#infinity}}
       -- Infinity background
       Runtime:addEventListener("enterFrame", layer.{{myLName}})
       Runtime:addEventListener("enterFrame", layer.{{myLName}}_2)
    {{/infinity}}
  {{/multLayers}}
end
--
function _M:toDispose(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{^multLayers}}
    {{#infinity}}
      if layer.{{myLName}} == nil  or layer.{{myLName}}_2 == nil then return end
      Runtime:removeEventListener("enterFrame", layer.{{myLName}})
      Runtime:removeEventListener("enterFrame", layer.{{myLName}}_2)
    {{/infinity}}
  {{/multLayers}}
end
--
function  _M:toDestory()
end
--
return _M