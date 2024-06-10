local M = {
  name = {{name}},
  class="body",
  properties = {
    bounce = {{bounce}},
    density = {{density}},
    friction = {{friction}},
    gravityScale = {{gravityScale}},
    isSensor = {{isSensor}},
    radius = {{bradius}}/4,
    shape   = {{shape}}, -- "circle", -- rect,  path
    type = "{{type}}",

  },
  dataPath = NIL, -- physicsEdtior(CodeAndWeb)
  dataShape ={}
}

{{#invert}}
M.properties.gravityScale = -1 * M.properties.gravityScale
{{/invert}}

return require("components.kwik.layer_physicsBody").set(M)
