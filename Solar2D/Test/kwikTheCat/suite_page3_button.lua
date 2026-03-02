local M = require("Test.base_suite").new({
  book = "book",
  page = "page3",
  component = "iconOnly"
})

local helper = require("Test.helper")

function M.test_select_button()
  helper.selectLayer("ball")
  helper.selectIcon("Interactions", "Button")

  local actionbox = require("editor.parts.actionbox")
  helper.actionTable = require("editor.action.actionTable")

  local classProps = require("editor.parts.classProps")
  helper.setProp(classProps.objs, "btaps", "2")

  -- helper.clickProp(classProps.objs, "mask")
  -- helper.selectLayer("baloon")

  helper.clickProp(classProps.objs, "over")
  helper.selectLayer("ball_over")

  -- select an action
  helper.clickProp(actionbox.objs, "onTap")
  helper.clickAction("eventOne")

  --
end

return M
