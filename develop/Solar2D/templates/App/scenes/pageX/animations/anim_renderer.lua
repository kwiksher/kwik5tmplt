-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
--
function _M:didShow(UI)
  -- UI.scene:dispatchEvent({name="{{myLName}}_{{layerType}}_{{triggerName}}", phase = "didShow", UI=UI})	}
  self:repoHeader(UI)
  self:buildAnim(UI)
    if model.play and model.type = "dissolve" then
        _K.trans[model.name]:play()
    end
end
--
function _M:toDispose()
	_K.cancelAllTweens()
	_K.cancelAllTransitions()
end

--
local function getPosGroupAndPage(layer, _endX, _endY, isSceneGroup)
	local mX, mY
	local endX, endY =  _K.ultimatePosition(_endX, _endY)
	if isEqualPoint(model.referencePoint, "center","center") then
		--CenterReferencePoint
	  if isSceneGroup then
	      mX = endX + layer.x
	      mY = endY + layer.y
	  else
	      mX = endX +layer.width/2 
	      mY = endY +layer.height/2
      end
    elseif isEqualPoint(model.referencePoint, "left", "top") then 
		--TopLeftReferencePoint
        mX = endX  + ( layer.width / 2)
        mY = endY  + ( layer.height / 2)
    elseif isEqualPoint(model.referencePoint, "center", "top") then 
        mX = endX  + (  layer.width / 2)
        mY = endY  + ( layer.height / 2)
    elseif isEqualPoint(model.referencePoint, "right", "top") then 
        mX = endX  + (  layer.width )
        mY = endY  + ( layer.height )
    elseif isEqualPoint(model.referencePoint, "left", "center") then 
        mX = endX  + ( layer.width / 2)
        mY = endY  + (  layer.height / 2)
    elseif isEqualPoint(model.referencePoint, "right", "center") then 
        mX = endX  + ( layer.width )
        mY = endY  + (  layer.height / 2)
    elseif isEqualPoint(model.referencePoint, "left", "bottom") then 
        mX = endX  + ( layer.width )
        mY = endY  + (  layer.height )
    elseif isEqualPoint(model.referencePoint, "right", "bottom") then 
        mX = endX  + (  layer.width )
        mY = endY  + (  layer.height )
    elseif isEqualPoint(model.referencePoint, "center", "bottom") then 
        mX = endX  + (  layer.width / 2)
        mY = endY  + (  layer.height )
    end
    
    if model.xRandom then
		mX = model.xRandom.width + math.random(model.xRandom.xStart, model.xRandom.eEnd)
    end
    if model.yRandom then
		mY =  model.yRandom.height + math.random(model.yRandom.yStart, model.yRandom.yEnd)
	end
	return mX, mY
end
--
local function getPos(layer, _endX, _endY)
	local endX, endY =  _K.ultimatePosition(_endX, _endY)
	local width, height = layer.width*layer.xScale, layer.height*layer.yScale
	if model.model.defaultReferencePoint then
        mX = endX + width/2
        mY = endY + height/2
    end
	if model.xText then
        mX = endX + model.xText
        mY = endY + model.yText
    end

    if isEqualPoint(model.referencePoint, "left", "top") then 
		--TopLeftReferencePoint
      mX = endX 
      mY = endY 
    elseif isEqualPoint(model.referencePoint, "center", "top") then 
	--TopCenterReferencePoint
      mX = endX + width/2 
      mY = endY 
    elseif isEqualPoint(model.referencePoint, "right", "top") then 
	--TopRightReferencePoint
      mX = endX + width 
      mY = endY 
    elseif isEqualPoint(model.referencePoint, "left", "center") then 
	--CenterLeftReferencePoint
      mX = endX 
      mY = endY + height/2
    elseif isEqualPoint(model.referencePoint, "right", "center") then 
	--CenterRightReferencePoint
      mX = endX + width 
      mY = endY + height/2 
    elseif isEqualPoint(model.referencePoint, "left", "bottom") then 
	--BottomLeftReferencePoint
      mX = endX 
      mY = endY + height 
    elseif isEqualPoint(model.referencePoint, "right", "bottom") then 
	--BottomRightReferencePoint
      mX = endX + width 
      mY = endY + height 
    elseif isEqualPoint(model.referencePoint, "center", "bottom") then 
	--BottomCenterReferencePoint
      mX = endX + width/2 
      mY = endY + height 
    end
    if model.xRandom then
		mX = model.xRandom.width + math.random(model.xRandom.xStart, model.xRandom.eEnd)
    end
    if model.yRandom then
		mY =  model.yRandom.height + math.random(model.yRandom.yStart, model.yRandom.yEnd)
	end
	return mX, mY
