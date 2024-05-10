local name = ...
local parent,root = newModule(name)
local M = require("editor.baseBox").new()
local shapes = require("extlib.shapes")
local widget = require( "widget" )

M.name = name
M.x = display.contentCenterX*0.5
M.y = display.actualContentHeight - 30
M.width = 48
M.top = 22
M.left = 50
---------------------------
-- animation = {
--   pause = {target = ""},
--   resume = {target = ""},
--   play = {target = ""},
--   playAll = { animations = {}}
-- },

--
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
    top                      = self.top, --self.triangle.contentBounds.yMin,
    left                     = self.left, --self.triangle.contentBounds.xMin - 48,
    width                    = self.width,
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

    obj.tap = function (target, e)
     return self:tap(target, e)
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
  self.model = {}
end
--
function M:create(UI)
  self.UI = UI
  -- print("--------------------- commandbox ------------")
  -- singleton. destroy with composer is delayed, it causes to free created objects
  -- if  viewStore.commandbox then return end
  --
  self.group = display.newGroup()
  --
  -- self.triangle = shapes.triangle.equi( self.x,self.y+5, 10 )
  -- self.triangle:rotate(90)
  -- self.triangle.tap = function(event)
  --   -- print("triangle tap")
  --   self.scrollView.isVisible = not self.scrollView.isVisible
  --   for i=1, #self.objs do
  --     local obj = self.objs[i]
  --     obj.isVisible = self.scrollView.isVisible
  --   end
  --   return true
  -- end
  -- self.triangle.alpha = 0
  -- ---
  -- self.triangle.mouse = function(event )
  -- end
  --
  -- self.group:insert(self.triangle)

  local obj = display.newText{
    parent = self.group,
    text = "",
    x = self.x,
    y = self.y,
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
  -- if self.triangle then
  --   self.triangle:addEventListener("tap", self.triangle)
  --   self.triangle:addEventListener( "mouse", self.triangle )
  -- end
end
--
function M:didHide(UI)
  -- if self.triangle then
  --   self.triangle:removeEventListener("tap", self.triangle)
  --   self.triangle:removeEventListener("mouse", self.triangle)
  -- end
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
--
return require(parent.."commandboxListener").attachListener(M)
