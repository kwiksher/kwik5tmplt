local M = {
  properties = {
    target     = "rect_0",
    type    = "", -- group, page, sprite
    animation  = true,
    delay      = 0,
    duration   = 4000,
    autoPlay   = true,
    loop       = 1,        -- 0 to play once
    easing     = "inQuad",
    -- reverse    = nil,
    -- resetAtEnd = nil,
    -- xSwipe     = nil,
    -- ySwipe     = nil,
    -- useLang = false,
  },
  filter = {
    -- name = NIL,
    type = "filter",
    effect ="brightness"
  } ,
  actions = {onComplete = NIL},
  filterTable = {},
  layer   = "rect_0"

}
--
M.filterTable["filter.brightness"] = {
  set = function(effect, value)
    if value then
        effect.intensity   = value.intensity
    else
      effect.intensity   = 0.1
     end
  end,
  get = function()
        local effect = {}
        effect.intensity   = 0.4
      return effect
  end
}

M.to = M.filterTable["filter.brightness"].get()
M.from = M.filterTable["filter.brightness"].get()
M.filterTable["filter.brightness"].set(M.from)

return require("components.kwik.layer_filter").set(M)
