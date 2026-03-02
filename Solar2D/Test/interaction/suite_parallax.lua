local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.test_emulator()
  local mod = require("components.kwik.layer_parallax")

  local names = {
    -- "background2",
    -- "background1",
    "cat",
    "water",
    "fish",
  }
  timer.performWithDelay(1000, function()
    local objs = {}
    for i, v in next, names do
      objs[i] = M.UI.sceneGroup[v] or {}
    end
    mod.dummyDispatcher(objs, 400)
  end)

end

return M
