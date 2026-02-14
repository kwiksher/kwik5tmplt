local M = {}

application = {
    content = {
        fps = 60,
        width = 320,
        height = 480,
        scale = "adaptive",
        xAlign = "center",
        yAlign = "center",
        imageSuffix = {
            ["@2x"] = 2.000,
            ["@4x"] = 4.000,
        },
        license = {
            google = {
                key = "Please set your google license key",
            },
        },
    },
}

function M.getDialogueLayout()
    local scale = 0.25
    local safeOriginX = display.safeScreenOriginX or display.screenOriginX or 0
    local safeOriginY = display.safeScreenOriginY or display.screenOriginY or 0
    local safeWidth = display.safeActualContentWidth or display.actualContentWidth or display.contentWidth or 320
    local safeHeight = display.safeActualContentHeight or display.actualContentHeight or display.contentHeight or 480
    local safeCenterX = safeOriginX + safeWidth * 0.5
    local safeBottomY = safeOriginY + safeHeight
    local dialogMargin = 16
    local dialogHeight = 55
    local buttonHeight = 23
    local buttonWidth = 72
    local dialogY = safeBottomY - dialogHeight * 0.5
    local nextButtonY = dialogY
    local dialogWidth = math.max(safeWidth - 48, 280)
    local buttonX = safeOriginX + safeWidth - (buttonWidth * 0.5) - dialogMargin

    return {
        scale = scale,
        safeOriginX = safeOriginX,
        safeOriginY = safeOriginY,
        safeWidth = safeWidth,
        safeHeight = safeHeight,
        safeCenterX = safeCenterX,
        safeBottomY = safeBottomY,
        dialogMargin = dialogMargin,
        dialogHeight = dialogHeight,
        buttonHeight = buttonHeight,
        buttonWidth = buttonWidth,
        dialogY = dialogY,
        nextButtonY = nextButtonY,
        dialogWidth = dialogWidth,
        buttonX = buttonX,
    }
end

return M