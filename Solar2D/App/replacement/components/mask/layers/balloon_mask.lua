local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
local M = {
  name = "balloon",
  properties = {
    target = "balloon",
    mask = "circlemask"
  },
  layerProps = layerProps
}

function M:didShow(UI)
  -- local obj = UI.sceneGroup[self.properties.target]

  -- local function animateMask()
  --   local centerX, centerY = display.contentCenterX, display.contentCenterY
  --   local radiusMax = math.sqrt( centerX*centerX + centerY*centerY )

  --   -- Generate random mask position
  --   local maskX = centerX + (math.random() * 2 - 1) * centerX * 0.5
  --   local maskY = centerY + (math.random() * 2 - 1) * centerY * 0.5

  --   -- Calculate scale delta
  --   local radius = math.sqrt( maskX*maskX + maskY*maskY )
  --   local scaleDelta = radius/radiusMax
  --   local maskScaleX = 1 + scaleDelta
  --   local maskScaleY = 1 + 0.2 * scaleDelta

  --   -- Calculate rotation
  --   local rotation = math.deg( math.atan2( maskY - centerY, maskX - centerX ) )

  --   transition.to(obj.group, {
  --     time = 1000,
  --     maskX = maskX,
  --     maskY = maskY,
  --     maskScaleX = maskScaleX,
  --     maskScaleY = maskScaleY,
  --     maskRotation = rotation,
  --     onComplete = function()
  --       timer.performWithDelay(2000, animateMask)
  --     end
  --   })
  -- end
  -- timer.performWithDelay(1000, animateMask)
end
--
return require("components.kwik.layer_mask").set(M)
