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
    print("DEBUG DisplayBase:create - Creating object with state=" .. tostring(modelData.currentState))
    print("DEBUG DisplayBase:create - Image path=" .. tostring(modelData.states[modelData.currentState]))
    print("DEBUG DisplayBase:create - Position x=" .. tostring(modelData.x) .. ", y=" .. tostring(modelData.y))
    print("DEBUG DisplayBase:create - Size width=" .. tostring(modelData.width) .. ", height=" .. tostring(modelData.height))
    print("DEBUG DisplayBase:create - visible=" .. tostring(modelData.visible))

    local obj = displayManager.newImageRect(
        parentGroup,
        modelData.states[modelData.currentState], -- this is the image file path
        modelData.width,
        modelData.height
    )

    obj.x = modelData.x
    obj.y = modelData.y
    obj.isVisible = modelData.visible

    -- Store reference to model data
    obj.modelData = modelData

    print("DEBUG DisplayBase:create - Created object type=" .. type(obj) .. ", isVisible=" .. tostring(obj.isVisible))
    print("DEBUG DisplayBase:create - Object bounds: " .. tostring(obj.contentBounds and obj.contentBounds.xMin) .. "," .. tostring(obj.contentBounds and obj.contentBounds.yMin))

    return obj
end

-------------------------------------------------------------------------------
-- Changes the state of a display object
-- @param obj The display object to change
-- @param newState The new state to change to
-- @return New display object if state changed, original object otherwise
-------------------------------------------------------------------------------
function DisplayBase:changeState(obj, newState)
    print("DEBUG DisplayBase.changeState: obj type = " .. type(obj))
    print("DEBUG DisplayBase.changeState: newState = " .. tostring(newState))

    -- Store references before removing the object
    local modelData = obj.modelData
    print("DEBUG DisplayBase.changeState: modelData type = " .. type(modelData))

    local parent = obj.parent
    local x = obj.x
    local y = obj.y
    local isVisible = obj.isVisible

    if modelData and modelData.states and modelData.states[newState] then
        print("DEBUG DisplayBase.changeState: Found state, creating new image...")
        print("DEBUG DisplayBase.changeState: states[newState] = " .. tostring(modelData.states[newState]))

        obj:removeSelf()

        local newImage = displayManager.newImageRect(
            parent,
            modelData.states[newState],
            modelData.width,
            modelData.height
        )

        print("DEBUG DisplayBase.changeState: newImage type = " .. type(newImage))

        newImage.x = x
        newImage.y = y

        -- Update modelData properties based on new state
        newImage.modelData = modelData
        newImage.modelData.currentState = newState

        -- Set visibility: visible/collected/glowing/open states should be visible, hidden state should not
        local shouldBeVisible = (newState == "visible" or newState == "collected" or newState == "glowing" or newState == "open")
        newImage.isVisible = shouldBeVisible
        newImage.modelData.visible = shouldBeVisible

        -- Debug: Print detailed position and visibility info
        print("=== OBJECT DISPLAY DEBUG ===")
        print("Object state: " .. tostring(newState))
        print("Position: x=" .. tostring(newImage.x) .. ", y=" .. tostring(newImage.y))
        print("Dimensions: width=" .. tostring(newImage.width) .. ", height=" .. tostring(newImage.height))
        print("isVisible: " .. tostring(newImage.isVisible))
        print("alpha: " .. tostring(newImage.alpha))
        print("Parent: " .. tostring(newImage.parent))
        if newImage.parent then
            print("Parent isVisible: " .. tostring(newImage.parent.isVisible))
        end
        print("=========================")

        -- Bring to front to ensure visibility
        if shouldBeVisible and newImage.toFront then
            newImage:toFront()
            print("DEBUG DisplayBase.changeState: Brought newImage to front")
        end

        print("DEBUG DisplayBase.changeState: Returning newImage, type = " .. type(newImage))
        return newImage
    end

    print("DEBUG DisplayBase.changeState: Condition failed, returning original obj")
    return obj
end

return DisplayBase
