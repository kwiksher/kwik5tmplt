local M = {}
local name = ...
M.weight = 1
---
local parent,     root = newModule(name)
local propsTable = require(parent .. "parts.propsTable")
local bt         = require(parent .. "controller.BTree.btree")
local tree       = require(parent .. "controller.BTree.selectorsTree")
local btNodeName = "select component"
local muiIcon    = require("components.mui.icon").new()

local layerTableCommands = require("editor.parts.layerTableCommands")
local contextButtons = require("editor.parts.buttons")

local posX = display.contentCenterX*0.75

function M.mouseHandler(event, type, selections)
  -- print("@@@@selected", type)
  if event.isSecondaryButtonDown then -- event.target.isSelected
    contextButtons:showContextMenu(posX, event.y,  {type=type, selections=selections})
  else
    -- print("@@@@not selected")
  end
  return true
end

-- target.class will be audio.long or audio.short or audio.sync
-- a sync audio can be multiple

local function onKeyEvent(self, event)
  -- Print which key was pressed down/up
  local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
  -- print(M.name, message)
  -- for k, v in pairs(event) do print(k, v) end
  self.altDown = false
  self.controlDown = false
  if (event.keyName == "leftAlt" or event.keyName == "rightAlt") and event.phase == "down" then
    print("baseTable", self.name, message)
    self.altDown = true
  elseif (event.keyName == "leftControl" or event.keyName == "rightControl") and event.phase == "down" then
    self.controlDown = true
  elseif (event.keyName == "leftShift" or event.keyName == "rightShift") and event.phase == "down" then
    self.shiftDown = true
  end
  -- print("controlDown", M.controlDown)
end
--
function M:isAltDown()
    return self.altDown
end
--
function M:isControlDown()
  return self.controlDown
end
--
function M:isShiftDown()
  return self.shiftDown
end
---
function M:init(marginX, marginY)
  self.selection = nil
  self.lastSelection = nil
  self.marginX, self.marginY = marginX or 74,  marginY or 20
end

function M:tick(e)
  -- print("listener")
  -- print("", e.isActive, e.wasActive, e.status  )
  if self.selection == nil then
    return
  end
  local rect = self.selection.rect
  if e.isActive then
    if e.status == bt.RUNNING then
      rect:setFillColor(0, 0, 1)
    elseif e.status == bt.SUCCESS then
      rect:setFillColor(0, 1, 0)
    else
      rect:setFillColor(1, 0.5, 0)
    end
  else
    rect:setFillColor(1, 0, 0)
  end
end
--

--
function M:initScene(UI)
  self.rootGroup = UI.editor.rootGroup
  self.group = display.newGroup()
  --
  if self.tick then
    self.group.tick = function(e)
      self:tick(e)
    end
    self.group:addEventListener("tick", self.group)
  end
  --
  local btNodes = tree.tree.conditions.items[btNodeName]
  btNodes[1].viewObj = self.group
  --
  local option = {
    text = "",
    x = 0,
    y = self.rootGroup[self.anchorName].y,
    width = 100,
    height = 20,
    font = native.systemFont,
    fontSize = 10,
    align = "left"
  }
  self.option = option
end

local function newText(option)
  local obj = display.newText(option)
  obj:setFillColor(0)
  return obj
