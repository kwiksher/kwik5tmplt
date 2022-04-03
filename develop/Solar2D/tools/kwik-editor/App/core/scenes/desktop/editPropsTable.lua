local M = {}
M.name = ...
M.weight = 1
---
local muiTable = require("components.mui.table").new()
local tableHelper = require("components.mui.tableHelper").new()
local muiButton = require("components.mui.button").new()
local muiText   = require("components.mui.text").new()
local muiSelector = require("components.mui.selector").new()
local util      = require("lib.util")
local dragger = require("components.kwik.layer_drag")
local mui = require("materialui.mui")


---
function M:init(UI) end
--
function M:create(UI)
    print("create", self.name)

    local models = {
        {name="layer01"},
        {name="layer02"}
    }

	self.group = display.newGroup()
	local tableObj, labelText, saveButton, cancelButton, stateSelector

	tableHelper.name = self.name

    UI.propsStore:listen(function(foo, fooValue)

		if tableObj then tableObj:removeSelf(); tableObj=nil  end
		if labelText then labelText:removeSelf();labelText = nil end
		if saveButton then saveButton:removeSelf();saveButton = nil end
		if cancelButton then cancelButton:removeSelf();cancelButton = nil end
	--	if stateSelector then stateSelector:removeSelf();stateSelector = nil end


		local props = {}
		for name, value in pairs(fooValue) do
			local p = {}
			p.name = name
			p.key = name
			p.text = name
			p.value = value
			p.isCategory = false
			p.valign = "middle"
			p.align = "left"
			table.insert(props, p)
        end

		local function compare(a,b)
			return a.name < b.name
    	end
		--
		table.sort(props,compare)
		models = props
		--

		local assetTable = mui.getWidgetByName("scenes.desktop.assetTable")

		labelText=muiText:createText{
			name=self.name.."-text",
			text = UI.editPropsLabel,
			x =  assetTable.options.left + assetTable.options.width + 40,
			y = assetTable.options.top
		}

		labelText:translate(0, -labelText.height + 4)

		local list = { -- if 'key' use it for 'id' in the table row
			{ key = "Row1", text = "Default", value = "Default", isCategory = false },
			{ key = "Row2", text = "Portrait", value = "Portrait", isCategory = false },
			{ key = "Row3", text = "To", value = "to", isCategory = false },
			{ key = "Row3", text = "From", value = "from", isCategory = false }
		}

		stateSelector = muiSelector:createSelector{
			parent = self.group,
			name=self.name.."-selector",
			text = UI.currentState or "Default",
			x =  labelText.x + 250,
			y =  labelText.y,
			list = list
		}

        tableObj = muiTable:createTableView{
			parent = self.group,
			name=self.name, left= display.contentCenterX, list=props,
			top = labelText.y + 20,
			left = labelText.x - labelText.width/2,
			height = 60*#models,
            -- width  = 300,
			rowHeight = 60,
			onRowRender = function(event) tableHelper:onRowRender(event, models) end
		}
		saveButton = muiButton:createButton{
			parent = self.group,
			name=self.name.."button.Save", text = "Save",
			x= tableObj.x,
			y= tableObj.y + tableObj.height/2 }

		cancelButton = muiButton:createButton{
			parent = self.group,
			name=self.name.."button.Cancel", text = "Cancel",
			x= tableObj.x + saveButton.width + 5,
			y= tableObj.y + tableObj.height/2 }

		local dx = self.group.x - labelText.x
		local dy = self.group.y - labelText.y

			dragger.add(labelText, function(t)
				print("dragged")
				self.group.x = labelText.x + dx
				self.group.y = labelText.y + dy
			end)

    end)

    muiTable.listener = function(index, value) print(index, value) end

	muiButton.listener = function(event)
		print("button listener")
		local map = {}
		local objs = tableHelper:getTextFields()
		for i=1, #objs do
			print(" "..i..":", objs[i].text)
			models[i].value = objs[i].text
			map[models[i].name] = objs[i].text -- TODO tonumber?
		end

		local tmplt = UI.appFolder.."/../../templates/components/layer_props"
		local path = UI.currentPage.path .."/"..UI.currentLayer.name.."_props"
		util.renderer(tmplt, path, map)

		-- UI.scene:dispatchEvent({
		-- 	name = "sidepanel.renderJSON",
		-- 	UI = UI,
		-- 	data = {tmplt = "layer_props.json", out=UI.currentLayer, models=models}
		-- })
--[[

	├── models
	│   └── scenes
	│       ├── explorer
	│       │   ├── bkgd.json
	│       │   ├── bkgd_image.json
	│       │   ├── bkgd_props.json
	│       │   ├── bkgd_animation.json
	│       │   ├── index.json
	│       └── tmp.json
	└── scenes
		├── explorer
			├── bkgd.lua <--- props is rendered inside
			├── bkgd_animation.lua <--- animation's props too
			└── index.lua

--]]


	end


    --self:createTableView(createList)

end
--
function M:didShow(UI) end
--
function M:didHide(UI) end
--
function M:destroy() end
--
return M

