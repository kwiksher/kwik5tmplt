local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.xtest_select()
  local name = "rect_0"
  helper.selectLayer(name)
end

function M.xtest_new_animation()
  local name = "rect_0"
  helper.selectLayer(name)
  helper.selectIcon("Animations", "Linear"):done(
    function()
    end
  )

  -- local buttons = require("editor.parts.buttons")
  -- local obj = buttons.objs["save"]
  -- obj.rect:tap()
end

function M.test_select_linear()
  local name = "rect_0"
  M.layerTable.altDown = true
  helper.selectLayer(name, "linear")
  M.layerTable.altDown = false
end

function M.xtest_select_for_editing()
  local name = "rect_0"
  M.layerTable.altDown = true
  print("------------------")
  helper.selectLayer(name)
  M.layerTable.altDown = false

  -- selectTool{class="linear", isNew=true}
  --selectComponent("Action")
end

function M.xtest_select_animation()
    local name = "rect_0"
    local toolbar = require("editor.parts.toolbar")
    local obj = toolbar.layerToolMap["Animations"]
    obj.callBack{target=obj}
    for k, v in pairs(toolbar.toolMap) do print(k, v) end
    local tool = toolbar.toolMap[obj.id.."-Linear"]
    tool.callBack{target=tool}
    --
    -- local button = "save"
    -- local obj = require("editor.parts.buttons").objs[button]
    -- obj.rect:tap()
    --
    -- selectors.componentSelector.iconHander()
    -- selectors.componentSelector:onClick(true,  "layerTable")

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

function M.xtest_new_action()
  M.UI.editor.actionEditor.iconHander()
  M.actionTable.newButton:tap{target=M.UI.editor.newButton}
end

function M.xtest_select_action()
  local actionName = "eventPlay"
  --
  local editor = require("editor.action.index")
  M.selectors.componentSelector:onClick(true,  "actionTable")
  helper.actionTable = M.actionTable
  M.actionTable.altDown = true
  helper.clickAction(actionName)
  M.actionTable.altDown = false

  local muiName = "action.commandView-"
-- local actionTable = require("editor.action.actionTable")
  local controller = require("editor.action.controller.index")

  -- Animation is muiIcon
  controller.commandGroupHandler{target={muiOptions={name=muiName.."Animation"}}}
  -- selectors.componentSelector:onClick(true,  "layerTable")

  --select play
  -- local commandEntry = commandbox.objs[2] -- should we change 'objs' to 'objs'?
  -- commandEntry:dispatchEvent{name="tap", target=commandEntry}

  -- -- select _target
  -- local objEntry = actionCommandPropsTable.objs[1]
  -- objEntry:dispatchEvent{name="tap", target=objEntry}

  -- helper.selectLayer("cat", "linear")

  -- select a layer's animation (one of animation class)

  -- button is newText, please see model.lua for commandClass
  --controller.commandHandler{model={commandClass = "button"}}

  -- action name
    -- local editor = require("editor.action.index")
    -- editor.selectbox.selectedObj = editor.selectbox.objs[1]
    -- editor.selectbox.selectedObj.field.text = "act01"
    -- editor.selectbox:textListener(nil, {phase = "ended"})

  --- select button command
    -- UI.scene.app:dispatchEvent {
    --   name = "editor.action.selectActionCommand",
    --   UI = UI,
    --   value = "button", -- obj.model.commandClass
    --   isNew = true
    -- }
    --

  --- select a layer
    -- local propsTable = require("editor.action.actionCommandPropsTable")
    -- local linkbox = propsTable.linkbox
    -- local obj = linkbox.objs[2]
    --   obj:tap({numTaps = 1})
  --

  --- save command props
      -- UI.scene.app:dispatchEvent {
      --   name = "editor.actionCommand.save",
      --   UI = UI,
      -- }
    --
end

function M.xtest_action()
  M.UI.scene.app:dispatchEvent {
    name = "editor.action.selectLayer",
    action = "eventOne",
    UI = M.UI
  }
end

return M
