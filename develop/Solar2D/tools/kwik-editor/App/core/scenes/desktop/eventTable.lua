local M = {}
M.name = ...
M.weight = 1
---
local muiTable = require("components.mui.table").new()
local json = require("json")
local app = require("Application")
local mui = require("materialui.mui")
local muiText   = require("components.mui.text").new()

---
function M:init(UI)
	UI.currentAction = {name = ""}
end

local function createTable(self, UI, props)
    self:destroy()
    self.group = display.newGroup()

    local layerTable = mui.getWidgetByName("scenes.desktop.layerTable")
    if layerTable == nil then
        layerTable = {options = {left = 100, width = 100}}
    end

    local labelText=muiText:createText{
        parent = self.group,
        name=self.name.."-text",
        text = "EVENTS",
        x =  layerTable.options.left + layerTable.options.width + 10,
        y = 100,
        align = "right"		}

    labelText.x = labelText.x + labelText.width/2

    local t = muiTable:createTableView{
        parent = self.group,
        name=self.name, list=props.list,
        left = labelText.x - labelText.width/2,
        top = labelText.y + labelText.height/2,
        fontSize = 16,
        rowHeight = 30,
        width =props.maxWidth,
        height = props.maxHeight
    }
end
--
function M:create(UI)
    print("create", self.name)

    local model = {}

    local handler = function(foo, fooValue)
        --print("UI.actionStore fooValue", fooValue)
        local maxWidth = 0
        local maxStr

        local actions = {} -- this is flat not nested for createTableView
        for i=1, #fooValue do
            local actionName =  fooValue[i]
			local action = {}
			action.name = actionName
			action.key = actionName
			action.text = actionName
			action.value = i
			action.isCategory = false
			action.valign = "middle"
			action.align = "left"
			--action.actions = entries
			print(actionName)
			table.insert(actions, action)
            local len = actionName:len()
            if len > maxWidth then
                maxWidth = len
                maxStr = actionName
            end

            --model.fontSize = 8
            --model.fillColor = {0, 0, 1, 0.2}
            --model.callBack = callbackHandler
            --model.callBackData = {index = i, name = model.name, path=model.path}
            -- model.columns = {} if it is a layerGroup
            --
        end
		model.list = actions
        --UI.actions = displayActions(actions, UI.currentPage.path, nil, UI)

         model.maxHeight = #actions * 30
        if model.maxHeight > 500 then
            model.maxHeight = 500
        end

        local options = {
            text = maxStr,
            x = 0,
            y = 0,
            font = native.systemFont,
            fontSize = 16
        }
        local dummy = display.newText(options)
        model.maxWidth = dummy.width + 10
        dummy:removeSelf()

        if model.maxWidth >  400 then
            model.maxWidth = 400
        end

        createTable(M, UI, model)

      end
	--
    UI.actionStore:listen(handler)

    muiTable.listener = function(index)
      UI.currentAction = model.list[index]
      -- print("", index, models[index])
      UI.scene:dispatchEvent({
          name = "sidepanel.selectAction",
          UI = UI
      })
    end

   -- handler(nil, {"test"})

    -- UI.eventTable = self
    -- self:destroy()
   --self:createTableView(createList)

end
--
function M:didShow(UI) end
--
function M:didHide(UI) end
--
function M:destroy()
    if self.group then
        self.group:removeSelf()
    end
    self.group = nil
end
--
return M

