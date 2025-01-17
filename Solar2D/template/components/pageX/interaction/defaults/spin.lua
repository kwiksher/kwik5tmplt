local M = {
  name = "spin0",
  class="spin",
  properties = {
    target = NIL,
    type   = NIL,
    minAngle  = NIL,
    maxAngle  = NIL,
    isActive = true
  },
  actions={
    onClokwise = NIL,
    onCounterClockwise = NIL,
    onEnded = NIL,
  }
}

return M