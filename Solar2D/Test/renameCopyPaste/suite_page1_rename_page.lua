local M = require("Test.base_suite").new({
  book = "renameCopyPaste",
  page = "page1",
  component = nil -- "iconOnly" "nil" for page
})

local helper = require("Test.helper")

local muiName = "editor.action.commandView-"
--
-- rename
--
function M.xtest_rename_page()
  --local book = helper.selectBook("mybook")
  --book:touch()
  if M.UI.book ~="renameCopyPaste" then return end
  helper.selectPage("page1", false)
  helper.selectPage("page1", true)
  helper.clickButton("rename", M.partsButtons)
end
--
-- rename layer.lua and layer_class.lua and generate(update) index.lua
--
--
function M.xtest_rename_book()
  --
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
