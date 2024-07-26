local name = ...
local parent,root = newModule(name)
local basePropsControl = require("editor.parts.basePropsControl")

local function getModel(params)
  local model = {}
  for k, v in pairs(params) do
    if not basePropsControl.filter(k) then
      model[#model+1] = prop
    end
  end
  return model
end

local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    print(name)
    local props = params.props
    print(props.class, props.layer)
    --
    local clipboard = UI.editor.clipboard
    local components = {}
    --- these are tables in index.lua
    components.layers = {}
    components.audios = {}
    components.groups = {}
    components.timers = {}
    components.variables = {}
    components.joints = {}
    components.page = {}
    data.components = components
    data.book = UI.book
    data.page = UI.page
    data.class = props.class -- if not nil, components.layers have a class's model.

    for i, v in next, UI.editor.selections do
      local params, model
      if props.class =="audio" then
        params = require("App."..UI.book..".components."..UI.page..".audios."..v.subclass.."."..v.audio)
        model = getModel(params)
        table.insert(components.audios, model)
      elseif props.class =="group" then
        params = require("App."..UI.book..".components."..UI.page..".groups."..v.group)
        model = getModel(params)
        table.insert(components.group, model)
      elseif props.class =="timer" then
        params = require("App."..UI.book..".components."..UI.page..".timers."..v.timer)
        model = getModel(params)
        table.insert(components.timers, model)
      elseif props.class =="variable" then
        params = require("App."..UI.book..".components."..UI.page..".variables."..v.variable)
        model = getModel(params)
        table.insert(components.variables, model)
      elseif props.class =="joint" then
        params = require("App."..UI.book..".components."..UI.page..".joints."..v.joint)
        model = getModel(params)
        table.insert(components.joint, model)
      elseif props.class =="page" then
        table.insert(components.page, v.page)
      elseif props.class then -- layer's class like linear, button, sprite ..
        params = require("App."..UI.book..".components."..UI.page..".layers."..v.layer.."_"..v.class)
        model = getModel(params)
        table.insert(components.layers, model)
      else -- class == nil
        params = require("App."..UI.book..".components."..UI.page..".layers."..v.layer)
        model = getModel(params)
        table.insert(components.layers, model)
      end
    end
    UI.editor.clipboard:save(data)
  end)
--
return instance