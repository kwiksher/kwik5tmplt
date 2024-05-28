local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable
local actionTable = require("editor.action.actionTable")
local commandbox = require("editor.action.commandbox")
local actionCommandPropsTable = require("editor.action.actionCommandPropsTable")
local helper = require("editor.tests.helper")

local muiName = "editor.action.commandView-"
local actionTable = require("editor.action.actionTable")
local controller = require("editor.action.controller.index")
local buttons = require("editor.parts.buttons")
--

function M.init(props)
  selectors = props.selectors
  UI        = props.UI
  bookTable = props.bookTable
  pageTable = props.pageTable
  layerTable = props.layerTable
  --
  props.buttons = buttons
  helper.init(props)

end

function M.suite_setup()
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  --
  -- UI.scene.app:dispatchEvent {
  --   name = "editor.selector.selectApp",
  --   UI = UI
  -- }
  -- appFolder = system.pathForFile("App", system.ResourceDirectory) -- default
  -- useTinyfiledialogs = false -- default
  ---
  bookTable.commandHandler({book="book"}, nil,  true)
  pageTable.commandHandler({page="page1"},nil,  true)
  -- timer.performWithDelay( 1000, function()
  selectors.componentSelector.iconHander()
  -- end)

end

function M.setup()
end

function M.teardown()
end

function M.test_multi_edit_props()
  --
  layerTable.controlDown = true
  --
  local names = {"name", "cat", "fish"}
  for i, name in next, names do
    helper.selectLayer(name)
    helper.selectLayer(name, nil, true) -- isRightClick true
  end
  layerTable.controlDown = false
  ---
  helper.clickButton("modify")

end

function M.xtest_multi_new_animation()
end

function M.xtest_multi_new_button()
end

function M.xtest_multi_set_physics()
end

function M.xtest_select_for_edit()
  local name = "cat"
  layerTable.altDown = true
  helper.selectLayer(name)
  layerTable.altDown = false

end

function M.xtest_select_for_edit_class()
  local name = "cat"
  local class = "linear"
  layerTable.altDown = true
  helper.selectLayer(name, class, true) -- isRightClick true
  layerTable.altDown = false
end

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

function M.xtest_save()
  --just save eventOne
end

function M.xtest_cancel()
  -- 1. cancel to close it
end

return M
