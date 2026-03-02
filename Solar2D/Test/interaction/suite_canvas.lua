local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.xtest_select()
  local name = "canvas"
  helper.selectLayer(name)
end

function M.test_select_for_editing()
  local name = "canvas"
  M.layerTable.altDown = true
  helper.selectLayer(name)
  M.layerTable.altDown = false
end

return M
