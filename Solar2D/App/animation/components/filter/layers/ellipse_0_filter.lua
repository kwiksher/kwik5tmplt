local M = {
  properties = {
    target     = "ellipse_0",
    type    = nil, -- group, page, sprite
    animation  = true,
    delay      = 0,
    duration   = 4000,
    autoPlay   = true,
    loop       = 1,        -- 0 to play once
    easing     = "inQuad",
    -- reverse    = nil,
    -- resetAtEnd = nil,
    -- useLang = false,
  },
  to = {},
  from = {},
  filter = {
    -- name = NIL,
    type = "filter",
    effect ="bloom"
  } ,
  actions = {onComplete = NIL},
  filterTable = {},
  layer   = "ellipse_0"
}
--
M.filterTable["filter.bloom"] = {
  set = function(effect, value)
    if value then
      effect.levels.gamma             = value.levels.gamma
      effect.levels.black             = value.levels.black
      effect.levels.white             = value.levels.white
      effect.blur.vertical.blurSize   = value.blur.vertical.blurSize
      effect.blur.vertical.sigma      = value.blur.vertical.sigma
      effect.blur.horizontal.blurSize = value.blur.horizontal.blurSize
      effect.blur.horizontal.sigma    = value.blur.horizontal.sigma
      effect.add.alpha                = value.add.alpha
    else
      effect.levels.gamma             = 1
      effect.levels.black             = 0.1
      effect.levels.white             = 0.8
      effect.blur.vertical.blurSize   = 20
      effect.blur.vertical.sigma      = 140
      effect.blur.horizontal.blurSize = 20
      effect.blur.horizontal.sigma    = 240
      effect.add.alpha                = 0.8
    end
  end,
  get = function()
      local effect = {}
      effect.levels = {}
      effect.blur  = {vertical={}, horizontal = {}}
      effect.add = {}
      effect.levels.gamma             = 1
      effect.levels.black             = 0.8
      effect.levels.white             = 0.8
      effect.blur.vertical.blurSize   = 200
      effect.blur.vertical.sigma      = 140
      effect.blur.horizontal.blurSize = 20
      effect.blur.horizontal.sigma    = 240
      effect.add.alpha                = 0.8
      return effect
  end
}
--
M.to = M.filterTable["filter.bloom"].get()
M.from = M.filterTable["filter.bloom"].get()
M.filterTable["filter.bloom"].set(M.from)
--
local json = require("json")
print(json.prettify(M.from))

return require("components.kwik.layer_filter").set(M)

