local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps
local M = {
  name = "rect_0",
  properties = {
    target = "rect_0",
    countValue = 10,
    font =  "native.systemFont", -- "HiraMaruProN-W4",
    fontSize =  30,
    alignment =  "",
    color    =  { 0/255, 255/255, 255/255, 1 },
    orientation = "horizontal",
    scaleX = NIL,
    scaleY = NIL,
    paddingX = 2,
    paddingY = -2,
    alpha = NIL,
    autoPlay = true
  },
  actions = {
    onComplete = ""
  },
  layerProps = layerProps
}
--
return require("components.kwik.layer_counter").set(M)
