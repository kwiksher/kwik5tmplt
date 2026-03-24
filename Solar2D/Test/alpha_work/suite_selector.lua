local M = require("Test.base_suite").new()

local helper = require("Test.helper")

local scene

function M.test_1_project_page()
  M.selectors.projectPageSelector:onClick(true)
  M.selectors.projectPageSelector:show()
  -- --
  M.UI.scene.app:dispatchEvent {
    name = "editor.selector.selectApp",
    UI = M.UI
  }
  print(#M.bookTable.objs)

end

function M.test_2_book_page()
  -- bookTable.commandHandler({book = "book"}, nil, true)
  -- pageTable.commandHandler({page = "page01"}, nil, true)
  print(#M.bookTable.objs)
  M.bookTable.commandHandler(M.bookTable.objs[1], nil, true)
  M.pageTable.commandHandler(M.pageTable.objs[1], nil, true)
end

function M.test_3_layer()
  M.selectors.componentSelector.iconHander()
  M.selectors.componentSelector:onClick(true, "layerTable")
  M.UI.editor.layerStore:set(scene.components.layers)
  ret = M.nanostores.getValue(M.UI.editor.layerStore)
  print("ret", #ret) -- == 3
end

function M.xtest_action()
  -- timer.performWithDelay( 1000, function()
  --   selectors.componentSelector.iconHander()
  --   selectors.componentSelector:onClick(true,  "actionTable")
  -- end)

  M.UI.scene.app:dispatchEvent {
    name = "editor.action.selectAction",
    action = "eventOne",
    UI = M.UI
  }
end

function M.xtest_slider()
  local slider = require("slider")

  -- Example usage
  local obj = slider.createSlider({
    width = 300,
    height = 6,
    thumbRadius = 12,
    minValue = 0,
    maxValue = 100,
    startValue = 50,
    onChange = function(value)
        print("Slider value: " .. value)
    end
  })
  obj.x = display.contentCenterX
  obj.y = 50
end

return M
