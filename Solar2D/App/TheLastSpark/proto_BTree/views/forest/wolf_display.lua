-- Wolf Display View
-- Display logic for wolf character

local displayManager = require("views.display_manager")

local M = {}

function M.create(parentGroup, modelData)
    local wolf = displayManager.newImageRect(
        parentGroup,
        modelData.states[modelData.currentState],
        modelData.width,
        modelData.height
    )

    wolf.x = modelData.x
    wolf.y = modelData.y
    wolf.isVisible = modelData.visible

    -- Store reference to model data
    wolf.modelData = modelData

    return wolf
end

function M.changeState(wolf, newState)
    if wolf.modelData.states[newState] then
        wolf:removeSelf()

        local newImage = displayManager.newImageRect(
            wolf.parent,
            wolf.modelData.states[newState],
            wolf.modelData.width,
            wolf.modelData.height
        )

        newImage.x = wolf.x
        newImage.y = wolf.y
        newImage.isVisible = wolf.isVisible
        newImage.modelData = wolf.modelData
        newImage.modelData.currentState = newState

        return newImage
    end

    return wolf
end

return M