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
	local onEndHandler = function()
		if self.properties.resetAtEnd then
			if self.class == "Shake" then
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

	local options = {
		ease        = gtween.easing[self.properties.easing],
		repeatCount = self.properties.loop,
		reflect     = self.properties.reverse,
		xSwipe      = self.properties.xSwipe,
		ySwipe      = self.properties.ySwipe,
		delay       = self.properties.delay,
		onComplete  = onEndHandler
	}
	if self.breadcrumbs then
		options.breadcrumb = true
		options.breadAnchor = 5
		options.breadShape = self.breadcrumbs.shape
		options.breadW =self.breadcrumbs.width
		options.breadH = self.breadcrumbs.height
		if self.breadcrumbs.color then
			options.breadColor = self.breadcrumbs.color
		else
			options.breadColor = {"rand"}
		end
		options.breadInterval = self.breadcrumbs.interval
		if self.breadcrumbs.dispose then
			options.breadTimer = self.breadcrumbs.time
		end
	end
	return options
end
--

local function createProps(self, layer, mX, mY)
  -- print("createProps", mX, mY)
	local props = {}
  if self.class == "Pulse" then
    props.xScale = self.to.xScale
    props.yScale = self.to.yScale
  elseif self.class == "Rotation" then
    props.rotation =  self.to.rotation
  elseif self.class == "Shake" then
    props.rotation =  self.to.rotation
  elseif self.class == "Bounce" then
    props.y=mY
  elseif self.class == "Blink" then
    props.xScale =  self.to.xScale
    props.yScale = self.to.yScale
  elseif (self.class == "linear" or self.class == "Dissolve" or self.class == "Path") then
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

local function createAnimationFunc(self, UI, class)
	return function(self, UI)
    local animObj = {}
		local layer = self.obj
		local sceneGroup = UI.sceneGroup
		--
		if layer == nil then print("Error failed to create animation") return end
		--
		layer.xScale = layer.oriXs
		layer.yScale = layer.oriYs

    self.to = self.to or {}
		--
    local   mX, mY= getPos(self, layer, self.to.x, self.to.y, self.isSceneGroup)
    --
		local options = createOptions(self, UI)
		local props = createProps(self, layer, mX, mY)
		---
		if class== "Linear" then
      -- print("--- Linear ---", props.x, props.y, self.properties.duration)
      -- for k, v in pairs(props) do print(k ,v) end
      -- print ("-------")
      -- for k, v in pairs(options) do print(k ,v) end

      self.properties.duration = self.properties.duration or 1000
			animObj = gtween.new( layer, self.properties.duration/1000, props, options)
		elseif class == "Path" then
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
		end
    return animObj
	end
end
--
animationFactory.Linear  = createAnimationFunc(self, UI, "Linear")
animationFactory.Path     = createAnimationFunc(self, UI, "Path")
animationFactory.Dissolve = function(self, UI)
	local layer = self.obj
	local sceneGroup = UI.sceneGroup
	--
	if layer == nil then return end
	--
	layer.xScale = layer.oriXs
	layer.yScale = layer.oriYs
  --
	local animObj = {}
	animObj.play = function()
		transition.dissolve(layer, self:getDssolvedLayer(UI),	self.properties.duration, self.properties.delay)
  end
  --
	animObj.pause = function()
		print("pause is not supported in dissove")
  end
  return animObj
end

--
function M:initAnimation(UI, layer, onEndHandler)
  self.onEndHandler = onEndHandler
  --
  if not(self.class == "Dissolve" or self.class =="Path") then
    self.buildAnim = animationFactory["Linear"]
  else
    self.buildAnim = animationFactory[M.class]
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