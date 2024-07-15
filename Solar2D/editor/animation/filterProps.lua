local M= require("editor.parts.baseProps").new({width=50})
M.name = "filterProps"
M.marginFieldX = -10


local util = require("lib.util")
local basePropsControl = require("editor.parts.basePropsControl")
--
local header = display.newText("", 0, 0, native.systemFont, 10)
header:addEventListener("tap", function()
  if M.group.isVisible then
    M:hide(header)
  else
    M:show(header)
  end
  header.isVisible = true
end)

local json = require("json")
local path = system.pathForFile( "editor/template/components/pageX/animation/defaults/filters.json", system.ResourceDirectory )
local file, errorString = io.open( path, "r" )
local contents = file:read( "*a" )
io.close( file )
--
local data = json.decode(contents)
--
function M.getFilterParams(name)
  for i, v in next, data do
    if v.name == name then
      -- for k, v in pairs(v.params) do print(k, v) end
      return v.params
    end
  end
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
    --
    header.x, header.y = self.x, self.y
    header.anchorX = 0.35
    header.anchorY = 0.3


    header.isVisible = true
    -- self.group:insert(header)
  --
  if self.props then
    local addSetValue
    local setValue = function(obj, value)
      obj.field.text = value
      local params = M.getFilterParams(value)
      local entries = util.split(value, ".")
      if entries[1] == "composite" then
        M:setValue({params=params, effect = entries[2], type = entries[1], paint1=NIL, paint2=NIL, folder=NIL })
      else
        M:setValue({params=params, effect = entries[2], type = entries[1] })
      end
      M:destroy()
      M:createTable(M.props)
      addSetValue()
    end

    addSetValue = function()
      for i, obj in next, M.objs do
        if obj.text == "_effect" then
          obj.setValue = setValue
          break
        end
      end
    end
    self:createTable(self.props)
    addSetValue()
  else
    -- print("no props")
    header.isVisible = false
  end
end

function M:getValue()
  local props = self.props or {}
  for i, v in next, props do
    if self.objs[i] == nil then break end
    -- print(props[i].name, self.objs[i].field.text )
    local fieldText =  self.objs[i].field.text
    local asset = self.objs[i].assetbox or {}
    local value = M:_getValue(props[i].name, fieldText, v.value, asset.value  )
    v.value = value or v.value
  end
  local json = require("json")
  -- print (json.encode(props))
  return props
end

-- https://stackoverflow.com/questions/7526223/how-do-i-know-if-a-table-is-an-array

local function isArray(t)
  return #t > 0 and next(t, #t) == nil
end


-- "levels", "blur.vertical","blur.horixaontal" "add"
-- "vertical", "horizontal"

local function flattenKeys(_parentKey, v)
  local ret = {}
  local parentKey = _parentKey or ""
  if type(v) == "table" then
    for key, value in pairs(v) do
      if type(value) ~="table" or isArray(value) then
        flatten_key = parentKey .."_"..key
        ret[flatten_key] = value
      else
        local _ret = flattenKeys(parentKey .."_"..key, value)
        for kk, vv in pairs(_ret) do
          ret[kk] = vv
        end
      end
    end
  else
    ret[parentKey] = v
  end
  return ret
end

M.flattenKeys = flattenKeys

local colorSet = table:mySet{"color", "darkColor", "lightColor", "color1", "color2", " dirLightColor", " pointLightColor"}

function M:setValue(fooValue)
  local props = {}
  local _fooValue = fooValue or {}
  local params = _fooValue.properties or _fooValue
  --
  for k, v in pairs(params) do
    --
    if not basePropsControl.filter(k) then
      local prop
      if k == "params" then
        local entries = flattenKeys(nil, v)
        for name, value in pairs(entries) do
          print("", name:sub(2), value)
          local _name = name:sub(2)
          if colorSet[_name] then
            prop = {name=_name, value=basePropsControl._yamlValue("color", value)}
          else
            prop = {name=_name, value=basePropsControl._yamlValue(_name, value, params)}
          end
          -- print("","", prop.value)
          props[#props+1] = prop
        end
      elseif k == "effect" then
        prop = {name="_effect", value=basePropsControl._yamlValue(k, v, params)}
        props[#props+1] = prop
      elseif k == "type" then
        prop = {name="_type", value=basePropsControl._yamlValue(k, v, params)}
        props[#props+1] = prop
      else
        prop = {name=k, value=basePropsControl._yamlValue(k, v, params)}
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
end

function M:show(skip)
  -- print("show", self.name)
  if self.objs == nil or #self.objs == 0 then
    header.isVisible = false
    return
  end
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
  header.isVisible = true

  -- if skip == nil then
  --   self:hide(true)
  -- end

end

function M:hide(skip)
  -- print("hide", self.name)
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
  if skip == nil then
    header.isVisible = false
  end
end

return M