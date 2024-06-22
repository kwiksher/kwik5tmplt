local name = ...
local parent, root = newModule(name)
--
local M = {}
M.name = name
M.weight = 1

M.x = display.actualContentWidth - 200
M.y = 10

---
local util = require("lib.util")
local yaml = require("server.yaml")
-- local actionbox  = require(parent.."actionbox")

local Prefix_Layers = table:mySet{"type","bodyA","bodyB" ,"width","height", "filename" }
---
local appFont
if ( "android" == system.getInfo( "platform" ) or "win32" == system.getInfo( "platform" ) ) then
  appFont = native.systemFont
else
  -- appFont = "HelveticaNeue-Light"
  appFont = "HelveticaNeue"
end
---
local option, newText = util.newTextFactory {
  text = "",
  x    = 0,
  y    = 100,
  width    = 72,
  height   = 20,
  fontSize = 10,
}
--
M.option = option
--
M.newText = newText
--
-- local posY  = (display.actualContentHeight - display.contentHeight + option.height)/2
-- Create invisible background element for hiding the keyboard (when applicable)
-- local backRect = display.newRect( rootGroup,  posX, posY, 1000, 1000 )
-- backRect:setFillColor(0.8)
-- backRect.isVisible = false
-- backRect.isHitTestable = true
--
-- local function closeKeyboard()
--   backRect:removeEventListener( "touch", closeKeyboard )
--   native.setKeyboardFocus( nil )
--   return true
-- end
--
-- touch the props's name such as url to show asset table
local basePropsControl = require("editor.parts.basePropsControl")
--
M.onTapLayerSet = {}
M.onTapPosXYSet   = {}

--
function M:tapListener(event, type)
  print("@@tapListener", type, event.target.text)
  self.activeProp = event.target.text
  event.actionbox = self
  basePropsControl.handler[type](event, self)
end

-- Input handler for text field/box
local function inputListener( event )
  -- if ( event.phase == "began" ) then
  --   backRect:addEventListener( "touch", closeKeyboard )
  -- elseif ( event.phase == "ended" or event.phase == "submitted" ) then
  --   closeKeyboard()
  -- end
end
--
local function newTextField(option)
    -- Create native text field
    textField = native.newTextField( option.x, option.y, option.width, option.height )
    -- textField = native.newTextBox( option.x, option.y, option.width, option.height )
    -- textField.isEditable = true
    textField.font = native.newFont( appFont, option.fontSize )
    --textField:resizeFontToFitHeight()
    textField:setReturnKey( "done" )
    --textField.placeholder = "Enter text"
    textField:addEventListener( "userInput", inputListener )
    native.setKeyboardFocus( textField )
    textField.text = option.text
    textField.anchorX = 0
    return textField
end
--
M.newTextField = newTextField
-------------------------------
--
-------------------------------
function M:init(UI, x, y, w, h)
  self.x = x or self.x
  self.y = y or self.y
  self.width = w
  self.height = h
  self.UI = UI
  option.width = w or option.width
end
--
local yamlArray = {}
local yamlHash = {}
-- use props instead of model because it has been sorted for view

local function _getValue(name, fieldText, currentValue, assetValue)
  local _type = type(currentValue)
  local value
  if name == '_file' then
    value = assetValue
  elseif name == '_type' then
     value = fieldText
  elseif _type == 'boolean' then
    if value == nil or value == "" then
      value = currentValue
    end
    value = tostring( fieldText )
  elseif _type == 'number' then
    value = tonumber( fieldText )
  elseif name == "actionName" then
    -- value = self.objs[i].actionbox.value
  elseif yamlHash[name] then
    value = '{ '..fieldText..' }'
    value = yaml.eval(value)
  elseif yamlArray[name] then
    value = '[ '..fieldText..' ]'
    value = yaml.eval(value)
  else
    value = fieldText
  end
  return value
end

M._getValue = _getValue

function M:getValue()
  local props = self.props or {}
  for i, v in next, props do
    if self.objs[i] == nil then break end
    -- print(props[i].name, self.objs[i].field.text )
    local fieldText =  self.objs[i].field.text
    local asset = self.objs[i].assetbox or {}
    local value = _getValue(props[i].name, fieldText, v.value, asset.value  )
    v.value = value or v.value
  end
  local json = require("json")
  -- print (json.encode(props))
  return props
end


