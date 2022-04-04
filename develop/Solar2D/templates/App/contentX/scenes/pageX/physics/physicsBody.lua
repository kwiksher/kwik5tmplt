-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local physics = require("physics")
--
function _M:localVars()
end
--
function _M:localPos()
end

{{#ultimate}}
{{#bradius}}
local bradius = {{bradius}}/4
{{/bradius}}
{{/ultimate}}
{{^ultimate}}
{{#bradius}}
local bradius = {{bradius}}
{{/bradius}}
{{/ultimate}}


--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  local curPage = UI.curPage
  if layer.{{bname}} == nil then return end
    {{#circle}}
      physics.addBody(layer.{{bname}}, "{{btype}}", {density={{bdensity}}, friction={{bfriction}}, bounce={{bbounce}}, radius=bradius })
    {{/circle}}
    {{#bshape}}
      {{#PE}}
        local physicsData = (requireKwik("{{re}}")).physicsData(1.0)
        {{#static}}
          physics.addBody(layer.{{bname}}, "static", physicsData:get("{{bnameLower}}"))
        {{/static}}
        {{^static}}
          physics.addBody(layer.{{bname}}, physicsData:get("{{bnameLower}}"))
        {{/static}}
      {{/PE}}
      {{#Path}}
        local {{bname}}Shape= { {{bpath}} }
        physics.addBody(layer.{{bname}}, "{{btype}}", {density={{bdensity}}, friction={{bfriction}}, bounce={{bbounce}}, shape={{bname}}Shape })
      {{/Path}}
    {{/bshape}}
    {{#rect}}
      physics.addBody(layer.{{bname}}, "{{btype}}", {density={{bdensity}}, friction={{bfriction}}, bounce={{bbounce}} })
    {{/rect}}
    layer.{{bname}}.myName = "{{bname}}"
    {{#bsensor}}
        layer.{{bname}}.isSensor = true
    {{/bsensor}}
    {{#binvert}}
        layer.{{bname}}.gravityScale = -1
    {{/binvert}}
    {{#bgscale}}
        layer.{{bname}}.gravityScale = {{bgscale}}
    {{/bgscale}}
end
--
function _M:toDispose()
end
--
function _M:localVars()
end
--
return _M