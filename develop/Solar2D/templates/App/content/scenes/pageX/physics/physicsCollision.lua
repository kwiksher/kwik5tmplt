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

   local function onCollision_{{bname}}(self, event)
  {{#collArr}}
        if event.phase == "began" and event.other.myName == "{{mcoll}}" then
          {{#maction}}
          -- {{maction}}()
        Runtime:dispatchEvent({name=UI.page..".action_{{maction}}", event={}, UI=UI})

          {{/maction}}
          {{#disbody}}
            layer.{{bname}}:removeSelf(); layer.{{bname}} = nil
          {{/disbody}}
          {{#discoll}}
            layer.{{mcoll}}:removeSelf(); layer.{{mcoll}} = nil
          {{/discoll}}
        end
    {{/collArr}}
    end
    layer.{{bname}}.collision = onCollision_{{bname}}
    layer.{{bname}}:addEventListener("collision", {{bname}})
end
--
function _M:toDispose()
end
--
function _M:localVars()
end
--
return _M