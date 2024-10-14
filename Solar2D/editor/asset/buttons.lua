local M = {}
local current = ...
local parent,  root = newModule(current)
M.contextInit = false

--
local App = require("Application")

local Props = {
  name = "asset",
  commandClass = "asset",
  anchorName = "selectAsset",
  model = {
      {name="save",   label="Save"},
      {name="cancel", label="Cancel"}}
}

local M = require(root.."parts.baseButtons").new(Props)

function M:init(UI, x, y)
  self.objs = {}
  self.x = x
  self.y = y
  if self.contextInit == false then
    local app = App.get()
    for i = 1, #self.model do
      local entry = self.model[i]
      app.context:mapCommand(
        "editor."..self.commandClass.."." .. entry.name,
        "editor.asset.controller." .. entry.name
      )
    end
    self.contextInit = true
  end
end

function M:create(UI)
  M:_create(UI)
  --UI.editor.audioEditor:insert(self.group)
  self.group:toFront()
  self:hide()
end

return M
