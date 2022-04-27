-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local app = require "Application"
local util = require("lib.util")
---
parseValue = function(value, newValue)
	if newValue then
		if value then
			return newValue
		else
			return nil
		end
	else
		return value
	end
end
--
local animationFunc = {}
local positionFunc = {}
--
--
positionFunc["groupAndPage"] = function (layer, _endX, _endY, isSceneGroup)
	local mX, mY
	local endX, endY =  app.ultimatePosition(_endX, _endY)
	local width, height = layer.width*layer.xScale, layer.height*layer.yScale

	if _M.referencePoint=="CenterReferencePoint" then
	  if isSceneGroup then
	      mX = endX + layer.x
	      mY = endY + layer.y
	  else
	      mX = endX + width/2
	      mY = endY + height/2
	  end
	end
	if _M.referencePoint=="TopLeftReferencePoint" then
        mX = endX + width/2
        mY = endY + height/2
	end
	if _M.referencePoint=="TopCenterReferencePoint" then
        mX = endX + width/2
        mY = endY + height/2
	end
	if _M.referencePoint=="TopRightReferencePoint" then
        mX = endX + width
        mY = endY + height
	end
	if _M.referencePoint=="CenterLeftReferencePoint" then
        mX = endX + width/2
        mY = endY + height/2
	end
	if _M.referencePoint=="CenterRightReferencePoint" then
        mX = endX + width
        mY = endY + height/2
	end
	if _M.referencePoint=="BottomLeftReferencePoint" then
        mX = endX + width
        mY = endY + height
	end
	if _M.referencePoint=="BottomRightReferencePoint" then
        mX = endX + width
        mY = endY + height
	end
	if _M.referencePoint=="BottomCenterReferencePoint" then
        mX = endX + width/2
        mY = endY + height
	end
	if _M.randXStart then
		mX = _M.layerWidth + math.random(_M.randXStart, _M.randXEnd)
	end
	if _M.randYStart then
		mY =  _M.layerHeight + math.random(_M.randYStart, _M.randYEnd)
	end
	return mX, mY
end
--
positionFunc["default"] = function (layer, _endX, _endY, isSceneGroup)
	local endX, endY =  app.ultimatePosition(_endX, _endY)
	local width, height = layer.width*layer.xScale, layer.height*layer.yScale
	if _M.defaultReference then
		mX = endX + width/2
		mY = endY + height/2
	end
	if _M.textReference then
		mX = endX + _M.nX - _M.layerX
		mY = endY + _M.nY - _M.layerY -height*0.5
	end
	if _M.referencePoint == "TopLeftReferencePoint" then
		mX = endX
		mY = endY
	end
	if _M.referencePoint == "TopCenterReferencePoint" then
		mX = endX + width/2
		mY = endY
	end
	if _M.referencePoint == "TopRightReferencePoint" then
      mX = endX + width
      mY = endY
	end
	if _M.referencePoint == "CenterLeftReferencePoint" then
      mX = endX
      mY = endY + height/2
	end
	if _M.referencePoint == "CenterRightReferencePoint" then
      mX = endX + width
      mY = endY + height/2
	end
	if _M.referencePoint == "BottomLeftReferencePoint" then
      mX = endX
      mY = endY + height
	end
	if _M.referencePoint == "BottomRightReferencePoint" then
      mX = endX + width
      mY = endY + height
	end
	if _M.referencePoint == "BottomCenterReferencePoint" then
      mX = endX + width/2
      mY = endY + height
	end
	if _M.randXStart then
		mX = _M.layerWidth + math.random(_M.randXStart, _M.randXEnd)
	end
	if _M.randYStart then
		mY =  _M.layerHeight + math.random(_M.randYStart, _M.randYEnd)
	end
	return mX, mY
end

local getPos = positionFunc[_M.positionFuncName]

--
function _M:repoHeader(UI)
	local layer = self:getLayer(UI)
	if self.referencePoint == "TopLeftReferencePoint" then
		layer.anchorX = 0
		layer.anchorY = 0;
		util.repositionAnchor(layer, 0,0)
	end
	if self.referencePoint == "TopCenterReferencePoint" then
		layer.anchorX = 0.5
		layer.anchorY = 0;
		util.repositionAnchor(layer, 0.5,0)
	end
	if self.referencePoint == "TopRightReferencePoint" then
		layer.anchorX = 1
		layer.anchorY = 0;
		util.repositionAnchor(layer, 1,0)
	end
	if self.referencePoint == "CenterLeftReferencePoint" then
		layer.anchorX = 0
		layer.anchorY = 0.5;
		util.repositionAnchor(layer, 0,0.5)
	end
	if self.referencePoint == "CenterRightReferencePoint" then
		layer.anchorX = 1
		layer.anchorY = 0.5;
		util.repositionAnchor(layer, 1,0.5)
	end
	if self.referencePoint == "BottomLeftReferencePoint" then
		layer.anchorX = 0
		layer.anchorY = 1;
		util.repositionAnchor(layer, 0,1)
	end
	if self.referencePoint == "BottomRightReferencePoint" then
		layer.anchorX = 1
		layer.anchorY = 1;
		util.repositionAnchor(layer, 1,1)
	end
	if self.referencePoint == "BottomCenterReferencePoint" then
		layer.anchorX = 0.5
		layer.anchorY = 1;
		util.repositionAnchor(layer, 0.5,1)
	end
