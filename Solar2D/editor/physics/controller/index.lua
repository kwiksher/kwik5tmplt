local current = ...
local parent,root, M = newModule(current)
--
local model      = require("editor.physics.model")

local selectIndex = 1

function M:setValue(decoded, index, template)
  if decoded == nil then return end
  if template then
    if decoded.class == "joint" then
      self.selectbox:setTemplate(decoded)  -- "linear 1", "rotation 1" ...
      local value = self.selectbox.model[selectIndex]
      self.classProps:setValue(value.entries)
    else
      --self.selectbox:setTemplate(decoded)  -- "linear 1", "rotation 1" ...
      --local value = self.selectbox.model[selectIndex]
      self.selectbox:setValue({})
      decoded.properties["_body"] = self.layer
      self.classProps:setValue(decoded)
    end
    self.class = decoded.class

    local props = {}
    if decoded.actions then
      for k, v in pairs (decoded.actions) do
        print("actions", k)
        props[#props+1] = {name=k, value=""}
      end
      self.actionbox:setValue(props)
      -- self.actionbox:initActiveProp(props)

    else
      --self.actionbox:hide()
      print("no actionbox")
      self.actionbox:setValue()
    end
  else
    -- print(json.encode(decoded[index]))
    self.classProps:setValue(decoded[index].properties)
    local props = {}
    local actions = decoded[index].actions
    if actions then
      for k, v in pairs (actions) do
        props[#props+1] = {name=k, value=""}
      end
      self.actionbox:setValue(props)
      -- self.actionbox:initActiveProp(actions)
    end
    if decoded[index].class == "joint" then
      self.selectbox:setValue(decoded, index)  -- "linear 1", "rotation 1" ...
    else
      self.selectbox:setValue({})
    end
    self.class = decoded[index].class
  end
end

function M:useClassEditorProps(UI)
  print("physics.useClassEditorProps",  self.class)
  local props = { properties = {}}
  --
  if self.classProps == nil then
    print("#Error self.classProps is nil for ", self.tool)
  end

  print ("@@", #self.classProps.objs)

  for i, obj in next, self.classProps.objs do
    local name = obj.text
    local value = obj.field.text
    name = name:gsub("_body", "body")
    props.properties[#props.properties + 1] = {name = name, value=value}
    if name == "_type" then
      props.properties[#props.properties + 1] = {name=value, value=true}
    end
    if name == "body" then
      -- props.name = value
      props.layer = value
    end
  end
  if self.class == "joint" then
    local objs = self.classProps.objs
    local bodyA, bodyB, typeObj = objs[1], objs[2], objs[3]
    props.name = bodyA.field.text.."_"..bodyB.field.text .."_"..typeObj.field.text
    props.isNew = true
  end
  props.class = self.class
  --
  -- props.actionName =self.actionbox.value
  return props
end

function M:show()
  print(self.id, self.class)
  if self.viewGroup then
    for k, v in pairs(self.viewGroup) do
      v:show()
    end
    self.view.group.isVisible = true
  end
  if self.class ~="joint" then
    self.pointA:hide()
    self.pointB:hide()
  end
end

function M:hide()
  if self.viewGroup then
    for k, v in pairs(self.viewGroup) do
      v:hide()
    end
    self.view.group.isVisible = false
  end
end


function M.new(views)
  local module = require("editor.controller.index").new(model.id)
  print(module.id, model.id)
  -- print(debug.traceback())
  module:init(views)
  module.setValue = M.setValue
  module.show = M.show
  module.hide = M.hide
  module.useClassEditorProps = M.useClassEditorProps
  module.buttons.useClassEditorProps = M.useClassEditorProps

  return module
end

return M
