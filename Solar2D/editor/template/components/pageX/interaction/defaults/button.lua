local M = {
  name = "button",
  class="button",
  properties = {
    target = NIL,
    isActive = true,
    type  = "tap", -- tap, touch
    over = NIL,
    btaps = 1,
    mask = NIL,
  },
  actions = {onTap = ""}
}

return M