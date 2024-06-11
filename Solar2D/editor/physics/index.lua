local current = ...
local parent,  root = newModule(current)
--
local model      = require(parent.."model")

local selectbox      = require(parent.."selectbox")
local classProps    = require(root.."parts.classProps")
local actionbox = require(root.."parts.actionbox")
local buttons       = require(root.."parts.buttons")
local util = require("editor.util")
local json = require("json")

local controller = require(parent.."controller").new{
  selectbox      = selectbox,
  classProps    = classProps,
  actionbox = actionbox,
  buttons       = buttons,
}
--
-- function controller:useClassEditorProps()
-- end

local M          = require(root.."parts.baseClassEditor").new(model, controller)

M.x				= display.contentCenterX + 480/2
M.y				= 20
-- M.y				= (display.actualContentHeight-1280/4 )/2
M.width = 50
M.height = 16
--
function M:init(UI)
  self.UI = UI
  self.group = display.newGroup()
  -- UI.editor.viewStore = self.group

  selectbox     : init(UI, display.contentCenterX-480/1.5, self.y, self.width, self.height)
  -- selectbox:init(UI, self.x, self.y, self.width/2, self.height)
  classProps:init(UI, self.x + self.width, self.y, 100, self.height)
  classProps.model = self.model.props
  --
  -- print("@@@@@", classProps.x + self.width*2, classProps.y)
  actionbox:init(UI, self.x+ self.width, display.contentCenterY)
  buttons:init(UI)

  UI.useClassEditorProps = function() return controller:useClassEditorProps() end

  --
  self.controller:init()
  self.controller.view = self
  selectbox.classEditorHandler = function(decoded, index)
    print("classEditorHandler", index)
    -- print(json.encode(decoded))
    local value = selectbox.model[index]
    print(json.encode(value))
    self.controller:reset()
    classProps:setValue(value.entries)
    self.controller:redraw()
  end

end
--
return M
