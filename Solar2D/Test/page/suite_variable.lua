local M = require("Test.base_suite").new({
  book = "page",
  page = "variable"
})

local helper = require("Test.helper")

--[[
  function M.test_readAssets()
    local util = require("editor.util")
    util.readAssets("page", "variable")
  end
--]]

--[[
function M.test_completeBox()
  timer.performWithDelay( 1000, function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "variableTable")
    local view = require("editor.timer.variableTable")

    M.UI.scene.app:dispatchEvent {
      name = "editor.selector.selectTimer",
      UI = M.UI,
      class = "timer",
      isNew = true, --(name ~= "Trash-icon"),
      isDelete =false -- (name == "Trash-icon")
    }

    -- list actions in completeBox
    -- select one of them
    -- save

  end)
end
--]]

---[[
function M.xtest_new_component()
  timer.performWithDelay( 1000, function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "variableTable")
    local view = require("editor.variable.variableTable")

    M.UI.scene.app:dispatchEvent {
      name = "editor.selector.selectVariable",
      UI = M.UI,
      class = "variable",
      isNew = true, --(name ~= "Trash-icon"),
      isDelete =false -- (name == "Trash-icon")
    }

    -- list actions in completeBox
    -- select one of them
    -- save
    local buttons = require("editor.variable.buttons")
    buttons.objs["save"].tap{eventName="save"}
  end)
end
--]]

--[[
function M.test_component()
  timer.performWithDelay( 1000, function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "variableTable")
    local view = require("editor.timer.variableTable")
    local obj = view.objs[1]
    obj:touch{phase="ended"}
    ---
    local buttons = require("editor.timer.buttons")
    buttons.objs["save"].tap{eventName="save"}
  end)
end
--]]

local muiName = "editor.action.commandView-"

function M.xtest_action_variable()
  timer.performWithDelay( 1000, function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "actionTable")

    -- this call selectHandler
    M.actionTable.objs[2]:tap() -- varaibleAction
    -- then edit
    M.actionTable.editButton:tap()

    -- now action editor is displayed
    -- let's chose Controls > Variables
    M.actionController.commandGroupHandler{target={muiOptions={name=muiName.."Controls"}}}

    -- each actionCommand in AC group is stored in commandMap
    local cmd = "Variables" -- "Condition"
    -- for k, v in pairs(actionIndex.commandMap) do
    --   print(k, v)
    -- end

    M.actionEditor.commandMap[cmd]:tap{}
    -- }
  end)
end

function M.xtest_action_condition()
  timer.performWithDelay( 1000, function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "actionTable")

    -- this call selectHandler
    M.actionTable.objs[2]:tap() -- varaibleAction
    -- then edit
    M.actionTable.editButton:tap()

    -- For editor  an existing actionCommand
    --   for examle, select variable.editVars in variableAction
    --
    -- local obj = actionCommandTable.objs[2]
    -- actionCommandTable:listener(obj,{phase="ended"})

    -- now action editor is displayed
    -- let's chose Controls > Variables
    M.actionController.commandGroupHandler{target={muiOptions={name=muiName.."Controls"}}}

    -- each actionCommand in AC group is stored in commandMap
    local cmd =  "Condition"
    -- for k, v in pairs(actionIndex.commandMap) do
    --   print(k, v)
    -- end

    M.actionEditor.commandMap[cmd]:tap{}

    M.commandbox.objs[2]:tap{}

    M.actionCommandPropsTable.objs[1].field.text = "conditions.isFruit"

  end)
end

return M
