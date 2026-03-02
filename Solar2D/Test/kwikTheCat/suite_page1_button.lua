local M = require("Test.base_suite").new()

local helper = require("Test.helper")

--local toolbar  = require("editor.parts.toolbar")

function xM.test_onTap()

  helper.selectLayer("star", "button", false) -- isRightClick
  helper.selectIcon("Interactions", "Button")
  helper.clickProp(M.actionbox.objs, "onTap")
  helper.clickButton("New", M.actionButtonContext)
  M.picker.obj.field.text = "testAction"
  helper.clickObj(M.picker.buttonObjs, "Continue")

  helper.selectActionGroup("Animation")
  helper.selectActionCommand("animation", "play")

  --helper.selectLayer("GroupA/SubA/Triangle", "linear", false) -- isRightClick

  -- helper.selectLayer("star", "button", true) -- isRightClick
  -- helper.clickProp(actionbox.objs, "onTap")

end

--[[
function M.test_select_layer()
  local name = "gotoBtn"
  for i, entry in next,M.layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry:touch({phase="ended"}) -- layer props
      break
    end
  end
end
--]]
--[[
  function M.test_select_button()
    local name = "gotoBtn"
    for i, entry in next,M.layerTable.objs do
      print("", i, entry.text)
      if entry.text == name then
        entry.classEntries[1]:touch({phase="ended"}) -- animation
        break
      end
    end
    --
    local button = "save"
    local obj = require("editor.parts.buttons").objs[button]
    obj:tap()
    --
  end
--]]

local function selectCancel()
  local button = "cancel"
  local obj = require("editor.parts.buttons").objs[button]
  obj.rect:tap()
end

function M.xtest_new_group_button()

  M.selectors.componentSelector:onClick(true,  "groupTable")
  local name = "groupCat"
  helper.selectGroup(name)
  helper.clickIcon("Interactions", "Button")
end

---[[
function M.xtest_new_button()
  M.selectors.componentSelector:onClick(true,  "layerTable")

  local name = "cat"
  for i, entry in next,M.layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry:touch({phase="ended"}) -- gotoBtn
      break
    end
  end
    --print("-----------------")
    -- for k, v in pairs(toolbar.layerToolMap.Interactions) do print(k, v) end
    -- for k, v in pairs(toolbar.toolMap) do print(k, v) end
    -- selectTool{class="button", isNew=true}

    helper.selectIcon("Interactions", "Button")

    local obj = M.actionbox.objs[1]
    obj:dispatchEvent({name="tap", target=obj})

    M.actionTable.altDown = true
    helper.selectAction("eventOne")
    M.actionTable.altDown = false

    -- selectCancel()
    --selectIcon("Interactions", "Button")

    -- local button = "save"
    -- local obj = require("editor.parts.buttons").objs[button]
    -- obj.rect:tap()

  -- selectors.componentSelector:onClick(true,  "actionTable")
  -- selectAction("eventOne")

  --  select an over-layer
    -- click "over" of the prop's name to make it active
    --   layerTable is displayed
    --   select a layer

  -- select a mask
    -- click "mask" of the prop's name to make it active
    --   layerTable is displayed
    --   select a layer

  -- selet an action
    -- click "over" of the prop's name to make it active
    --   layerTable is displayed
    --   select a layer

    -- --
  end
--]]

--[[
function M.test_new_button_cancel()
  local name = "gotoBtn"
  for i, entry in next,M.layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry:touch({phase="ended"}) -- gotoBtn
      break
    end
  end

  M.UI.scene.app:dispatchEvent(
    {
      name = "editor.selector.selectTool",
      UI = M.UI,
      class = "button", -- obj.class,
      -- toolbar = self,
      isNew = true
    }
  )

  -- Canel
  local button = "cancel"
  local obj = require("editor.parts.buttons").objs[button]
  obj:tap()
end
--]]

--[[
  function M.test_add_second_button()
    local name = "gotoBtn"
    for i, entry in next,M.layerTable.objs do
      print("", i, entry.text)
      if entry.text == name then
        entry.classEntries[1]:touch({phase="ended"}) -- animation
        break
      end
    end

    M.UI.scene.app:dispatchEvent(
      {
        name = "editor.selector.selectTool",
        UI = M.UI,
        class = "button", -- obj.class,
        -- toolbar = self,
        isNew = true
      }
    )

    local button = "save"
    local obj = require("editor.parts.buttons").objs[button]
    obj:tap()

  end
--]]

return M
