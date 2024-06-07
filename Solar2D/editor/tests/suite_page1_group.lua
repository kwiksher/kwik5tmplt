local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable

local groupTable = require("editor.group.groupTable")
local buttons = require("editor.group.buttons")

local helper = require("editor.tests.helper")

function helper.selectGroup(name, class, isRightClick)
  -- print(name, class)
  for i, obj in next, groupTable.objs do
    if obj.text == name then
      print("", i, obj.text, obj.name)
      if class == nil then
        if isRightClick then
          obj:dispatchEvent{name="mouse", target=obj, isSecondaryButtonDown=true, x =obj.x, y=obj.y}
        else
          obj:touch({phase="ended"})
        end
      else
        for i, classObj in next, obj.classEntries do
          print("", "", classObj.class)
          if classObj.class == class then
              if isRightClick then
                  print("", "", "isRightClick")
                  classObj:dispatchEvent{name= "mouse", target=classObj, isSecondaryButtonDown=true, x = classObj.x, y = classObj.y}
              else
                print("", "", "touch ended")
                classObj:touch({phase="ended"})
              end
            break
          end
        end
      end
      -- obj.classEntries[1]:touch({phase="ended"}) -- animation
      return obj
    end
  end
end


function M.init(props)
  selectors = props.selectors
  UI        = props.UI
  bookTable = props.bookTable
  pageTable = props.pageTable
  layerTable = props.layerTable
  --
  props.groupTable = groupTable
  props.buttons = buttons
  helper.init(props)

end

local book = "book"
local page = "page1"

function M.suite_setup()
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  -- --
  -- UI.scene.app:dispatchEvent {
  --   name = "editor.selector.selectApp",
  --   UI = UI
  -- }
  -- appFolder = system.pathForFile("App", system.ResourceDirectory) -- default
  -- useTinyfiledialogs = false -- default
  ---
  bookTable.commandHandler({book=book}, nil,  true)
  pageTable.commandHandler({page=page},nil,  true)
  selectors.componentSelector.iconHander()
end

function M.setup()
end

function M.teardown()
end

function M.xtest_click_group()
    -- UI.testCallback = function()
      UI.page = "page1"
      selectors.componentSelector:onClick(true,  "groupTable")
      --  -- click the icon for creatign a new group
      -- UI.scene.app:dispatchEvent {
      --   name = "editor.selector.selectGroup",
      --   UI = UI,
      --   isNew = true, --(name ~= "Trash-icon"),
      --   isDelete =false -- (name == "Trash-icon")
      -- }

        helper.selectGroup("groupC")
    -- end
end

function M.test_click_group_for_editing()
  -- UI.testCallback = function()
    UI.page = "page1"
    groupTable.altDown = true
    selectors.componentSelector:onClick(true,  "groupTable")
    helper.selectGroup("groupC")
    groupTable.altDown = false

  -- end
end


function M.xtest_click_group_linear()
  -- UI.testCallback = function()
    UI.page = "page1"
    selectors.componentSelector:onClick(true,  "groupTable")
    helper.selectGroup("groupC")
    -- helper.selectGroup("groupC", "linear")
  -- end
end

function M.xtest_click_group_linear_for_editing()
  -- UI.testCallback = function()
    UI.page = "page1"
    groupTable.altDown = true
    selectors.componentSelector:onClick(true,  "groupTable")
    helper.selectGroup("groupC", "linear")
    groupTable.altDown = false

  -- end
end

function M.xtest_new_group()
  selectors.componentSelector:onClick(true,  "groupTable")
  -- for k, v in pairs(groupTable.iconObjs[1]) do print(k, v) end
  local obj = groupTable.iconObjs[1]
  obj.callBack({target={muiOptions={name="groups-icon"}}})

      -- layersbox -> layersTable
      local layersbox = require("editor.group.layersbox")
      local names = {"cat", "cat_face1"}
      -- layersbox.controlDown = true -- multi
      layersbox.controlDown = true
      helper.selectEntries(layersbox, names)
      -- click add button
      helper.clickButton("add")

  -- local button = "save"
  -- local obj = require("editor.group.buttons").objs[button]
  -- obj:tap()

end

return M
