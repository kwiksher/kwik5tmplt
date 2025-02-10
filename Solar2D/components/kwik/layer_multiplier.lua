local M = {}
--
local _K = require "Application"
--
local imageWidth = {{elW}}/4
local imageHeight = {{elH}}/4
local mX, mY                 = _K.ultimatePosition({{mX}}, {{mY}})
local elStartX, elStartY = _K.ultimatePosition({{elStartX}}, {{elStartY}})
local elEndX, elEndY   = _K.ultimatePosition({{elEndX}}, {{elEndY}})
{{^elDistance}}
local elFixX, elFixY   = _K.ultimatePosition({{elFixX}}, {{elFixY}})
{{/elDistance}}
--
function M:create(UI)
  local sceneGroup = UI.sceneGroup
  local layeName = UI.properties.target
  local props = self.properties
  local layerProps = self.layerProps
  --
  layer.gp_{{myLName}} = display.newGroup()
  sceneGroup:insert( layer.gp_{{myLName}})
end
--
function M:didShow(UI)
  local sceneGroup = UI.sceneGroup
  local layeName = UI.properties.target
  local props = self.properties
  local layerProps = self.layerProps

  local _loop = {{elfora}} --1 plays multiplier forever
  local _counter = {{elCopies}}

--
  local objs       = {}
  local count      = 0
  self.maxCopies    = {{elCopies}}
  --
  {{#elphys}}
     physics.start(true);
  {{/elphys}}
  --
  local handler = function(counter)
    {{#elwind}}

      physics.setGravity(math.random({{elwind}}*-1,{{elwind}})/10, 4);
      --
    {{/elwind}}
    --
    objs.counter = display.newImageRect( _K.imgDir.. imagePath, _K.systemDir, imageWidth, imageHeight );
    --
    {{#elDistance}}
      objs.counter.x = math.random(elStartX,elEndX)
      objs.counter.y = math.random(elStartY,elEndY)
    {{/elDistance}}
    {{^elDistance}}
      objs.counter.x = mX + ((counter-1) * elFixX)
      objs.counter.y = mY + ((counter -1)* elFixY)
    {{/elDistance}}
    objs.counter.alpha = math.random({{elStartAlpha}},{{elEndAlpha}}) / 100
    objs.counter.oldAlpha = oriAlpha
    objs.counter.xScale = math.random({{elScaleStartX}},{{elScaleEndX}}) / 100
    --
    {{#elScaleLock}}
      objs.counter.yScale = objs.counter.xScale
    {{/elScaleLock}}
    {{^elScaleLock}}
      objs.counter.yScale = math.random({{elScaleStartY}},{{elScaleEndY}}) / 100
    {{/elScaleLock}}
    --
    objs.counter.rotation = math.random({{elrot1}},{{elrot2}})
    --
    {{#elphys}}
      local pweight = math.random({{elwStart}}, {{elwEnd}});
      physics.addBody(objs.counter, "dynamic", {density=pweight, friction=0, bounce=0{{myshape}} });
      {{#elsensor}}
        objs.counter.isSensor = true;
      {{/elsensor}}
        local a = pweight * objs.counter.xScale;
        objs.counter.linearDumping = a;
    {{/elphys}}
       objs.counter.myName = "{{myLName}}"
       layer.gp_{{myLName}}:insert(objs.counter)

    end
    --
    local function copyHandler()
      if self.timer0 then
         count = count + 1
         if handler ~= nil then
            handler( count)
         end
         if (count == self.maxCopies    and _loop == 1)  then
            if self.timer1 then
              timer.cancel( self.timer1 )
            end
            self.timer1 = timer.performWithDelay( {{elInterval}}, copyHandler, {{elCopies}} )
            self.maxCopies    = count + _counter
         end
       end
    end
    --
    local timerHandler = function()
       UI.timers[UI.timers + 1] timer.performWithDelay( {{elInterval}}, copyHandler, {{elCopies}} )
    end
    if props.autoPlay then
      timerHandler()
    end
  --
  if self.hashasMutliplier
    -- Clean up memory for Multiplier set to forever
    -- control variable to dispose kClean via kNavi
    self.cleanHandler = function()
          -- runs normal code
          {{codeMultiplier}}
       end
    end
    Runtime:addEventListener("enterFrame", self.cleanHandler)
  end
end
--
function M:codeMultiplier(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  --
  for i = 1, self.maxCopies    do
    if objs[i] ~= nil then
      if objs[i].y ~= nil then
        if  objs[i].y {{aa}} then
          display.remove(objs[i])
          objs[i]:removeSelf()
          objs[i] = nil
        end
      end
    end
  end
end
--
function M:didHide(UI)
  if slef.hasMutliplier then
    if self.cleanHandler ~=nil then
      Runtime:removeEventListener("enterFrame", self.cleanHandler)
      self.cleanHandler = nil
    end
  end
    if self.timer0 then
      timer.cancel(self.timer0)
    end
    if self.timer1 then
      timer.cancel( self.timer1 )
    end
end
--
function M:destroy(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
    layer.gp_{{myLName}}:removeSelf()
    layer.gp_{{myLName}} = nil
  if self.hashasMutliplier then
    self.cleanHandler = nil
  end
end
--
return M