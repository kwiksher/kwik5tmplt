local M = {}
local Var = require("components.kwik.vars")
local App   = require("Application")

function M:init(UI)
  if not self.isAfter then
    if not self.isLocal then
      if self.type == "table" then
        App[self.name] = { self.value }
      else
        App[self.name] = self.value
      end
      --
      if self.isSave then
        -- Check if variable has a pre-saved content
        if Var:kwkVarCheck(self.name) ~= nil then
          App[self.name] = Var:kwkVarCheck(self.name)
        end
      end
    else
      if self.type == "table" then
        UI[self.name] = { self.value }
      else
        UI[self.name] = self.value
      end
      if self.isSave then
        -- Check if variable has a pre-saved content
        if Var:kwkVarCheck(self.name) ~= nil then
          UI[self.name] = Var:kwkVarCheck(self.name)
        end
      end
    end
  end
end

function M:create(UI)
  local sceneGroup  = UI.sceneGroup
end
--
function M:didShow(UI)
  if self.isAfter then
    if not self.isLocal then
      if self.type == "table" then
        App[self.name] = { self.value }
      else
        App[self.name] = self.value
      end
    else
      if self.type == "table" then
        UI[self.name] = { self.value }
      else
        UI[self.name] = self.value
      end
    end
  end
end
--
function M:destroy(UI)
end
--
M.set = function(instance)
	return setmetatable(instance, {__index=M})
end

return M