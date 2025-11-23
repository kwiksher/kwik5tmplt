-- Wolf Display View
-- Display logic for obj character

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
    if obj.modelData.states[newState] then
        obj:removeSelf()

        local newImage = displayManager.newImageRect(
            obj.parent,
            obj.modelData.states[newState],
            obj.modelData.width,
            obj.modelData.height
        )

        newImage.x = obj.x
        newImage.y = obj.y
        newImage.isVisible = obj.isVisible
        newImage.modelData = obj.modelData
        newImage.modelData.currentState = newState

        return newImage
    end

    return obj
end

return M