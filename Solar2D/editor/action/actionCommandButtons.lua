local M = {}
local current = ...
local parent = current:match("(.-)[^%.]+$")

M.name = current
M.weight = 1
M.contextInit = false

local App = require("Application")

--
-- local button = require("extlib.com.gieson.Button")
-- local tools = require("extlib.com.gieson.Tools")
---
M.commands = {"delete", "save", "cancel"}
M.objs = {}

M.x = display.contentCenterX + 480/2
M.y = display.actualContentHeight-10


local isCancel = function(event)
  local ret = event.phase == "up" and event.keyName == 'escape'
  return ret or (system.getInfo("platform") == "android" and event.keyName == "back")
end

---
function M:init(UI, toggleHandler)
  if not self.contextInit then
    local app = App.get()
    for i = 1, #self.commands do
      app.context:mapCommand(
        "editor.actionCommand." .. self.commands[i],
        "editor.action.actionCommand." .. self.commands[i]
      )
    end
    self.togglePanel = toggleHandler
    self.contextInit  = true
  end
end
--
function M:create(UI)
  -- print("create", self.name)
  self.group = display.newGroup()

  local posX = self.x
  local posY = self.y

  local function tap(event)
    -- print("tap")
    if event.eventName == "toggle" then
      self.togglePanel(true)
      if self.objs[event.eventName].text == "show" then
        self.objs[event.eventName].text = "hide"
      else
        self.objs[event.eventName].text = "show"
      end
    else
      UI.scene.app:dispatchEvent {
        name = "editor.actionCommand." .. event.eventName,
        UI = UI
      }
    end
    return true
  end

  local options = {
    parent = self.group,
    text = "",
    font = native.systemFont,
    fontSize = 10,
    align = "left"
  }

  local function createButton(params)
    options.text = params.text
    options.x = params.x
    options.y = params.y

    local obj = display.newText(options)
    --obj.anchorY=0.5
    obj.tap = tap
    obj.eventName = params.eventName
    -- obj.anchorX =0

    local rect = display.newRoundedRect(obj.x, obj.y, 40, obj.height + 2, 10)
    self.group:insert(rect)
    self.group:insert(obj)
    rect:setFillColor(0, 0, 0.8)
    obj.rect = rect
    -- rect.anchorX = 0

    self.objs[params.eventName] = obj
    return obj.rect
  end

  -- local obj = createButton {
  --   text = "New",
  --   x = display.contentCenterX - 210,
  --   y = display.actualContentHeight-10,
  --   eventName = "create"
  -- }

  -- obj = createButton {
  --   text = "Copy",
  --   x = display.contentCenterX - 170,
  --   y = display.actualContentHeight-10,
  --   eventName = "copy"
  -- }

  -- obj = createButton {
  --   text = "Paste",
  --   x = display.contentCenterX -130,
  --   y = obj.y,
  --   eventName = "paste"
  -- }

  local obj = createButton {
    text = "Delete",
    x = posX,
    y = posY,
    eventName = "delete"
  }

  -- obj = createButton {
  --   text = "hide",
  --   x = obj.x + obj.width+10,
  --   y = obj.y,
  --   eventName = "toggle"
  -- }

  obj = createButton {
    text = "Save",
    x = obj.x + obj.width+10,
    y = display.actualContentHeight-10,
    eventName = "save"
  }
  obj = createButton {
    text = "Cancel",
    x = obj.x + obj.width,
    y = obj.y,
    eventName = "cancel"
  }

  UI.editor.viewStore.actionCommandButtons = self
  self:hide()
end
--
function M:didShow(UI)
  for k, obj in pairs(self.objs) do
    obj:addEventListener("tap", obj)
  end
  self.UI = UI
  -- self:toggle()
end
--
function M:didHide(UI)
  for k, obj in pairs(self.objs) do
    obj:removeEventListener("tap", obj)
  end
end
--
function M:destroy()
end

function M:toggle()
  for k, obj in pairs(self.objs) do
    obj.isVisible = not obj.isVisible
    obj.rect.isVisible = obj.isVisible
  end
end

function M:show()
  for k, obj in pairs(self.objs) do
    obj.isVisible = true
    obj.rect.isVisible = obj.isVisible
    end
    self.isVisible = true

    self.onKeyEvent = function(event)
      -- Print which key was pressed down/up
      local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
      -- print(message)
      --for k, v in pairs(event) do print(k, v) end
      if isCancel(event)  then
        self.UI.scene.app:dispatchEvent {
          name = "editor.actionCommand.cancel",
          UI = self.UI,
        }
        --Android, prevent it from backing out of the app
        return true
      end
      -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
      -- This lets the operating system execute its default handling of the key
      return false
    end

    Runtime:addEventListener("key", self.onKeyEvent)

end

function M:hide()
  for k, obj in pairs(self.objs) do
    obj.isVisible = false
    obj.rect.isVisible = obj.isVisible
    end
    self.isVisible = false

  Runtime:removeEventListener("key", self.onKeyEvent)

end

--
return M
