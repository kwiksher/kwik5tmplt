local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
local M = {
  name = "snowFlake",
  properties = {
    target         = "snowFlake",
    alphaMax       = 1,
    alphaMin       = 0.1,
    autoPlay       = true,
    enabledWind    = true,
    enablePhysics  = true,
    enableSeonsor  = true,
    fixedDistance  = false,
    fixedScaleMax   = false,
    fixedScaleMin   = false,
    gravityY        = 0.2,
    interval       = 0.5,
    numOfCopies    = 40,
    playForever    = true,
    rotationMax    = 45,
    rotationMin    = 0,
    physicsShape   = "",
    weightMax      = 4,
    weightMin      = 1,
    windSpeed      = 10,
    xEnd           = 1920,
    xSaleMax       = 1,
    xScaleMin      = 0.7,
    xStart         = 0,
    yEnd           = 0,
    ySaleMax       = 1,
    yScaleMin      = 0.7,
    yStart         = -480,
  },
  layerProps = layerProps
}
--
return require("components.kwik.layer_multiplier").set(M)
