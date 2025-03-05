local M = {
  properties = {
    target     = ellipse_0,
    type    = "", -- group, page, sprite
    animation  = false,
    delay      = 0,
    duration   = 1000,
    autoPlay   = true,
    loop       = 1,        -- 0 to play once
    easing     = "inQuad",
  -- reverse    = nil,
  -- resetAtEnd = nil,
  },
  filter = {
    -- name = "filter.bloom",
    type = "filter",
    effect = "bloom"
  } ,
  actions = {onComplete = NIL},
  layer == "ellipse_0",
  filterTable = {},
}
--
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
local name
if M.filter then
  name = "filter."..M.filter.effect
elseif M.composite then
  name = "filter."..M.composite.effect
elseif M.generator then
  name = "filter."..M.generator.effect
end
--
M.to = M.filterTable[name].get()
M.from = M.filterTable[name].get()
M.filterTable[name].set(M.from)
-- M.filter.params = M.filterTable[name].get()
return M
