local M = require("Test.base_suite").new({
  book = "book",
  page = "page3",
  component = "iconOnly"
})

local helper = require("Test.helper")

function M.xtest_rectTool()
  local rectTool = require("editor.shape.rectTool")

  helper.selectLayer("ball")
  helper.selectLayer("fish")
  helper.selectIcon("Interactions", "Drag")

  local classProps = require("editor.parts.classProps")
  local obj = classProps.objs[2] -- boundaries
  -- rectTool:setActiveEntry(obj)
  rectTool:setActiveEntry({text="0,1920,0,1080"})
  rectTool:drawRect()

end

function M.xtest_new_drag()
  helper.selectLayer("ball")
  helper.selectLayer("fish")
  helper.selectIcon("Interactions", "Drag")

  local classProps = require("editor.parts.classProps")

  helper.clickProp(classProps.objs, "dropArea")
  helper.selectLayer("baloon")

  local actionbox = require("editor.parts.actionbox")
  helper.actionTable = require("editor.action.actionTable")

  -- select an action
  helper.clickProp(actionbox.objs, "onMoved")
  helper.clickAction("eventOne")

  helper.clickProp(actionbox.objs, "onDropped")
  helper.clickAction("eventTwo")

  helper.clickProp(actionbox.objs, "onReleased")
  helper.clickAction("eventThree")

  helper.setProp(classProps.objs, "constrainAngle", "90")

-- selectors.componentSelector:onClick(true,  "actionTable")
-- selectAction("eventOne")

  -- --
  -- local button = "save"
  -- local obj = require("editor.parts.buttons").objs[button]
  -- obj:tap()
end

return M
