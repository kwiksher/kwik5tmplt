
local current = ...
local parent,  root = newModule(current)
--
local pointA        = require(parent.."pointA")
local pointB        = require(parent.."pointB")
local AtoBbutton    = require(parent.."AtoBbutton")
local selectbox      = require(root.."parts.selectbox")
-- local classProps    = require(root.."parts.classProps")
--
local classProps    = require("editor.parts.baseProps").new({width=50})
--
local pointABbox    = require(parent.."pointABbox")
local actionbox = require("editor.parts.actionbox")
local buttons       = require(root.."parts.buttons")

local model         = require(parent.."model")

-- local model = require(parent.."model")
local controller = require(parent.."controller")

----------
local M = require(root.."parts.baseClassEditor").new(model, controller)

M.x				= display.contentCenterX + 480/2
M.y				= 20
-- M.y				= (display.actualContentHeight-1280/4 )/2
M.width = 80
M.height = 16

function M:init(UI)
  self.UI = UI
  self.group = display.newGroup()
  UI.editor.viewStore.animation = self.group

  selectbox     : init(UI, self.x + self.width/2, self.y, self.width*0.74, self.height)
  classProps   : init(UI, self.x + self.width*1.5 + 2, self.y,  self.width, self.height)
  classProps.model = model.props
  --
  -- pointABbox   : init(UI, display.contentWidth*0.25,  display.contentHeight*0.75,  self.width, self.height)
  pointABbox   : init(UI,  self.x + self.width/2,  display.contentHeight*0.5,  self.width, self.height)
  pointA       : init(UI, self.x + self.width * 5, self.y,  self.width, self.height)
  pointB       : init(UI, self.x + self.width * 7, self.y,  self.width, self.height)
  AtoBbutton   : init(UI, self.x + self.width * 9, self.y,  self.width, self.height)
  actionbox: init(UI, self.x + self.width, display.contentHeight*0.75, self.width, self.height)
  actionbox.props = {
    {name="onComplete", value=""}
  }

  buttons:init(UI)
  -- --

  controller:init{
    selectbox      = selectbox,
    classProps    = classProps,
    pointA        = pointA,
    pointB        = pointB,
    AtoBbutton    = AtoBbutton,
    pointABbox    = pointABbox,
    actionbox = actionbox,
    buttons       = buttons
  }

  controller.view = self

  UI.useClassEditorProps = function() return controller:useClassEditorProps() end


  --self.group:translate(200, 0)
  --
end

return M
