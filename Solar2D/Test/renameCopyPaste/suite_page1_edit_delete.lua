local M = require("Test.base_suite").new({
  book = "book",
  page = "page1",
  component = "iconOnly"
})

local helper = require("Test.helper")

local muiName = "editor.action.commandView-"
--
--

function M.xtest_multi_edit_props()
  --
  M.layerTable.controlDown = true
  --
  local names = {"name", "cat", "fish"}
  for i, name in next, names do
    helper.selectLayer(name)
    --helper.selectLayer(name, nil, true) -- isRightClick true
  end
  M.layerTable.controlDown = false
  ---
  -- helper.clickButton("modify")

  local toolbar = require("editor.parts.toolbar")
  local obj = toolbar.layerToolMap["Layer"]
  obj.callBack{target=obj}
  for k, v in pairs(toolbar.toolMap) do print(k, v) end
  local tool = toolbar.toolMap[obj.id.."-Properties"]
  tool.callBack{target=tool}

  for i, obj in next, M.classProps.objs do
  --  print(obj.text)
    if obj.text == "alpha" then
      obj.field.text = 1
    end
  end

  -- for k, obj in pairs(buttons.objs) do
  --   print(k)
  -- end
  -- buttons.objs["save"].rect:tap()
  -- buttons.objs["cancel"]:tap()

end

function M.xtest_multi_delete()
  --
  M.layerTable.controlDown = true
  --
    local names = {"name", "cat", "fish"}
    for i, name in next, names do
      helper.selectLayer(name)
      --helper.selectLayer(name, nil, true) -- isRightClick true
    end
    M.layerTable.controlDown = false
  ---
end

function M.xtest_multi_class_delete()
  --
  M.layerTable.controlDown = true
  --
    local names = {"name", "cat", "fish"}
    local class = "properties"
    for i, name in next, names do
      helper.selectLayer(name, class)
      --helper.selectLayer(name, nil, true) -- isRightClick true
    end
    M.layerTable.controlDown = false

      -- helper.clickButton("modify")

  -- local toolbar = require("editor.parts.toolbar")
  -- local obj = toolbar.layerToolMap["Layer"]
  -- obj.callBack{target=obj}

  -- local tool = toolbar.toolMap[obj.id.."-Properties"]
  -- tool.callBack{target=tool}

end

function M.xtest_saveLua()
  local util = require("editor.util")

  local tmplt='editor/template/components/pageX/layer/layer_properties.lua'
  local dst ='App/book/components/page1/layers/name_nil.lua'
  local model = json.decode('{"yScale":"nil","type":"nil","randYStart":"nil","height":"nil","xScale":"nil","randXStart":"nil","width":"nil","y":"nil","x":"nil","blendMode":"nil","name":"nil","randXEnd":"nil","kind":"nil","randYEnd":"nil","rotation":"nil"}')

  util.saveLua(tmplt, dst, model)
end

function M.xtest_multi_new_animation()
end

function M.xtest_multi_new_button()
end

function M.xtest_multi_set_physics()
end

function M.xtest_select_for_edit()
  local name = "cat"
  -- layerTable.altDown = true
  helper.selectLayer(name)
  -- layerTable.altDown = false

end

function M.xtest_select_for_edit_class()
  local name = "cat"
  local class = "properties"
  -- layerTable.altDown = true
  helper.selectLayer(name, class, false) -- isRightClick true
  -- layerTable.altDown = false
end

function M.xtest_save()
  --just save eventOne
end

function M.xtest_cancel()
  -- 1. cancel to close it
end

return M
