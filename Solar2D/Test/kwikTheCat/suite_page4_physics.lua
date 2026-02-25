local M = require("Test.base_suite").new({
  book = "book",
  page = "page4",
  component = "iconOnly"
})

local helper = require("Test.helper")

local function selectIcon(toolGroup, tool)
  local toolbar = M.UI.editor.toolbar
  local obj = toolbar.layerToolMap[toolGroup]
  obj.callBack{target=obj}
  if tool then
    local obj = toolbar.toolMap[obj.id.."-"..tool]
    obj.callBack{target=obj}
  end
end

function M.xtest_select()
  -- selectIcon("Physics", "Physics")
  -- selectIcon("Physics", "Body")
  -- selectIcon("Physics", "Collision")
  --selectIcon("Physics", "Force")
  selectIcon("Physics", "Joint")
end

function M.xtest_new_body()

  -- local classProps    = require("editor.physics.classProps")
  -- local bodyA = classProps.objs[1]
  -- local bodyB = classProps.objs[2]
  -- -- bodyA.field.text = "test"
  -- bodyA:dispatchEvent{name="tap", target=bodyA}

  M.layerTable.controlDown = true

  local obj = M.layerTable.objs[8] -- car
  obj:dispatchEvent{name="touch", target=obj, phase="ended"}

  obj = M.layerTable.objs[9] -- wheel2
  obj:dispatchEvent{name="touch", target=obj, phase="ended"}

  obj = M.layerTable.objs[10] -- wheel1
  obj:dispatchEvent{name="touch", target=obj, phase="ended"}

  M.layerTable.controlDown = false

  selectIcon("Physics", "Body")

  -- local buttons = require("editor.physics.buttons")
  --local obj = buttons.objs["save"]
  -- obj.rect:tap()

end

function M.xtest_select_joints()
  M.selectors.componentSelector:onClick(true,  "layerTable")
  M.selectors.componentSelector:onClick(true,  "jointTable")
  local jointTable = require("editor.physics.jointTable")
  local obj = jointTable.objs[1]

  jointTable.altDown = true
  obj:touch{phase="ended"}
  jointTable.altDown = false

end

function M.xtest_new_joint()
  selectIcon("Physics", "Joint")

  local selectbox = require("editor.physics.selectbox")
  local obj = selectbox.objs[10] -- wheel
  obj:dispatchEvent{name="tap", target=obj}

  local classProps    = require("editor.physics.classProps")
  local bodyA = classProps.objs[1]
  local bodyB = classProps.objs[2]
  -- bodyA.field.text = "test"
  bodyA:dispatchEvent{name="tap", target=bodyA}

  obj = M.layerTable.objs[8] -- car
  obj:dispatchEvent{name="touch", target=obj, phase="ended"}

  bodyB:dispatchEvent{name="tap", target=bodyB}
  obj = M.layerTable.objs[10] -- wheel1
  obj:dispatchEvent{name="touch", target=obj, phase="ended"}

  local buttons = require("editor.physics.buttons")
  --local obj = buttons.objs["save"]
  -- obj.rect:tap()

end

function M.xtest_phsyics_settings()
  selectIcon("Physics", "Physics")
end

function M.xtest_phsyics_force()
  obj = M.layerTable.objs[8] -- car
  obj:dispatchEvent{name="touch", target=obj, phase="ended"}
  selectIcon("Physics", "Force")

end

function M.test_phsyics_collision()
  obj = M.layerTable.objs[8] -- car
  obj:dispatchEvent{name="touch", target=obj, phase="ended"}
  selectIcon("Physics", "Collision")
end

return M
