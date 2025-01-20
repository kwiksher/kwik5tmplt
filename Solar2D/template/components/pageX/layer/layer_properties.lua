local M = {}
--
M.properties = {
  {{#properties}}
  blendMode = "{{blendMode}}",
  height    = {{height}},
  width     = {{width}} ,
  kind      = "{{kind}}",
  name      = "{{name}}",
  type      = "{{type}}",
  x         = {{x}},
  y         = {{y}},
  alpha     = {{alpha}},
  --
  align       = "{{align}}",
  randXStart  = {{randXStart}},
  randXEnd    = {{randXEnd}},
  randYStart  = {{randYStart}},
  randYEnd    = {{randYEnd}},
  --,
  xScale     = {{xScale}},
  yScale     = {{yScale}},
  rotation   = {{rotation}},
  --,
  layerAsBg     = {{layerAsBg}},
  isSharedAsset = {{isSharedAsset}},
  ---
  {{#color}}
  color    = { {{r}}, {{g}}, {{b}}, {{a}} },
  {{/color}}
  {{#text}}
  text = {{text}},
  font = {{font}},
  fontSize = {{fontSize}},
  {{/text}}
  ---
  {{#infinity}}
  infinity = {
    speed = {{speed}},
    distance = {{distance}},
    direction = "{{direction}}",
  },
  {{/infinity}}
  ---
  {{#imagePath}}
  imagePath   = {{imagePath}},
  imageHeight = {{imageHeight}},
  imageWidth  = {{imageWidth}}
  {{/imagePath}}
  {{/properties}}
}
--
return M