local M = {}
local current = ...
local parent = current:match("(.-)[^%.]+$")
local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")
local util = require("lib.util")
--
M.name = current
M.weight = 1
-- M.groupName = nil
M.groupName = "rootGroup"
-- M.x =  display.contentCenterX + 28 -- UI.editor.viewStore.actionCommandTable.left + UI.editor.viewStore.actionCommandTable.width -- commandbox.x + option.width/2
-- M.x = display.contentCenterX + 480/2
M.x = display.actualContentWidth -50
M.y =  22
M.width = 100
      -- commandbox.y  -- (display.actualContentHeight - display.contentHeight + option.height)/2

local option, newText = util.newTextFactory{
  x = 0,
  y = 100,
  width = M.width,
  height = 20
}

local commandbox = require(parent.."commandbox")
-- local linkbox   = require(root.."parts.linkbox").new()
---
local util = require("lib.util")
local json = require("json")

local baseProps = require("editor.parts.baseProps")
local basePropsControl = require("editor.parts.basePropsControl")

--
--- I/F ---
--

--[[
  local function _getValue(name, fieldText, currentValue)
    local _type = type(currentValue)
    local value = fieldText
    -- if name == "_target" then
    --   value = self.objs[i].linkbox.value
    -- end
    -- print("@", type(self.model.properties[i].value))
    if _type == 'boolean' then
      if value == nil or value == "" then
        value = currentValue
      end
      value = tostring(value)
    elseif  _type == 'number' then
      value = tonumber( value )
    end
    return value
  end
--]]

function M:getValue()
  -- print(json.encode(self.model))
  -- for k, v in pairs(linkbox) do print(k, v) end
  for i=1, #self.model.properties do
    if self.objs[i] == nil then break end
    -- print(self.model[i], self.objs[i].text, self.objs[i].field.text )
    self.model.properties[i].value = baseProps._getValue(self.model.properties[i].name, self.objs[i].field.text, self.model.properties[i].value)
  end
  if commandbox.selectedObj then -- create
    return self.model, commandbox.selectedObj.text
  else
    return self.model, commandbox.command
  end
end
--
function M:init(UI)
  -- self.linkbox = linkbox
end

