local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.test_emulator()
  local mod = require("components.kwik.layer_pinch")

  local obj = M.UI.sceneGroup["ellipse_0"]
  -- transition.to(obj, {time=3000, xScale = 0.1, yScale = 0.1})
  if obj then
    mod.createPinchEmulator(obj, function(scale)
      if scale == nil then return end
      if  scale < obj.pinch.properties.scaleMax then
        transition.to(obj, {time=1000, xScale = scale, yScale = scale})
      else
        transition.to(obj, {time=1000, xScale = obj.pinch.properties.scaleMax, yScale = obj.pinch.properties.scaleMax})
      end
    end)
  else
    print("### Error")
  end

end

return M
