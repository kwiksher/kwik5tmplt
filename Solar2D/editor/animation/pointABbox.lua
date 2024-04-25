local model= {
  {name="x",A="", B=""},
  {name="y",A="", B=""},
  {name="alpha",A="", B=""},
  {name="xScale",A="", B=""},
  {name="yScale",A="", B=""},
  {name="rotation",A="", B=""},
}

-- local model= {
--   {name="x",A="", B=""},
--   {name="y",A="", B=""},
--   {name="alpha",A="", B=""},
--   {name="duration",A="", B=""},
--   {name="xScale",A="", B=""},
--   {name="yScale",A="", B=""},
--   {name="rotation",A="", B=""},
-- }

local M = require("editor.baseBox").new(model)
local shapes = require("extlib.shapes")
local widget = require( "widget" )
local numberOfRows=#model
local halfW = display.contentCenterX
local halfH = display.contentCenterY

local names = {"A", "B"}

---------------------------
M.name = "settings"
M.selectedText = {}
M.objs = {groups={}, A={}, B = {}}
M.triangle = nil
M.scrollView = nil
M.labelText = nil
--

function M:setValue(_fromProps, _toProps)
  local fromProps = _fromProps or {}
  local toProps   = _toProps or {}
  for i=1, #self.model do
    local entry = self.model[i]
    entry.A = fromProps[entry.name]
    entry.B = toProps[entry.name]
  end
  return self.model
end

function M:getValue()
  for i=1, #self.model do
    local value = self.objs.A[i].text
    self.model[i].A = value or self.model[i].A

    value = self.objs.B[i].text
    self.model[i].B = value or self.model[i].B
  end
  return self.model
end
--
local function createTable(triangle, group)
  -- print("createTable")
  local labelText = display.newText{
      parent = group,
      text = "point A, point B",
      x = triangle.x+18,
      y = triangle.y-10,
    fontSize = 10,
  }
  labelText.alpha = 0
  labelText:setFillColor( 1 )
  M.labelText = labelText

  local obj = display.newText{
    parent = group,
    text = "Point         A                 B",
    x = triangle.x + 4,
    y = triangle.y,
    fontSize = 10,
  }
  obj:setFillColor( 1 )
  obj.anchorX = 0
  M.selectedText = obj

  --
  local scrollView = widget.newScrollView
  {
    top                      = triangle.contentBounds.yMax,
    left                     = triangle.contentBounds.xMin,
    width                    = 48,
    height                   = #model*16,
    scrollHeight             = #model*16,
    verticalScrollDisabled   = false,
    horizontalScrollDisabled = true,
    friction                 = 2,
  }
  --scrollView.x=labelText.x
  ---[[

  local option = M.option
  option.parent   = group
  --
  local index = 1
  local function createRow(entry, name)
    -- print("createRow")
    local group = display.newGroup()
    -- name
    option.parent = group
    option.text   =  entry.name
    option.x = 42  --labelText.contentBounds.xMin - 100
    option.y = index * option.height -8
    -- option.y = triangle.contentBounds.yMax + (index-2) * option.height-5
    --
    local obj = M.newText(option)
    obj.name = entry.name
    --
    local fieldA = native.newTextField(option.width-10, obj.y, 40, obj.height )
    -- fieldA.anchorY = 0.8
    -- local separator = display.newText{
    --   text     = ">>>>>>>>>",
    --   x        = option.width-12 + fieldA.width,
    --   y        = option.y-5,
    --   font     = native.systemFont,
    --   fontSize = 10,
    -- }
    -- separator:setFillColor(0.8)
    local fieldB = native.newTextField(option.width-12 + fieldA.width + 4, obj.y, 40, obj.height)
    -- fieldB.anchorY = 0.8
    fieldA.text = entry.A
    fieldB.text = entry.B
    --field.inputType = "number"
    obj.fieldA = fieldA
    obj.fieldB = fieldB
    group:insert(fieldA)
    -- group:insert(separator)
    group:insert(fieldB)

    scrollView:insert(group)
    M.objs.A[index] = fieldA
    M.objs.B[index] = fieldB
    M.objs.groups[index] = group
    index = index + 1

  end
  --
  for k, entry in pairs(model) do
    createRow(entry, name)
  end
  --
  -- scrollView.isVisible = false
  group:insert(scrollView)
  M.scrollView = scrollView
  --scrollView.anchorY = 0
--]]

