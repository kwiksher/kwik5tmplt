local M = {
  name = "drag",
  class="drag",
  actions = {
    onDropped = "",
    onReleased ="",
    onMoved= "" },
  properties = {
    constrainAngle = NIL,
    isActive = true,
    isFocus = true,
    isGroup = false,
    --
    isFlip = true,
    flipInitialDirection = "right",  -- flipSet.right
    isDrop = true,
    dropArea = "",
    dropAreaMargin = 10,
    --
    boundaries = {x=0, y=0, w=1920, h=1280}, -- select a layer
    --
    rockingEnable = 1 ,-- 0,
    backToOrigin = true,

  }
}

return M