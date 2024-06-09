local name = ...
local parent,root, M = newModule(name)
-- local actionbox = require(root.."parts.actionbox")
local actionTableListener = require(parent.."actionTableListener")
local buttons = require(parent.."buttons")
local contextButtons = require("editor.parts.buttons")
local layerTableCommands = require("editor.parts.layerTableCommands")
local util = require("lib.util")
--
M.selections = {}
M.x = nil
M.y = nil
M.width = 48
M.groupName = "rootGroup"

local option, newText = util.newTextFactory{anchorX=0}

local function onKeyEvent(event)
  return M:onKeyEvent(event)
end

local function mouseHandler(event)
  return  M:mouseHandler(event)
end
--
--  Selector will show action Table
--
-- load widget library
local widget = require("widget")

function M:setPosition()
  -- self.x = self.rootGroup.selectAction.rect.contentBounds.xMax
  self.x = display.contentCenterX - 480*0.95
  self.y = 22 -- self.rootGroup.selectAction.y

  -- self.x = self.rootGroup.selectAction.contentBounds.xMax
  -- self.y = self.rootGroup.selectAction.y

end

function M:init(UI)
end
--

function M:create(UI)
  -- if self.rootGroup then return end
  self.rootGroup = UI.editor[self.groupName]
  self.group = display.newGroup()
  self.UI = UI
  self:setPosition()

  option.width = self.width -- nil makes newText automatically adjust the width

   local function render (models, xIndex, yIndex)
    -- print("actionStore", #models)
    M:destroy()
    buttons:show()

    local objs = {}

    local newButton = newText{
      x = self.x,
      y = self.y + 4,
      text = "New"
    }
    newButton:setFillColor(1, 1, 0)

    newButton.rect = display.newRect(self.group, newButton.x, newButton.y, newButton.width, newButton.height)
    newButton.rect:setFillColor(0.8)
    newButton.rect.anchorX = 0
    newButton.alpha = 1
    newButton.rect.alpha = 0
    newButton.tap = function(event) self:newHandler(event) end
    newButton:addEventListener("tap", newButton)

    local editButton = newText{
      x = newButton.contentBounds.xMax +4,
      y = newButton.y,
      text = "Set"
    }
    editButton:setFillColor(1, 1, 0)
    editButton.tap = function(event)self:editHandler(event)end
    editButton:addEventListener("tap", editButton)
    -- editButton.rect = display.newRect(self.group, editButton.x, editButton.y, editButton.width, editButton.height)
    -- editButton.rect:setFillColor(0.8)
    -- editButton.rect.anchorX = 0
    editButton.alpha = 1
    -- editButton.rect.alpha = 0

    for i = 1, #models do
      option.text = models[i]
      option.x = newButton.x
      option.y = newButton.y+ option.height * i
      --option.width = 100
      local obj = newText(option)
      obj.touch = function(target, event)
        -- print(event)
        if event.phase =="ended" then
          self:selectHandler(target)
        end
        return true
      end
      obj.mouse = function(event)self:mouseHandler(event)
        return true
      end
      obj.action = obj.text
      obj:addEventListener("touch", obj)
      obj:addEventListener("mouse",obj)

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
      -- print(debug.traceback())
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

return setmetatable(M, {__index=actionTableListener})
