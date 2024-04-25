
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

M.x = 240 -- display.contentCenterX
M.y = 40

function M:init(UI)
  controller.view  = self
  self.UI               = UI
  self.group            = display.newGroup()
  --
  selectbox:init()
  classProps:init(UI, self.x-18 , self.y-32,  self.width, self.height)
  classProps.option.width = 54
  classProps.model = model.props
  classProps:setValue{name="group-1"}
  --
  -- actionbox:init(UI)
  -- group specific UI
  layersbox:init(UI, self.x+50, self.y, nil, nil, "layer")
  layersTable:init(self.x + layersbox.width/2 + 80, self.y)
  buttons:init(self.x +50 + layersbox.width/2 , self.y)
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
    print("@@@@@@@@@@@")
  end

end

return M
