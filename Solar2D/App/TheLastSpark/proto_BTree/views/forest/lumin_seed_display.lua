-- Lumin Seed Display View
-- Handles display logic for the lumin seed
local displayManager = require("views.display_manager")

local M = {}

function M.create(parentGroup, modelData)
    local obj = displayManager.newImageRect(
        parentGroup,
        modelData.states[modelData.currentState],
        modelData.width,
        modelData.height
    )

    obj.x = modelData.x
    obj.y = modelData.y
    obj.isVisible = modelData.visible

    -- Store reference to model data
    obj.modelData = modelData

    return obj
end

function M.changeState(obj, newState)
    -- Store references before removing the object
    local modelData = obj.modelData
    local parent = obj.parent
    local x = obj.x
    local y = obj.y
    local isVisible = obj.isVisible

    if modelData and modelData.states and modelData.states[newState] then
        obj:removeSelf()

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

    return obj
end

return M