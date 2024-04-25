
local M = require("editor.baseBox").new()
local shapes = require("extlib.shapes")
local widget = require( "widget" )

---------------------------
M.name = ...
local parent = M.name:match("(.-)[^%.]+$")


-- animation = {
--   pause = {target = ""},
--   resume = {target = ""},
--   play = {target = ""},
--   playAll = { animations = {}}
-- },

--
-- I/F
function M:setValue(UI, command, model, selected)

  self:destroy()
  --
  self.command           = command -- animation
  self.model             = model
  self.selectedText.text = command -- audio, animation, image ...
  print("action command", command)
  -- self.selectedTextValue = nil
  self.selectedIndex     = nil
  self.selectedObj       = nil
  self.objs           = {}
  ---
  if model then
    self:createTable(UI, selected)
  end
end

local function newText(option)
  local obj=display.newText(option)
  obj:setFillColor( 0 )
  return obj
end
--
function M:createTable(UI, selected)

  -- print("createTable")

  local option = {
    text     = "",
    x        = 0,
    y        = 0,
    width    = 80,
    height   = 16,
    font     = native.systemFont,
    fontSize = 10,
    align    = "left"
  }

    --
  local scrollView = widget.newScrollView
  {
    top                      = self.triangle.contentBounds.yMin,
    left                     = self.triangle.contentBounds.xMin - 48,
    width                    = 48,
    height                   = #self.model*16,
    scrollHeight             = #self.model*16,
    verticalScrollDisabled   = false,
    horizontalScrollDisabled = true,
    friction                 = 2,
  }
  --scrollView.x=labelText.x
  ---[[


  local index = 0
  local function createRow(entry)
    -- print("createRow")
    local group = display.newGroup()
    -- name
    option.text   =  entry.name
    option.x = 42  --labelText.contentBounds.xMin - 100
    option.y = index * option.height + option.height/2
    --

    local obj = newText(option)
    obj.name = entry.name
    obj.params = entry.params
    --
    local rect = display.newRect(obj.x, obj.y, obj.width+10,option.height)
    rect:setFillColor(0.8)

    obj.rect = rect
    group:insert(rect)
    group:insert(obj)

    index = index + 1
    obj.index = index

    function obj:tap(e)
      -- print(e.target.name)
      if e.numTaps == 2 then
        -- print("------double tap --------")
      else
        -- print("-----single tap------")
        if M.selectedObj ~= obj then
          if M.selectedObj then
            M.selectedObj.rect:setFillColor(0.8)
          end
          -- print("#####", self.text)
          M.selectedObj = self
          -- M.selectedText.text =self.text
          M.selectedIndex = self.index
          M.selectedObj.rect:setFillColor(0, 1, 0)
          --
          -- for k, v in pairs(self.params) do print("", k, v) end
          UI.scene.app:dispatchEvent {
            name = "editor.action.selectActionCommand",
            UI = UI,
            commandClass = M.command,
            index = self.index,
            isNew = true
          }
          -- UI.editor.actionCommandPropsStore:set(self.params)
        end
      end
      return true
    end
    obj:addEventListener("tap",obj)
    --
    scrollView:insert(group)
    self.objs[index] = obj
  end
  --
  --
  for k, entry in pairs(self.model) do
    createRow(entry)
  end
  --
  if #self.objs > 0 then
    self.objs[selected].rect:setFillColor(0,1,0)
    self.selectedObj = self.objs[selected]
    -- self.selectedText.text = self.objs[1].text
  end
  --
  --scrollView.isVisible = false
  self.group:insert(scrollView)
  --scrollView.anchorY = 0
--]]
  self.scrollView = scrollView

end
--
--
function M:init(UI)
  self.x = display.contentCenterX/2 + 30
  self.y = display.actualContentHeight - 30
  self.model = {}
end
--
function M:create(UI)
  -- print("--------------------- commandbox ------------")
  -- singleton. destroy with composer is delayed, it causes to free created objects
  -- if  viewStore.commandbox then return end
  --
  self.group = display.newGroup()
  --
  self.triangle = shapes.triangle.equi( self.x,self.y+5, 10 )
  self.triangle:rotate(90)
  self.triangle.tap = function(event)
    -- print("triangle tap")
    self.scrollView.isVisible = not self.scrollView.isVisible
    for i=1, #self.objs do
      local obj = self.objs[i]
      obj.isVisible = self.scrollView.isVisible
    end
    return true
  end
  self.triangle.alpha = 0
  ---
  self.triangle.mouse = function(event )
  end
  --
  self.group:insert(self.triangle)

  local obj = display.newText{
    parent = self.group,
    text = "",
    x = self.triangle.x,
    y = self.triangle.y,
    fontSize = 10,
  }
  obj:setFillColor(1, 0, 1 )
  obj.anchorX = 0

  self.selectedText = obj

  UI.editor.viewStore.commandbox = self
  --self.group:translate(100, 100)
  self:hide()
end
--
function M:didShow(UI)
  if self.triangle then
    self.triangle:addEventListener("tap", self.triangle)
    self.triangle:addEventListener( "mouse", self.triangle )
  end

end
--
function M:didHide(UI)
  if self.triangle then
    self.triangle:removeEventListener("tap", self.triangle)
    self.triangle:removeEventListener("mouse", self.triangle)
  end

end
--
function  M:destroy(UI)
  if self.objs then
    for i=1, #self.objs do
      self.objs[i].rect:removeSelf()
      self.objs[i]:removeSelf()
    end
  end
  if self.scrollView then
    self.scrollView:removeSelf()
  end
  self.objs = nil
  self.scrollView = nil
  -- self.triangle:removeSelf()
  -- self.selectedText:removeSelf()
  -- self.triangle = nil
  -- self.selectedText = nil
  -- print(debug.traceback())
end

function M:toggle()
  self.triangle.tap()
  self.triangle.isVisible = self.scrollView.isVisible
  self.selectedText.isVisible  = self.scrollView.isVisible
end

function M:show()
  -- print("show")
  self.triangle.isVisible = true
  self.selectedText.isVisible  = true
  --
  if self.scrollView == nil  then return end
  self.scrollView.isVisible = true
  for i=1, #self.objs do
    local obj = self.objs[i]
    obj.isVisible = true
    obj.rect.isVisible = true
  end
  -- print("", "show end")
end

function M:hide()
  -- print("hide")
  self.triangle.isVisible = false
  self.selectedText.isVisible  = false
  --
  if self.scrollView == nil  then return end
  self.scrollView.isVisible = false
  for i=1, #self.objs do
    local obj = self.objs[i]
    obj.isVisible = false
    obj.rect.isVisible = false
  end
  -- print("", "hide end")
end
--
return M