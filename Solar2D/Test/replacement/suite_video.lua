local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.xtest_new()
  local name = "rect_0"
  helper.selectLayer(name)
  helper.selectIcon("Replacements", "Video"):done(function() end)
end

function M.test_select()
  local name = "rect_0"
  M.layerTable.altDown = true
  helper.selectLayer(name, "video")
  M.layerTable.altDown = false
end

return M