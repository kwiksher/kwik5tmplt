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
			transition.resume(_K.trans.{{tm}})
		{{/gtDissolve}}
		{{^gtDissolve}}
		if _K.gt.{{gtName}} then
			_K.gt.{{gtName}}:play()
		end
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
	      mX = layer.x + ((endX +layer.width/2) - layer.x)
	      mY = layer.y + ((endY +layer.height/2) -layer.y)
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
		mX = {{elW}} + math.random({{anim.randXStart}}, {{randXEnd}})
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
	{{#DefaultReference}}
    mX = layer.x + endX + layer.width/2  - layer.x
    mY = layer.y + endY + layer.height/2 - layer.y
	{{/DefaultReference}}
	{{#TextReference}}
    mX = layer.x + endX + {{nX}} - {{elX}} - layer.x
    mY = layer.y + endY + {{nY}} - {{elY}} - layer.y -layer.height*0.5
	{{/TextReference}}
	{{#TopLeftReferencePoint}}
		--TopLeftReferencePoint
      mX = layer.x + endX - layer.x
      mY = layer.y + endY - layer.y
	{{/TopLeftReferencePoint}}
	{{#TopCenterReferencePoint}}
	--TopCenterReferencePoint
      mX = layer.x + endX + layer.width/2 - layer.x
      mY = layer.y + endY - layer.y
	{{/TopCenterReferencePoint}}
	{{#TopRightReferencePoint}}
	--TopRightReferencePoint
      mX = layer.x + endX + layer.width - layer.x
      mY = layer.y + endY - layer.y
	{{/TopRightReferencePoint}}
	{{#CenterLeftReferencePoint}}
	--CenterLeftReferencePoint
      mX = layer.x + endX - layer.x
      mY = layer.y + endY + layer.height/2 - layer.y
	{{/CenterLeftReferencePoint}}
	{{#CenterRightReferencePoint}}
	--CenterRightReferencePoint
      mX = layer.x + endX + layer.width - layer.x
      mY = layer.y + endY + layer.height/2 - layer.y
	{{/CenterRightReferencePoint}}
	{{#BottomLeftReferencePoint}}
	--BottomLeftReferencePoint
      mX = layer.x + endX - layer.x
      mY = layer.y + endY + layer.height - layer.y
	{{/BottomLeftReferencePoint}}
	{{#BottomRightReferencePoint}}
	--BottomRightReferencePoint
      mX = layer.x + endX + layer.width - layer.x
      mY = layer.y + endY + layer.height - layer.y
	{{/BottomRightReferencePoint}}
	{{#BottomCenterReferencePoint}}
	--BottomCenterReferencePoint
      mX = layer.x + endX + layer.width/2 - layer.x
      mY = layer.y + endY + layer.height - layer.y
	{{/BottomCenterReferencePoint}}
	{{#randX}}
		mX = {{elW}} + math.random({{anim.randXStart}}, {{randXEnd}})
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
	-- Wait request for '+gtName+'\r\n';
	if {{gtLayer}} == nil then return end
	{{gtLayer}}.xScale = {{gtLayer}}.oriXs
	{{gtLayer}}.yScale = {{gtLayer}}.oriYs

	{{#gtDissolve}}
		_K.trans.{{tm}} = transition.dissolve({{gtLayer}}, layer.{{gtDissolve}},	{{gtDur}}, {{gtDelay}})
		transition.pause(_K.trans.{{tm}})
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
			local deltaX = 0
			local deltaY = 0
			local onEnd_{{gtComplete}} = function()
				if _restart then
						{{#getTypeShake}}
						{{gtLayer}}.rotation = 0
						{{/getTypeShake}}
						-- {{gtLayer}}.x				 = {{gtLayer}}.oriX - deltaX
						-- {{gtLayer}}.y				 = {{gtLayer}}.oriY - deltaY
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
				deltaX = {{gtLayer}}.oriX -mX
				deltaY = {{gtLayer}}.oriY -mY
				mX, mY = display.contentCenterX - deltaX, display.contentCenterY - deltaY
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
						{{#scaleW}}
						xScale={{scalW}},
						{{/scaleW}}
						{{#scaleH}}
						yScale={{scalH}},
						{{/scaleH}}
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
					reflect		 = {{gtReverse}},
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
					xScale={{scalW}},
					{{/scalW}}
					{{#scalH}}
					yScale={{scalH}},
					{{/scalH}}
					{{#gtNewAngle}}
					newAngle = {{gtNewAngle}}
					{{/gtNewAngle}}
					})
			{{/gtTypePath}}
			_K.gt.{{gtName}}:pause()
  		_K.gt.{{gtName}}:toBeginning()
  		{{gtLayer}}.anim["{{gtName}}"] = _K.gt.{{gtName}}

		{{/gtDissolve}}
	--
	-- {{gtName}}()
end
--
function _M:play(UI)
	{{#gtDissolve}}
		transition.resume(_K.trans.{{tm}})
	{{/gtDissolve}}
	{{^gtDissolve}}
		-- _K.gt.{{gtName}}:toBeginning()
		_K.gt.{{gtName}}:play()
	{{/gtDissolve}}
end
--
function _M:resume(UI)
	{{#gtDissolve}}
		transition.resume(_K.trans.{{tm}})
	{{/gtDissolve}}
	{{^gtDissolve}}
		_K.gt.{{gtName}}:play()
	{{/gtDissolve}}
end
--
return _M