function M:setValue(fooValue)
  local props = {}
  local _fooValue = fooValue or {}
  local params = _fooValue.properties or _fooValue

  -- print(debug.traceback())

  if params.layerProps then
    for k, v in pairs(params.layerProps) do
      local prop = {name=k, value=basePropsControl._yamlValue(k, v, params.layerProps)}
      props[#props+1] = prop
    end
  else
    for k, v in pairs(params) do
      --
      if not basePropsControl.filter(k) then
        -- print("", k)
        local prop = {name=k, value=basePropsControl._yamlValue(k, v, params)}
        if Prefix_Layers[k] then
          prop.name = "_"..prop.name
        end
        props[#props+1] = prop
      end
    end
  end
  --
  local function compare(a,b)
    return a.name < b.name
  end
  --
  table.sort(props,compare)
  self.props = props
    -- self:createTable(props)
    -- self:show()

    --------
    -- save
    --[[

    local map = {}
    local objs = tableHelper:getTextFields()
    for i=1, #objs do
      print(" "..i..":", objs[i].text)
      models[i].value = objs[i].text
      map[models[i].name] = objs[i].text -- TODO tonumber?
    end
    local tmplt = UI.appFolder.."/../../templates/components/layer_props"
    local path = UI.currentPage.path .."/"..UI.currentLayer.name.."_props"
    util.renderer(tmplt, path, map)
  --]]
end
--
local prevHover, hoverObj
local mouseHover = require "extlib.plugin.mouseHover" -- the plugin is activated by default.
--
function M:createTable(props)
  local UI = self.UI
  local objs = {}
  local alphaObj, imageObj
  -- print(#props)
  for i=1, #props do
    local prop = props[i] or {}
    option.text = prop.name
    print("@@ parts.baseProps",i, prop.name, prop.value)
    option.x = self.x
    option.y = i*option.height + self.y
    -- print(self.group, option.x, option.y, option.width, option.height)
    local rect = display.newRect(self.group, option.x, option.y, option.width, option.height)
    rect:setFillColor(1)

    option.x = self.x + 2
    local obj = newText(option)
    obj.rect = rect
    objs[#objs + 1] = obj
    -- show asset table
    -- print("", prop.name)
    if prop.name == 'url' or prop.name == '_filename' or prop.name == 'sheetInfo' then
       obj.class = self.class
       obj:addEventListener("tap", function(event) self:tapListener(event, 'url')end)
    elseif prop.name == 'onComplete' then
        obj:addEventListener("tap", function(event) self:tapListener(event, 'action')end)
    elseif prop.name == "othersGroup" then
      print("@@@@@ othersGroup")
        obj:addEventListener("tap", function(event) self:tapListener(event, 'group')end)
    elseif self.onTapLayerSet[prop.name] then
      obj:addEventListener("tap", function(event) self:tapListener(event, 'layer')end)
    elseif self.onTapPosXYSet[prop.name] then
      obj:addEventListener("tap", function(event) self:tapListener(event, 'posXY')end)
    elseif prop.name == 'alpha' then
      alphaObj = obj
    elseif prop.name == 'color' or prop.name:find("Color")  or prop.name == 'imageFile' then
      -- obj.fieldAlpha = alphaObj.field
      imageObj = obj
      obj.targetObject = self.targetObject
      obj.page = "*"..UI.page .."*"
      obj:addEventListener("tap", function(event) self:tapListener(event, 'color') end)
    elseif  prop.name == 'imageFile' then
      -- obj.fieldAlpha = alphaObj.field
      imageObj = obj
      obj.targetObject = self.targetObject
      obj.page = "*"..UI.page .."*"
      obj:addEventListener("tap", function(event) self:tapListener(event, prop.name)end)
    elseif prop.name == "imageFolder" then
        local onMouseHover = function(event)
          local hoverText = event.target.field.text
          -- print("hover", hoverText)
          if hoverObj == nil and prevHover ~= hoverText then
            local textOptions = {
              --   parent = group,
              text = hoverText,
              x = event.x,
              --display.contentCenterX,
              y = event.y -20,
              width = hoverText:len() * 10,
              font = native.systemFont,
              fontSize = 10,
              align = "left" -- Alignment parameter
            }
            hoverObj = display.newText(textOptions)
            hoverObj:setFillColor(1, 0, 1)
            prevHover = hoverText
            timer.performWithDelay(
              1500,
              function()
                hoverObj:removeSelf()
                hoverObj = nil
                prevHover = nil
              end
            )
          end
          --for k, v in pairs (event.target) do print(k ,v ) end
        end
      obj:addEventListener("mouseHover", onMouseHover)
    end
    -- Edit
    option.x =rect.x + rect.width/2
    option.y = rect.y
    if type(prop.value) == "boolean" then
      option.text = tostring(prop.value)
    else
      option.text = prop.value
    end
    --
    -- if prop.name == 'actions' then
      --[[
        actionbox:load(self.UI, class, obj.contentBounds.xMax, obj.y , prop.value)
        obj.actionbox = actionbox
        self.group:insert(obj.actionbox.scrollView)
        -- obj.x = actionbox.x -- - actionbox.width
        -- obj.y = actionbox.y
        -- obj.rect.x = actionbox.x -- - actionbox.width
        -- obj.rect.y = actionbox.y
        actionbox.callbackTriagnle = function(on)
          if on then
            self:showFields()
          else
            self:hideFields()
          end
        end
      --]]
    -- else
      local objField = newTextField(option)
      obj.field = objField
      self.group:insert(objField)
      -- obj.page = props.name
      -- obj.tap = commandHandler
      -- obj:addEventListener("tap", obj)
    -- end
    self.group:insert(obj.rect)
    self.group:insert(obj)
  end

  -- set alpha obj to color.fieldAlpha
    for i, obj in next, objs do
      -- print(obj.text)
      if obj.text == "color" then
        if alphaObj then
          obj.fieldAlpha = alphaObj.field
        end
      end
      if obj.text == "imageFolder" then
        if imageObj then
          imageObj.imageFolder = obj
        end
      end

    end

  -- backRect.x = posX
  -- backRect.height = #props * option.height
  -- backRect.isVisible = true
  -- objs[#objs + 1] = backRect
  self.objs = objs
  -- print("##### parts.baseProps", #self.objs)
  -- print(debug.traceback())
  --self.group:translate(300, 0)
end

function M:create(UI)
  -- print("@@create", self.name)
  -- if self.group == nil then
    self.UI = UI
    if UI.editor.currentLayer then
      self.targetObject = UI.sceneGroup[UI.editor.currentLayer]
    end
    --
    self.group = display.newGroup()
    UI.editor.viewStore.propsTable = self.group
  -- end
  -- local commandHandler = function(event)
  --   UI.editor.currentLayer = event.layer
  --   UI.editor.currentClass = event.class
  --   -- for k ,v in pairs(event) do print(k, v) end
  --   UI.scene.app:dispatchEvent {
  --     name = "editor.selector.selectLayer",
  --     UI = UI
  --   }
  -- end

  --UI.editor.propsStore:listen(self.setValue)
  --UI.editor.propsTable = self
  --
  option.parent = self.group
  if self.props then
    self:createTable(self.props)
  else
    -- print("no props")
  end

end
--
function M:didShow(UI)
end
--
function M:didHide(UI)
end
--
function M:destroy()
  -- print("destroy")
  if self.objs then
    for i=1, #self.objs do
      if self.objs[i].rect then
        self.objs[i].rect:removeSelf()
      end
      if self.objs[i].field then
        self.objs[i].field:removeSelf()
      end
      if self.objs[i].actionbox then
        self.objs[i].actionbox:destroy()
      end
      if self.objs[i].radioGroup then
        self.objs[i].radioGroup:removeSelf()
      end
      self.objs[i]:removeSelf()
    end
    self.objs = nil
  end
end
--
function M:hide()
  print("hide", self.name)
  -- print(debug.traceback())
  if self.objs == nil then return end
  for i=1, #self.objs do
    self.objs[i].isVisible = false
    if self.objs[i].rect then
      self.objs[i].rect.isVisible = false
    end
    if self.objs[i].field then
      self.objs[i].field.isVisible = false
    end
    if self.objs[i].actionbox then
      self.objs[i].actionbox:hide()
    end
  end
  self.group.isVisible = false
  self.isVisible = false
end

function M:hideFields()
  if self.objs == nil then return end
  for i=1, #self.objs do
    if self.objs[i].field then
      self.objs[i].field.isVisible = false
    end
  end
end

function M:showFields()
  if self.objs == nil then return end
  for i=1, #self.objs do
    if self.objs[i].field then
      self.objs[i].field.isVisible = true
    end
  end
end


function M:show()
  print("show", self.name)
  if self.objs == nil then return end
  for i=1, #self.objs do
    self.objs[i].isVisible = true
    if self.objs[i].rect then
      self.objs[i].rect.isVisible = true
    end
    if self.objs[i].field then
      self.objs[i].field.isVisible = true
    end
    if self.objs[i].actionbox then
      self.objs[i].actionbox:show()
    end
  end
  self.group.isVisible = true
  self.isVisible = true
end

function M:getObj(name)
  for i, obj in next, self.objs do
    print(obj.text)
    if obj.text == name then
      return obj
    end
  end
end

M.new = function(option)
  local _instance = setmetatable({}, {__index=M})
  if option then
    for k, v in pairs(option) do
      _instance.option[k] = v
    end
  end
	return _instance
end

M.Prefix_Layers = Prefix_Layers
--
return M
