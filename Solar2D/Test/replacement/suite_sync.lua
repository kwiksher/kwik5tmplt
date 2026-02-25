local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.test_new()
  local name = "ABC"
  helper.selectLayer(name)
  helper.selectIcon("Replacements", "Sync"):done(function() end)
end

return M