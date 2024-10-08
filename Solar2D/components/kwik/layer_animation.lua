local M = {}
--
local app = require "controller.Application"
local util = require("lib.util")
local gtween = require("extlib.gtween")
local btween = require("extlib.btween")

---
local animationFactory = {}
--
--
local function groupPos(self, layer, _endX, _endY, isSceneGroup)
  local mX, mY
  local endX, endY = app.getPosition(_endX, _endY)
  local width, height = layer.width * layer.xScale, layer.height * layer.yScale

  local referencePoint = self.layerOptions.referencePoint
  if referencePoint == "Center" then
    if isSceneGroup then
      mX = endX + layer.x
      mY = endY + layer.y
    else
      mX = endX + width / 2
      mY = endY + height / 2
    end
  end
  if referencePoint == "TopLeft" then
    mX = endX + width / 2
    mY = endY + height / 2
  end
  if referencePoint == "TopCenter" then
    mX = endX + width / 2
    mY = endY + height / 2
  end
  if referencePoint == "TopRight" then
    mX = endX + width
    mY = endY + height
  end
  if referencePoint == "CenterLeft" then
    mX = endX + width / 2
    mY = endY + height / 2
  end
  if referencePoint == "CenterRight" then
    mX = endX + width
    mY = endY + height / 2
  end
  if referencePoint == "BottomLeft" then
    mX = endX + width
    mY = endY + height
  end
  if referencePoint == "BottomRight" then
    mX = endX + width
    mY = endY + height
  end
  if referencePoint == "BottomCenter" then
    mX = endX + width / 2
    mY = endY + height
  end
  if layer.randXStart then
    mX = layer.width + math.random(layer.randXStart, self.randXEnd)
  end
  if layer.randYStart then
    mY = layer.height + math.random(layer.randYStart, self.randYEnd)
  end
  return mX, mY
end
--
local function linearPos(self, layer, _endX, _endY, isSceneGroup)
  local endX, endY = app.getPosition(_endX, _endY)
  -- print("linearPos", endX, endY)
  local mX, mY
  local width, height = layer.width * layer.xScale, layer.height * layer.yScale
  local referencePoint = self.layerOptions.referencePoint
  if referencePoint == "Center" then
    mX = endX + width / 2
    mY = endY + height / 2
  end
  if self.deltaX then -- for text
    mY = endY + self.deltaY - layer.x - height * 0.5
  end
  if self.deltaY then -- for text
    mY = endY + self.deltaY - layer.y - height * 0.5
  end
  if referencePoint == "TopLeft" then
    mX = endX
    mY = endY
  end
  if referencePoint == "TopCenter" then
    mX = endX + width / 2
    mY = endY
  end
  if referencePoint == "TopRight" then
    mX = endX + width
    mY = endY
  end
  if referencePoint == "CenterLeft" then
    mX = endX
    mY = endY + height / 2
  end
  if referencePoint == "CenterRight" then
    mX = endX + width
    mY = endY + height / 2
  end
  if referencePoint == "BottomLeft" then
    mX = endX
    mY = endY + height
  end
  if referencePoint == "BottomRight" then
    mX = endX + width
    mY = endY + height
  end
  if referencePoint == "BottomCenter" then
    mX = endX + width / 2
    mY = endY + height
  end
  if layer.randXStart then
    mX = layer.width + math.random(layer.randXStart, self.randXEnd)
  end
  if layer.randYStart then
    mY = layer.height + math.random(layer.randYStart, self.randYEnd)
  end
  return mX, mY
end

local function getPos(self, layer, _endX, _endY, isSceneGroup)
  if self.properties.type == "group" then
    return groupPos(self, layer, _endX, _endY, isSceneGroup)
  else
    return linearPos(self, layer, _endX, _endY, isSceneGroup)
  end
end

--
--
local function createOptions(self, UI)
  local layer = self.obj
  self.properties = self.properties or {}
  --
  -- print("--- options ---")
  local options = {
    repeatCount = tonumber(self.properties.loop),
    reflect = self.properties.reverse == "true",
    xSwipe = self.properties.xSwipe,
    ySwipe = self.properties.ySwipe,
    delay = self.properties.delay / 1000
  }

  if self.properties.easing then
    local easingName = self.properties.easing:gsub("Expo", "Exponential")
    easingName = easingName:gsub("Quad", "Quadratic")
    easingName = easingName:gsub("Quart", "Quartic")
    easingName = easingName:gsub("Quint", "Quintic")
    easingName = easingName:gsub("Circ", "Circular")
    -- print("", "easing", self.properties.easing, gtween.easing[easingName])
    options.ease = gtween.easing[easingName]
  end

  if self.breadcrumbs and #self.breadcrumbs then
    options.breadcrumb = true
    options.breadAnchor = 5
    options.breadShape = self.breadcrumbs.shape
    options.breadW = self.breadcrumbs.width
    options.breadH = self.breadcrumbs.height
    if self.breadcrumbs.color then
      local values = util.split(self.breadcrumbs.color, ",")
      options.breadColor = {
        tonumber(values[1]) / 255,
        tonumber(values[2]) / 255,
        tonumber(values[3]) / 255,
        tonumber(values[4])
      }
    else
      options.breadColor = {"rand"}
    end
    options.breadInterval = self.breadcrumbs.interval
    if self.breadcrumbs.dispose then
      options.breadTimer = self.breadcrumbs.time / 1000
    end
  end

  return options
