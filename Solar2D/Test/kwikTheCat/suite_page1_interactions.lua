local M = require("Test.base_suite").new({
  component = "iconOnly"
})

----
----
local helper = require("Test.helper")

function M.xtest_new_drag()
  local name = "groupCat"
  M.selectors.componentSelector:onClick(true,  "groupTable")
  helper.selectGroup(name)
  helper.clickIcon("Interactions", "Drag")
end

function M.xtest_new_parallax()
  local name = "groupCat"
  M.selectors.componentSelector:onClick(true,  "groupTable")
  helper.selectGroup(name)
  helper.clickIcon("Interactions", "Parallax")
end

function M.xtest_new_scroll()
  local name = "groupCat"
  M.selectors.componentSelector:onClick(true,  "groupTable")
  helper.selectGroup(name)
  helper.clickIcon("Interactions", "Scroll")
end

function M.xtest_new_shake()
  local name = "groupCat"
  M.selectors.componentSelector:onClick(true,  "groupTable")
  helper.selectGroup(name)
  helper.clickIcon("Interactions", "Shake")
end

function M.xtest_new_spin()
  local name = "groupCat"
  M.selectors.componentSelector:onClick(true,  "groupTable")
  helper.selectGroup(name)
  helper.clickIcon("Interactions", "Spin")
end

function M.test_new_swipe()
  local name = "groupCat"
  M.selectors.componentSelector:onClick(true,  "groupTable")
  helper.selectGroup(name)
  helper.clickIcon("Interactions", "Swipe")
end

return M
