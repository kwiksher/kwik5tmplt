local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.test_new()
  local name = "rect_0"
  helper.selectLayer(name)
  helper.selectIcon("Replacements", "Map"):done(function() end)
end

return M