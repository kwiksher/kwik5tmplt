local M = require("editor.parts.buttons").new("physics")
local App = require("Application")

function M:init(UI, toggleHandler)
  -- singleton ---
  self.objs = {}
  ---
  if not self.contextInit then
    local app = App.get()
    for i, command in next, self.commands do
      if command == "save" then

      -- print("@@@@@@@@@@@ ppppp", self.id, #self.commands, self.contextInit)

        app.context:mapCommand(
          "editor.classEditor.physics." .. self.commands[i],
          "editor.physics.controller." .. self.commands[i]
        )
      else
        -- app.context:mapCommand(
        --   "editor.classEditor." .. self.commands[i],
        --   "editor.controller." .. self.commands[i]
        -- )
      end
    end
    self.contextInit = true
  end
  self.togglePanel = toggleHandler
end

function M:didShow(UI)
  self.UI = UI
  local obj = self.objs.save
  obj.eventName = "physics.save"
  obj.rect.eventName = "physics.save"
end


return M

