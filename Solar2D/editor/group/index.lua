
local name = ...
local parent,root = newModule(name)

local model = {
  id ="group",
  props = {
    {name="name", value="group-new"},
  }
}

--
local layersbox        = require(parent.."layersbox")
local layersTable      = require(parent.."layersTable")
-- local propsTable       = require(parent.."propsTable")

local selectbox      = require(parent .. "groupTable")
local classProps    =  require(root.."baseProps").new()
-- local actionbox = require(root..".parts.actionbox")
-- this set editor.timer.save, cacnel
local buttons       = require(parent.."buttons")

local controller = require(parent.."controller")
local M = require(root.."baseClassEditor").new(model, controller)

M.x = display.contentCenterX
M.y = 55

function M:init(UI)
  controller.view  = self
  self.UI               = UI
  self.group            = display.newGroup()
  --
  selectbox:init(UI, 4, self.y)
  classProps:init(UI, display.contentCenterX+480*0.6 , display.contentCenterY,  self.width, self.height)
  classProps.option.width = 54
  classProps.model = model.props
  classProps:setValue{name="group-1"}
  --
  -- actionbox:init(UI)
  -- group specific UI
  layersbox:init(UI, self.x-480/2-20, self.y, nil, nil, "layer")
  layersTable:init(UI, self.x + 480/2 + 20, self.y)
  buttons:init(UI, self.x , self.y-20)
  --
  controller:init{
    selectbox      = selectbox,
    classProps    = classProps,
    -- actionbox = actionbox,
    --
    layersbox     = layersbox,
    layersTable   = layersTable,
    buttons       = buttons,
  }

  controller.view = self

  selectbox.useClassEditorProps = function()  return controller:useClassEditorProps() end
  selectbox.classEditorHandler = function(decoded, index)
    -- print("@@@@@@@@@@@")
  end

end

return M
