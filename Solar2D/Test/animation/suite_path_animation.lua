local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.xtest_select()
  local name = "star"
  helper.selectLayer(name)
  -- selectTool{class="linear", isNew=true}
  --selectComponent("Action")
end

function M.xtest_select_for_editing()
  local name = "star"
  M.layerTable.altDown = true
  print("------------------")
  helper.selectLayer(name)
  M.layerTable.altDown = false

  -- selectTool{class="linear", isNew=true}
  --selectComponent("Action")
end

function M.test_new_path_animation()
  local name = "star"
  helper.selectLayer(name)
  helper.selectIcon("Animations", "Path"):done(
    function()
      local pathProps = require("editor.animation.pathProps")
      printKeys(pathProps)
      print(pathProps.name, #pathProps.objs)
      helper.setProp(pathProps.objs, "_filename", "PathStar_open.json")
    end
  )

  -- local classProps = require("editor.parts.classProps")
  -- helper.setProp(classProps.objs, "_filename", "PathStar_open.json")
  -- timer.performWithDelay(1000, function()

end

function M.xtest_new_animation()
  local name = "cat"
  helper.selectLayer(name)
  helper.clickIcon("Animations", "Linear")

  local obj = M.buttons.objs["save"]
  -- obj.rect:tap()

end

function M.xtest_new_group_animation()
  local name = "groupCat"
  M.selectors.componentSelector:onClick(true,  "groupTable")

  helper.selectGroup(name)
  helper.clickIcon("Animations", "Linear")

  -- local obj = buttons.objs["save"]
  -- obj.rect:tap()

end

function M.xtest_new_animation_template()
  local name = "cat"
  helper.selectLayer(name)
  helper.clickIcon("Animations", "Linear")

  local obj = M.buttons.objs["save"]
  -- obj.rect:tap()

  local props = M.buttons:useClassEditorProps()
  -- for k, v in pairs(props) do print(k, v) end
  print(M.json.encode(props))

  local _model = [[{"xSwipe":"nil","ySwipe":"nil","to":{"y":400,"xScale":1.5,"rotation":90,"yScale":1.5,"alpha":1,"x":100},"resetAtEnd":"nil","properties":{"type":"","autoPlay":"true","resetAtEnd":"false","reverse":"false","duration":1000,"delay":0,"loop":1},"easing":"Linear","from":{"y":0,"xScale":1,"rotation":0,"yScale":1,"alpha":0,"x":0},"reverse":"nil","layerOptions":{"isSceneGroup":"false","referencePoint":"Center","deltaX":0,"deltaY":0}}]]

  local util = require("editor.util")

  local tmplt='editor/template/components/pageX/animation/layer_animation.lua'
  local dst ='tmp.lua'
  local model = M.json.decode(_model)
  util.saveLua(tmplt, dst, model)

end

function M.xtest_new_multi_animation()
  local name = "cat"
  --
  M.layerTable.controlDown = true
  --
  local names = {"name", "cat", "fish"}
  local class = nil
  for i, name in next, names do
    helper.selectLayer(name, class)
    --helper.selectLayer(name, nil, true) -- isRightClick true
  end
  M.layerTable.controlDown = false
  helper.clickIcon("Animations", "Linear")

  local button = "save"
  local obj = require("editor.parts.buttons").objs[button]
  obj.rect:tap()

end

function M.xtest_action()
  M.UI.scene.app:dispatchEvent {
    name = "editor.action.selectLayer",
    action = "eventOne",
    UI = M.UI
  }
end

return M
