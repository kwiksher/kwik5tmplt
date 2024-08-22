local M = {}
local current = ...
local parent,  root = newModule(current)
--

local Props = {
  name = "layer",
  anchorName = "selectLayer"
}

local M = require(parent.."baseProps").new(Props)
return M
