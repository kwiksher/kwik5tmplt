local M = {}
M.name = ...
M.weight = 1
---
local muiTable = require("components.mui.table").new()
local app = require("Application")
local mui = require("materialui.mui")
local muiText   = require("components.mui.text").new()
local preview = require(M.name.."Preview")

---
function M:init(UI) end
--
function M:create(UI)
    print("create", self.name)

    local models = {
        {name="layer01"},
        {name="layer02"}
    }
    UI.layerStore:listen(function(foo, fooValue)
        print("UI.layerStore fooValue", fooValue)
        for k, v in pairs(fooValue[1]) do print(k, v) end

        local pageTable = mui.getWidgetByName("scenes.desktop.pageTable")
        for k, v in pairs(pageTable.options) do print(k, v) end

        local labelText=muiText:createText{
			name=self.name.."-text",
			text = "LAYERS",
			x =  pageTable.options.left + pageTable.options.width + 10,
			y = 100,
            align = "right"
		}
        labelText.x = labelText.x + labelText.width/2

        local layers = {} -- this is flat not nested for createTableView
        local maxWidth = 0
        local maxStr

        for i=1, #fooValue do
            local layer = {}
            for layerName, entries in pairs(fooValue[i]) do
                if layerName ~= "events" and layerName ~="types" then
                    layer.name = layerName
                    layer.key = layerName
                    layer.text = layerName
                    layer.value = i
                    layer.isCategory = false
                    layer.valign = "middle"
                    layer.align = "left"
                    layer.layers = entries
                    print(layerName)
                    table.insert(layers, layer)
                    local len = layerName:len()
                    if len > maxWidth then
                        maxWidth = len
                        maxStr = layerName
                    end
                elseif layerName == "types" then
                    layer.types = entries
                end
            end
            --model.fontSize = 8
            --model.fillColor = {0, 0, 1, 0.2}
            --model.callBack = callbackHandler
            --model.callBackData = {index = i, name = model.name, path=model.path}
            -- model.columns = {} if it is a layerGroup
            --
        end
        --
        models.layers = layers
        --
        UI.types = {} -- animation, button .. this is flat not nested for createTableView
        UI.layers = preview.displayLayers(layers, UI.currentPage.path.."/layers", nil, UI)
        --
        UI.layerInstanceStore:set(UI.types)
        --
        UI.rootScene:translate(display.contentWidth*0.4, display.contentHeight*0.25)
        -- print("#####", UI.rootScene.x, UI.rootScene.y)

        -- UI.layers = {
        --     bg,
        --     Loading,
        --     sidepanle -- group
        -- }
        for k, v in pairs(UI.layers) do
            print(v.name, v.type, v.width, v.height, v.alpha)
            if v.type =="group" then
            end
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

        local maxHeight = #layers * 30
        if maxHeight > 500 then
            maxHeight = 500
        end

        muiTable:createTableView({
            name=self.name,
            top= pageTable.options.top,
            left = pageTable.options.left + pageTable.options.width + 10,
            fontSize = 16,
            rowHeight = 30,
            width =maxWidth,
            height = maxHeight,
            list=layers})
      end)

    muiTable.listener = function(index)
      UI.currentLayer = models.layers[index]
      print("", index, models.layers[index].name)
      UI.scene:dispatchEvent({
          name = "sidepanel.selectLayer",
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

