local M = require("Test.base_suite").new({
  book = "bookFree",
  page = "page4",
  component = "iconOnly"
})

local helper = require("Test.helper")

local book = "bookFree"
local page = "page4"

function M.xtest_new_group()
    M.UI.testCallback = function()
      M.UI.page = "page4"
      M.selectors.componentSelector:onClick(true,  "groupTable")
       -- click the icon for creatign a new group
      M.UI.scene.app:dispatchEvent {
        name = "editor.selector.selectGroup",
        UI = M.UI,
        isNew = true, --(name ~= "Trash-icon"),
        isDelete =false -- (name == "Trash-icon")
      }

    end
end

function M.test_cancel_group()
  M.UI.testCallback = function()
    M.UI.page = "page4"
    M.selectors.componentSelector:onClick(true,  "groupTable")
     -- click the icon for creatign a new group
    M.UI.scene.app:dispatchEvent {
      name = "editor.selector.selectGroup",
      UI = M.UI,
      isNew = true, --(name ~= "Trash-icon"),
      isDelete =false -- (name == "Trash-icon")
    }

    local objs = require("editor.group.buttons").objs
    for k, v in pairs(objs) do
      print(k, v.text)
    end
    local button = "cancel"
    local obj = require("editor.group.buttons").objs[button]
    obj:tap()

  end
end

function M.xtest_select_group()
  M.UI.testCallback = function()
    M.UI.page = "page4"
    M.selectors.componentSelector:onClick(true,  "groupTable")
    helper.selectGroup("myGroup")
     -- click the icon for creatign a new group
    M.UI.scene.app:dispatchEvent {
      name = "editor.selector.selectGroup",
      UI = M.UI,
      isNew = false, --(name ~= "Trash-icon"),
      isDelete =false -- (name == "Trash-icon")
    }

  end
end

function M.xtest_add()
  M.UI.testCallback = function()
      M.UI.page = "page4"
      local name = "myGroup"
      M.selectors.componentSelector:onClick(true,  "groupTable")
      helper.selectGroup(name)
       -- click the icon for creatign a new group
      M.UI.scene.app:dispatchEvent {
        name = "editor.selector.selectGroup",
        UI = M.UI,
        group = name,
        isNew = false, --(name ~= "Trash-icon"),
        isDelete =false -- (name == "Trash-icon")
      }

    -- layersbox -> layersTable
    local layersbox = require("editor.group.layersbox")
    local names = {"Ellipse", "Triangle"}
    -- layersbox.controlDown = true -- multi
    layersbox.controlDown = true
    helper.selectEntries(layersbox, names)

    -- click add button
    helper.clickButton("add")
    -- hello in layersbox should be grayed
  end
end

function M.xtest_remove()
  M.UI.testCallback = function()
      M.UI.page = "page4"
      local name = "myGroup"
      --selectors.componentSelector:onClick(true,  "layerTable") --isVisible = true
      M.selectors.componentSelector:onClick(true,  "groupTable")
      helper.selectGroup(name)
       -- click the icon for creatign a new group
      M.UI.scene.app:dispatchEvent {
        name = "editor.selector.selectGroup",
        UI = M.UI,
        group = name,
        isNew = false, --(name ~= "Trash-icon"),
        isDelete =false -- (name == "Trash-icon")
      }

    -- layersbox -> layersTable
    local layersbox = require("editor.group.layersbox")
    local names = {"hello"}
    -- layersbox.controlDown = true -- multi
    helper.selectEntries(layersbox, names)

    -- click add button
    helper.clickButton("add")

    -- hello in layersbox should be grayed

    -- layersbox <- layersTable
    local layersTable = require("editor.group.layersTable")
    -- layersTable.controlDown = true -- multi

    local objs = helper.getObjs(layersTable, names) -- {"hello"}
    local target = objs[1].parent
    local layerName = objs[1].text
    local xStart = target.x
    local yStart = target.y
    layersTable.listener(target, {phase="ended", id="myscollview"})

    helper.clickButton("remove")

    -- hello should be removed from layersTable
    objs = helper.getObjs(layersTable, names) -- {"hello"}
    ---
    assert(#objs==0, "remove fail #objs="..#objs)
    ---
    -- hello become active color in layersbox
    objs = helper.getEntries(layersbox, {"bg", "hello"})
    --local fillColor = getFillColor(objs[1].rect)
    print("@@",objs[1].alpha, objs[2].alpha)
    ---
    assert(objs[1].alpha == objs[2].alpha, "hello not become active")
    ---

  end
end

function M.xtest_add_from_group()
  M.UI.testCallback = function()
      M.UI.page = "page4"
      local name = "myGroup"
      --selectors.componentSelector:onClick(true,  "layerTable") --isVisible = true
      M.selectors.componentSelector:onClick(true,  "groupTable")
      helper.selectGroup(name)
       -- click the icon for creatign a new group
      M.UI.scene.app:dispatchEvent {
        name = "editor.selector.selectGroup",
        UI = M.UI,
        group = name,
        isNew = false, --(name ~= "Trash-icon"),
        isDelete =false -- (name == "Trash-icon")
      }

    -- layersbox -> layersTable
    local layersbox = require("editor.group.layersbox")

    local names = {"Ellipse"}
    -- layersbox.controlDown = true -- multi
    helper.selectEntries(layersbox, names)

    -- click add button
    helper.clickButton("add")

    -- Ellipse in layersbox should be grayed

  end
end

function M.xtest_add_drag()
  M.UI.testCallback = function()
      M.UI.page = "page4"
      local name = "myGroup"
      --selectors.componentSelector:onClick(true,  "layerTable") --isVisible = true
      M.selectors.componentSelector:onClick(true,  "groupTable")
      helper.selectGroup(name)
       -- click the icon for creatign a new group
      M.UI.scene.app:dispatchEvent {
        name = "editor.selector.selectGroup",
        UI = M.UI,
        group = name,
        isNew = false, --(name ~= "Trash-icon"),
        isDelete =false -- (name == "Trash-icon")
      }

    -- add layersbox -> layersTable
    local layersbox = require("editor.group.layersbox")
    -- select them
    local names = {"bg", "Ellipse"}
    layersbox.controlDown = true -- multi
    helper.selectEntries(layersbox, names)

    -- click add button
    helper.clickButton("add")

    -- drag an object in layersTable
    local layersTable = require("editor.group.layersTable")
    local target = layersTable.objs[3].parent
    local layerName = layersTable.objs[3].text
    local xStart = target.x
    local yStart = target.y
    layersTable.listener(target, {phase="began", id="myscollview"})
    target:dispatchEvent{name="touch", target=target, phase="began", x =target.x, y=target.y, xStart=xStart, yStart=yStart}
    target:dispatchEvent{name="touch", target=target, phase="moved", x=target.x, y= target.y-40, xStart=xStart, yStart=yStart}
    target:dispatchEvent{name="touch", target=target, phase="ended", x=target.x, y= target.y-40, xStart=xStart, yStart=yStart}

    assert_match(layersTable.objs[2].text, layerName, "moved to index 2")
    --print(layersTable.objs[2].text, layerName, "moved to index 2")

    -- click remove
    -- local layersTable = require("editor.group.layersTable")
    --
  end
end

return M
