local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps

local M = {
  properties = {
    {{#properties}}
    loop     = "{{loop}}",
    rewind   = "{{rewind}}",
    isLocal  = "{{isLocal}}",
    url      = "{{url}}",
    autoPlay = "{{autoPlay}}",
    {{/properties}}
  },
  action = {
    {{#actions}}
    onCompelete = "{{onComplete}}"
    {{/actions}}
  },
  layerProps = layerProps
}
--
M.singleNames = {"PagePrevM", "PageNextM"}
--
M.x = layerProps.x
M.y = layerProps.y
--
return require("components.kwik.layer_video").new(M)
