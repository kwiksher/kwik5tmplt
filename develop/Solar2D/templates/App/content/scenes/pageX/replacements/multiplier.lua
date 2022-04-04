-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
--
{{#ultimate}}
local imageWidth = {{elW}}/4
local imageHeight = {{elH}}/4
local mX, mY                 = _K.ultimatePosition({{mX}}, {{mY}})
local elStartX, elStartY = _K.ultimatePosition({{elStartX}}, {{elStartY}})
local elEndX, elEndY   = _K.ultimatePosition({{elEndX}}, {{elEndY}})
{{^elDistance}}
local elFixX, elFixY   = _K.ultimatePosition({{elFixX}}, {{elFixY}})
{{/elDistance}}
{{/ultimate}}
{{^ultimate}}
local imageWidth = {{elW}}
local imageHeight = {{elH}}
local mX = {{mX}}
local mY = {{mY}}
local elStartX = {{elStartX}}
local elEndX   = {{elEndX}}
local elStartY = {{elStartY}}
local elEndY   = {{elEndY}}
{{^elDistance}}
local elFixX   = {{elFixX}}
local elFixY   = {{elFixY}}
{{/elDistance}}
{{/ultimate}}
--
{{#kwk}}
local imagePath = "{{bn}}.{{fExt}}"
{{/kwk}}
{{^kwk}}
local imageName = "/{{bn}}.{{fExt}}"
{{/kwk}}
local oriAlpha = {{oriAlpha}}
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  -- Multipliers for {{myLName}}
  local {{myLName}}_m_loop = {{elfora}} --1 plays multiplier forever
  local {{myLName}}_m_counter = {{elCopies}}
{{^kwk}}
  local imagePath = UI.imagePage .. imageName
{{/kwk}}
  --
  layer.{{myLName}}        = {}
  layer.c_{{myLName}}      = 0
  _K.{{myLName}}_m_restart = {{elCopies}}
  --
  {{#elphys}}
     physics.start(true);
  {{/elphys}}
  --
  _K.mt_{{myLName}} = function(counter)
  {{^multLayers}}
    {{#elwind}}

      physics.setGravity(math.random({{elwind}}*-1,{{elwind}})/10, 4);
      --
    {{/elwind}}
    --
    layer.{{myLName}}[counter] = display.newImageRect( _K.imgDir.. imagePath, _K.systemDir, imageWidth, imageHeight );
    --
    {{#elDistance}}
      layer.{{myLName}}[counter].x = math.random(elStartX,elEndX)
      layer.{{myLName}}[counter].y = math.random(elStartY,elEndY)
    {{/elDistance}}
    {{^elDistance}}
      layer.{{myLName}}[counter].x = mX + ((counter-1) * elFixX)
      layer.{{myLName}}[counter].y = mY + ((counter -1)* elFixY)
    {{/elDistance}}
    layer.{{myLName}}[counter].alpha = math.random({{elStartAlpha}},{{elEndAlpha}}) / 100
    layer.{{myLName}}[counter].oldAlpha = oriAlpha
    layer.{{myLName}}[counter].xScale = math.random({{elScaleStartX}},{{elScaleEndX}}) / 100
    --
    {{#elScaleLock}}
      layer.{{myLName}}[counter].yScale = layer.{{myLName}}[counter].xScale
    {{/elScaleLock}}
    {{^elScaleLock}}
      layer.{{myLName}}[counter].yScale = math.random({{elScaleStartY}},{{elScaleEndY}}) / 100
    {{/elScaleLock}}
    --
    layer.{{myLName}}[counter].rotation = math.random({{elrot1}},{{elrot2}})
    --
    {{#elphys}}
      local pweight = math.random({{elwStart}}, {{elwEnd}});
      physics.addBody(layer.{{myLName}}[counter], "dynamic", {density=pweight, friction=0, bounce=0{{myshape}} });
      {{#elsensor}}
        layer.{{myLName}}[counter].isSensor = true;
      {{/elsensor}}
        local a = pweight * layer.{{myLName}}[counter].xScale;
        layer.{{myLName}}[counter].linearDumping = a;
    {{/elphys}}
       layer.{{myLName}}[counter].myName = "{{myLName}}"
       layer.gp_{{myLName}}:insert(layer.{{myLName}}[counter])

    end
    --
    local function ct_{{myLName}}()
      if _K.timerStash.mt0 then
         layer.c_{{myLName}} = layer.c_{{myLName}} + 1
         if _K.mt_{{myLName}} ~= nil then
            _K.mt_{{myLName}}( layer.c_{{myLName}})
         end
         if (layer.c_{{myLName}} == _K.{{myLName}}_m_restart and {{myLName}}_m_loop == 1)  then
            if _K.timerStash.mt then
              timer.cancel( _K.timerStash.mt )
            end
            _K.timerStash.mt = timer.performWithDelay( {{elInterval}}, ct_{{myLName}}, {{elCopies}} )
            _K.{{myLName}}_m_restart = layer.c_{{myLName}} + {{myLName}}_m_counter
         end
       end
    end
    --
    _K.multi_{{myLName}} = function()
       _K.timerStash.mt0 = timer.performWithDelay( {{elInterval}}, ct_{{myLName}}, {{elCopies}} )
    end
    {{^elwait}}
      _K.multi_{{myLName}}()
    {{/elwait}}
  {{/multLayers}}
  --
  {{#hasMutliplier}}
    -- Clean up memory for Multiplier set to forever
    -- control variable to dispose kClean via kNavi
    _K.kClean = function()
          -- runs normal code
          {{codeMultiplier}}
       end
    end
    Runtime:addEventListener("enterFrame", _K.kClean)
  {{/hasMutliplier}}
end
--
function _M:codeMultiplier(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  --
  for i = 1, _K.{{myLName}}_m_restart do
    if layer.{{myLName}}[i] ~= nil then
      if layer.{{myLName}}[i].y ~= nil then
        if  layer.{{myLName}}[i].y {{aa}} then
          display.remove(layer.{{myLName}}[i])
          layer.{{myLName}}[i]:removeSelf()
          layer.{{myLName}}[i] = nil
        end
      end
    end
  end
end
--
function _M:toDispose(UI)
  {{^multLayers}}
  {{#hasMutliplier}}
    if _K.kClean ~=nil then
      Runtime:removeEventListener("enterFrame", _K.kClean)
      _K.kClean = nil
    end
  {{/hasMutliplier}}
    if _K.timerStash.mt0 then
      timer.cancel(_K.timerStash.mt0)
    end
    if _K.timerStash.mt then
      timer.cancel( _K.timerStash.mt )
    end
  {{/multLayers}}
end
--
function _M:toDistory(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{^multLayers}}
    layer.gp_{{myLName}}:removeSelf()
    layer.gp_{{myLName}} = nil
  {{/multLayers}}
  {{#hasMutliplier}}
    _K.kClean = nil
  {{/hasMutliplier}}
end
--
function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  --
  layer.gp_{{myLName}} = display.newGroup()
  sceneGroup:insert( layer.gp_{{myLName}})
end
--
function _M:localVars(UI)
  {{#multLayers}}
  {{^kwk}}
    local imagePath = UI.imagePage .. imageName
  {{/kwk}}
      UI.tab{{um}}["{{dois}}"] = {imagePath, elW, elH, mX, mY, oriAlpha, {{elwind}}, elStartX, elEndX, elStartY, elEndY, elFixX, elFixY, {{elStartAlpha}}, {{elEndAlpha}}, {{elScaleStartX}}, {{elScaleEndX}}, {{elScaleStartY}}, {{elScaleEndY}}, {{elwStart}}, {{elwEnd}}
    }
  {{/multLayers}}
end
--
return _M