end
--

local function createPropsTo(self, layer, _mX, _mY)
  local mX, mY = _mX or self.to.x, _mY or self.to.y
  -- print("createProps", self.class, mX, mY, self.to.x, self.to.y)
  local props = {}
  if self.class == "pulse" then
    props.xScale = self.to.xScale
    props.yScale = self.to.yScale
    props.rotation = self.to.rotation
  elseif self.class == "rotation" then
    props.rotation = self.to.rotation
  elseif self.class == "tremble" then
    props.rotation = self.to.rotation
  elseif self.class == "bounce" then
    props.y = mY
    props.rotation = self.to.rotation
  elseif self.class == "blink" then
    props.xScale = self.to.xScale
    props.yScale = self.to.yScale
  elseif (self.class == "linear" or self.class == "dissolve" or self.class == "path") then
    if self.to.x then
      props.x = mX
    end
    if self.to.y then
      props.y = mY
    end
    if self.to.rotation then
      props.rotation = self.to.rotation
    end
    if self.to.xScale then
      props.xScale = self.to.xScale * layer.xScale
    end
    if self.to.yScale then
      props.yScale = self.to.yScale * layer.yScale
    end
    if self.path and self.path.newAngle then -- path
      props.newAngle = tonumber(self.path.newAngle)
    end
  end
  if self.to.alpha then
    props.alpha = self.to.alpha
  end
  return props
end

local function createPropsFrom(self, layer, _mX, _mY)
  local mX, mY = _mX or layer.x, _mY or layer.y
  if self.from then
    print("createProps", self.class, mX, mY, self.from.x, self.from.y)
  end
  local props = {}
  if self.class == "pulse" then
    props.xScale = layer.xScale
    props.yScale = layer.yScale
  elseif self.class == "rotation" then
    props.rotation = layer.rotation
  elseif self.class == "shake" then
    props.rotation = layer.rotation
  elseif self.class == "bounce" then
    props.y = mY
  elseif self.class == "blink" then
    props.xScale = layer.xScale
    props.yScale = layer.yScale
  elseif (self.class == "linear" or self.class == "Dissolve" or self.class == "Path") then
    if self.from then
      if self.from.x then
        props.x = mX
      end
      if self.from.y then
        props.y = mY
      end
      if self.from.rotation then
        props.rotation = layer.rotation
      end
      if self.from.xScale then
        props.xScale = layer.xScale
      end
      if self.from.yScale then
        props.yScale = layer.yScale
      end
      if self.from.alpha then
        props.alpha = layer.alpha
      end
    end
    if self.pathProps and self.pathProps.newAngle then -- path
      props.newAngle = layer.newAngle
    end
  end
  return props
end

