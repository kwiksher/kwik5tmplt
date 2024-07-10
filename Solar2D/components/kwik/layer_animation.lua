local M = {}
--
local app    = require "controller.Application"
local util   = require("lib.util")
local gtween = require("extlib.gtween")
local btween = require("extlib.btween")

---
local animationFactory = {}
--
--
local function groupPos(self, layer, _endX, _endY, isSceneGroup)
	local mX, mY
	local endX, endY =  app.getPosition(_endX, _endY)
  local width, height = layer.width*layer.xScale, layer.height*layer.yScale

  local referencePoint = self.layerOptions.referencePoint
	if referencePoint=="Center" then
	  if isSceneGroup then
	      mX = endX + layer.x
	      mY = endY + layer.y
	  else
	      mX = endX + width/2
	      mY = endY + height/2
	  end
	end
	if referencePoint=="TopLeft" then
        mX = endX + width/2
        mY = endY + height/2
	end
	if referencePoint=="TopCenter" then
        mX = endX + width/2
        mY = endY + height/2
	end
	if referencePoint=="TopRight" then
        mX = endX + width
        mY = endY + height
	end
	if referencePoint=="CenterLeft" then
        mX = endX + width/2
        mY = endY + height/2
	end
	if referencePoint=="CenterRight" then
        mX = endX + width
        mY = endY + height/2
	end
	if referencePoint=="BottomLeft" then
        mX = endX + width
        mY = endY + height
	end
	if referencePoint=="BottomRight" then
        mX = endX + width
        mY = endY + height
	end
	if referencePoint=="BottomCenter" then
        mX = endX + width/2
        mY = endY + height
	end
	if layer.randXStart then
		mX = layer.width + math.random(layer.randXStart, self.randXEnd)
	end
	if layer.randYStart then
		mY =  layer.height + math.random(layer.randYStart, self.randYEnd)
	end
	return mX, mY
end
--
local function linearPos (self, layer, _endX, _endY, isSceneGroup)
	local endX, endY =  app.getPosition(_endX, _endY)
  -- print("linearPos", endX, endY)
  local mX, mY
  local width, height = layer.width*layer.xScale, layer.height*layer.yScale
  local referencePoint = self.layerOptions.referencePoint
	if referencePoint=="Center" then
		mX = endX + width/2
		mY = endY + height/2
	end
	if self.deltaX  then -- for text
		mY = endY + self.deltaY - layer.x -height*0.5
	end
	if self.deltaY  then -- for text
		mY = endY + self.deltaY - layer.y -height*0.5
	end
	if referencePoint == "TopLeft" then
		mX = endX
		mY = endY
	end
	if referencePoint == "TopCenter" then
		mX = endX + width/2
		mY = endY
	end
	if referencePoint == "TopRight" then
      mX = endX + width
      mY = endY
	end
	if referencePoint == "CenterLeft" then
      mX = endX
      mY = endY + height/2
	end
	if referencePoint == "CenterRight" then
      mX = endX + width
      mY = endY + height/2
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
      mX = endX + width/2
      mY = endY + height
	end
	if layer.randXStart then
		mX = layer.width + math.random(layer.randXStart, self.randXEnd)
	end
	if layer.randYStart then
		mY =  layer.height + math.random(layer.randYStart, self.randYEnd)
	end
	return mX, mY
end

local function getPos (self, layer, _endX, _endY, isSceneGroup)
  if self.layerOptions.isGroup then
    return goupPos(self, layer, _endX, _endY, isSceneGroup)
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
  print("--- options ---")
  local options = {
		repeatCount = tonumber(self.properties.loop),
		reflect     = self.properties.reverse == "true",
		xSwipe      = self.properties.xSwipe,
		ySwipe      = self.properties.ySwipe,
		delay       = self.properties.delay/1000,
	}

  if self.properties.easing then
    local easingName = self.properties.easing:gsub("Expo", "Exponential")
    easingName = easingName:gsub("Quad", "Quadratic")
    easingName = easingName:gsub("Quart", "Quartic")
    easingName = easingName:gsub("Quint", "Quintic")
    easingName = easingName:gsub("Circ", "Circular")
      print("", "easing",self.properties.easing, gtween.easing[easingName] )
    options.ease        = gtween.easing[easingName]
  end

	if self.breadcrumbs and #self.breadcrumbs then
		options.breadcrumb = true
		options.breadAnchor = 5
		options.breadShape = self.breadcrumbs.shape
		options.breadW =self.breadcrumbs.width
		options.breadH = self.breadcrumbs.height
		if self.breadcrumbs.color then
      local values =  util.split(self.breadcrumbs.color, ",")
      options.breadColor = {tonumber(values[1])/255, tonumber(values[2])/255, tonumber(values[3])/255, tonumber(values[4])}
		else
			options.breadColor = {"rand"}
		end
		options.breadInterval = self.breadcrumbs.interval
		if self.breadcrumbs.dispose then
			options.breadTimer = self.breadcrumbs.time/1000
		end
	end

	return options
