-- $weight=
--
local parent,root, M = newModule(...)

local _layerProps = {
  blendMode = "nil",
  height    = nil,
  width     = nil ,
  kind      = "",
  name      = "",
  type      = "",
  x         = nil,
  y         = nil,
  alpha     = 1,
  --
  align       = "",
  randXStart  = nil,
  randXEnd    = nil,
  randYStart  = nil,
  randYEnd    = nil,
  --,
  xScale     = nil,
  yScale     = nil,
  rotation   = nil,
  --,
  layerAsBg     = false,
  isSharedAsset = false,
  ---
  ---
  infinity = nil,
  infinitySpeed = nil,
  infinityDistance = nil,
---
}
--
function M:init(UI)
--local sceneGroup = UI.sceneGroup
end
--
function M:create(UI)
end
--
function M:didShow(UI)
end
--
function M:didHide(UI)
end
--
function  M:destroy(UI)
end
--
function M:new(props)
  return self:newInstance(props, _layerProps)
end
--
return M
