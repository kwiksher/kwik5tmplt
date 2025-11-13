-- Elara Display View
-- Display logic for Elara character

local displayManager = require("views.display_manager")

local M = {}

function M.create(parentGroup, modelData)
    local elara = displayManager.newImageRect(
        parentGroup,
        modelData.states[modelData.currentState],
        modelData.width,
        modelData.height
    )

    elara.x = modelData.x
    elara.y = modelData.y
    elara.isVisible = modelData.visible

    -- Store reference to model data
    elara.modelData = modelData

    return elara
end

function M.changeState(elara, newState)
    -- Store references before removing the object
    local modelData = elara.modelData
    local parent = elara.parent
    local x = elara.x
    local y = elara.y
    local isVisible = elara.isVisible

    if modelData and modelData.states and modelData.states[newState] then
        elara:removeSelf()

        local newImage = displayManager.newImageRect(
            parent,
            modelData.states[newState],
            modelData.width,
            modelData.height
        )

        newImage.x = x
        newImage.y = y
        newImage.isVisible = isVisible
        newImage.modelData = modelData
        newImage.modelData.currentState = newState

        return newImage
    end

    return elara
end

return M