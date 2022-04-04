-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
--
function _M:myMain()
end
--
function _M:localVars ()
end
--
function _M:localPos()
end
--
function _M:didShow(UI)
  -- UI.scene:dispatchEvent({name="{{myLName}}_{{layerType}}_{{triggerName}}", phase = "didShow", UI=UI})	}
  self:repoHeader(UI)
  self:buildAnim(UI)
	{{#aplay}}
		{{#gtDissolve}}
			_K.trans.{{gtName}}:play()
		{{/gtDissolve}}
		{{^gtDissolve}}
	--	if _K.gt.{{gtName}} then
	--		_K.gt.{{gtName}}:play()
	--	end
		{{/gtDissolve}}
	{{/aplay}}
end
--
function _M:toDispose()
	_K.cancelAllTweens()
	_K.cancelAllTransitions()
end
--
function _M:toDestory()
end
--
{{#groupAndPage}}
local function getPosGroupAndPage(layer, _endX, _endY, isSceneGroup)
	local mX, mY
	local endX, endY =  _K.ultimatePosition(_endX, _endY)
	{{#CenterReferencePoint}}
		--CenterReferencePoint
	  if isSceneGroup then
	      mX = endX + layer.x
	      mY = endY + layer.y
	  else
	      mX = endX +layer.width/2) 
	      mY = endY +layer.height/2)
	  end
	{{/CenterReferencePoint}}
	{{#TopLeftReferencePoint}}
		--TopLeftReferencePoint
        mX = endX  + ( layer.width / 2)
        mY = endY  + ( layer.height / 2)
	{{/TopLeftReferencePoint}}
	{{#TopCenterReferencePoint}}
	--TopCenterReferencePoint
        mX = endX  + (  layer.width / 2)
        mY = endY  + ( layer.height / 2)
	{{/TopCenterReferencePoint}}
	{{#TopRightReferencePoint}}
	--TopRightReferencePoint
        mX = endX  + (  layer.width )
        mY = endY  + ( layer.height )
	{{/TopRightReferencePoint}}
	{{#CenterLeftReferencePoint}}
	--CenterLeftReferencePoint
        mX = endX  + ( layer.width / 2)
        mY = endY  + (  layer.height / 2)
	{{/CenterLeftReferencePoint}}
	{{#CenterRightReferencePoint}}
	--CenterRightReferencePoint
        mX = endX  + ( layer.width )
        mY = endY  + (  layer.height / 2)
	{{/CenterRightReferencePoint}}
	{{#BottomLeftReferencePoint}}
	--BottomLeftReferencePoint
        mX = endX  + ( layer.width )
        mY = endY  + (  layer.height )
	{{/BottomLeftReferencePoint}}
	{{#BottomRightReferencePoint}}
	--BottomRightReferencePoint
        mX = endX  + (  layer.width )
        mY = endY  + (  layer.height )
	{{/BottomRightReferencePoint}}
	{{#BottomCenterReferencePoint}}
	--BottomCenterReferencePoint
        mX = endX  + (  layer.width / 2)
        mY = endY  + (  layer.height )
	{{/BottomCenterReferencePoint}}
	{{#randX}}
		mX = {{elW}} + math.random({{randXStart}}, {{randXEnd}})
	{{/randX}}
	{{#randY}}
		mY =  {{elH}} + math.random({{randYStart}}, {{randYEnd}})
	{{/randY}}
	return mX, mY
end
{{/groupAndPage}}
{{^groupAndPage}}
--
local function getPos(layer, _endX, _endY)
	local endX, endY =  _K.ultimatePosition(_endX, _endY)
	local width, height = layer.width*layer.xScale, layer.height*layer.yScale
	{{#DefaultReference}}
    mX = endX + width/2
    mY = endY + height/2
	{{/DefaultReference}}
	{{#TextReference}}
    mX = endX + {{nX}} - {{elX}} 
    mY = endY + {{nY}} - {{elY}} -height*0.5
	{{/TextReference}}
	{{#TopLeftReferencePoint}}
		--TopLeftReferencePoint
      mX = endX 
      mY = endY 
	{{/TopLeftReferencePoint}}
	{{#TopCenterReferencePoint}}
	--TopCenterReferencePoint
      mX = endX + width/2 
      mY = endY 
	{{/TopCenterReferencePoint}}
	{{#TopRightReferencePoint}}
	--TopRightReferencePoint
      mX = endX + width 
      mY = endY 
	{{/TopRightReferencePoint}}
	{{#CenterLeftReferencePoint}}
	--CenterLeftReferencePoint
      mX = endX 
      mY = endY + height/2
	{{/CenterLeftReferencePoint}}
	{{#CenterRightReferencePoint}}
	--CenterRightReferencePoint
      mX = endX + width 
      mY = endY + height/2 
	{{/CenterRightReferencePoint}}
	{{#BottomLeftReferencePoint}}
	--BottomLeftReferencePoint
      mX = endX 
      mY = endY + height 
	{{/BottomLeftReferencePoint}}
	{{#BottomRightReferencePoint}}
	--BottomRightReferencePoint
      mX = endX + width 
      mY = endY + height 
	{{/BottomRightReferencePoint}}
	{{#BottomCenterReferencePoint}}
	--BottomCenterReferencePoint
      mX = endX + width/2 
      mY = endY + height 
	{{/BottomCenterReferencePoint}}
	{{#randX}}
		mX = {{elW}} + math.random({{randXStart}}, {{randXEnd}})
	{{/randX}}
	{{#randY}}
		mY =  {{elH}} + math.random({{randYStart}}, {{randYEnd}})
	{{/randY}}
	return mX, mY
end
{{/groupAndPage}}

--
function _M:repoHeader(UI)
	local layer = UI.layer
	{{#TopLeftReferencePoint}}
	{{gtLayer}}.anchorX = 0
	{{gtLayer}}.anchorY = 0;
	_K.repositionAnchor({{gtLayer}}, 0,0)
	{{/TopLeftReferencePoint}}
	{{#TopCenterReferencePoint}}
	{{gtLayer}}.anchorX = 0.5
	{{gtLayer}}.anchorY = 0;
	_K.repositionAnchor({{gtLayer}}, 0.5,0)
	{{/TopCenterReferencePoint}}
	{{#TopRightReferencePoint}}
	{{gtLayer}}.anchorX = 1
	{{gtLayer}}.anchorY = 0;
	_K.repositionAnchor({{gtLayer}}, 1,0)
	{{/TopRightReferencePoint}}
	{{#CenterLeftReferencePoint}}
	{{gtLayer}}.anchorX = 0
	{{gtLayer}}.anchorY = 0.5;
	_K.repositionAnchor({{gtLayer}}, 0,0.5)
	{{/CenterLeftReferencePoint}}
	{{#CenterRightReferencePoint}}
	{{gtLayer}}.anchorX = 1
	{{gtLayer}}.anchorY = 0.5;
	_K.repositionAnchor({{gtLayer}}, 1,0.5)
	{{/CenterRightReferencePoint}}
	{{#BottomLeftReferencePoint}}
	{{gtLayer}}.anchorX = 0
	{{gtLayer}}.anchorY = 1;
	_K.repositionAnchor({{gtLayer}}, 0,1)
	{{/BottomLeftReferencePoint}}
	{{#BottomRightReferencePoint}}
	{{gtLayer}}.anchorX = 1
	{{gtLayer}}.anchorY = 1;
	_K.repositionAnchor({{gtLayer}}, 1,1)
	{{/BottomRightReferencePoint}}
	{{#BottomCenterReferencePoint}}
	{{gtLayer}}.anchorX = 0.5
	{{gtLayer}}.anchorY = 1;
	_K.repositionAnchor({{gtLayer}}, 0.5,1)
	{{/BottomCenterReferencePoint}}
end
--
{{#ultimate}}
local function getPath(t)
    local _t = {}
    _t.x, _t.y =  _K.ultimatePosition(t.x, t.y)
    return _t
end
{{#gtBread}}
local gtbw = {{gtbw}}/4
local gtbh = {{gtbh}}/4
{{/gtBread}}
{{/ultimate}}
{{^ultimate}}
{{#gtBread}}
local gtbw = {{gtbw}}
local gtbh = {{gtbh}}
{{/gtBread}}
{{/ultimate}}
--
function _M:buildAnim(UI)
	local layer = UI.layer
	local sceneGroup = UI.scene.view
	-- Wait request for '+gtName+'\r\n';
	if {{gtLayer}} == nil then return end
	{{gtLayer}}.xScale = {{gtLayer}}.oriXs
	{{gtLayer}}.yScale = {{gtLayer}}.oriYs

	{{#gtDissolve}}
		_K.trans.{{gtName}} = {}
		_K.trans.{{gtName}}.play = function()
			transition.dissolve({{gtLayer}}, layer.{{gtDissolve}},	{{gtDur}}, {{gtDelay}})
		end
		_K.trans.{{gtName}}.pause = function() print("pause is not supported in dissove") end
		_K.trans.{{gtName}}.resume = function()
			transition.dissolve({{gtLayer}}, layer.{{gtDissolve}},	{{gtDur}}, {{gtDelay}})
		end
	{{/gtDissolve}}
	{{^gtDissolve}}
		local {{gtName}} = function(event)
			if _K.gt.{{gtName}} then
				_K.gt.{{gtName}}:toBeginning()
			end
		end -- end of function
		{{#gtRestart}}
		local _restart = {{gtRestart}}
		{{/gtRestart}}
		{{^gtRestart}}
		local _restart = false
		{{/gtRestart}}
			{{#isComic}}
			local deltaX = 0
			local deltaY = 0
			{{/isComic}}
			local onEnd_{{gtComplete}} = function()
				if _restart then
						{{#getTypeShake}}
						{{gtLayer}}.rotation = 0
						{{/getTypeShake}}
						{{^isComic}}
						{{gtLayer}}.x				 = {{gtLayer}}.oriX
						{{gtLayer}}.y				 = {{gtLayer}}.oriY
						{{/isComic}}
						{{gtLayer}}.alpha		 = {{gtLayer}}.oldAlpha
						{{gtLayer}}.rotation	= 0
						{{gtLayer}}.isVisible = true
						{{gtLayer}}.xScale		= {{gtLayer}}.oriXs
						{{gtLayer}}.yScale		= {{gtLayer}}.oriYs
						{{#tabSS}}
						{{gtLayer}}:pause()
						{{gtLayer}}.currentFrame = 1
						{{/tabSS}}
						{{^tabSS}}
						{{#tabMC}}
						{{gtLayer}}::stopAtFrame(1)
						{{/tabMC}}
						{{/tabSS}}
				end
				{{#gtAction}}
			--	{{gtAction}}()
        Runtime:dispatchEvent({name=UI.page..".action_{{gtAction}}", event={}, UI=UI})
				{{/gtAction}}
				{{#gtAudio}}
				audio.setVolume({{avol}}, { channel={{achannel}} })
				{{#alloRepeat}}
				{{gtAudio}}x9 = audio.play({{gtAudio}}, { channel={{achannel}}, loops={{aloop}}{{tofade}} })
				{{/alloRepeat}}
				{{^alloRepeat}}
				audio.play(UI.allAudios.{{gtAudio}}, { channel={{achannel}}, loops={{aloop}}{{tofade}} })
				{{/alloRepeat}}
				{{/gtAudio}}
			end --ends reStart for {{gtName}}
			{{#endX}}
				{{^groupAndPage}}
				local mX, mY = getPos({{gtLayer}}, {{endX}}, {{endY}})
				{{#isComic}}
				deltaX = {{gtLayer}}.oriX -mX
				deltaY = {{gtLayer}}.oriY -mY
				mX, mY = display.contentCenterX - deltaX, display.contentCenterY - deltaY
				{{/isComic}}
				{{/groupAndPage}}
	   		{{#groupAndPage}}
				local mX, mY = getPosGroupAndPage({{gtLayer}}, {{endX}}, {{endY}}, {{isSceneGroup}})
				{{/groupAndPage}}
			{{/endX}}
			{{^gtTypePath}}
				_K.gt.{{gtName}} = _K.gtween.new(
					{{gtLayer}},
					{{gtDur}},
					{{^Linear}}
					{
						{{#Pulse}}
						  xScale ={{scalW}}, yScale ={{scalH}},
						{{/Pulse}}
						{{#Rotation}}
							rotation = {{rotation}},
						{{/Rotation}}
						{{#Shake}}
							rotation = {{rotation}},
						{{/Shake}}
						{{#Bounce}}
							y=mY,
						{{/Bounce}}
						{{#Blink}}
						 xScale = {{scalW}}, yScale = {{scalH}},
						{{/Blink}}
					},
					{{/Linear}}
					{{#Linear}}
					{
						{{#endX}}
						x = mX, y = mY,
						{{/endX}}
						{{#gtEndAlpha}}
						alpha={{gtEndAlpha}},
						{{/gtEndAlpha}}
						{{#rotation}}
						rotation={{rotation}},
						{{/rotation}}
						{{#scalW}}
						xScale={{scalW}} * {{gtLayer}}.xScale,
						{{/scalW}}
						{{#scalH}}
						yScale={{scalH}} * {{gtLayer}}.yScale,
						{{/scalH}}
					},
					{{/Linear}}
					{
						ease = _K.gtween.easing.{{gtEase}},
						repeatCount = {{gtLoop}},
						reflect = {{gtReverse}}{{gtSwipes}},
						delay={{gtDelay}},
						onComplete=onEnd_{{gtComplete}}
						{{#gtBread}}
						, breadcrumb = true, breadAnchor = 5,
						breadShape = "{{gtbshape}}", breadW =gtbw, breadH = gtbh
						{{#gtbcolor}}
						, breadColor = { {{gtbcolor}} }
						{{/gtbcolor}}
						{{^gtbcolor}}
						, breadColor = {"rand"}
						{{/gtbcolor}}
						, breadInterval = {{gtbinter}}
						{{#gtbdispose}}
						, breadTimer = {{gtbsec}}
						{{/gtbdispose}}
						{{/gtBread}}
						})
			{{/gtTypePath}}
			{{#gtTypePath}}
			_K.gt.{{gtName}} = _K.btween.new(
				{{gtLayer}},
				{{gtDur}},
				{
					{{pathCurve}} angle = {{gtAngle}}
				},
				{
					ease			 = _K.gtween.easing.{{gtEase}},
					repeatCount = {{gtLoop}},
					reflect		 = {{gtReverse}}{{gtSwipes}},
					delay			 = {{gtDelay}},
					onComplete = onEnd_{{gtComplete}}
					{{#gtBread}}
					, breadcrumb = true, breadAnchor = 5,
					breadShape = "{{gtbshape}}", breadW =gtbw, breadH = gtbh
					{{#gtbcolor}}
					, breadColor = { {{gtbcolor}} }
					{{/gtbcolor}}
					{{^gtbcolor}}
					, breadColor = {"rand"}
					{{/gtbcolor}}
					, breadInterval = {{gtbinter}}
					{{#gtbdispose}}
					, breadTimer = {{gtbsec}}
					{{/gtbdispose}}
					{{/gtBread}}
				},
				{
					{{#endX}}
					x= mX, y= mY,
					{{/endX}}
					{{#gtEndAlpha}}
					alpha={{gtEndAlpha}},
					{{/gtEndAlpha}}
					{{#rotation}}
					rotation={{rotation}},
					{{/rotation}}
					{{#scalW}}
					xScale={{scalW}} * {{gtLayer}}.xScale,
					{{/scalW}}
					{{#scalH}}
					yScale={{scalH}} * {{gtLayer}}.yScale,
					{{/scalH}}
					{{#gtNewAngle}}
					newAngle = {{gtNewAngle}}
					{{/gtNewAngle}}
					})
				_K.gt.{{gtName}}.pathAnim = true
			{{/gtTypePath}}
				{{^aplay}}
				_K.gt.{{gtName}}:pause()
				{{/aplay}}
  			-- _K.gt.{{gtName}}:toBeginning()
	  		{{#isComic}}
  		{{gtLayer}}.anim["{{gtName}}"] = _K.gt.{{gtName}}
  		{{/isComic}}
		{{/gtDissolve}}
	--
	-- {{gtName}}()
end
--
function _M:play(UI)
	{{#gtDissolve}}
		_K.trans.{{gtName}}:play()
	{{/gtDissolve}}
	{{^gtDissolve}}
		-- _K.gt.{{gtName}}:toBeginning()
		_K.gt.{{gtName}}:play()
	{{/gtDissolve}}
end
--
function _M:resume(UI)
	{{#gtDissolve}}
		_K.trans.{{gtName}}:resume()
	{{/gtDissolve}}
	{{^gtDissolve}}
		_K.gt.{{gtName}}:play()
	{{/gtDissolve}}
end
--
return _M