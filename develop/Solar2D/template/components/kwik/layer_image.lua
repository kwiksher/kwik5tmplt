-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local app = require "Application"
local util = require "lib.util"
-- Infinity background animation
local function infinityBackHandler(self, event)
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
--
local function createInfinityImage(self, sceneGroup, layer)
  local layer_2 = display.newImageRect( app.imgDir..self.imagePath, app.systemDir, self.imageWidth, self.imageHeight)
  -- layer_2 = newImageRect({{bn}}, imageWidth, imageHeight )
  if layer_2 == nil then return end
  layer_2.blendMode = self.blendMode
  sceneGroup:insert(layer_2)
  sceneGroup[self.layerName.."_2"] = layer_2
  --
  layer.anchorX = 0
  layer.anchorY = 0;
  util.repositionAnchor(layer, 0,0)
  --
  layer_2.anchorX = 0
  layer_2.anchorY = 0;
  util.repositionAnchor(layer_2, 0,0)
  --
  if self.inifityDirection == "up" then
  layer.x = layer.oriX
  layer.y = 0;
  if self.infinityDistance > 0 then
    layer_2.y = layer.height + self.infinityDistance
    layer_2.x = layer.oriX;
    layer.distance = self.infinityDistance
    layer_2.distance = self.infinityDistance
  else
    layer_2.y = layer.height
    layer_2.x = layer.oriX;
  end
    layer.enterFrame = infinityBackHandler
    layer.speed = self.infinitySpeed
    layer.direction = self.infinityDirection
    layer_2.enterFrame = infinityBackHandler
    layer_2.speed = self.infinitySpeed
    layer_2.direction = self.infinityDirection
  elseif self.inifityDirection == "down" then
  layer.x = layer.oriX
  layer.y = 0;
  if self.infinityDistance > 0 then
    layer_2.y = -layer.height - self.infinityDistance
    layer_2.x = layer.oriX;
    layer.distance = idist
    layer_2.distance = idist
  else
    layer_2.y = -layer.height
    layer_2.x = layer.oriX;
  end
    layer.enterFrame = infinityBackHandler
    layer.speed = self.infinitySpeed
    layer.direction = self.infinityDirection
    layer_2.enterFrame = infinityBackHandler
    layer_2.speed = self.infinitySpeed
    layer_2.direction = self.infinityDirection
  elseif self.inifityDirection == "right" then
  layer.x = 0
  layer.y = layer.oriY;
  if self.infinityDistance > 0 then
    layer_2.x = -layer.width + self.infinityDistance
    layer_2.y = layer.oriY;
    layer.distance = idist
    layer_2.distance = idist
  else
    layer_2.x = -layer.width
    layer_2.y = layer.oriY;
  end
  layer.enterFrame = infinityBackHandler
  layer.speed = self.infinitySpeed
  layer.direction = self.infinityDirection
  layer_2.enterFrame = infinityBackHandler
  layer_2.speed = self.infinitySpeed
  layer_2.direction = self.infinityDirection
  elseif self.inifityDirection == "left" then
  layer.x = 0
  layer.y = layer.oriY;
  if self.infinityDistance > 0 then
    layer_2.x = layer.width + self.infinityDistance
    layer_2.y = layer.oriY;
          layer.distance = idist
          layer_2.distance = idist
  else
    layer_2.x = layer.width
    layer_2.y = layer.oriY;
  end
    layer.enterFrame = infinityBackHandler
    layer.speed = self.infinitySpeed
    layer.direction = self.infinityDirection
    layer_2.enterFrame = infinityBackHandler
    layer_2.speed = self.infinitySpeed
    layer_2.direction = self.infinityDirection
  end
end

function _M:newImage(UI, sceneGroup)
  local layer = display.newImageRect( app.imgDir..self.imagePath, app.systemDir, self.imageWidth, self.imageHeight)
  -- layer = newImageRect({{bn}}, imageWidth, imageHeight )
  if layer == nil then return end
  layer.imagePath = self.imagePath
  layer.x = self.mX
  layer.y = self.mY
  layer.alpha = self.oriAlpha
  layer.oldAlpha = self.oriAlpha
  layer.blendMode = self.blendMode
  if self.randXStart > 0 then
    layer.x = math.random( self.randXStart, self.randXEnd)
  end
  if self.randYStart > 0 then
    layer.y = math.random( self.randYStart, self.randYEnd)
  end
  if self.scaleX then
    layer.xScale = self.scaleX
  end
  if self.scaleY then
    layer.yScale = self.scaleY
  end
  if self.rotation then
    layer:rotate( self.rotation )
  end
  layer.oriX = layer.x
  layer.oriY = layer.y
  layer.oriXs = layer.xScale
  layer.oriYs = layer.yScale
  layer.name = self.layerName
  layer.type = "image"
  sceneGroup[self.layerName] = layer
  if self.layerAsBg then
    sceneGroup:insert( 1, layer)
  else
    sceneGroup:insert( layer)
  end
  --
  if self.infinity then
    createInfinityImage(self, sceneGroup, layer)
  end
  return layer
end


function _M:myNewImage(UI)
  return self:newImage(UI, UI.scene.view)
end
--
function _M:comicImage(UI)
  local sceneGroup = UI.scene.view
  local options = {
    frames ={},
     sheetContentWidth = self.imageWidth,
     sheetContentHeight = self.imageHeight
   }
   local widthDiff = options.sheetContentWidth - self.mX/2
   local heightDiff = options.sheetContentHeight - self.mY/2
   --
   for i=1, #self.layerSet do
     local target = self.layerSet[i]
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
   local group = display.newGroup()
   local sheet = graphics.newImageSheet(app.imgDir..self.imagePath, app.systemDir, options )
   for i=1, #self.layerSet do
     local target = self.layerSet[i]
     local frame = options.frames[i]
     local frame1 = display.newImageRect( sheet, i, frame.width, frame.height )
     frame1.x, frame1.y = app.getPosition(target.x, target.y)
     frame1.name = target.myLName
     frame1.oriX              = frame1.x
     frame1.oriY              = frame1.y
     frame1.oriXs             = 1
     frame1.oriYs             = 1
     frame1.oldAlpha          = 1
     frame1.anim              = {}
     target.panel = frame1
     UI.layer[target.myLName] = frame1
     group:insert(frame1)
   end
   --
   UI.layer[self.layerSetName] = group
  --  sceneGroup:insert(layer) necessary?
end

_M.new = function()
	local instance = {}
	return setmetatable(instance, {__index=_M})
end

return _M