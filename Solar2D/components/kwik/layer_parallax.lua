
local _M = {}
---------------------
function M:setParallax(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
    --
    {{#parallaxArr}}
    layer.{{nm2}}X = {{nm}}.x
    layer.{{nm2}}Y = {{nm}}.y
    {{/parallaxArr}}
    --
    _K.accelerometerHandler = function(event)
    	{{#parallaxArr}}
      {{#dampX}}
           {{nm}}.x = layer.{{nm2}}X + (layer.{{nm2}}X * event.yGravity * {{dpx}});
      {{/dampX}}
      {{#dampY}}
           {{nm}}.y = layer.{{nm2}}Y + (layer.{{nm2}}Y * event.yGravity * {{dpy}});
      {{/dampY}}
        if event.zGravity > 0 then
          {{#triggerBack}}
           UI.scene:dispatchEvent({name="{{triggerBack}}", accel=event })
          {{/triggerBack}}
        else
          {{#triggerForward}}
           UI.scene:dispatchEvent({name="{{triggerForward}}", accel=event })
          {{/triggerForward}}
        end
      {{/parallaxArr}}
    end
    Runtime:addEventListener("accelerometer", _K.accelerometerHandler)
    _K.tAccell = _K.accelerometerHandler
end

--
function M:activate(obj)
  if obj == nil then
    return
  end
  local props = self.properties
  ---
end

function M:deactivate(obj)
end

M.set = function(model)
  return setmetatable(model, {__index = M})
end
--
return M
