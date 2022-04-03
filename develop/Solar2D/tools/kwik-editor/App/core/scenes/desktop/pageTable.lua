local M = {}
M.name = ...
M.weight = 1
---
local muiTable = require("components.mui.table").new()
local muiText   = require("components.mui.text").new()
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

    UI.pageStore:listen(function(foo, fooValue)

        -- local assetTable = mui.getWidgetByName("scenes.desktop.assetTable")
        -- if assetTable == nil then
        --     assetTable = {options = {left = 100, width = 100}}
        -- end

        local labelText=muiText:createText{
			name=self.name.."-text",
			text = "PAGES",
			x =  50, --assetTable.options.left + assetTable.options.width + 60,
			y = 100
		}

        local maxWidth = 0
        local maxStr

        models = fooValue
        for i=1, #models do
            local model = models[i]
            model.key = model.name
            model.text = model.name
            model.value = i
            model.isCategory = false
            model.valign = "middle"
            model.align = "left"
            print(model.path)
            local len = model.name:len()
            if len > maxWidth then
                maxWidth = len
                maxStr = model.name
            end
            --model.fontSize = 8
            --model.fillColor = {0, 0, 1, 0.2}
            --model.callBack = callbackHandler
            --model.callBackData = {index = i, name = model.name, path=model.path}
            -- model.columns = {} if it is a layerGroup
        end

        local function compare(a,b)
			return a.name < b.name
    	end
		--
		table.sort(models,compare)
        local maxHeight = #models * 30
        if maxHeight > 500 then
            maxHeight = 500
        end

        local options = {
            text = maxStr,
            x = 0,
            y = 0,
            font = native.systemFont,
            fontSize = 16
        }
        local dummy = display.newText(options)
        maxWidth = dummy.width + 10
        dummy:removeSelf()

        --
        muiTable:createTableView{
            name=self.name, list=models,
            width =maxWidth,
            left = labelText.x - labelText.width/2,
            top = labelText.y + labelText.height/2,
            fontSize = 16,
            rowHeight = 30,
            height = maxHeight
        }
      end)

    muiTable.listener = function(index)
      UI.currentPage = models[index]
      print(#models, models[index])
      UI.scene:dispatchEvent({
          name = "sidepanel.selectPage",
          UI = UI
      })
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

