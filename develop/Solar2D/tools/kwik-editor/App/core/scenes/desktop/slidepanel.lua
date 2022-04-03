local M = {}
M.name = ...
M.weight = 1
---
local mui = require("materialui.mui")

---
function M:init(UI) end
--
function M:create(UI)
    print("create", self.name)

    local models = {
        {command="selectApp"},
        {command="selectAlbum"},
        {command ="selectPage"}}
        --
        local commandHandler = function(event)
            print(event)
            print(event.callBackData.command)
            UI.scene:dispatchEvent({
                name = "sidepanel."..event.callBackData.command,
                UI = UI
            })
        end

    local createList = function()
        for i=1, #models do
            local model = models[i]
            model.key = model.command
            model.value = model.command
            model.labelText = model.command
            model.icon = "view_list"
            model.isActive = false
            model.callBack = commandHandler
            model.callBackData = {command = model.command}
        end
        return models
    end


    local showSlidePanel = function(event)
        if mui.getWidgetBaseObject("slidepanel") ~= nil then
            mui.debug("slidePanel exists, show it")
        else
            mui.newSlidePanel({
                parent = mui.getParent(),
                name = "slidepanel",
                title = "Kwik Demo", -- leave blank for no panel title text
                titleAlign = "center",
                font = native.systemFont,
                width = 300,
                titleFontSize = 20,
                titleFontColor = {1, 1, 1, 1},
                titleFont = native.systemFont,
                titleBackgroundColor = {0.25, 0.75, 1, 1},
                fontSize = 18,
                fillColor = {1, 1, 1, 1}, -- background color
                headerImage = "assets/mui/creative-blue-abstract-background-header-4803_0.jpg",
                buttonToAnimate = "slidepanel-button",
                callBack = mui.actionForSlidePanel,
                callBackData = {item = "cake"},
                labelColor = {0.3, 0.3, 0.3, 1}, -- active
                labelColorOff = {0.5, 0.5, 0.5, 1}, -- non-active
                buttonHeight = 36, -- fontSize * 2
                buttonHighlightColor = {0.5, 0.5, 0.5},
                buttonHighlightColorAlpha = 0.5,
                lineSeparatorHeight = 1,
                list = createList(),
                isVisible = true, -- do show immediately but create the menu
            })

        end
        -- add some buttons to the menu!
    end
    showSlidePanel() -- create but do not show panel demo


end
--
function M:didShow(UI) end
--
function M:didHide(UI) end
--
function M:destroy() end
--
return M

