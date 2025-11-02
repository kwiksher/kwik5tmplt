-- Elara Display View
-- Display logic for Elara character

local M = {}

function M.create(parentGroup, modelData)
    local elara = display.newImageRect(
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
    if elara.modelData.states[newState] then
        elara:removeSelf()

        local newImage = display.newImageRect(
            elara.parent,
            elara.modelData.states[newState],
            elara.modelData.width,
            elara.modelData.height
        )

        newImage.x = elara.x
        newImage.y = elara.y
        newImage.isVisible = elara.isVisible
        newImage.modelData = elara.modelData
        newImage.modelData.currentState = newState

        return newImage
    end

    return elara
end

return M