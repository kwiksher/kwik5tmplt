local name = ...
local parent,root = newModule(name)

local props = require(root.."model").pageTools.group
props.anchorName = "selectGroup"
props.icons      = {"groups", "trash"}
props.type       = "groups"

local M = require(root.."baseTable").new(props)
return M
