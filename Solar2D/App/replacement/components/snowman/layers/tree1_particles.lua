local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
local M = {
  name ="tree1",
  class = "particles", -- spritesheet
  -- sheet = tree1_sheet,
  properties = {
    target = "tree1",
    filename = "particles/emitter.lua", -- kaboom_393.json
    autoPlay = true,
  }
}
--
M.x = layerProps.x
M.y = layerProps.y
--
return require("components.kwik.layer_particles").new(M)
