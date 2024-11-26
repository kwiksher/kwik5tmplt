local parent,root, M = newModule(...)

local M = {
  name ="{{name}}",
  class = "{{class}}", -- spritesheet
  -- sheet = {{name}}_sheet,
  properties = {
    {{#properties}}
    target = "{{target}}",
    url = "{{url}}", -- kaboom_393.json
    autoPlay = {{autoPlay}},
    {{/properties}}
  }
}
--
local layerProps = require(parent.."{{layer}}")
--
M.x = layerProps.x
M.y = layerProps.y
--

return require("components.kwik.layer_particles").new(M)
