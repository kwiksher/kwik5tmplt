local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps

local M = {
  loop = true,
  rewind = true,
  isLocal = true,
  url = "",
  autoPlay = true,
  onCompelete = "action_{{elTrigger}}"
}
--
M.singleNames = {"PagePrevM", "PageNextM"}
--
M.x = layerProps.x
M.y = layerProps.y
--
return require("components.kwik.layer_video").new(M)
