local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.xtest_select()
  local name = "rect_0"
  helper.selectLayer(name)
end

function M.xtest_select_for_editing()
  local name = "rect_0"
  M.layerTable.altDown = true
  helper.selectLayer(name)
  M.layerTable.altDown = false
end

function M.test_new_button()
  local name = "star"
  helper.selectLayer(name)
  helper.selectIcon("Interactions", "Button"):done(
    function()
    end
  )
end

function M.test_new_button_new_action()
  local name = "star"
  helper.selectLayer(name)
  helper.selectIcon("Interactions", "Button"):done(
    function()
    end
  )
end

function M.test_new_button_over()
  local name = "star"
  helper.selectLayer(name)
  helper.selectIcon("Interactions", "Button"):done(
    function()
    end
  )
end

function M.test_new_button_mask()
  local name = "star"
  helper.selectLayer(name)
  helper.selectIcon("Interactions", "Button"):done(
    function()
    end
  )
end

function M.xtest_action()
  M.UI.scene.app:dispatchEvent {
    name = "editor.action.selectLayer",
    action = "eventOne",
    UI = M.UI
  }
end

return M
