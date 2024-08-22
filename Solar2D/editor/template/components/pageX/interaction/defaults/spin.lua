local M = {
  name = "spin",
  class="spin",
  properties = {
    constrainAngle = 360,
    bounds = {xStart=nil, xEnd=nil, yStart=nil, yEnd=nil},
    isActive = true
  },
  actions={
    onClokwise = nil,
    onCounterClockwise = nil,
    onReleased =nil,
  }
}

return M