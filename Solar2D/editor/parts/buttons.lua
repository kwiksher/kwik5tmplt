local M = {}
local current = ...
local parent,  root = newModule(current)

M.name = current
M.weight = 1

local App = require("Application")

local screen = require("extlib.spyric.screen")

local selectbox = require(parent.."selectbox")
--
-- local button = require("extlib.com.gieson.Button")
-- local tools = require("extlib.com.gieson.Tools")
---
local _contextMenu = {"create", "rename", "modify","openEditor", "copy", "paste", "delete"}
M.contextMenu = _contextMenu
-- M.contextMenu = table:mySet{"edit", "copy", "paste", "delete"}


M.commands = {"create", "shape.new_rectangle", "shape.new_ellipse", "shape.new_text",
  "rename",
  "modify", "shape.move", "shape.scale", "shape.rotate",
  "openEditor",
  "copy", "paste", "delete",
  "toggle",
  "save", "cancel"}

M.objs = nil

local isCancel = function(event)
  local ret = event.phase == "up" and event.keyName == 'escape'
  return ret or (system.getInfo("platform") == "android" and event.keyName == "back")
end

---
function M:init(UI, toggleHandler)
  -- singleton ---
  if self.objs then return end
  self.objs = {}
  ---
  local app = App.get()
  for i = 1, #self.commands do
    app.context:mapCommand(
      "editor.classEditor." .. self.commands[i],
      "editor.controller." .. self.commands[i]
    )
  end
  self.togglePanel = toggleHandler
