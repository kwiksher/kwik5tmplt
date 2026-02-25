local M = require("Test.base_suite").new({
  selectApp = true
})

local helper = require("Test.helper")

local muiName = "editor.action.commandView-"

--

function M.setup()
  local obj = helper.selectBook("bookFree")
   M.bookTable.commandHandler(obj, {phase="ended"},  true)
end

-- new folder in context menu for layer' selection?
-- open vs code to make a group folder and put layers in it?

function M.xtest_new_rectangle()
  M.UI.testCallback = function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "layerTable")
    --

    -- new layer A
    -- new layer B
    -- select A and B
    -- new group in context menu with selecting layers
    --    mkdir folderName
    --    mv layer A & B .lua
    --    update App/bookX/components/pageX/index.lua

    -- shortcut t to select and group layers
    Runtime:dispatchEvent{name="key", keyName="", phase="down"}

   end
end

------
return M
