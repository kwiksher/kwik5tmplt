local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.test_new()
  local name = "balloon"
  helper.selectLayer(name)
  helper.selectIcon("Replacements", "Mask"):done(function() end)
end

return M