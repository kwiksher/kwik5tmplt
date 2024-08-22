local current = ...
local parent,  root = newModule(current)
--
local model      = require(parent.."model")
local selectbox      = require(root.."parts.selectbox")
local classProps    = require(root.."parts.classProps")
-- local actionbox = require(parent.."actionbox")
local actionbox = require("editor.parts.actionbox")
local buttons       = require(root.."parts.buttons")
local controller = require(root.."controller.index").new(model.id)
--
controller:init{
  selectbox      = selectbox,
  classProps    = classProps,
  actionbox = actionbox,
  buttons       = buttons,
}

local M          = require(root.."parts.baseClassEditor").new(model, controller)
--
M.x				= display.contentCenterX + 480/2 -80
M.y				= 20
M.width   = 100
-- classProps.marginFieldX = 30
-- actionbox.marginFieldX = 0
--
function M:init(UI)
  self.UI = UI
  self.group = display.newGroup()
  -- UI.editor.viewStore = self.group
--
  selectbox     : init(UI, self.x + self.width/2, self.y, self.width*0.74, self.height)
  -- selectbox:init(UI, self.x, self.y, self.width/2, self.height)
  classProps:init(UI, self.x + self.width*1.5, self.y,  self.width, self.height)
  classProps.model = self.model.props
  --
  -- print("@@@@@", classProps.x + self.width*2, classProps.y)
  -- actionbox.props = {{name="onTap", value=""}}
  -- actionbox.activeProp = "onTap"
  actionbox:init(UI, self.x + self.width*1.5,  display.contentCenterY+30, self.width, self.height)
  buttons:init(UI)

  UI.useClassEditorProps = function() return controller:useClassEditorProps() end

  --
  self.controller:init()
  self.controller.view = self
end

function controller:useClassEditorProps()
  -- print(debug.traceback())
  print("editor.controller.useClassEditorProps", self.id)
  local props = { properties = {}}
  if self.selectbox.selectedObj and self.selectbox.selectedText then
    props = {
      name = self.selectbox.selectedObj.text, -- UI.editor.currentLayer,
      class= self.selectbox.selectedText.text:lower(),
      actionName = nil,
      -- the following vales come from read()
      page = self.page,
      layer = self.layer,
      isNew = self.isNew,
      --class = self.class,
      index = self.selectbox.selectedIndex,
      properties = {}
    }
  end
  --
  local properties = self.classProps:getValue()
  for i, entry in next, properties do
    -- print("", properties[i].name, type(properties[i].value))
    if entry.name == "_target" then
      props.properties[#props.properties+1] = {name = "target", value = entry.value}
      props.layer = entry.value
    elseif entry.name == "boundaries" then
      local v = {xMin=entry.value[1], xMax = entry.value[2], yMin = entry.value[3], yMax = entry.value[4]}
      props.properties[#props.properties+1] = {name = "boundaries", value = v}
    else
      props.properties[#props.properties+1] = {name = entry.name, value = entry.value}
    end
  end
  --
  props.actions ={}
  for i, obj in next, self.actionbox.objs do
    props.actions[obj.text] =  obj.field.text
  end
  return props
end

--
return M
