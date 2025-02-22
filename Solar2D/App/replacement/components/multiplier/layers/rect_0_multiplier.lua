local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
local M = {
  name = "rect_0",
  properties = {
    target         = "rect_0",
    alphaMax       = 1,
    alphaMin       = 0.1,
    autoPlay       = true,
    enabledWind    = true,
    enablePhysics  = true,
    enableSeonsor  = true,
    fixedDistance  = false,
    interval       = 5,
    numOfCopies    = 4,
    playForever    = true,
    rotationMax    = 360,
    rotationMin    = 0,
    shape          = "circle",
    weightMax      = 30,
    weightMin      = 1,
    windSpeed      = 10,
    xEnd           = 960,
    xSaleMax       = 2,
    xScaleMin      = 0.1,
    xStart         = 0,
    yEnd           = 590,
    ySaleMax       = 2,
    yScaleMin      = 0.1,
    yStart         = 0,
  },
  layerProps = layerProps
}
--
return require("components.kwik.layer_multiplier").set(M)
