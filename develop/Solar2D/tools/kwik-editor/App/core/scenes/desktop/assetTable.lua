local M = {}
M.name = ...
M.weight = 1
---
local muiTable = require("components.mui.table").new()
local json = require("json")
local app = require("Application")
local mui = require("materialui.mui")
local muiText = require("components.mui.text").new()

local dragger = require("components.kwik.layer_drag")


---
function M:init(UI) UI.currentAction = {name = ""} end

local function createTable(self, UI, props)
    self:destroy()
    self.group = display.newGroup()

    local labelText = muiText:createText{
        parent = self.group,
        name = self.name .. "-text",
        text = "ASSETS",
        x = 30, -- display.contentWidth - props.maxWidth - 30,
        y = display.contentCenterY,
        align = "right"
    }

    labelText.x = labelText.x + labelText.width / 2

    local mytable = muiTable:createTableView{
        parent = self.group,
        name = self.name,
        list = props.list,
        left = labelText.x - labelText.width / 2,
        top = labelText.y + labelText.height / 2,
        fontSize = 16,
        rowHeight = 30,
        width = props.maxWidth,
        height = props.maxHeight
    }

   local dx = mytable.x - labelText.x
   local dy = mytable.y - labelText.y

    dragger.add(labelText, function(t)
        print("dragged")
        mytable.x = labelText.x + dx
        mytable.y = labelText.y + dy
    end)

end
--
function M:create(UI)
    print("create", self.name)

    local model = {}

    local handler = function(foo, fooValue)
        -- print("UI.actionStore fooValue", fooValue)
        local maxWidth = 0
        local maxStr

        local categories = {
            {name = "audios/sounds", list = {}},
            {name = "audios/streams", list = {}},
            {name = "audios/sync", list = {}},
            {name = "particles", list = {}},
            {name = "sprites", list = {}},
            {name = "videos", list = {}},
            {name = "www", list = {}}
        }

        local assets = {} -- this is flat not nested for createTableView
        for i = 1, #fooValue do
            local assetName = fooValue[i].path
            local asset = {}
            for index, entry in pairs(categories) do
                print(assetName, entry.name)
                first, last = assetName:find(entry.name)
                print ("", first, last)
                if first == 1 then
                    local name = assetName:sub(last+2)
                    asset.name = name
                    asset.key = i
                    asset.text = name
                    asset.value = assetName
                    asset.isCategory = false
                    asset.valign = "middle"
                    asset.align = "left"
                    -- audio.assets = entries
                    table.insert(entry.list, asset)
                    local len = name:len()
                    if len > maxWidth then
                        maxWidth = len
                        maxStr =name
                    end
                    break
                end
            end
        end

        for index, entry in pairs(categories) do
            assets[#assets + 1] = {
                name = entry.name,
                key = index,
                text = entry.name,
                value = entry.name,
                isCategory = true,
                valign = "middle",
                align = "middle",
            }
            for i=1, #entry.list do
                assets[#assets + 1] = entry.list[i]
            end
        end

        model.list = assets
        -- UI.assets = displayActions(assets, UI.currentPage.path, nil, UI)

        model.maxHeight = (#assets +1) * 30
        if model.maxHeight > 500 then model.maxHeight = 500 end

        local options = {
            text = maxStr,
            x = 0,
            y = 0,
            font = native.systemFont,
            fontSize = 16
        }
        local dummy = display.newText(options)
        model.maxWidth = dummy.width + 50
        dummy:removeSelf()

        if model.maxWidth > 400 then model.maxWidth = 400 end

        createTable(M, UI, model)

    end
    --
    UI.assetStore:listen(handler)

    muiTable.listener = function(index)
        UI.currentAction = model.list[index]
        -- print("", index, models[index])
        UI.scene:dispatchEvent({name = "sidepanel.selectAsset", UI = UI})
    end

    -- handler(nil, {
    --     {path = "audios/sounds/ballsCollide.mp3"},
    --     {path = "audios/sync/page01_Text1.mp3"},
    --     {path = "audios/sync/page01_Text1.txt"},
    --     {path = "audios/sync/page02_Text1.mp3"},
    --     {path = "audios/sync/page02_Text1.txt"},
    --     {path = "particles/kaboom_393.json"},
    --     {path = "particles/kaboom_393.png"},
    --     {path = "sprites/butflysprite.png"},
    --     {path = "videos/kwikplanet.mp4"},
    --     })

    -- UI.eventTable = self
    -- self:destroy()
    -- self:createTableView(createList)

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

