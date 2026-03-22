local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.xtest_new()
  local name = "rect_0"
  helper.selectLayer(name)
  helper.selectIcon("Replacements", "Sprite"):done(function() end)
end

function M.xtest_select_sprite()
  local name = "rect_0"
  M.layerTable.altDown = true
  local obj = helper.selectLayer(name, "sprite")
  M.layerTable.altDown = false
end

return M