-- Display Manager
-- Coordinates all display components for the BTree forest scene
-- Manages creation, positioning, removal, and transitions of display objects

local M = {}

-- Display component references
local displayComponents = {}
local sceneGroup = nil
local currentFocus = nil

-- Display states
local DISPLAY_STATES = {
    FOREST = "forest",
    CABIN_FOCUS = "cabin_focus",
    WOLF_FOCUS = "wolf_focus",
    ELARA_FOCUS = "elara_focus",
    CHOICE = "choice"
}

-- Transition types
local TRANSITION_TYPES = {
    FADE = "fade",
    SLIDE = "slide",
    ZOOM = "zoom",
    NONE = "none"
}

-- Initialize the display manager
function M.initialize(parentGroup)
    sceneGroup = parentGroup
    displayComponents = {}
    currentFocus = DISPLAY_STATES.FOREST

    print("Display Manager: Initialized with parent group")
    return true
end

-- Load all display components
function M.loadDisplayComponents(models)
    if not sceneGroup then
        print("Display Manager: Error - Scene group not initialized")
        return false
    end

    -- Load display modules
    local elaraDisplay = require("views.elara_display")
    local wolfDisplay = require("views.wolf_display")
    local luminSeedDisplay = require("views.lumin_seed_display")
    local cabinDisplay = require("views.cabin_display")

    -- Create display objects
    displayComponents.elara = elaraDisplay.create(sceneGroup, models.elara)
    displayComponents.wolf = wolfDisplay.create(sceneGroup, models.wolf)
    displayComponents.luminSeed = luminSeedDisplay.create(models.luminSeed)
    displayComponents.cabin = cabinDisplay.create(models.cabin)

    -- Initialize all as hidden
    M.hideAll()

    print("Display Manager: Loaded all display components")
    return displayComponents
end

-- Get display components
function M.getDisplayComponents()
    return displayComponents
end

-- Show specific element
function M.showElement(elementName, transitionType)
    if not displayComponents[elementName] then
        print("Display Manager: Element not found - " .. elementName)
        return false
    end

    if displayComponents[elementName].isVisible ~= nil then
        -- For Solar2D display objects
        displayComponents[elementName].isVisible = true
    else
        -- For custom display objects
        displayComponents[elementName].visible = true
    end

    print("Display Manager: Showing " .. elementName .. " with transition: " .. (transitionType or TRANSITION_TYPES.NONE))
    return true
end

-- Hide specific element
function M.hideElement(elementName, transitionType)
    if not displayComponents[elementName] then
        print("Display Manager: Element not found - " .. elementName)
        return false
    end

    if displayComponents[elementName].isVisible ~= nil then
        -- For Solar2D display objects
        displayComponents[elementName].isVisible = false
    else
        -- For custom display objects
        displayComponents[elementName].visible = false
    end

    print("Display Manager: Hiding " .. elementName .. " with transition: " .. (transitionType or TRANSITION_TYPES.NONE))
    return true
end

-- Hide all elements
function M.hideAll()
    for name, component in pairs(displayComponents) do
        if component.isVisible ~= nil then
            component.isVisible = false
        else
            component.visible = false
        end
    end
    print("Display Manager: All elements hidden")
end

-- Focus on wolf (camera/attention focus)
function M.focusOnWolf()
    currentFocus = DISPLAY_STATES.WOLF_FOCUS

    -- Hide other elements
    M.hideElement("elara")
    M.hideElement("cabin")
    M.hideElement("luminSeed")

    -- Show wolf
    M.showElement("wolf", TRANSITION_TYPES.ZOOM)

    -- In a real implementation, this would animate camera to wolf position
    -- transition.to(sceneGroup, {x = -displayComponents.wolf.x + display.contentCenterX, y = -displayComponents.wolf.y + display.contentCenterY, time = 1000})

    print("Display Manager: Focused on wolf")
    return true
end

-- Focus on Elara
function M.focusOnElara()
    currentFocus = DISPLAY_STATES.ELARA_FOCUS

    -- Hide other elements
    M.hideElement("wolf")
    M.hideElement("cabin")
    M.hideElement("luminSeed")

    -- Show Elara
    M.showElement("elara", TRANSITION_TYPES.ZOOM)

    -- In a real implementation, this would animate camera to Elara position
    -- transition.to(sceneGroup, {x = -displayComponents.elara.x + display.contentCenterX, y = -displayComponents.elara.y + display.contentCenterY, time = 1000})

    print("Display Manager: Focused on Elara")
    return true
end

-- Focus on cabin
function M.focusOnCabin()
    currentFocus = DISPLAY_STATES.CABIN_FOCUS

    -- Hide other elements
    M.hideElement("wolf")
    M.hideElement("elara")
    M.hideElement("luminSeed")

    -- Show cabin
    M.showElement("cabin", TRANSITION_TYPES.ZOOM)

    -- In a real implementation, this would animate camera to cabin position
    -- transition.to(sceneGroup, {x = -displayComponents.cabin.x + display.contentCenterX, y = -displayComponents.cabin.y + display.contentCenterY, time = 1000})

    print("Display Manager: Focused on cabin")
    return true
end

-- Show forest scene (default state)
function M.showForestScene()
    currentFocus = DISPLAY_STATES.FOREST

    -- Show all elements in their default positions
    M.showElement("elara", TRANSITION_TYPES.FADE)
    M.showElement("wolf", TRANSITION_TYPES.FADE)
    M.showElement("cabin", TRANSITION_TYPES.FADE)
    M.showElement("luminSeed", TRANSITION_TYPES.FADE)

    -- Reset camera position
    -- transition.to(sceneGroup, {x = 0, y = 0, time = 1000})

    print("Display Manager: Showing forest scene")
    return true
end

-- Change element state (e.g., Elara to scared state)
function M.changeElementState(elementName, newState)
    if not displayComponents[elementName] then
        print("Display Manager: Element not found - " .. elementName)
        return false
    end

    -- Check if the display module has changeState function
    local displayModule = require("views." .. elementName .. "_display")
    if displayModule and displayModule.changeState then
        displayComponents[elementName] = displayModule.changeState(displayComponents[elementName], newState)
        print("Display Manager: Changed " .. elementName .. " state to " .. newState)
        return true
    else
        print("Display Manager: changeState not supported for " .. elementName)
        return false
    end
end

-- Get current focus state
function M.getCurrentFocus()
    return currentFocus
end

-- Check if element is visible
function M.isElementVisible(elementName)
    if not displayComponents[elementName] then
        return false
    end

    if displayComponents[elementName].isVisible ~= nil then
        return displayComponents[elementName].isVisible
    else
        return displayComponents[elementName].visible
    end
end

-- Clean up display manager
function M.cleanup()
    for name, component in pairs(displayComponents) do
        if component.removeSelf then
            component:removeSelf()
        end
    end
    displayComponents = {}
    sceneGroup = nil
    currentFocus = nil

    print("Display Manager: Cleaned up all display components")
end

-- Export display states and transition types for external use
M.DISPLAY_STATES = DISPLAY_STATES
M.TRANSITION_TYPES = TRANSITION_TYPES

return M