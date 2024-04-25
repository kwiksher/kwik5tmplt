local name = ...
local parent,root = newModule(name)

local props = require(root.."model").pageTools.variable
props.anchorName = "selectVariable"
props.icons      = {"variables", "trash"}

local M = require(root.."baseTable").new(props)
M.type       = "variables"
return M
