local M = require("Test.base_suite").new({
  book = "renameCopyPaste",
  page = "page1",
  component =  "iconOnly" -- "nil" for page
})

local helper = require("Test.helper")

local muiName = "editor.action.commandView-"
--
-- rename
--

function M.test_rename_group()
  --
  -- pre:create a group
  --

  M.selectors.componentSelector:onClick(true,  "groupTable")
  --
  -- click the icon for creatign a new group
  --
  -- M.UI.scene.app:dispatchEvent {
  --   name = "editor.selector.selectGroup",
  --   UI = M.UI,
  --   isNew = true, --(name ~= "Trash-icon"),
  --   isDelete =false -- (name == "Trash-icon")
  -- }

end

function M.xtest_rename_joints()
  -- try copy & paste from physics book
  --   copy layer image and class together
  --   copy the joint
  -- rename
end

function M.xtest_rename_layer()
end

function M.xtest_rename_layer_with_class()
end

function M.xtest_rename_timer()
  -- create a script copy timer action
  -- or coping a page of a timer/action, and then rename
end

function M.xtest_rename_var()
  -- create a var and then try renaming
end

function M.xtest_rename_audio()
  -- copy an audio from another and raname it
end
--

return M