end
--
M.newText = newText
--
function M:commandHandler(eventObj, event)
  if event.phase == "began" or event.phase == "moved" then
    return
  end
  layerTableCommands.clearSelections(self, "audio")

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
      print("TODO show audio props")
      -- print(target[self.id])
      tree.backboard = {
        show = true,
        class = target.class
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
-- icons
function M:createIcons (_marginX, _marginY)
  -- print("createIcons", self.anchorName,_marginX, _marginY)
  local marginX = _marginX or self.marginX
  local marginY = _marginY or 0
  for i=1, #self.icons do
    local name = self.icons[i]
    local actionIcon = muiIcon:create {
      icon = {name.."_over", name.."Color_over", name},
      text = "",
      name = name.."-icon",
      x = self.rootGroup[self.anchorName].x + marginX + i*22,
      y = self.rootGroup[self.anchorName].y -22 + marginY,
      width = 22,
      height = 22,
      fontSize =16,
      fillColor = {1.0},
      listener = function(event)
        -- should we use BT with "add component"?
        -- for k, v in pairs(event.target.muiOptions) do print(k, v) end
        local name = event.target.muiOptions.name
        self.UI.scene.app:dispatchEvent {
          name = "editor.selector."..self.anchorName,
          UI = self.UI,
          class = self.id,
          isNew = (name ~= "trash-icon"),
          isDelete = (name == "trash-icon")
        }
        --
        if  #self.selections > 0 then
          for i = 1, #self.selections do
            if self.selections[i].rect then
              self.selections[i].rect:setFillColor(0.8)
            end
          end
       end
       self.selections = {}
       self.selection = nil
        --
      end,
    }
    self.objs[#self.objs + 1] = actionIcon
    self.group:insert(actionIcon)
  end
end
--
function M:create(UI)
  if self.rootGroup then
    return
  end
  -- print("create", self.id)
  self.selections = {}
  self:initScene(UI)
  --
  local function render(models, xIndex, yIndex)
    local count = 0
    local option = self.option
    ---[[
    for i = 1, #models do
      local name = models[i]

      option.text = name
      option.x = self.rootGroup[self.anchorName].x + self.marginX + xIndex * 5
      option.y = self.rootGroup[self.anchorName].y + self.marginY + option.height * (count-1)
      -- print(name, option.x, option.y)
      option.width = 100
      local obj = newText(option)
      obj[self.id] = name
      obj[self.type] = name
      obj.index = i
      obj.class = self.id
      -- obj.touch = commandHandler
      -- obj:addEventListener("touch", obj)
      --
      obj.touch = function(eventObj, event)
        self:commandHandler(eventObj, event)
        UI.editor.selections = self.selections
        if self.selection then
          -- self.selection.rect:setFillColor(0,1,0)
          self.selection.rect:setStrokeColor(0,1,0)
          self.selection.rect.strokeWidth = 1
        end
      end
      obj:addEventListener("touch", obj)
      obj:addEventListener("mouse", function(event)
        print("self.type", self.type)
        self.mouseHandler(event, self.type, self.selections)
      end)
      --
      local rect = display.newRect(obj.x, obj.y, obj.width + 10, option.height)
      rect:setFillColor(0.8)
      rect.strokeWidth = 1
      self.group:insert(rect)
      self.group:insert(obj)
      --
      count = count + 1
      obj.rect = rect
      self.objs[#self.objs + 1] = obj
    end
    --]]
    -- self.group.isVisible = true
  end

  UI.editor[self.id.."Store"]:listen(
    function(foo, fooValue)
      self:destroy()
      self.selection = nil
      self.selections = {}
      self.objs = {}
      if fooValue then
        render(fooValue, 0, 0)
        if #fooValue == 0 then
           self:createIcons(120, 5)
        else
           self:createIcons()
        end
      end
      --
      self.rootGroup:insert(self.group)
      self.rootGroup[self.id.."Table"] = self.group

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
--
function M:didShow(UI)
  self.UI = UI
  print(self.name, "didShow")
  self.keyListener = function(event) onKeyEvent(self, event)end
  Runtime:addEventListener("key", self.keyListener)
end

--
function M:didHide(UI)
  print(self.name, "didHide")
  Runtime:removeEventListener("key", self.keyListener)
end

function M:show()
  print(self.name, "show")
  --print(debug.traceback())
  if self.group then
    self.group.isVisible = true
  end
  if self.objs then
    for i=1, #self.objs do
      self.objs[i].isVisible = true
    end
  end
end

function M:hide()
  -- print(self.name, "hide")

  if self.group then
    self.group.isVisible = false
  end
  if self.objs then
    for i=1, #self.objs do
      self.objs[i].isVisible = false
    end
  end
  -- for i=1, #self.objs do
  --   self.objs[i].isVisible = false
  -- end
end
--
function M:destroy()
  if self.objs then
    for i = 1, #self.objs do
      if self.objs[i].rect then
        self.objs[i].rect:removeSelf()
      end
      if self.objs[i] and self.objs[i].removeSelf then
        self.objs[i]:removeSelf()
      end
    end
  end
  self.objs = nil
  self.selection = nil
  --
  if self.rootGroup then
    self.rootGroup[self.id.."Table"] = nil
  end
end

function M:clean()
  if self.objs then
    for i = 1, #self.objs do
      self.objs[i].rect:removeSelf()
      self.objs[i]:removeSelf()
    end
    self.objs = nil
  end
  self.selection = nil
  -- print(debug.traceback())
end

M.new = function(instance)
  if instance.objs == nil then
    instance.objs = {}
  end
	return setmetatable(instance, {__index=M}), bt, tree
end
--
return M
