local M = {}
local current = ...
local parent,  root = newModule(current)
--

local Props = {
  name = "Settings",
  anchorName = "Settings"
}

local M = require(root.."baseProps").new(Props)
--
-- I/F
--
M.useClassEditorProps = function()
  return M:getValue()
end

return M
