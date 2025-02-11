local M = {
  name = "map0",
  class="map",
  properties = {
    target = NIL,
    mapType         = "Normal", -- Normal, Satellite, Hybrid
    latituite       = 37.331692,
    longtitude      = -122.030456,
    isScrollEnabled = true,
    isZoomEnabled   = true,
    marker = {
      enabled    = true,
      latituite  = 37.331692,
      longtitude = -122.030456,
      title      = "title",
      subtitle   = "subtitle",
    },
  },
}

return M