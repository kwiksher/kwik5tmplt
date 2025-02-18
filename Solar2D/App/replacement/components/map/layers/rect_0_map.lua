local parent, root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
local M = {
  name = "rect_0",
  properties = {
    target          = "rect_0",
    mapType         = "standard",
    latituite       = "37.331692",
    longtitude      = "-122.030456",
    isScrollEnabled = true,
    isZoomEnabled   = true,
    marker = {
      enabled    = true,
      latituite  = "37.331692",
      longtitude = "-122.030456",
      title      = "title",
      subtitle   = "subtitle",
    },
  },
  layerProps = layerProps
}
--
return require("components.kwik.layer_map").set(M)
