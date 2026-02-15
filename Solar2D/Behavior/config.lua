local M = {}

function M.getDialogueLayout()
    local scale = 0.25
    local safeOriginX = display.safeScreenOriginX or display.screenOriginX or 0
    local safeOriginY = display.safeScreenOriginY or display.screenOriginY or 0
    local safeWidth = display.safeActualContentWidth or display.actualContentWidth or display.contentWidth or 320
    local safeHeight = display.safeActualContentHeight or display.actualContentHeight or display.contentHeight or 480
    local safeCenterX = safeOriginX + safeWidth * 0.5
    local safeBottomY = safeOriginY + safeHeight
    local dialogMargin = 16
    local dialogHeight = 48
    local dialogueFontSize = 12
    local buttonHeight = 23
    local buttonWidth = 72
    local dialogY = safeBottomY - dialogHeight * 0.5
    local nextButtonY = dialogY
    local dialogWidth = math.max(safeWidth - 48, 280)
    local dialogTextWidth = math.max(dialogWidth - buttonWidth-30, 150)
    local dialogTextHeight = math.max(dialogHeight - 20, 20)
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
        dialogueFontSize = dialogueFontSize,
        buttonHeight = buttonHeight,
        buttonWidth = buttonWidth,
        dialogY = dialogY,
        nextButtonY = nextButtonY,
        dialogWidth = dialogWidth,
        dialogTextWidth = dialogTextWidth,
            dialogTextHeight = dialogTextHeight,
        buttonX = buttonX,
    }
end

return M