end
--
--
function M:init(UI, x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
end
--
function M:create(UI)
  local group = display.newGroup()
  local x = self.x  -- classProps's scrollView
  local y = self.y
  self.triangle = shapes.triangle.equi( x, y+5, 10 )
  self.triangle:rotate(180)
  self.triangle.tap = function(event)
    -- print("triangle tap")
    for k, name in pairs(names) do
      for i=1, #self.objs[name] do
        local obj = self.objs[name][i]
        obj.isVisible = not obj.isVisible
        --obj.fieldA.isVisible = obj.isVisible
        --obj.fieldB.isVisible = obj.isVisible
      end
    end
    M.scrollView.isVisible = not M.scrollView.isVisible
    return true
  end
  ---
  self.triangle.mouse = function(event )
    --print(event.name, event.type, event.y)
    --for k, v in pairs(event) do print(k, v) end
    -- if event.type == "down" then
    --     if event.isPrimaryButtonDown then
    --         print( "Left mouse button clicked." )
    --     elseif event.isSecondaryButtonDown then
    --         print( "Right mouse button clicked." )
    --     end
    -- end
    if M.labelText.alpha == 0 then
      M.labelText.alpha = 1
      timer.performWithDelay( 1000, function() M.labelText.alpha = 0 end)
    end
  end
  --
  group:insert(self.triangle)
  createTable(self.triangle, group)
  self.group = group
end
--
function M:didShow(UI)
  for k, name in pairs(names) do
    for i=1, #self.objs[name] do
      local obj = self.objs[name][i]
      function obj:tap(e)
        print(e.target.name)
        M.selectedText.text = e.target.name
        return true
      end
      if obj.addEventListener then
        obj:addEventListener("tap",obj)
      end
    end
  end
  if self.triangle and self.triangle.addEventListener then
    self.triangle:addEventListener("tap", self.triangle)
  end
  -- self.triangle:addEventListener( "mouse", self.triangle )

end
--
function M:didHide(UI, name)
  for k, name in pairs(names) do
    for i=1, #self.objs[name] do
      local obj = self.objs[name][i]
      if obj and obj.removeEventListener then
        obj:removeEventListener("tap", obj)
      end
    end
  end
  if self.triangle and self.triangle.removeEventListener then
    self.triangle:removeEventListener("tap", self.triangle)
    -- self.triangle:removeEventListener("mouse", self.triangle)
  end
end
--
function  M:destroy(UI)
  if self.triangle and self.triangle.removeSelf then
    self.triangle:removeSelf()
    self.labelText:removeSelf()
    self.selectedText:removeSelf()
    for i=1, #self.objs.groups do
      self.objs.groups[i]:removeSelf()
    end
    self.scrollView:removeSelf()
  end
end
--
function M:toggle()
  self.triangle.tap()
  self.triangle.isVisible = self.scrollView.isVisible
  self.labelText.isVisible = self.scrollView.isVisible
  self.selectedText.isVisible  = self.scrollView.isVisible
end

function M:show()
  if self.scrollView == nil  then return end
  for k, name in pairs(names) do
    for i=1, #self.objs[name] do
      local obj = self.objs[name][i]
      obj.isVisible = true
      --obj.fieldA.isVisible = obj.isVisible
      --obj.fieldB.isVisible = obj.isVisible
    end
  end
  self.scrollView.isVisible = true
  self.triangle.isVisible = true
  self.labelText.isVisible = true
  self.selectedText.isVisible  = true
end

function M:hide()
  if self.scrollView == nil  then return end
  for k, name in pairs(names) do
    for i=1, #self.objs[name] do
      local obj = self.objs[name][i]
      obj.isVisible = false
      --obj.fieldA.isVisible = obj.isVisible
      --obj.fieldB.isVisible = obj.isVisible
    end
  end
  self.scrollView.isVisible = false
  self.triangle.isVisible = false
  self.labelText.isVisible = false
  self.selectedText.isVisible  = false
end
--
return M