
local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
local M = {
  name = "article",
  properties = {
    text =  "",
    inputType = "default",
    font =  NIL, -- "HiraMaruProN-W4",
    fontSize =  30,
    -- alignment =  "",
    color    = { 0, 1, 1, 1 },
    paddingX = 0,
    paddingY = -2,
    variable = "",
    dynamicText = "ellipse_0"
  },
  layerProps = layerProps
}
--
return require("components.kwik.layer_textinput").set(M)