end
--
function M:create(UI)
  self.UI = UI
  -- print("create", self.name)
  -- singleton ---
  if self.objs and next(self.objs) then return end
  self.objs = {}

  -- print(debug.traceback())
  ---
  local group = display.newGroup()
  self.group = group

  local function tapHandler(event)
    print("tap", event.eventName)
    if event.eventName == "toggle" then
      self.togglePanel(true)
      local obj = self.objs[event.eventName]
      if obj.text == "show" then
        obj.text = "hide"
      else
        obj.text = "show"
      end
    else
      local props = {}
      transition.from(obj, {time=500, xScale=2, yScale=2})
      if event.eventName == "copy" then
        props = {
          layer=self.UI.editor.currentLayer,
          class= self.UI.editor.currentClass,
          selections = self.UI.editor.selections,
        }
      elseif event.eventName == "save" then
        props = self.useClassEditorProps()
      end
      -- close context menu
      -- for i, key in next, self.contextMenu do
      --   if key == event.eventName then
      --     self:hide()
      --     break
      --   end
      -- end
      --
      self:hide()
      --
      if self.contextMenuOptions then
        props.options = self.contextMenuOptions
      end

      self.UI.scene.app:dispatchEvent {
        name = "editor.classEditor." .. event.eventName,
        UI = self.UI,
        decoded = selectbox.decoded,
        props = props
      }
    end
    return true
  end

  local options = {
    parent = group,
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
    -- obj.anchorX = 0
    obj.eventName = params.eventName

    local rect = display.newRoundedRect(obj.x, obj.y, 40, obj.height + 2, 10)
    group:insert(rect)
    group:insert(obj)
    rect:setFillColor(0, 0, 0.8)
    obj.rect = rect
    --
    obj.rect.tap = tapHandler
    obj.rect.eventName = params.eventName

    obj.alignment = params.alignment
    -- rect.anchorX = 0
    self.objs[params.eventName] = obj
    return obj
  end

  local function createButtonsInRow(obj, params)
    local objs = {}
    for i, v in next, params do
      v.x = obj.x  + obj.width/2 + obj.width*(i-1)
      v.y = obj.y
      local _obj = createButton(v)
      v.x = _obj.x + _obj.rect.width
      objs[#objs+1] =_obj
    end
    return objs
  end

  local obj = createButton {
    text = "New",
    x = display.contentCenterX - 210,
    y = display.actualContentHeight-10,
    eventName = "create",
    alignment = "left"
  }

  obj.rect.buttonsInRow = createButtonsInRow(
    obj.rect, {
    {text = "rectangle", eventName="shape.new_rectangle"},
    {text = "ellipse", eventName="shape.new_ellipse"},
    {text = "text", eventName="shape.new_text"},
  })

  -- print("@@@", #obj.rect.buttonsInRow)

  obj = createButton {
    text = "Edit",
    x = display.contentCenterX - 210,
    y = display.actualContentHeight-10,
    eventName = "modify",
    alignment = "left"
  }

  obj.rect.buttonsInRow = createButtonsInRow(
    obj.rect, {
    {text = "move", eventName="shape.move"},
    {text = "scale", eventName="shape.scale"},
    {text = "rotate", eventName="shape.rotate"},
  })

  obj = createButton {
    text = "Copy",
    x = display.contentCenterX - 170,
    y = display.actualContentHeight-10,
    eventName = "copy",
    alignment = "left"
  }

  obj = createButton {
    text = "Paste",
    x = display.contentCenterX -130,
    y = obj.y,
    eventName = "paste",
    alignment = "left"

  }

  obj = createButton {
    text = "Delete",
    x = obj.x + obj.width,
    y = obj.y,
    eventName = "delete",
    alignment = "left"
  }

  obj = createButton {
    text = "hide",
    x = obj.x + obj.width+10,
    y = obj.y,
    eventName = "toggle",
    alignment = "left"
  }

  obj = createButton {
    text = "Save",
    x = display.contentCenterX + 45,
    y = display.actualContentHeight-10,
    eventName = "save",
    alignment = "right"
  }
  obj = createButton {
    text = "Cancel",
    x = obj.x + obj.width,
    y = obj.y,
    eventName = "cancel",
    alignment = "right"
  }

  obj = createButton {
    text = "In vscode",
    x = obj.x + obj.width,
    y = obj.y,
    eventName = "openEditor",
    alignment = "right"
  }

  obj = createButton {
    text = "Rename",
    x = obj.x + obj.width,
    y = obj.y,
    eventName = "rename",
    alignment = "right"
  }

  self.openEditorObj = obj
  self.openEditorObj.originalText = obj.text

  for k, obj in pairs(self.objs) do
    obj.rect:addEventListener("tap", obj.rect)
  end

  self.UI.editor.rootGroup:insert(group)
  self.UI.editor.rootGroup.buttons = group

  group.split = function()
    local leftPosX, rightPosX = screen.safe.minX + 30 , screen.centerX + 480*0.5
    print(leftPosX, rightPosX)
    for i, eventName in next, self.commands do
      if self.objs then
        local obj = self.objs[eventName]
        if obj == nil then print(eventName) end
        if obj.alignment == "left" then
        obj.x = leftPosX
        obj.rect.x = leftPosX
        leftPosX = leftPosX + obj.rect.width
        elseif obj.alignment == "right" then
          obj.x = rightPosX
          obj.rect.x = rightPosX
          rightPosX = rightPosX + obj.rect.width
        end
      end
    end

  end
  --
  self:hide()
end
--
function M:didShow(UI)
  self.UI = UI

end
--
function M:didHide(UI)
end
--
function M:destroy()
  -- print(debug.traceback())
  print("buttons:destroy()")
  if self.objs then
    for k, obj in next, self.objs do
      obj.rect:removeEventListener("tap", obj)
      obj.rect:removeSelf()
      obj:removeSelf()
      if obj.rect.buttonsInRow then
        for k, o in next, obj.rect.buttonsInRow do
          o.rect:removeEventListener("mouse", self.mouseOverInRow)
          o.rect:removeSelf()
        end
      end
    end
  end
  self.objs = nil
end

function M:toggle()
  for k, obj in pairs(self.objs) do
    obj.isVisible = not obj.isVisible
    obj.rect.isVisible = obj.isVisible
    end
end

function M.mouseOver(event)
  local obj = M.lastButtonRect
  if obj then
    obj.alpha = 0.5
    if obj.buttonsInRow then
      for k, o in next, obj.buttonsInRow do
        o.isVisible = false
        o.rect.isVisible = false
      end
    end
  end
  --
  local target = event.target
  target.alpha = 1
  --
  obj = M.lastButtonRectInRow
  if obj then
    obj.alpha = 0.5
  end
  --
  if target.buttonsInRow then
    for k, o in next, target.buttonsInRow do
      o.isVisible = true
      o.rect.isVisible = true
      o.alpha = 1
    end
  end
  M.lastButtonRect = target
end

function M.mouseOverInRow(event)
  local obj = M.lastButtonRectInRow
  if obj then
    obj.alpha = 0.5
  end
  local target = event.target
  target.alpha = 1
  M.lastButtonRectInRow = target
end

function M:showContextMenu(x,y, options)
  self.contextMenuOptions = options
  if options then
    self.contextMenu = options.contextMenu or _contextMenu
  end
  local indexX, indexY = 0,0
  for k, key in next, self.contextMenu do
    for k, obj in next, self.objs do
      if key  == obj.rect.eventName then
        obj.isVisible = true
        obj.rect.isVisible = obj.isVisible
        if options and options.orientation =="horizontal" then
          obj.x = x + indexX * obj.rect.width
          obj.y = y
          indexX = indexX + 1
        else
          obj.x = x --+ obj.width
          obj.y = y + indexY * obj.rect.height
          indexY = indexY + 1
        end
        obj.rect.x = obj.x
        obj.rect.y = obj.y
        obj.rect.alpha = 0.5
        -- obj.rect:toFront()
        -- obj:toFront()
        obj.rect:addEventListener("mouse", self.mouseOver)
        --
        -- for buttons in row
        --
        if obj.rect.buttonsInRow then
          local indexXX = 1
          for i, o in next, obj.rect.buttonsInRow do
            print(i, o.text)
            o.isVisible = false
            o.rect.isVisible = o.isVisible
            -- if options and options.orientation =="horizontal" then
              o.x = obj.x + indexXX * o.rect.width
              o.y = obj.y
              indexXX = indexXX + 1
            -- else
            --   o.x = x --+ o.width
            --   o.y = y + indexY * o.rect.height
            --   indexY = indexY + 1
            -- end
            o.rect.x = o.x
            o.rect.y = o.y
            o.rect.alpha = 0.5
            -- o.rect:toFront()
            -- o:toFront()
            o.rect:addEventListener("mouse", self.mouseOverInRow)
          end
        end
        break
      end
    end
  end
  self.group:toFront()
end

function M:hideContextMenu()
  self.contextMenuOptions = nil -- "actionTable"
  self.contextMenu = _contextMenu
  self.openEditorObj.text = self.openEditorObj.originalText
end

function M:show()
  for k, obj in pairs(self.objs) do
    obj.isVisible = true
    obj.rect.isVisible = obj.isVisible
    obj.rect:removeEventListener("mouse", self.mouseOver)
    if obj.rect.buttonsInRow then
      for i, o in next, obj.rect.buttonsInRow do
        o:removeEventListener("mouse", self.mouseOverInRow)
      end
    end
  end

  self.onKeyEvent = function(event)
    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    -- print(message)
    --for k, v in pairs(event) do print(k, v) end
    if isCancel(event)  then
      self.UI.scene.app:dispatchEvent {
        name = "editor.classEditor.cancel",
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
  if self.objs then
    for k, obj in pairs(self.objs) do
      obj.isVisible = false
      obj.rect.isVisible = obj.isVisible
      if obj.rect.buttonsInRow then
        for i, o in next, obj.rect.buttonsInRow do
          o.isVisible = false
          o.rect.isVisible = false
        end
      end

    end
  end
  Runtime:removeEventListener("key", self.onKeyEvent)
  self.openEditorObj.text = self.openEditorObj.originalText

end

--
return M
