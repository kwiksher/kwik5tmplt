local current = ...
local parent,  root = newModule(current)
--
local model      = require(parent.."model")

local selectbox      = require(root.."parts.selectbox")
local classProps    = require(root.."parts.classProps")
local actionbox = require(parent.."actionbox")
local buttons       = require(root.."parts.buttons")

local controller = require(parent.."controller.index")
local listbox = require(parent.."listbox")
local listPropsTable = require(parent.."listPropsTable")
local listButtons = require(parent.."listButtons")
--

--
--
-- function controller:useClassEditorProps()
-- end

local M          = require(root.."parts.baseClassEditor").new(model, controller)
--
M.x				= display.contentCenterX + 480/2
M.y				= 20
-- M.y				= (display.actualContentHeight-1280/4 )/2
M.width = 80
M.height = 16

function M:init(UI)
  -- singleton because reset is called from selectTool
  if self.group then return end
  ---
  self.UI = UI
  self.group = display.newGroup()
  -- UI.editor.viewStore = self.group

  selectbox     : init(UI, self.x + self.width/2, self.y, self.width*0.74, self.height)
  -- selectbox:init(UI, self.x, self.y, self.width/2, self.height)
  classProps:init(UI, self.x + self.width, self.y,  self.width+20, self.height)
  classProps.model = self.model.props
  --
  -- print("@@@@@", classProps.x + self.width*2, classProps.y)
  actionbox:init(UI, self.x + self.width, classProps.y+classProps.height + 3)
  buttons:init(UI)

  UI.useClassEditorProps = function() return controller:useClassEditorProps() end

  --
  self.controller:init{
    selectbox      = selectbox,
    classProps    = classProps,
    actionbox = actionbox,
    buttons       = buttons,
    listbox       = listbox,
    listPropsTable = listPropsTable,
    listButtons   = listButtons
  }

  self.controller.view = self


end
--
return M
