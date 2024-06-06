local M = {
  name = "button",
  class="button",
  actionName = "",
  properties = {
    isActive = true,
    type  = "", -- tap, press
    over = "",
    btaps = 1,
    mask = "",
  },
  actions = {onComplete = ""}
}

return M