end
--
--
local function createOptions(self, UI)
	local onEndHandler = function()
		if self.restart then
			if self.animationSubType == "Shake" then
				layer.rotation = 0
			end
			if not self.isComic then
				layer.x				 = layer.oriX
				layer.y				 = layer.oriY
			end
			layer.alpha		 = layer.oldAlpha
			layer.rotation	= 0
			layer.isVisible = true
			layer.xScale		= layer.oriXs
			layer.yScale		= layer.oriYs

			if _M.isSpritesheet then
				layer:pause()
				layer.currentFrame = 1
			else if _M.isMovieClip then
				layer::stopAtFrame(1)
			end
		end
		if self.actionName:len() > 0  then
			Runtime:dispatchEvent({name=UI.page..self.actionName, event={}, UI=UI})
		end
		if sef.audioName:len() > 0 then
			audio.setVolume({self.audioVolume, { channel=self.audioChannel })
			if self.allowRepeat then
				audio.play(UI.allAudios[self.audioName], { channel=self.audioChannel, loops=self.audioLoop, fadein=self.audioFadeIn })
			else
				audio.play(UI.allAudios[self.audioName], { channel=self.audioChannel, loops=0, fadein=self.audioFadeIn })
			end
		end
	end

	local options = {
		ease        = app.gtween.easing[self.animationEasing],
		repeatCount = self.animationLoop,
		reflect     = self.animationReverse,
		xSwipe      = self.animationSwipeX,
		ySwipe      = self.animationSwipeY,
		delay       = self.animationDelay,
		onComplete  = onEndHandler
	}
	if self.breadcrumb then
		options.breadcrumb = true
		options.breadAnchor = 5,
		options.breadShape = self.breadShape
		options.breadW =self.breadcrumWidth
		options.breadH = self.breadcrumHeight
		if self.breadcrumColor then
			options.breadColor = {self.breadcrumColor }
		else
			options.breadColor = {"rand"}
		end
		options.breadInterval = self.breadcrumbInterval
		if self.breadcrumbDispose then
			options.breadTimer = self.breadcrumbTime
		end
	end
	return options
end
--
local function getEndPosition(self, layer)
	if self.animationEndX then
		local mX, mY = getPos(layer, self.animationEndX, self.animationEndY, self.isSceneGroup)
		if self.isComic then
			local deltaX = layer.oriX -mX
			local deltaY = layer.oriY -mY
			mX, mY = display.contentCenterX - deltaX, display.contentCenterY - deltaY
		end
	end
	return mX, mY
end
--
local function createProps(self, layer)
	local props = {}
	if self.animationSubType == "Linear" then
		if self.animationSubType == "Pulse" then
			props.xScale = self.animationScaleX
			props.yScale = self.animationScaleY
		end
		if self.animationSubType == "Rotation" then
			props.rotation =  self.animationRotation
		end
		if self.animationSubType == "Shake" then
			props.rotation =  self.animationRotation
		end
		if self.animationSubType == "Bounce" then
			props.y=mY
		end
		if self.animationSubType == "Blink" then
			props.xScale =  self.animationScaleX
			props.yScale = self.animationScaleY,
		end
	else
		if self,animationEndX then
			props.x = mX
			props.y = mY
		end
		if self.animationEndAlpha then
			props.alpha=self.animationEndAlpha
		end
		if self.animationRotation then
			props.rotation = self.animationRotation
		end
		if self.animationScaleX then
			props.xScale=self.animationScaleX * layer.xScale
		end
		if self.animationScaleY then
			props.yScale=self.animationScaleY * layer.yScale
		end
		if self.animationNewAngle then
			props.newAngle = self.animationNewAngle
		end
	end
	return props
end

local function createAnimationFunc(self, UI)
	return function(self, UI)
		local layer = self:getLayer(UI)
		local sceneGroup = UI.scene.view
		--
		if layer == nil then return end
		--
		layer.xScale = layer.oriXs
		layer.yScale = layer.oriYs

		local restartHandler= function(event)
			if app.gt[self.layerName] then
				app.gt[self.layerName]:toBeginning()
			end
		end
		--
		local mX, mY = getEndPosition(self, layer)
		--
		local options = createOptions(self, UI)
		--
		local props = createProps(self, layer)
		---
		if self.animationType == "Default" then
			app.gt[self.layerName] = app.gtween.new( layer, self.animationDuration, props, options)
		else if self.animationType == "Path" then
			app.gt[self.layerName] = app.btween.new(
				layer,
				self.animationDuration,
				self.pathAnimation,
				options,
				props)

			app.gt[self.layerName].pathAnim = true
		end
		--
		if not self.audioPlay then
			app.gt[self.layerName]:pause()
		end
		-- app.gt[self.layerName]:toBeginning()
		if self.isComic then
			layer.anim[self.layerName] = app.gt[self.layerName]
		end
	end
end
--
animationFunc["Default"]  = createAnimationFunc(self, UI)
animationFunc["Path"]     = createAnimationFunc(self, UI)
animationFunc["Dissolve"] = function(self, UI)
	local layer = self:getLayer(UI)
	local sceneGroup = UI.scene.view
	--
	if layer == nil then return end
	--
	layer.xScale = layer.oriXs
	layer.yScale = layer.oriYs

	app.trans[self.layerName] = {}
	app.trans[self.layerName].play = function()
		transition.dissolve(layer, self:getDssolvedLayer(UI),	self.animationDuration, self.animationDelay}}) end
	app.trans[self.layerName].pause = function()
		print("pause is not supported in dissove") end
	app.trans[self.layerName].resume = function()
		transition.dissolve(layer, self:getDssolvedLayer(UI),	self.animationDuration, self.animationDelay) end
end

--
_M.buildAnim = animationFunc[_M.animationType]
---------------------------
_M.new = function()
	local instance = {}
	setmetatable(instance, {__index=_M})
end
--
return _M