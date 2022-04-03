-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
function _M:localVars()
end
--
function _M:localPos()
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if layer.{{bname}} == nil then return end

    {{#auto}}
      layer.{{bname}}:{{btraj}}({{bxforce}}, {{byforce}}, layer.{{bname}}.x, layer.{{bname}}.y)
    {{/auto}}
    {{^auto}}
      local function {{btype}}{{bname}}(event)
         if event.phase == "began" then
            display.getCurrentStage():setFocus(layer.{{bname}})
         elseif event.phase == "ended" then
            {{#binitial}}
              {{#pull}}
                layer.{{bname}}:{{btraj}}(event.xStart - event.x, event.yStart - event.y, layer.{{bname}}.x, layer.{{bname}}.y)
              {{/pull}}
              {{#push}}
                layer.{{bname}}:{{btraj}}(event.x - event.xStart, event.y - event.yStart, layer.{{bname}}.x, layer.{{bname}}.y)
              {{/push}}
            {{/binitial}}
            {{^binitial}}
              local x = event.x; local y = event.y
              {{#pull}}
                local xForce = (layer.{{bname}}.x - x) * {{bxforce}}
                local yForce = (layer.{{bname}}.y - y) * {{byforce}}
              {{/pull}}
              {{#push}}
                local xForce = (-1 * (layer.{{bname}}.x - x)) * {{bxforce}}
                local yForce = (-1 * (layer.{{bname}}.y - y)) * {{byforce}}
              {{/push}}
              layer.{{bname}}:{{btraj}}(xForce, yForce, layer.{{bname}}.x, layer.{{bname}}.y)
            {{/binitial}}
            display.getCurrentStage():setFocus(nil)
         end
         return true
      end
      layer.{{bname}}:addEventListener("touch", {{btype}}{{bname}})
    {{/auto}}
end
--
function _M:toDispose()
end
--
function _M:localVars()
  {{#physics}}
  {{/physics}}
end
--
return _M