local function createAnimationFunc(self, UI, tool)
  -- print("createAnimationFunc", tool)
  local animObj, animObjTo, animObjFrom
  local layer = self.obj
  local sceneGroup = UI.sceneGroup
  --
  if layer == nil then
    print("Error failed to create animation")
    return
  end
  --
  layer.xScale = layer.oriXs
  layer.yScale = layer.oriYs
  --
  local isTo = self.to
  local isFrom = self.from
  --
  self.to = self.to or {}
  local class = self.class:lower()
  --
  local mX, mY = getPos(self, layer, self.to.x, self.to.y, self.isSceneGroup)
  -- print("@@@@@", layer.x, layer.y)
  -- print("@@@@@", self.to.x, self.to.y, mX, mY)
  -- print("@@@@@", self.from.x, self.from.y)

  --
  local options = createOptions(self, UI)
  -- local props = createProps(self, layer, mX, mY)
  local propsTo = createPropsTo(self, layer)
  local propsFrom = createPropsFrom(self, layer)
  ---
  local onEndHandler = function()
    local layer = self.obj
    if self.properties.resetAtEnd then
      if self.subclass == "Shake" then
        layer.rotation = 0
      end
      layer.x = layer.oriX
      layer.y = layer.oriY
      layer.alpha = layer.oldAlpha
      layer.rotation = 0
      layer.isVisible = true
      layer.xScale = layer.oriXs
      layer.yScale = layer.oriYs

      if self.layerOptions.isSpritesheet then
        layer:pause()
        layer.currentFrame = 1
      end
    end
   self.onEndHandler(UI)
  end
  ---
  if tool == "gtween" then
    if class == "blink" or class == "bounce" or class == "pulse" or class == "rotation" then
      options.onComplete = onEndHandler

      -- print(class, "--- propsTo ---", propsTo.x, propsTo.y, self.properties.duration)
      -- for k, v in pairs(propsTo) do
      --   print(k, v)
      -- end
      animObjTo = gtween.new(layer, self.properties.duration / 1000, propsTo, options)
      animObjTo:pause()
      return animObjTo
    else -- linear
      -- print("--- Linear propsFrom ---", propsFrom.x, propsFrom.y, self.properties.duration)
      -- for k, v in pairs(propsFrom) do
      --   print(k, v)
      -- end
      -- print("-------")
      -- print("--- Linear propsTo ---", propsTo.x, propsTo.y, self.properties.duration)
      -- for k, v in pairs(propsTo) do
      --   print(k, v)
      -- end

      self.properties.duration = self.properties.duration or 1000
      --
      --
      if isFrom then
        options.onComplete = function()
          print("Done From")
          animObjTo:play()
        end
        animObjFrom = gtween.new(layer, self.properties.duration / 1000, propsFrom, options)
        animObjFrom:pause()
      end
      --
      --
      if isTo then
        options.onComplete = onEndHandler
        options.delay = 0 -- notice
        animObjTo = gtween.new(layer, self.properties.duration / 1000, propsTo, options)
        animObjTo:pause()
        print("@@@@@ To", animObjTo, layer.name)
      end
      -- for k, v in pairs(animObj) do print(k, v) end
      return {to = animObjTo, from = animObjFrom}
    end
  elseif tool == "btween" then
    self.path.newAngle = tonumber(self.path.newAngle)
    local extraValues = createPropsTo(self, layer)
    animObj = btween.new(layer, self.properties.duration / 1000, self.curve, extraValues, options)

    animObj.pathAnim = true
    animObj:pause()
    return animObj
  else
    print("Error")
  end
end
--
animationFactory.gtween = function(self, UI)
  return createAnimationFunc(self, UI, "gtween")
end
animationFactory.path = function(self, UI)
  return createAnimationFunc(self, UI, "btween")
end
animationFactory.switch = function(self, UI)
  local layer = self.obj
  local sceneGroup = UI.sceneGroup
  --
  if layer == nil then
    return
  end
  --
  layer.xScale = layer.oriXs
  layer.yScale = layer.oriYs
  local newLayer = sceneGroup[self.properties.to]
  --
  local animObj = {}
  animObj.play = function()
    print(layer.imagePath, newLayer.imagePath)
    newLayer.x = layer.x
    newLayer.y = layer.y
    transition.dissolve(layer, newLayer, self.properties.duration, self.properties.delay)
  end
  --
  animObj.pause = function()
    print("pause is not supported in dissove")
  end
  return animObj
end

function M:init()
  -- print("@@@", self.from.x, self.from.y)
  if self.from then
    if self.from.x then
      self.obj.x = self.from.x
    end
    if self.from and self.from.y then
      self.obj.y = self.from.y
    end
    if self.from.rotation then
      self.obj.rotation = self.from.rotation
    end
    if self.from.xScale then
      self.obj.xScale = self.from.xScale * self.obj.xScale
    end
    if self.from.yScale then
      self.obj.yScale = self.from.yScale * self.obj.yScale
    end
    if self.from.alpha then
      self.obj.alpha = self.from.alpha
    end
  end
  if self.pathProps and self.pathProps.newAngle then -- path
    self.obj.newAngle = tonumber(self.pathProps.newAngle)
  end
end

