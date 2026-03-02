local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.xtest_new()
  local name = "rect_0"
  helper.selectLayer(name)
  helper.selectIcon("Interactions", "Swipe"):done(
    function()
    end
  )
end

return M
