local _M = {
  name       = {{name}},
  members   = {
    {{#members}}
    {{.}},
    {{/members}}
  },
  properties = {
    {{#properties}}
    alpha = {{alpha}},
    xScale = {{scaleW}},
    yScale = {{scaleH}},
    rotation = {{rotation}},
    isLuaTable = false
    {{/properties}}
  }
}

return require("components.kwik.page_group").set(props)