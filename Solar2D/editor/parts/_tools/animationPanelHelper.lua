local M = {}
M.name = ...
M.weight = 1
local json = require("json")
---

local muiTableHelper = require("components.mui.tableHelper").new()


function muiTableHelper:nameHandler(name, value)
 	return self:newTextField(name, value)
end

function muiTableHelper:audioHandler(name, value, row)
	return self:createText(name, value, row)
end

function muiTableHelper:breadcrumbsHandler(name, value, row)
	if row.params.text == "color" then
		return self:createColor(name, value, row)
	else
		return self:createText(name, value, row)
	end
end

function muiTableHelper:toHandler(name, value, row)
	return self:createText(name, value, row)
end

function muiTableHelper:fromHandler(name, value, row)
	return self:createText(name, value, row)
end

function muiTableHelper:controlsHandler(name, value, row)
	return self:createText(name, value, row)
end

--
return muiTableHelper

