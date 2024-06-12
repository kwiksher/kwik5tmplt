local current = ...
local parent,root, M = newModule(current)
--
local model      = require(parent.."model")

local selectIndex = 1

function M:setValue(decoded, index, template)
  if decoded == nil then return end
  if not template then
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
  else
    if decoded.class == "joint" then
      self.selectbox:setTemplate(decoded)  -- "linear 1", "rotation 1" ...
      local value = self.selectbox.model[selectIndex]
      self.classProps:setValue(value.entries)
    else
      --self.selectbox:setTemplate(decoded)  -- "linear 1", "rotation 1" ...
      --local value = self.selectbox.model[selectIndex]
      self.selectbox:setValue({})
      self.classProps:setValue(decoded)
    end
    local props = {}
    if decoded.actions then
      for k, v in pairs (decoded.actions) do
        props[#props+1] = {name=k, value=""}
      end
      self.actionbox:setValue(props)
      -- self.actionbox:initActiveProp(props)

    else
      print("no actionbox")
      --self.actionbox:hide()
      self.actionbox:setValue()
      -- print(#self.actionbox.objs)
    end
  end
end

function M.new(views)

  local module = require(root.."controller.index").new(model.id)
  module:init(views)
  module.setValue = M.setValue
  return module
end

return M
