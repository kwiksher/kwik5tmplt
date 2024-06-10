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
--
-- function controller:useClassEditorProps()
--   -- print("useClassEditorProps")
--   local props = {
--     name = self.selectbox.selectedObj.text, -- UI.editor.currentLayer,
--     class= self.selectbox.selectedText.text:lower(),
--     properties = {},
--     actionName = nil,
--     -- the following vales come from read()
--     page = self.page,
--     layer = self.layer,
--     isNew = self.isNew,
--     --class = self.class,
--     index = self.selectbox.selectedIndex,
--   }
--   --
--   if self.control == nil then
--     print("#Error self.control is nil for ", self.layerTool)
--     return {}
--   end
--   local properties = self.control:getValue()
--   for i=1, #properties do
--     -- print("", properties[i].name, type(properties[i].value))
--     props.properties[properties[i].name] = properties[i].value
--   end
--   --
--   props.actionName =self.actionbox.selectedTextLabel
--   return props
-- end

local M          = require(root.."parts.baseClassEditor").new(model, controller)
--
M.x				= display.contentCenterX + 480/2 -80
M.y				= 20
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
  actionbox:init(UI, self.x + self.width*1.5,  display.contentCenterY)
  buttons:init(UI)

  UI.useClassEditorProps = function() return controller:useClassEditorProps() end

  --
  self.controller:init()
  self.controller.view = self
end
--
return M
