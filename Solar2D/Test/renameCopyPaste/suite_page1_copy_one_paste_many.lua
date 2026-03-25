local M = require("Test.base_suite").new({
  book = "book",
  page = "page1",
  component = "iconOnly"
})

local helper = require("Test.helper")

local muiName = "editor.action.commandView-"
--
-- get_started/copy_paste_component/
-- copied in page1 layerTable, then pasted in page2 pageTable or layerTable
--
--
-- one layer or class is copied in page1, and pasted in page1 layerTable
--
function M.xtest_copy_layer()
  local name = "cat"
  -- layerTable.altDown = true
  helper.selectLayer(name)
  helper.selectLayer(name, nil, true) -- isRightClick true
  helper.clickButton("copy")

  -- layerTable.altDown = false

  -- selectors.componentSelector:onClick(true,  "actionTable")
  -- helper.selectAction("eventOne")
end

function M.xtest_copy_paste_button()
  helper.selectLayer("color8", "button", false) -- isRightClick
  helper.selectLayer("color8", "button", true) -- isRightClick
  --
  -- local M.actionButtonContext = require("editor.parts.actionButtonContext")
  -- helper.clickButton("Copy", M.actionButtonContext)
  --
  -- helper.selectLayer("color7", "button", false) -- isRightClick
  -- helper.selectLayer("color6", "button", false) -- isRightClick
  -- helper.selectLayer("color5", "button", false) -- isRightClick
  -- helper.selectLayer("color4", "button", false) -- isRightClick
  -- helper.selectLayer("color3", "button", false) -- isRightClick
  -- helper.selectLayer("color2", "button", false) -- isRightClick
  -- helper.selectLayer("color1", "button", false) -- isRightClick
  --
  -- then paste it manually
end
--
-- one layer or class copied in page1, and pasted to multiple layers in page1 layerTable
--
function M.xtest_copy_layers()
end

function M.xtest_copy_paste_buttons()
end

function M.xtest_copy_paste_bodies() -- physics
end

return M
