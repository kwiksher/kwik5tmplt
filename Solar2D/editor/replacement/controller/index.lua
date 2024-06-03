local current = ...
local parent,  root = newModule(current)
--
local json = require("json")

local M = require("editor.controller.index").new("replacement")


function M:init(viewGroup)
  self.viewGroup = viewGroup
  --
  self.selectbox      = viewGroup.selectbox
  self.classProps    = viewGroup.classProps
  self.actionbox = viewGroup.actionbox
  self.buttons       = viewGroup.buttons
  -- for sprite.sequenceData, sync.line
  self.listbox        = viewGroup.listbox
  self.listPropsTable = viewGroup.listPropsTable
  self.listButtons = viewGroup.listButtons

  self.listButtons:init()
  --print(debug.traceback())
  --
  self.buttons.useClassEditorProps = function() return self:useClassEditorProps() end
  self.selectbox.useClassEditorProps = function() self:useClassEditorProps() end
  --
  self.selectbox.classEditorHandler = function(decoded, index)
    self:reset()
    self:setValue(decoded, index)
    self:redraw()
  end
end
-------
-- I/F
------
function M:show()
  -- don't show listbox, listPropsTavle, listButtons
  local viewGroup = {
    self.selectbox,
    self.classProps,
    self.actionbox,
    self.buttons,
    self.listbox
  }
  for k, v in pairs(viewGroup) do
    v:show()
  end
  self.view.group.isVisible = true

end

function M:hide()
  for k, v in pairs(self.viewGroup) do
    v:hide()
  end
  self.view.group.isVisible = false
  --
  self.listbox:hide()
  self.listPropsTable:hide()
  self.listButtons:hide()
  --
end

function M:useClassEditorProps()
  -- print("useClassEditorProps")
  local props = {
    index = self.selectbox.selectedIndex,
    name = self.selectbox.selectedObj.text, -- UI.editor.currentLayer,
    class=self.selectbox.selectedText.text,
    properties = {},
  }
  --
  local properties = self.classProps:getValue()
  for i=1, #properties do
    -- print("", properties[i].name, type(properties[i].value))
    props.properties[properties[i].name] = properties[i].value
  end
  -- onComplete
  if self.actionbox.isActive then
    props.actionName =self.actionbox.value
  end
  --
  -- TBI? listbox
  --
  return props
end

-- this handler should be called from self.selectbox to set one of animtations user selected
function M:setValue(decoded, index, template)
  if decoded == nil then print("## Error setValue ##") return end
  if not template then
    print(json.encode(decoded[index]))
    self.selectbox:setValue(decoded, index)  -- "linear 1", "rotation 1" ...
    self.classProps:setValue(decoded[index].properties)
    self.classProps.class = decoded[index].class
    if decoded[index].actionName then
      self.actionbox:setValue(decoded[index].actionName)
      self.actionbox.isActive = true
    end
    -- for sprite.sequenceData, sync.line
    if decoded[index].sequenceData or decoded[index].line then
      self.listbox:setValue(decoded[index].sequenceData or  decoded[index].line)
      self.listbox.isActive = true
    end
  else
    self.selectbox:setTemplate(decoded)  -- "linear 1", "rotation 1" ...
    self.classProps:setValue(decoded.properties)
    self.classProps.class = decoded.class
    if decoded.actionName then
       self.actionbox:setValue(decoded.actionName)
        self.actionbox.isActive = true
    end
    if decoded.sequenceData or decoded.line then
      local type = "sequenceData"
      if decoded.line then
        type = "line"
      end
      self.listbox:setValue(decoded.sequenceData or  decoded.line, type)
      self.listbox.isActive = true
    end
  end
end

function M:mergeAsset(value, asset)
  print("mergreAsset", asset.path, asset.name, #asset.links)
  value.properties.url = asset.name
  for k, v in pairs(value) do print(k,v) end
  return value
end

return M