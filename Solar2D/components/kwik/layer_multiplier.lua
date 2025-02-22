local M = require("components.kwik.layer_base").new()
--
function M:create(UI)
  local sceneGroup = UI.sceneGroup
  local layeName = self.properties.target
  local props = self.properties
  local layerProps = self.layerProps
  --
  self.group = display.newGroup()
  sceneGroup:insert(self.group)
end
--
function M:didShow(UI)
  local sceneGroup = UI.sceneGroup
  local layeName =self.properties.target
  local props = self.properties
  local layerProps = self.layerProps

  local objs = {}
  local count = 0
  self.maxCopies = props.numOfCopies
  --
  if props.enablePhysics then
    physics.start(true)
  end
  --
  local handler = function(counter)
    print(counter)
    if props.enabledWind then
      physics.setGravity(math.random(props.windSpeed * -1, props.windSpeed) / 10, 4)
    end
    --
    objs.counter = display.newImageRect(UI.props.imgDir .. layerProps.imagePath, UI.props.systemDir, layerProps.imageWidth, layerProps.imageHeight)
    --
    if props.fixedDistance then
      objs.counter.x = math.random(props.xStart, props.xEnd)
      objs.counter.y = math.random(props.yStart, props.yEnd)
    else
      objs.counter.x = mX + ((counter - 1) * props.xStart)
      objs.counter.y = mY + ((counter - 1) * props.yStart)
    end
    --
    objs.counter.oldAlpha = layyerProps.oriAlpha
    objs.counter.alpha = math.random(props.alphaMin, props.alphaMax) / 100
    --
    objs.counter.xScale = math.random(props.xScaleMin, props.xSaleMax) / 100
    objs.counter.yScale = math.random(props.yScaleMin, props.ySaleMax) / 100
    --
    objs.counter.rotation = math.random(props.rotationMin, props.rotationMax)
    --
    if props.enablePhysics then
      physics.addBody(objs.counter, "dynamic", {density = pweight, friction = 0, bounce = 0, shape = porps.shape})
      --
      if props.enableSeonsor then
        objs.counter.isSensor = true
      end
      --
      local pweight = math.random(props.weightMin, props.weightMax)
      objs.counter.linearDumping = pweight * objs.counter.xScale
    end
    self.group:insert(objs.counter)
    self.objs = objs
  end
  --
  local function copyHandler()
    print("copyHandler")
    if self.timer0 then
      count = count + 1
      if handler ~= nil then
        handler(count)
      end
      print("", self.maxCopies, props.playForever)
      if (count == self.maxCopies and props.playForever) then
        if self.timer1 then
          timer.cancel(self.timer1)
        end
        self.timer1 = timer.performWithDelay(props.interval*1000, copyHandler, props.numOfCopies)
        self.maxCopies = count + props.numOfCopies
      end
    end
  end
  --
  if props.autoPlay then
    print("@@@@@@@@@", props.interval*1000,  props.numOfCopies)
    self.timer0 = timer.performWithDelay(props.interval*1000, copyHandler, props.numOfCopies)
    UI.timers[#UI.timers + 1] = self.timer0
  end
  --
  if self.hashasMutliplier == nil then
    self.hashasMutliplier = true
    -- Clean up memory for Multiplier set to forever
    -- control variable to dispose kClean via kNavi
    self.cleanHandler = function()
      -- runs normal code
      self:codeMultiplier(UI)
    end
    Runtime:addEventListener("enterFrame", self.cleanHandler)
  end
end
--
local function isReachedEnd(y, props)
  if props.gravity == "inverted" then
    return y < 0
  else
    return y > display.actualContentHeight
  end
end
--
function M:codeMultiplier(UI)
  local sceneGroup = UI.sceneGroup
  local layer = UI.layer
  local objs = self.objs
  --
  if objs == nil then return end
  --
  for i = 1, self.maxCopies do
    if objs[i] ~= nil then
      if objs[i].y ~= nil and isReachedEnd(objs[i].y, props) then
        display.remove(objs[i])
        objs[i]:removeSelf()
        objs[i] = nil
      end
    end
  end
end
--
function M:didHide(UI)
  if self.hasMutliplier then
    if self.cleanHandler ~= nil then
      Runtime:removeEventListener("enterFrame", self.cleanHandler)
      self.cleanHandler = nil
    end
  end
  if self.timer0 then
    timer.cancel(self.timer0)
  end
  if self.timer1 then
    timer.cancel(self.timer1)
  end
end
--
function M:destroy(UI)
  local sceneGroup = UI.sceneGroup
  local layer = UI.layer
  self.group:removeSelf()
  self.group = nil
  if self.hashasMutliplier then
    self.cleanHandler = nil
  end
end
--
M.set = function(instance)
  return setmetatable(instance, {__index = M})
end
return M
