local M = require("Test.base_suite").new({
  book = "renameCopyPaste",
  page = "page1",
  component = "iconOnly"
})

local helper = require("Test.helper")

local muiName = "editor.action.commandView-"
--
-- get_started/copy_paste_component/
-- copied in page1 layerTable, then pasted in page2 pageTable or layerTable
--


function M.xtest_new_animation()
  local name = "title2"
  helper.selectLayer(name)
  helper.selectIcon("Animations", "Linear"):done(
    function()
    end
  )

  -- local buttons = require("editor.parts.buttons")
  -- local obj = buttons.objs["save"]
  -- obj.rect:tap()
end


--
-- one layer or class is copied in page1, and pasted in page1 layerTable
--
function M.xtest_copy_layer()
  local name = "title1"
  -- layerTable.altDown = true
  helper.selectLayer(name)
  helper.selectLayer(name, nil, true) -- isRightClick true
  helper.clickButton("copy")

  -- layerTable.altDown = false

  -- selectors.componentSelector:onClick(true,  "actionTable")
  -- helper.selectAction("eventOne")
end

function M.xtest_copy_layer_class()
  local name = "title1"
  -- layerTable.altDown = true
  helper.selectLayer(name, "pulse")
  helper.selectLayer(name, nil, true) -- isRightClick true
  helper.clickButton("copy")

  -- layerTable.altDown = false

  -- selectors.componentSelector:onClick(true,  "actionTable")
  -- helper.selectAction("eventOne")
end


function M.xtest_copy_paste_button()
  helper.selectLayer("color8", "button", false) -- isRightClick
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
-- one action is copied in page1 actionTable, then pasted in page1 actionTable
--
function M.xtest_copy_paste_action()
  helper.selectIcon("action")
  helper.clickAction("brushBlack")
  -- helper.selectAction("brushBlack", true)
  --helper.clickButton("Copy", M.actionButtonContext)
  --helper.clickButton("Paste", M.actionButtonContext)
  -- helper.clickButton("Edit", M.actionButtonContext)
end

function M.xtest_copy_paste_actionCommand()
end
--
-- copied in page1 actionTable, then pasted in page2 pageTable or actionTable
--

function M.xtest_copy_paste_group()
end

function M.xtest_copy_paste_timer()
end

function M.xtest_copy_paste_joints()
end

function M.xtest_copy_paste_var()
end

function M.xtest_copy_paste_audio()
end

function M.xtest_copy_paste_page()
end

function M.xtest_copy_paste_book()
end

return M