--
function M:initAnimation(UI, layer, _onEndHandler)
  self.onEndHandler = _onEndHandler
  --
  if not (self.class == "switch" or self.class == "path") then
    self.buildAnim = animationFactory["gtween"]
    -- print("self.buildAnim", self.buildAnim)
  else
    -- print(self.class)
    if self.class == "path" then
      local json = require("json")
      local path =
        system.pathForFile(
        "App/" .. UI.book .. "/assets/images/" .. UI.page .. "/" .. self.path.filename,
        system.ResourceDirectory
      )
      if path then
        local decoded, pos, msg = json.decodeFile(path)
        if not decoded then
          print("Decode failed at " .. tostring(pos) .. ": " .. tostring(msg))
          return
        end
        self.curve = self:setCurve(decoded, self.path.closed, self.path.pause)
        -- print("@@@@", self.curve)
      end
    end
    self.buildAnim = animationFactory[self.class]
  end
  ---
  self.obj = layer
  self.obj.oriX = layer.x
  self.obj.oriY = layer.y
  self.obj.oriXs = layer.xScale
  self.obj.oriYs = layer.yScale

  self.layerOptions = self.layerOptions or {}
  local referencePoint = self.layerOptions.referencePoint
  if referencePoint == "TopLeft" then
    layer.anchorX = 0
    layer.anchorY = 0
    util.repositionAnchor(layer, 0, 0)
  end
  if referencePoint == "TopCenter" then
    layer.anchorX = 0.5
    layer.anchorY = 0
    util.repositionAnchor(layer, 0.5, 0)
  end
  if referencePoint == "TopRight" then
    layer.anchorX = 1
    layer.anchorY = 0
    util.repositionAnchor(layer, 1, 0)
  end
  if referencePoint == "CenterLeft" then
    layer.anchorX = 0
    layer.anchorY = 0.5
    util.repositionAnchor(layer, 0, 0.5)
  end
  if referencePoint == "CenterRight" then
    layer.anchorX = 1
    layer.anchorY = 0.5
    util.repositionAnchor(layer, 1, 0.5)
  end
  if referencePoint == "BottomLeft" then
    layer.anchorX = 0
    layer.anchorY = 1
    util.repositionAnchor(layer, 0, 1)
  end
  if referencePoint == "BottomRight" then
    layer.anchorX = 1
    layer.anchorY = 1
    util.repositionAnchor(layer, 1, 1)
  end
  if referencePoint == "BottomCenter" then
    layer.anchorX = 0.5
    layer.anchorY = 1
    util.repositionAnchor(layer, 0.5, 1)
  end
end

function M:setCurve(pathPoints, closed, pause)
  local pathCurve = {}

  local curX = 0
  local curY = 0
  local curLX = 0
  local curLY = 0
  local curRX = 0
  local curRY = 0
  local nextX = 0
  local nextY = 0
  local nextLX = 0
  local nextLY = 0
  local nextRX = 0
  local nextRY = 0
  local closed1
  local closed2
  local closed3
  local closed4
  local firstY = 0

  --var bodyShape = []; //FOR THE FUTURE, WHEN PATHS CAN BE EXPORTED AS SHAPES

  for i, point in next, pathPoints do
    --builds the pathCurve
    local pointA = pathPoints[i]
    local pointB = pathPoints[i + 1]
    curX, curY = app.getPosition(pointA[1], pointA[2])
    curLX, curLY = app.getPosition(pointA[3], pointA[4])
    curRX, curRY = app.getPosition(pointA[5], pointA[6])
    if i == 1 then
      firstY = curY
      --saves for closed paths
      closed3 = {x = curX, y = curY}
    -- bodyShape.push(curX); bodyShape.push(curY)
    end
    if i < #pathPoints then
      nextX, nextY = app.getPosition(pointB[1], pointB[2]) -- anchor[0] anchor[1]
      nextLX, nextLY = app.getPosition(pointB[3], pointB[4]) -- leftDirection[0] leftDirection[1]
      nextRX, nextRY = app.getPosition(pointB[5], pointB[6]) -- rightDirection[0] rightDirection[1]
      --builds the pathCurve
      pathCurve[#pathCurve + 1] = {x = curX, y = curY} --regular curve
      pathCurve[#pathCurve + 1] = {x = curLX, y = curLY}
      pathCurve[#pathCurve + 1] = {x = nextRX, y = nextRY}
      pathCurve[#pathCurve + 1] = {x = nextX, y = nextY}
      closed4 = {x = nextX, y = nextY} --used for Pause when complete
    -- bodyShape.push(curX); bodyShape.push(curY)
    end
    if i == #pathPoints then
      --saves for closed paths
      closed1 = {x = nextX, y = nextY}
      closed2 = {x = nextX, y = firstY}
    end
  end
  --this is used only when a path is set to CLOSED
  if closed then
    pathCurve[#pathCurve + 1] = closed1
    pathCurve[#pathCurve + 1] = closed3
    pathCurve[#pathCurve + 1] = closed3
    pathCurve[#pathCurve + 1] = closed3
    closed4 = closed3
  end
  --Repeats the last set of path - makes no sense for almost all situations and do not render if a path is set to CLOSED
  --DO NOT RETURN TO THE ORIGINAL POSITION AT END - this is used only when a path is set to CLOSED
  --********* REMOVE WHEN FIND A WAY TO STOP THE ANGLE APPLICATION IN THE LAST PATH POINT IN BTWEEN
  if pause then
    pathCurve[#pathCurve + 1] = closed4
    pathCurve[#pathCurve + 1] = closed4
    pathCurve[#pathCurve + 1] = closed4
    pathCurve[#pathCurve + 1] = closed4
  end
  local json = require("json")
  print(json.encode(pathCurve))
  return pathCurve
end
---------------------------
M.set = function(instance)
  return setmetatable(instance, {__index = M})
end
--
return M
