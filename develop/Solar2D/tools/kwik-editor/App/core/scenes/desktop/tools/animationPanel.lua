local M = {}
M.name = ...
M.weight = 1
---

local nanostores = require("extlib.nanostores.index")

local store = nanostores.createStore()

local colorPicker = require("extlib.color_picker")

---
local muiTable = require("components.mui.table").new()
local tableHelper = require(M.name .. "Helper")
local muiButton = require("components.mui.button").new()
local muiText = require("components.mui.text").new()
local muiSelector = require("components.mui.selector").new()
local muiToolbar = require("components.mui.toolbar").new()
local dragger = require("components.kwik.layer_drag")


local util = require("lib.util")

local function createTable(self, UI, props)

    self:destroy()

    self.group = display.newGroup()
    dragger.add(self.group, function(t)print("dragged", t.name)end)

    --
    labelText = muiText:createText{
        parent = self.group,
        name = M.name .. "-text",
        text = "Animation For " .. UI.currentLayer.name,
        x = display.contentCenterX ,
        y = 100
    }
    ----------
    local list = { -- if 'key' use it for 'id' in the table row
        {key = "Row1", text = "Loading01", value = "Default", isCategory = false},
        {
            key = "Loading02",
            text = "Loading02",
            value = "Loading02",
            isCategory = false
        } }

    local stateSelector = muiSelector:createSelector{
		parent = self.group,
        name = self.name .. "-selector",
        text = "Loading01",
        x = labelText.x - labelText.width/2 + 550 - 100,
        y = 100,
        width = 200,
        list = list
    }

    local tableObj = muiTable:createTableView{
		parent = self.group,
        name = self.name,
        left = labelText.x - labelText.width/2,
        list = props,
        top = 100 + 20,
        height = 70 * #props,
        rowHeight = 70,
        width = 550,
        onRowRender = function(event)
			print("##", tableHelper.fromHandler)
            tableHelper:onRowRender(event)
        end
    }

	-- local panelList = {
	--     muiToolbar.createEntry {text = "To:", isActive = true},
	--     muiToolbar.createEntry {text = "From:"},
	--     muiToolbar.createEntry {text = "Controls"},
	--     muiToolbar.createEntry {text = "On complete"},
	--     muiToolbar.createEntry {text = "Bread crumbs"}
	-- }
	--
    -- panelToolbar = muiToolbar:createToolbar{
    --     parent = self.group,
    --     name = self.name .. "-toolbar",
    --     list = panelList,
    --     width = tableObj.width,
    --     x = tableObj.x - tableObj.width / 2,
    --     y = tableObj.y + tableObj.height / 2,
    --     listener = function(event) end
    -- }

    local saveButton = muiButton:createButton{
        parent = self.group,
        name = self.name .. "button.Save",
        text = "Save",
        x = tableObj.x,
        y = tableObj.y + tableObj.height / 2
    }

    local cancelButton = muiButton:createButton{
        parent = self.group,
        name = self.name .. "button.Cancel",
        text = "Cancel",
        x = tableObj.x + saveButton.width + 5,
        y = tableObj.y + tableObj.height / 2
    }

end
---
function M:init(UI) UI.animationStore = store end

--
function M:create(UI)
    print("create", self.name)

    -- https://code.coronalabs.com/node/94.html
    -- colorPicker.show(function(r, g, b,a) print(r, g, b,a) end, 1,0,0,1)

    local models = {{name = "layer01"}, {name = "layer02"}}

    local tableObj, labelText, saveButton, cancelButton, stateSelector,
          panelToolbar

    tableHelper.name = self.name

	local handler = function(foo, fooValue)
		local props = {}
		for name, value in pairs(fooValue) do
			print(name)
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

		local function compare(a, b) return a.name < b.name end
		--
		table.sort(props, compare)
		models = props
        createTable(self, UI, props)
    end

    UI.animationStore:listen(handler)

    muiTable.listener = function(index, value) print(index, value)
		if type(value) =='table' then
			UI.currentState = models[index].name
			UI.propsStore:set(value)
		end
		--transition.to( self.group, { x=(display.contentWidth/2)*-1, time=600, transition=easing.outQuint } )
		--transition.to( itemSelected, { x=labelText.x + 40 time=600, transition=easing.outQuint } )
		--transition.to( backButton, { x=labelText.x + 40 time=750, transition=easing.outQuint } )

	end

    muiButton.listener = function(event)
        print("button listener")
        local map = {}
        local objs = tableHelper:getTextFields()
        for i = 1, #objs do
            print(" " .. i .. ":", objs[i].text)
            models[i].value = objs[i].text
            map[models[i].name] = objs[i].text -- TODO tonumber?
        end

        local tmplt = UI.appFolder ..
                          "/../../templates/components/layer_animation"
        local path = UI.currentPage.path .. "/" .. UI.currentLayer.name ..
                         "_animation"
        util.renderer(tmplt, path, map)

    end

    UI.currentLayer = {name = "Hello"}

	local fooValue = {
        name = "Loading01",
        from = {
            x = 0,
            y = 0,
            alpha = 0,
            duration = 1000,
            xScale = 1,
            yScale = 1,
            rotation = 0
        },
        to = {
            x = 100,
            y = 100,
            alpha = 1,
            duration = 2000,
            xScale = 1.5,
            yScale = 1.5,
            rotation = 90
        },
		controls = {
			restart = false,
			easing = "Linear",
			reverse = false,
			delay = 1000,
			loop = 1,
			angle = 45,
			xSwipe=0, ySwipe=0,
			anchor = "CenterReferencePoint"
		},
		audio = {
			name="",
			volume = 5,
			channel = 1,
			loop = 1,
			fadeIn = false,
			repeatable = false
		},
		breadcrumbs = {
			dispose = true,
			shape = "",
			color = {1,0,1},
			interval = 300,
			time = 2000,
			width = 30,
			height = 30
		}
    }

	--handler(nil, fooValue )
	--self:destroy()

    UI.animationPanel = self


end
--
function M:didShow(UI) end
--
function M:didHide(UI) end
--
function M:destroy()
    if self.group then self.group:removeSelf() end
    self.group = nil
end
--
return M