end

--
function _M:repoHeader(UI)
    local layer = UI.layer
    local obj = layer[model.layer]
    
    if isEqualPoint(model.referencePoint, "left", "top") then 	
	obj.anchorX = 0
	obj.anchorY = 0;
	_K.repositionAnchor(obj, 0,0)
    elseif isEqualPoint(model.referencePoint, "center", "top") then 
	obj.anchorX = 0.5
	obj.anchorY = 0;
	_K.repositionAnchor(obj, 0.5,0)
    elseif isEqualPoint(model.referencePoint, "right", "top") then 
	obj.anchorX = 1
	obj.anchorY = 0;
	_K.repositionAnchor(obj, 1,0)
    elseif isEqualPoint(model.referencePoint, "left", "center") then 
	obj.anchorX = 0
	obj.anchorY = 0.5;
	_K.repositionAnchor(obj, 0,0.5)
    elseif isEqualPoint(model.referencePoint, "right", "center") then 
	obj.anchorX = 1
	obj.anchorY = 0.5;
	_K.repositionAnchor(obj, 1,0.5)
	{{/CenterRightReferencePoint}}
	{{#BottomLeftReferencePoint}}
	obj.anchorX = 0
	obj.anchorY = 1;
	_K.repositionAnchor(obj, 0,1)
    elseif isEqualPoint(model.referencePoint, "left", "bottom") then 
	obj.anchorX = 1
	obj.anchorY = 1;
	_K.repositionAnchor(obj, 1,1)
    elseif isEqualPoint(model.referencePoint, "right", "bottom") then 
	obj.anchorX = 0.5
	obj.anchorY = 1;
    _K.repositionAnchor(obj, 0.5,1)
    end
end
--
local function getPath(t)
    local _t = {}
    _t.x, _t.y =  _K.ultimatePosition(t.x, t.y)
    return _t
end

if model.type == "dissolve" then
    _M.buildAnim = function(self, UI)
        local layer = UI.layer
        local sceneGroup = UI.scene.view
        local obj = layer[model.layer]
        -- Wait request for '+gtName+'\r\n';
        if obj == nil then return end
        obj.xScale = obj.oriXs
        obj.yScale = obj.oriYs

        _K.trans[model.name] = {}
        _K.trans[model.name].play = function()
            transition.dissolve(obj, layer.{{gtDissolve}},	{{gtDur}}, {{gtDelay}})
        end
        _K.trans[model.name].pause = function() print("pause is not supported in dissove") end
        _K.trans[model.name].resume = function()
            transition.dissolve(obj, layer.{{gtDissolve}},	{{gtDur}}, {{gtDelay}})
        end
    end
else

end
local onEnd_{{gtComplete}} = function()
    if _restart then
        if model.getTypeShake then
        obj.rotation = 0
        end
        if not model.isComic then
            obj.x				 = obj.oriX
            obj.y				 = obj.oriY
        end
        obj.alpha		 = obj.oldAlpha
        obj.rotation	= 0
        obj.isVisible = true
        obj.xScale		= obj.oriXs
        obj.yScale		= obj.oriYs

        if model.pauseCurrentFrameOne then
            obj:pause()
            obj.currentFrame = 1
        elseif model.stopAtFrameOne then
            obj::stopAtFrame(1)
        end 
    end

    if model.action then
        Runtime:dispatchEvent({name=UI.page..".action_"..model.action, event={}, UI=UI})
    end
        
    if model.audio then
        audio.setVolume(model.audio.volume, { channel=model.audio.channel })
        if model.audio.repeat then
        {{gtAudio}}x9 = audio.play(model.audio.name, { channel=model.audio.channel, loops=model.audio.loops} )
        else
        audio.play(UI.allAudios[model.audio.name], { channel=model.audio.channel, loops=model.audio.loops} )
        end
    end
end --ends reStart for {{gtName}}


local function copyTableTo(t1, t2)
  for k,v in pairs(t1) do
    t2[k] = v
  end
  return t2
end

function createParamsForBtween (model, mX, mY)
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
                xScale={{scalW}} * obj.xScale,
                {{/scalW}}
                {{#scalH}}
                yScale={{scalH}} * obj.yScale,
                {{/scalH}}
                {{#gtNewAngle}}
                newAngle = {{gtNewAngle}}
                {{/gtNewAngle}}
                })
end

function createParamsForGtween (model, mX, mY)
    local params

    if model.type ~="linear" then
        if model.type == "pulse" then
         params =  {xScale =model.xScale, yScale =model.yScale}
        elseif model.type =="rotation" then
         params =   {rotation = model.rotation}
        elseif model.type =="shake" then
         params =   {rotation = model.rotation}
        elseif model.type =="bounce" then
         params =   {y=mY}
        elseif model.type =="blink" then
         params =   {xScale = model.xScale, yScale = model.yScale} 
        end
    
    else
        local  t1 = {}
        if model.xEnd and model.yEnd then
          table.insert(t1, { x = mX, y = mY})
        end

        if model.alpha then
         table.insert(t1, {alpha=model.alpha})
        end

        if model.rotation then
            table.insert(t1, {rotation=model.rotation})
        end

        if model.xScale then
            table.insert(t1, {xScale=model.xScale * obj.xScale})
        end
        
        if model.yScale then
            table.insert(t1, {yScale=model.yScale * obj.yScale})
        end

        for i=1, #t1 do 
            copyTableTo(t1[i], params)
        end
        
    end 

    local props =  {
            ease = _K.gtween.easing[model.ease],
            repeatCount = model.repeatCount,
            reflect = model.refrect,
            delay=model.delay,
            onComplete=onEnd_gtComplete
            }
    
    if model.breadShape then
        local t1 ={{ breadcrumb = true, breadAnchor = 5
            breadShape = "{{gtbshape}}", breadW =gtbw, breadH = gtbh
            , breadInterval = model.breadInterval
        }}
            
        if model.breadShape then 
            table.insert(t1, {breadColor =model.breadColor })
        else
            table.insert(t1, {breadColor ={"rand"} })
        end
        if model.breadTimer then
            table.insert(t1, {breadTimer = model.breadTimer})
        end

        for i=1, #t1 do 
            copyTableTo(t1[i], props)
        end

    end

    return [model.duration, params, props]
end
--
function _M:buildAnim(UI)
	local layer = UI.layer
    local sceneGroup = UI.scene.view
    local obj = layer[model.layer]
	-- Wait request for '+gtName+'\r\n';
	if obj == nil then return end
	obj.xScale = obj.oriXs
	obj.yScale = obj.oriYs
    
    local _restart = model.restart or false
    
    local deltaX = 0
    local deltaY = 0

    local mX, mY 
    if model.xEnd and model.yEnd then
        if not model.groupAndPage then
            mX, mY = getPos(obj, model.xEnd, model.yEnd)
            if model.isComic then
                deltaX = obj.oriX -mX
                deltaY = obj.oriY -mY
                mX, mY = display.contentCenterX - deltaX, display.contentCenterY - deltaY
            end
        else
            mX, mY = getPosGroupAndPage(obj, model.xEned, model.yEnd, model.isSceneGroup)
        end
    end

    if model.type ~= "path" then
        local params = createParamsForGtween(model, mX, mY)
        _K.gt[model.name] = _K.gtween.new(obj, unpack(params))

    else
        local params = createParamsForBtween(model, mX, mY)
        _K.gt[model.name] = _K.btween.new(obj, unpack(params))
        _K.gt[model.name].pathAnim = true
    end
    if not model.play then
    _K.gt[model.name]:pause()
    end
        -- _K.gt[model.name]:toBeginning()
    if model.isComic then
        obj.anim[model.name] = _K.gt[model.name]
    end
 	--
	-- {{gtName}}()
end
--
function _M:play(UI)
	if model.type =="dissolve" end
		_K.trans[model.name]:play()
    else
		-- _K.gt[model.name]:toBeginning()
		_K.gt[model.name]:play()
    end
end
--
function _M:resume(UI)
	if model.type =="dissolve" end
		_K.trans[model.name]:resume()
    else
        _K.gt[model.name]:play()
    end
end
--
return _M