end
--

local function createPropsTo(self, layer, _mX, _mY)
  local mX, mY = _mX or self.to.x, _mY or self.to.y
  print("createProps", self.class, mX, mY, self.to.x, self.to.y)
	local props = {}
  if self.class == "pulse" then
    props.xScale = self.to.xScale
    props.yScale = self.to.yScale
    props.rotation =  self.to.rotation

  elseif self.class == "rotation" then
    props.rotation =  self.to.rotation
  elseif self.class == "tremble" then
    props.rotation =  self.to.rotation
  elseif self.class == "bounce" then
    props.y=mY
    props.rotation =  self.to.rotation

  elseif self.class == "blink" then
    props.xScale =  self.to.xScale
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
      props.xScale=self.to.xScale * layer.xScale
    end
    if self.to.yScale then
      props.yScale=self.to.yScale * layer.yScale
    end
    if self.pathProps and self.pathProps.newAngle then -- path
      props.newAngle = self.pathProps.newAngle
    end
  end
  if self.to.alpha then
    props.alpha=self.to.alpha
  end
	return props
end

local function createPropsFrom(self, layer, _mX, _mY)
  local mX, mY = _mX or layer.x, _mY or layer.y
  print("createProps", self.class, mX, mY, self.from.x, self.from.y)
	local props = {}
  if self.class == "pulse" then
    props.xScale = layer.xScale
    props.yScale = layer.yScale
  elseif self.class == "rotation" then
    props.rotation =  layer.rotation
  elseif self.class == "shake" then
    props.rotation =  layer.rotation
  elseif self.class == "bounce" then
    props.y=mY
  elseif self.class == "blink" then
    props.xScale =  layer.xScale
    props.yScale = layer.yScale
  elseif (self.class == "linear" or self.class == "Dissolve" or self.class == "Path") then
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
      props.xScale= layer.xScale
    end
    if self.from.yScale then
      props.yScale= layer.yScale
    end
    if self.pathProps and self.pathProps.newAngle then -- path
      props.newAngle = layer.newAngle
    end
  end
  if self.from.alpha then
    props.alpha= layer.alpha
  end
	return props
end

local function createAnimationFunc(self, UI, tool)
  print("createAnimationFunc", tool)
    local animObj, animObjTo, animObjFrom = {}, {}, {}
		local layer = self.obj
		local sceneGroup = UI.sceneGroup
		--
		if layer == nil then print("Error failed to create animation") return end
		--
		layer.xScale = layer.oriXs
		layer.yScale = layer.oriYs

    self.to = self.to or {}
    local class = self.class:lower()
		--
    local   mX, mY= getPos(self, layer, self.to.x, self.to.y, self.isSceneGroup)
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
        layer.x				 = layer.oriX
        layer.y				 = layer.oriY
        layer.alpha		 = layer.oldAlpha
        layer.rotation	= 0
        layer.isVisible = true
        layer.xScale		= layer.oriXs
        layer.yScale		= layer.oriYs

        if self.layerOptions.isSpritesheet then
          layer:pause()
          layer.currentFrame = 1
        end
      end
      self.onEndHandler(UI)
    end
    ---
		if tool== "gtween" then
      if class =="blink" or class == "bounce" or class=="pulse" or class == "rotation" then
        options.onComplete  = onEndHandler

        print(class, "--- propsTo ---", propsTo.x, propsTo.y, self.properties.duration)
        for k, v in pairs(propsTo) do print(k ,v) end
        animObjTo = gtween.new( layer, self.properties.duration/1000, propsTo, options)
        animObjTo:pause()
        return  animObjTo
      else -- linear
        print("--- Linear propsFrom ---", propsFrom.x, propsFrom.y, self.properties.duration)
        for k, v in pairs(propsFrom) do print(k ,v) end
        print ("-------")

        print("--- Linear propsTo ---", propsTo.x, propsTo.y, self.properties.duration)
        for k, v in pairs(propsTo) do print(k ,v) end

        self.properties.duration = self.properties.duration or 1000
        --
        -- for from
        options.onComplete = function()
          print("Done From")
          animObjTo:play()
        end
        animObjFrom = gtween.new( layer, self.properties.duration/1000, propsFrom, options)
        --
        -- for to
        options.onComplete  = onEndHandler
        options.delay = 0
        animObjTo = gtween.new( layer, self.properties.duration/1000, propsTo, options)
        animObjFrom:pause()
        animObjTo:pause()
            -- for k, v in pairs(animObj) do print(k, v) end
        return  animObjTo, animObjFrom
      end
		elseif class == "btween" then
			animObj = btween.new(
				layer,
				self.properties.duration,
				{
          self.curve,
          angle = self.pathProps.angle
        },
				options,
				props)

			animObj.pathAnim = true
      return animObj
    else
      print("Error")
		end
