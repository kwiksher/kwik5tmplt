local M = {}
local current = ...
local parent,  root = newModule(current)
--

local Props = {
  name = "layer",
  anchorName = "selectLayer"
}

local M = require(root.."baseProps").new(Props)
return M
