-------------------------------------------------------------------------------
-- Display Base Module
-- Base class for all display modules using metatable inheritance
-- Provides common create and changeState functionality
-------------------------------------------------------------------------------

local displayManager = require("views.display_manager")

local DisplayBase = {}
DisplayBase.__index = DisplayBase

-------------------------------------------------------------------------------
-- Constructor: Creates a new instance that inherits from DisplayBase
-- @return New instance with DisplayBase as metatable
-------------------------------------------------------------------------------
function DisplayBase:new()
    local instance = {}
    setmetatable(instance, self)
    return instance
end

-------------------------------------------------------------------------------
-- Creates a display object from model data
-- @param parentGroup The parent display group
-- @param modelData The model data containing states, dimensions, and position
-- @return Display object with modelData reference
-------------------------------------------------------------------------------
function DisplayBase:create(parentGroup, modelData)
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

-------------------------------------------------------------------------------
-- Changes the state of a display object
-- @param obj The display object to change
-- @param newState The new state to change to
-- @return New display object if state changed, original object otherwise
-------------------------------------------------------------------------------
function DisplayBase:changeState(obj, newState)
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

return DisplayBase