end
--
animationFactory.gtween  = function(self,UI)
  return createAnimationFunc(self, UI, "gtween")
end
animationFactory.path     = function(self, UI) return createAnimationFunc(self, UI, "btween") end
animationFactory.switch = function(self, UI)
	local layer = self.obj
	local sceneGroup = UI.sceneGroup
	--
	if layer == nil then return end
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
		transition.dissolve(layer, newLayer,	self.properties.duration, self.properties.delay)
  end
  --
	animObj.pause = function()
		print("pause is not supported in dissove")
  end
  return animObj
end

function M:init()
  -- print("@@@", self.from.x, self.from.y)
  if self.from.x then
    self.obj.x = self.from.x
  end
  if self.from.y then
    self.obj.y = self.from.y
  end
  if self.from.rotation then
    self.obj.rotation = self.from.rotation
  end
  if self.from.xScale then
    self.obj.xScale=self.from.xScale * self.obj.xScale
  end
  if self.from.yScale then
    self.obj.yScale=self.from.yScale * self.obj.yScale
  end
  if self.pathProps and self.pathProps.newAngle then -- path
    self.obj.newAngle = self.pathProps.newAngle
  end
  if self.from.alpha then
    self.obj.alpha=self.from.alpha
  end
end

--
function M:initAnimation(UI, layer, onEndHandler)
  self.onEndHandler = onEndHandler
  --
  if not(self.class == "switch" or self.class =="path") then
    self.buildAnim = animationFactory["gtween"]
    print("self.buildAnim", self.buildAnim)
  else
    print(self.class)
    self.buildAnim = animationFactory[self.class]
  end
  ---
	self.obj = layer
  self.obj.oriX = layer.x
  self.obj.oriY = layer.y
  self.obj.oriXs = layer.xScale
  self.obj.oriYs = layer.yScale

  self.layerOptions =  self.layerOptions or {}
	local referencePoint = self.layerOptions.referencePoint
	if referencePoint == "TopLeft" then
		layer.anchorX = 0
		layer.anchorY = 0;
		util.repositionAnchor(layer, 0,0)
	end
	if referencePoint == "TopCenter" then
		layer.anchorX = 0.5
		layer.anchorY = 0;
		util.repositionAnchor(layer, 0.5,0)
	end
	if referencePoint == "TopRight" then
		layer.anchorX = 1
		layer.anchorY = 0;
		util.repositionAnchor(layer, 1,0)
	end
	if referencePoint == "CenterLeft" then
		layer.anchorX = 0
		layer.anchorY = 0.5;
		util.repositionAnchor(layer, 0,0.5)
	end
	if referencePoint == "CenterRight" then
		layer.anchorX = 1
		layer.anchorY = 0.5;
		util.repositionAnchor(layer, 1,0.5)
	end
	if referencePoint == "BottomLeft" then
		layer.anchorX = 0
		layer.anchorY = 1;
		util.repositionAnchor(layer, 0,1)
	end
	if referencePoint == "BottomRight" then
		layer.anchorX = 1
		layer.anchorY = 1;
		util.repositionAnchor(layer, 1,1)
	end
	if referencePoint == "BottomCenter" then
		layer.anchorX = 0.5
		layer.anchorY = 1;
		util.repositionAnchor(layer, 0.5,1)
	end
end

---------------------------
M.set = function(instance)
	return setmetatable(instance, {__index=M})
end
--
return M