local name = ...
local parent,root = newModule(name)
local actionbox = require(root.."parts.actionbox")
--
local M = {
  selections = {}
}
M.name = name

local buttons = require(parent.."buttons")
local contextButtons = require("editor.parts.buttons")
local layerTableCommands = require("editor.parts.layerTableCommands")

local function onKeyEvent(event)
  -- Print which key was pressed down/up
  -- local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
  -- for k, v in pairs(event) do print(k, v) end
  M.altDown = false
  M.controlDown = false
  if (event.keyName == "leftAlt" or event.keyName == "rightAlt") and event.phase == "down" then
    -- print(message)
    M.altDown = true
  elseif (event.keyName == "leftControl" or event.keyName == "rightControl") and event.phase == "down" then
    M.controlDown = true
  elseif (event.keyName == "leftShift" or event.keyName == "rightShift") and event.phase == "down" then
    M.shiftDown = true
  end
  -- print("controlDown", M.controlDown)
end

--
--  Selector will show action Table
--
-- load widget library
local widget = require("widget")

function M:init(UI) end
--

local posX = display.contentCenterX*0.75

function M.mouseHandler(event)
  if event.isSecondaryButtonDown and event.target.isSelected then
    -- print("@@@@selected")
    contextButtons:showContextMenu(posX, event.y,  {type="action", selections=M.selections})
  else
    -- print("@@@@not selected")
  end
  return true
end

function M:create(UI)
  -- if self.rootGroup then return end
  self.rootGroup = UI.editor.rootGroup
  self.group = display.newGroup()
  self.UI = UI

  buttons:show()
  -- click an action
  local selectHandler = function(target)
    layerTableCommands.clearSelections(self, "action")
    if self.altDown then
      if layerTableCommands.showLayerProps(self, target) then
        print("TODO show action props")
      end
    elseif self.controlDown then
      print("controlDown")
      layerTableCommands.multiSelections(self, target)
    else
      if layerTableCommands.singleSelection(self, target) then
        actionbox:setActiveProp(target.action) -- nil == activeProp
      end
      self.lastTarget = target
    end
  end
  -- edit button
  local editHandler = function(target)
    if self.lastTarget then
      self.UI.scene.app:dispatchEvent {
        name = "editor.action.selectAction",
        action = self.lastTarget.action,
        UI = self.UI
      }
    end
  end

  local newHandler = function(target)
    self.UI.scene.app:dispatchEvent {
      name = "editor.action.selectAction",
      action = {},
      isNew = true,
      UI = self.UI
    }
end

  local option = {
    text = "",
    x = 0,
    y = 0,
    width = nil,
    height = 20,
    font = native.systemFont,
    fontSize = 10,
    align = "left"
  }

  local function newText(option)
    local obj = display.newText(option)
    obj:setFillColor(0)
    obj.anchorX = 0
    return obj
  end

  local function render (models, xIndex, yIndex)
    -- print("actionStore", #models)
    M:destroy()
    --buttons:show()

    local objs = {}

    local newButton = newText{
      x = self.rootGroup.selectAction.contentBounds.xMax,
      y = self.rootGroup.selectAction.y,
      text = "New"
    }
    newButton:setFillColor(1, 1, 0)

    newButton.rect = display.newRect(self.group, newButton.x, newButton.y, newButton.width, newButton.height)
    newButton.rect:setFillColor(0.8)
    newButton.rect.anchorX = 0
    newButton.alpha = 1
    newButton.rect.alpha = 0
    newButton.tap = newHandler
    newButton:addEventListener("tap", newButton)

    local editButton = newText{
      x = newButton.contentBounds.xMax +4,
      y = newButton.y,
      text = "Edit"
    }
    editButton:setFillColor(1, 1, 0)
    editButton.tap = editHandler
    editButton:addEventListener("tap", editButton)
    -- editButton.rect = display.newRect(self.group, editButton.x, editButton.y, editButton.width, editButton.height)
    -- editButton.rect:setFillColor(0.8)
    -- editButton.rect.anchorX = 0
    editButton.alpha = 1
    -- editButton.rect.alpha = 0

    for i = 1, #models do
      option.text = models[i]
      option.x = newButton.x
      option.y = newButton.contentBounds.yMin+ option.height * i
      --option.width = 100
      local obj = newText(option)
      obj.tap = selectHandler
      obj.action = obj.text
      obj:addEventListener("tap", obj)
      obj:addEventListener("mouse", self.mouseHandler)

      local rect = display.newRect(obj.x, obj.y, obj.width+10,option.height)
      rect:setFillColor(0.8)
      rect.strokeWidth = 1
      rect.anchorX = 0
      self.group:insert(rect)
      self.group:insert(obj)
      obj.rect = rect
      objs[i] = obj
    end
    -- objs[#objs + 1] = newButton
    self.rootGroup.actionTable= self.group
    self.rootGroup:insert(self.group)
    if #objs > 1 then
      newButton.rect.width = objs[#objs-1].rect.width
      newButton.rect.height = objs[#objs-1].rect.height
    end

    return objs, newButton, editButton
  end

  UI.editor.actionStore:listen(
    function(foo, fooValue)
      self:destroy()
      if fooValue then
        self.objs, self.newButton, self.editButton = render(fooValue,0,0)
      end
    end
  )

end

function M:didShow(UI)
  self.UI = UI
  if self.newButton then
    self.newButton.isVisible = true
  end
  Runtime:addEventListener("key", onKeyEvent)
end
--
function M:didHide(UI)
  if self.newButton then
    self.newButton.isVisible = false
  end
  Runtime:removeEventListener("key", onKeyEvent)
end
--
function M:destroy()
  if self.objs then
    for i = 1, #self.objs do
      if self.objs[i].rect then
        self.objs[i].rect:removeSelf()
      end
      self.objs[i]:removeSelf()
    end
  end
  self.objs = nil
  if self.newButton then
    self.newButton:removeSelf()
    self.editButton:removeSelf()
    self.newButton = nil
  end
end


return M