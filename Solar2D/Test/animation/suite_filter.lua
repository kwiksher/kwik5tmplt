local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.test_select_filter()
  local name = "rect_0"
  M.layerTable.altDown = true
  local obj = helper.selectLayer(name, "filter")
  M.layerTable.altDown = false

  assert_not_nil(obj)
  assert_equal(obj.class, "filter")
end

return M