local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.xtest_new()
  local name = "rect_0"
  helper.selectLayer(name)
  helper.selectIcon("Interactions", "Shake"):done(
    function()
    end
  )
end

function M.test_emulator()
  local mod = require("components.kwik.layer_shake")
  local obj = M.UI.sceneGroup["ellipse_0"]
  if obj then
    mod.createShakeEmulator(obj, function(event)
      event.target = obj
      obj.shake.shakeHandler(event)
    end)
  else
    print("### Error")
  end

end

return M
