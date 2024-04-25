local M = {
  name = "drag",
  class="drag",
  actions = {
    onDropped = "",
    onReleased ="",
    onMoved= "" },
  settings = {
    constrainAngle = nil,
    isActive = true,
    isFocus = true,
    isPage = false,
    --
    isFlip = true,
    flip = "right",  -- flipSet.right
    flipSet  = {
      right = {
        axis = "x",
        from = "right",
        to = "left",
        scaleStart = 1,
        scaleEnd = -1,
      },
      left = {
        axis = "x",
        from = "right",
        to = "left",
        scaleStart = -1,
        scaleEnd = 1,
      },
      bottom={
        axis = "y",
        from = "bottom",
        to = "top",
        scaleStart = 1,
        scaleEnd = -1,
      },
      top = {
        axis = "y",
        from = "bottom",
        to = "top",
        scaleStart = -1,
        scaleEnd = 1,
      },
    },
    isDrop = true,
    dropLayer = "",
    dropMargin = 10,
    --
    dropBound = {xStart=0, xEnd=0, yStart = 0, yEnd=0},
    --
    rock = 1 ,-- 0,
    backToOrigin = true,

  }
}

return M