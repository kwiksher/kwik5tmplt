local M = require("Test.base_suite").new({
  book = "book",
  page = "canvas",
  component = "iconOnly"
})

local helper = require("Test.helper")

function M.xtest_new_canvas()
  M.UI.testCallback = function()
    M.selectors.componentSelector:onClick(true,  "layerTable")
    local name = "Candice"
    helper.selectLayer(name)
    helper.selectTool{class="canvas", isNew=true}

    M.selectors.componentSelector:onClick(true,  "actionTable")
    helper.selectAction("blueBTN")
    -- actionTable.editButton:tap()
    -- actionTable.newButton:tap()

   -- --
    -- local button = "save"
    -- local obj = require("editor.parts.buttons").objs[button]
    -- obj:tap()
    --
    -- Cancel
    -- local button = "cancel"
    -- local obj = require("editor.parts.buttons").objs[button]
    -- obj:tap()
  end
end

function M.test_blueBTN_brushColor()
  M.UI.testCallback = function()
    M.selectors.componentSelector:onClick(true,  "actionTable")
    helper.selectAction("blueBTN")
    M.actionTable.editButton:tap()
    -- actionTable.newButton:tap()

    local obj = M.actionCommandTable.objs[2]
    M.actionCommandTable.singleClickEvent(obj)

    local objColorEntry = M.actionCommandPropsTable.objs[2]
    objColorEntry:dispatchEvent{name="tap", target=objColorEntry}

    timer.performWithDelay( 2000, function()
      --
      local colorBox = M.colorPicker.colorBox
      colorBox:dispatchEvent{name="touch", phase="began", target=colorBox,
      x = display.contentWidth*0.5, y = display.contentHeight*0.5}
      colorBox:dispatchEvent{name="touch", phase="ended", target=colorBox}
      -- close
      timer.performWithDelay( 2000, function()
        M.colorPicker.background:dispatchEvent{name="tap"}
      end)
    end)
    -- --
    -- local button = "save"
    -- local obj = require("editor.parts.buttons").objs[button]
    -- obj:tap()
    --
    -- Cancel
    -- local button = "cancel"
    -- local obj = require("editor.parts.buttons").objs[button]
    -- obj:tap()
  end
end

function M.xtest_colorPicker()
  -- https://github.com/andrewyavors/Lua-Color-Converter
  local converter = require("convertcolor")
  -- print(converter.tohex(10))
  print(converter.tohex(1.0, 0, 0))

  --
  ---[[
  -- https://www.jasonschroeder.com/2014/03/24/add-a-color-picker-to-your-corona-app-with-one-line-of-code/
  -- require the colorPicker module
  -- draw a rectangle on the screen
  local myRect = display.newRect(0, 0, display.contentWidth * .5, display.contentWidth * .5)
  myRect.x, myRect.y = display.contentCenterX, display.contentCenterY
  myRect.r, myRect.g, myRect.b, myRect.a = 1, 1, 1, 1

  -- here is our listener function to change the rectangle's color
  local function pickerListener(r, g, b, a)
    print(r, g, b, a)
    -- print("#"..converter.tohex(r)..converter.tohex(g)..converter.tohex(b))
    print(converter.tohex(r, g, b))
    myRect:setFillColor(r, g, b, a)
    myRect.r, myRect.g, myRect.b, myRect.a = r, g, b, a
  end

  M.colorPicker.show(pickerListener, myRect.r, myRect.g, myRect.b, myRect.a)
 --]]

end

function M.xtest_snapshot_paint()
  -- https://forums.solar2d.com/t/snapshot-as-paint-input/319084/29?page=2
  -- /Applications/Corona/SampleCode/Graphics/SnapshotEraser
  -- /Applications/Corona/SampleCode/Graphics/SnapshotPaint
  -- https://docs.coronalabs.com/guide/graphics/snapshot.html

  -- https://forums.solar2d.com/t/simple-trail-finally-a-corona-plugin-to-render-trails/150187/12

    -- https://github.com/H0neyP0ney/SimpleTrail

    -- https://github.com/ponywolf/ponyblitz/tree/master

end

return M
