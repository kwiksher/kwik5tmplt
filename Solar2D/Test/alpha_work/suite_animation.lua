local M = require("Test.base_suite").new()
local helper = require("Test.helper")

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

