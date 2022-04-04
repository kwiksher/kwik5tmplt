local M = {}
M.name = ...
M.weight = 1
---
--local muiTable = require("components.mui.table").new()
local muiSelector = require("components.mui.selector").new()
local muiIcon = require("components.mui.icon").new()
local mui = require("materialui.mui")
local muiText   = require("components.mui.text").new()

---
function M:init(UI) end
--
function M:create(UI)
    print("create", self.name)

    local models = {
        {name="layer01"},
        {name="layer02"}
    }

    local toolListener = function(event)
        timer.performWithDelay(1000, function()
            mui.turnOnButtonByName("selectApp")
        end)
        -- UI.scene:dispatchEvent({
        --     name = "sidepanel.selectApp",
        --     UI = UI
        -- })
    end

    UI.contentStore:listen(function(foo, fooValue)
        models = fooValue
        print("contentStore", #models)

        local maxWidth = 0
        local maxStr

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
        print(self.name)
        local obj = muiSelector:createSelector{
            name=self.name,
            x = 100,
            y = 50,
            width = 150,
            text =models[2].text,
            list = models}
        print(obj)
       --
        muiIcon:create{
            icon = {"Settings_over","Settings_over","Settings_over"},
            name = "selectApp",
            --text = "select App folder",
            x = obj.container.x + obj.container.width/2 + 20 ,
            y = obj.container.y -18,
            width = 36,
            height = 36,
            listener =toolListener
        }

       -- mui.turnOnButtonByName("selectApp")

       UI.currentcontent = models[2]
       UI.scene:dispatchEvent({
           name = "sidepanel.selectcontent",
           UI = UI
       })


      end)


    muiSelector.listener = function(event)
      -- for k, v in pairs(event) do print(k, v) end
      UI.currentcontent = models[event.index]
      --print(#models, event.row.index, models[event.row.id])
      UI.scene:dispatchEvent({
          name = "sidepanel.selectcontent",
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

