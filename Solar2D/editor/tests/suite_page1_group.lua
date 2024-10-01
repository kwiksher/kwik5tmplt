local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable

local groupTable = require("editor.group.groupTable")
local buttons = require("editor.group.buttons")

local helper = require("editor.tests.helper")
local json   = require("json")

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
    helper.selectGroup("groupCat")
    groupTable.altDown = false

  -- end
end

function M.xtest_render()
  local tmplt='editor/template/components/pageX/group/group.lua'
  local dst ='App/book/components/page1/groups/group-2.lua'
  local model = json.decode('{"layersboxSelections":[],"name":"groupC","layersbox":[{"rect":[],"layer":"background","index":1,"name":"background"},{"rect":[],"layer":"name","index":2,"name":"name"},{"rect":[],"layer":"cat","index":3,"name":"cat"},{"rect":[],"layer":"cat_face1","index":4,"name":"cat_face1"},{"rect":[],"layer":"title_base","index":5,"name":"title_base"},{"rect":[],"layer":"title3","index":6,"name":"title3"},{"rect":[],"layer":"title2","index":7,"name":"title2"},{"rect":[],"layer":"title1","index":8,"name":"title1"},{"rect":[],"layer":"starfish","index":9,"name":"starfish"},{"rect":[],"layer":"fish","index":10,"name":"fish"}],"properties":[{"name":"name","value":"group-2"}],"layersTable":[{"index":1,"rect":[]},{"index":2,"rect":[]}],"layersTableSelections":[]}')
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
