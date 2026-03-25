local M = require("Test.base_suite").new({
  book = "renameCopyPaste",
  page = "page1",
  component = "iconOnly"
})

local helper = require("Test.helper")

local muiName = "editor.action.commandView-"
--
-- rename
--
function M.test_rename_page()
  local book = helper.selectBook("mybook")
  book:touch()
  if M.UI.book ~="mybook" then return end
  helper.selectPage("page3", false)
  helper.selectPage("page3", true)
  helper.clickButton("rename")
end
--
-- rename layer.lua and layer_class.lua and generate(update) index.lua
--
function M.xtest_rename_book()
end

function M.xtest_rename_group()
end

function M.xtest_rename_timer()
end

function M.xtest_rename_joints()
end

function M.xtest_rename_var()
end

function M.xtest_rename_audio()
end
--
-- low level commands
--
function M.xtest_4_renamePage()
  local commands = require("editor.scripts.commands")
  commands.renamePage("renameCopyPaste", "page1", "page01")
  native.requestExit() -- this prevents from infinitly looping of simulator reloading
end

function M.xtest_4_copyPage()
  local commands = require("editor.scripts.commands")
  commands.copyPage("renameCopyPaste", "page1", "page01")
  native.requestExit() -- this prevents from infinitly looping of simulator reloading
end

return M
