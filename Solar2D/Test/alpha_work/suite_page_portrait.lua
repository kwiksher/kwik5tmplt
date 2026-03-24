local M = require("Test.base_suite").new({
  selectApp = true,
  book = "bookFree",
  page = "page1"
})

local helper = require("Test.helper")

function M.xtest_componentSelector()
  M.UI.testCallback = function()
    M.selectors.componentSelector:onClick(true,  "layerTable")
    M.selectors.componentSelector.iconHander()
    -- local name = "Candice"
    -- helper.selectLayer(name)

    --helper.selectTool{class="linear", isNew=true}
    --helper.selectTool{class="canvas", isNew=true}
   M.actionEditor.iconHander()

    -- selectors.componentSelector:onClick(true,  "actionTable")

    --[[

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
    --]]
  end
end

local muiName = "editor.action.commandView-"

function M.test_actionSelector()
  M.UI.testCallback = function()
    M.selectors.componentSelector.iconHander()
    -- actionIndex.iconHander()

    M.selectors.componentSelector:onClick(true,  "actionTable")

      -- this call selectHandler
      M.actionTable.objs[1]:tap() -- varaibleAction
      -- then edit
      M.actionTable.editButton:tap()

      -- now action editor is displayed
      -- let's chose Controls > Variables
      M.actionController.commandGroupHandler{target={muiOptions={name=muiName.."Controls"}}}

      -- -- each actionCommand in AC group is stored in commandMap
      local cmd = "Condition"
      M.actionEditor.commandMap[cmd]:tap{}
  end
end

function M.xtest_action_variable()
  M.UI.testCallback = function()
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
  end
end

return M
