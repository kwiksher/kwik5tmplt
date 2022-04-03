---------------------------
-- Layer Properties (common)
---
local Props = {
	alpha     = 100/100,
	blendMode = "normal",
	height    = 234 - 290,
	kind      = "text",
	name      = "Loading",
	width     = 386 - 583,
	x         = 583 + (386 -583)/2,
	y         = 234 + (290 - 234)/2,
  }

  --[[
	  _M.layerName
	  _M.layerWidth
	  _M.layerHeight
	  _M.nX     -- text
	  _M.nY     -- text
	  _M.layerX
	  _M.layerY
	  --
	  _M.randXStart
	  _M.randXEnd
	  _M.randYStart
	  _M.randYEnd
  --]]

Props.random = {from={x=0, y = 0}, to={x=0, y=0}}

--
---------------------------
-- Animation Type
---
--[[

	Props.gtDissolve
	_M.isSceneGroup

	_M.animationType
	"Path"
    "Default"

	_M.isTypeShape
	_M.isSpritesheet
	_M.isMovieClip

	_M.positionFuncName
	"grpupAndPage"
	"default"

	_M.animationSubType =
	"Linear"
	"Pulse"
	"Rotation"
	"Shake"
	"Bounce"
	"Blink"
--]]
Props.Animation = {
	type ="Linear",
	type_list = {
		"Linear",
		"Pulse",
		"Rotation",
		"Shake",
		"Bounce",
		"Blink"
	}
}
---------------------------
-- Animation Properties
---
--_M.actionName

Props.Animation.action = {name=""}

-- Coordinates
--[[

	_M.animationEndX
	_M.animationEndY
	_M.animationEndAlpha
	_M.animationDuration
	_M.animationScaleY
	_M.animationScaleX
	_M.animationRotation
	--]]

	Props.Animation.from={
		x=0, y=0,
		alpha=0,
		duration=1000,
		xScale=1, yScale=1,
		rotation=0,
	}

	Props.Animation.to={
		x=0, y=0,
		alpha=0,
		duration=1000,
		xScale=1, yScale=1,
		rotation=0,
	}

	-- Props.pathCurve

	Props.Animation.path ={}

	--[[

		_M.defaultReference
		_M.textReference
		_M.referencePoint
		"CenterReferencePoint"
		"TopLeftReferencePoint"
		"TopCenterReferencePoint"
		"TopRightReferencePoint"
		"CenterLeftReferencePoint"
		"CenterRightReferencePoint"
		"BottomLeftReferencePoint"
		"BottomLeftReferencePoint"
		"BottomRightReferencePoint"


		-- Controls
		_M.restart
		_M.animationEasing
		_M.animationReverse
		_M.animationDelay
		_M.animationLoop
		_M.animationNewAngle -- path animation
		_M.animationSwipeX -- flip
		_M.animationSwipeY -- flip
	--]]

	Props.Animation.controls = {
		restart = false,
		easing = "Linear",
		reverse = false,
		delay = 1000,
		loop = 1,
		angle = 45,
		xSwipe=0, ySwipe=0,
		anchor = "CenterReferencePoint"
	}

	Props.Animation.controls.anchor_list = {
		"CenterReferencePoint",
		"TopLeftReferencePoint",
		"TopCenterReferencePoint",
		"TopRightReferencePoint",
		"CenterLeftReferencePoint",
		"CenterRightReferencePoint",
		"BottomLeftReferencePoint",
		"BottomLeftReferencePoint",
		"BottomRightReferencePoint",
	}

	Porps.Animation.controls.easing_list = {
		'Linear',
		'inOutExpo',
		'inOutQuad',
		'outExpo',
		'outQuad',
		'inExpo',
		'inQuad',
		'inBounce',
		'outBounce',
		'inOutBounce',
		'inElastic',
		'outElastic',
		'inOutElastic',
		'inBack',
		'outBack',
		'inOutBack',
	}

--
-- Animatin Audio
--[[
	_M.audioPlay
	_M.audioVolume
	_N.audioChannel
	_M.audioName
	_M.audioLoop
	_M.audioFadeIn
	_M.allowRepeat -- repeatable
--]]

Props.Animation.audio = {
	name="",
	volume = 5,
	channel = 1,
	loop = 1,
	fadeIn = false,
	repeatable = false
}
--
-- Bread crumbs
--[[

	_M.breadcrumb
	_M.breadcrumbDispose
	_M.breadShape
	_M.breadcrumbColor
	_M.breadcrumbInterval
	_M.breadcrumbTime
	_M.breadcrumWidth
	_M.breadcrumHeight
	--
--]]

Props.Animation.breadcrumbs = {
	dispose = true,
	shape = "",
	color = {1,0,1},
	interval = 300,
	time = 2000,
	width = 30,
	height = 30
}