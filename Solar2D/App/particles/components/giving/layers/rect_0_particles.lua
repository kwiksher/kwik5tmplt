local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
local M = {
  name ="rect_0",
  class = "particles", -- spritesheet
  -- sheet = rect_0_sheet,
  properties = {
    target = "rect_0",
    filename = "particles/giving.json", -- kaboom_393.json
    autoPlay = true,
  }
}
--
M.x = layerProps.x
M.y = layerProps.y
--
return require("components.kwik.layer_particles").new(M)