--
function M:create(UI)
  -- if viewStore.actionCommandPropsTable then return end
  -- print("create", self.name)
  self.group = display.newGroup()
  UI.editor.viewStore.actionCommandPropsTable = self

  option.parent = self.group


    -- Create invisible background element for hiding the keyboard (when applicable)


  local newTextField = util.newTextField

  --
  UI.editor.actionCommandPropsStore:listen(
    function(foo, props)
      M:didHide(UI)
      M:destroy()
      print("------- actionCommandPropsStore --------")
      local alphaObj = nil


      local posX = self.x
      print("#### commandbox.x", commandbox.x)
      -- local posY  = display.contentCenterY + 1280/4 * 0.5  +  (option.height)/2
      local posY  = self.y
      -- print("actionCommandPropsStore:listen", posX, posY)
      -- print("", debug.traceback())
      local function compare(a,b)
        return a.name < b.name
      end
      --
      for i=1, #props.properties do
        if props.properties[i].name == "target" then
          props.properties[i].name = "_target"
        end
      end
      table.sort(props.properties,compare)
      ---
      local objs = {}
      for i=1, #props.properties do
        local entry = props.properties[i]
        option.text = entry.name
        option.x = posX
        option.y = i*option.height + posY
        option.text = entry.name
        local rect = display.newRect(option.parent, option.x, option.y, option.width*1.2, option.height)
        rect:setFillColor(1)
        --
        local obj
        obj = newText(option)
        obj.rect = rect
        obj.anchorY = 0.25
        objs[#objs + 1] = obj

        -- Edit
        --[[
          if entry.name == "_target" then
            linkbox:load(UI, props.type, obj.x + obj.width, obj.y - obj.height/4, entry.value)
            obj.linkbox = linkbox
          else
            option.x = posX + option.width
            option.text = entry.value
            --
            obj.field = newTextField(option)
          end
        --]]
        if entry.name == "_target" then
          M.activeProp = entry.name
          if basePropsControl.CommandForTapSet[commandbox.command] then
            obj:addEventListener("tap", function(event) basePropsControl.handler[commandbox.command](event) end)
          else -- layer
            obj:addEventListener("tap", function(event) basePropsControl.handler.layer(event) end)
          end
        elseif entry.name == "alpha" then
          alphaObj = obj
        elseif entry.name == "color" then
          obj.fieldAlpha = alphaObj.field
          obj:addEventListener("tap", baseProps.tapListenerColor)
        end
        option.x = posX + option.width
        option.text = basePropsControl._yamlValue(entry.name, entry.value)
        obj.field = newTextField(option)

        -- objs[#objs + 1] = obj
        -- obj.page = props.name
        -- obj.tap = commandHandler
        -- obj:addEventListener("tap", obj)
        --
        -- TBI set value to obj.field for some special cases
        --   animation.playAll
        --     read all animations, xxx_linear, yyy_bounce ...

      end
      M.objs = objs
      M.model = props

      --
      --
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
  )
  -- viewStore.actionCommandPropsTable.group:translate(-100, 0)

  if system.orientation == "portrait" then
    -- local delta_x = 400
    -- self.group:translate(delta_x, 0)
    -- if self.group.propsTable then
    --   self.group.propsTable:translate(delta_x, 0)
    -- end
  else
    self.group:translate(-130, 0)
  end



end
--
--
--
local Animation = table:mySet{"linear", "blink", "bounce", "pulse", "rotaion", "shake"}
local Layer     = table:mySet{"image", "layer", "audio"}
local Layer_Class = table:mySet{ "button", "countdown", "filter", "multiplier", "particles", "sprite", "readme", "video", "web"}
--
function M:setActiveProp(layer, class)
  -- print("####", self.activeProp, layer, class)
  local name =self.activeProp
  local value = layer
  if class then
    value = layer.."_"..class
  end
  --
  -- check
  --
  local activeCommandName = commandbox.selectedText.text
  -- animation.play, animation.pause, animation.resume
  local isValid = function(class)
    if activeCommandName == "animation"  then
      return Animation[class]
    elseif Layer_Class[activeCommandName] then
      return activeCommandName == class
    elseif Layer[activeCommandName] then
      return class == nil
    end
  end
  if isValid(class) then
    ---
    for i,v in next, self.objs do
      if v.text == name then
        -- print("@@@@@@", value)
        v.field.text = value
        return
      end
    end
  else
    -- TBI show popup
  end
end
--
function M:didShow(UI)
  self:show()
  -- linkbox:didShow(UI)
end
--
function M:didHide(UI)
  self:hide()
  -- linkbox:didHide(UI)
end
--
function M:destroy()
  if self.objs then
    for i=1, #self.objs do
      if self.objs[i].rect then
        self.objs[i].rect:removeSelf()
      end
      if self.objs[i].field then
        self.objs[i].field:removeSelf()
      end
      self.objs[i]:removeSelf()
    end
    self.objs = nil
  end
end
--
function M:hide()
  -- linkbox:hide()
  self.isVisible = false
  if self.objs == nil then return end
  for i=1, #self.objs do
    self.objs[i].isVisible = false
    if self.objs[i].rect then
      self.objs[i].rect.isVisible = false
    end
    if self.objs[i].field then
      self.objs[i].field.isVisible = false
    end
    -- if self.objs[i].linkbox then
    --   self.objs[i].linkbox.isVisible = false
    -- end
  end
end

function M:show()
  -- linkbox:show()
  self.isVisible = true
  if self.objs == nil then return end
  for i=1, #self.objs do
    self.objs[i].isVisible = true
    if self.objs[i].rect then
      self.objs[i].rect.isVisible = true
    end
    if self.objs[i].field then
      self.objs[i].field.isVisible = true
    end
    -- if self.objs[i].linkbox then
    --   self.objs[i].linkbox.isVisible = true
    -- end
  end
end
--
return M
