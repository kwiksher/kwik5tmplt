local M = {}
M.name = ...
M.weight = 1
local json = require("json")
local util = require("lib.util")

---

local muiTableHelper = require("components.mui.tableHelper").new()

function muiTableHelper:createText (name, value, row)
	local group = display.newGroup()

	local arr = {}
	for key,value in util.pairsByKeys(value) do
		print("", key, value)
		if type(value) == 'table' then
			arr[#arr + 1] = tostring(key) .. "= {" .. table.concat(value,",") .."}"
		else
			arr[#arr + 1] = tostring(key) .. "=" .. tostring(value)
		end
	end

	local textOptions =
	{
		parent = group,
		text = table.concat(arr, ", "),
		x = 30,--display.contentCenterX,
		y = 0,
		width = row.contentWidth-100,
		font = native.systemFont,
		fontSize = row.params.fontSize,
		align = "left" -- Alignment parameter
	}
	local rowTitle = display.newText( textOptions )
	print("rowTitle", rowTitle.x, rowTitle.y)
	rowTitle:setFillColor(0,0,0)
	return group
end


function muiTableHelper:showHideHandler(name, value, row)
	return self:createText(name, value, row)
end

--
return muiTableHelper

