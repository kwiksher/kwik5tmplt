local name = ...
local parent,root = newModule(name)
local util = require("lib.util")
local widget = require("widget")
local buttonContext = require("editor.parts.buttonContext")
--
-- local buttonsContextListener = require(parent.."buttonsContextListener")
-- local layerTableCommands = require("editor.parts.layerTableCommands")

local model = {"New", "Edit", "Copy", "Paste", "Delete"}

local M = buttonContext.new{model=model}
M._init = M.init
M.handler = {}
---
function M:init(UI)
  self:_init(UI, function(eventName)
    print(eventName)
    self.handler[eventName](self)
  end)
end

-- edit button
function M.handler.Edit(self)
  -- print("editHandler")
  if self.target then
    -- print("", self.target.action)
    self.UI.scene.app:dispatchEvent {
      name = "editor.action.selectAction",
      action = self.target.action,
      UI = self.UI
    }
  end
end

--[[
--
--  baseProps's tapListener for action, set actionbox as self.target in parts.buttonContext
--
function M.handler.Attach(self)
  if self.target then
    if layerTableCommands.showLayerProps(self, self.target) then
       print("TODO show action props")
       if layerTableCommands.singleSelection(self, self.target) and self.actionbox then
         self.actionbox:setActiveProp(self.target.action) -- nil == activeProp
         self.actionbox = nil
       end
    end
  end
end
--]]

function M.handler.New(self)
  self.UI.scene.app:dispatchEvent {
    name = "editor.action.selectAction",
    action = {},
    isNew = true,
    UI = self.UI
  }
end

function M.handler.Copy(self)
end

function M.handler.Paste(self)
end

function M.handler.Delete(self)
end

return M