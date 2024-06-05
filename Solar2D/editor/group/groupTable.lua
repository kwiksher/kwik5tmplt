local name = ...
local parent,root = newModule(name)

local props = require(root.."model").pageTools.group
props.anchorName = "selectGroup"
props.icons      = {"groups", "trash"}
props.type       = "groups"

local M = setmetatable({}, {__index=require(root.."parts.layerTable")})

local bt = require(root .. "controller.BTree.btree")
local tree = require(root .. "controller.BTree.selectorsTree")

local actionCommandPropsTable = require("editor.action.actionCommandPropsTable")
local buttons                 = require("editor.parts.buttons")
local classProps              = require("editor.parts.classProps")

M.anchorName = "selectGroup"
M.icons      = {"groups", "trash"}
M.type       = "groups"
M.id         = "group"

M.x = display.contentCenterX
M.y = 20

function M:init(UI, x, y)

  self.x = x or self.x
  self.y = y or self.y
end
-- function M:setPosition()
--   self.x = self.rectWidth/2 + 22
--   self.y = self.rootGroup.selectLayer.y + marginY
-- end

local layerTableCommands = require("editor.parts.layerTableCommands")

function M:commandHandler(eventObj, event)
  print("@@@@@@@@@@ commandHandler")
  if event.phase == "began" or event.phase == "moved" then
    return
  end
  layerTableCommands.clearSelections(self, "group")

  local target = eventObj -- or event.target
  --UI.editor.currentLayer = target.layer
  --UI.editor.currentClass = target.class
  --
  if target and target.setFillColor then
    target:setFillColor(0, 0, 1)
  end
  if self.selection and self.selection.rect then
    self.selection.rect:setFillColor(0.8)
  end
  --
  if self.altDown then
    if layerTableCommands.showLayerProps(self, target) then
      print("TODO show group props")
      -- print(target[self.id])
      tree.backboard = {
        show = true,
        class = "group"
      }
      -- for instance, obj.animation = "animA", obj.group = "grouA"
      --  see obj[self.id] = name in render
      --
      tree.backboard[self.id] = target[self.id],
      tree:setConditionStatus("select component", bt.SUCCESS, true)
      tree:setActionStatus("load "..self.id, bt.RUNNING, true)
      tree:setConditionStatus("select "..self.id, bt.SUCCESS)
    end
  elseif self.controlDown then -- mutli selections
    layerTableCommands.multiSelections(self, target)
  else
    if layerTableCommands.singleSelection(self, target) then
      self.UI.editor.currentLayer = target.layer
      -- target.isSelected = true
      self.UI.editor.currentClass = target.name
    end
  end
  return true

end



function M:commandHandlerClass(target, event)
  print("commandHandlerClass", target.layer, target.text)
  local class = target.text
  local UI = self.UI
  if event.phase == "began" or event.phase == "moved" then
    return
  end
  --
  layerTableCommands.clearSelections(self, "class")
  --
  buttons:hide()
  --
  if self:isAltDown() then
    print("", "isAltDown")
    --showClassProps(self, target, "group")
    print("::::::::::", target.layer)
    tree.backboard = {
      show = true,
      group  = target.layer,
      class = class
    }
    -- for instance, obj.animation = "animA", obj.group = "grouA"
    --  see obj[self.id] = name in render
    --
    --tree.backboard[self.id] = target[self.id],
    tree:setConditionStatus("select component", bt.SUCCESS, true)
    tree:setActionStatus("load "..self.id, bt.RUNNING, true)
    tree:setConditionStatus("select "..self.id, bt.SUCCESS)

  elseif self:isControlDown() then -- mutli selections
    print("", "isControlDown")
    layerTableCommands.multiSelections(self, target)
  else
    if layerTableCommands.singleSelection(self, target) then
      print("", "singleSelection")
      actionCommandPropsTable:setActiveProp(target.layer, target.class)
      classProps:setActiveProp(target.layer, target.class)
    end
  end
  UI.editor.selections = self.selections
  return true
end



function M:create(UI)
  print("##############")

  -- self.commandHandlerClass = layerTableCommands.commandHandlerClass
  -- self.showClassProps = showClassProps
  -- --self.commandHandler = commands.commandHandler

  -- if self.rootGroup then return end

  self:initScene(UI)
  self.selections = {}

  self.UI = UI

  UI.editor.groupStore:listen(
    function(foo, fooValue)
      self:destroy()
      self.selection = nil
      self.selections = {}
      self.objs = {}
      self.iconObjs = {}
      if fooValue then
        self.objs = self:render(fooValue, 0, 0)
        if #fooValue == 0 then
           self:createIcons(120, 5)
        else
           self:createIcons()
        end
      end
      --
      self.rootGroup:insert(self.group)
      self.rootGroup["groupTable"] = self.group

      -- print(self.id,  #self.objs)
      if fooValue  then
        -- print(debug.traceback())
        self:show()
      else
        self:hide()
      end

    end
  )
end
return M
