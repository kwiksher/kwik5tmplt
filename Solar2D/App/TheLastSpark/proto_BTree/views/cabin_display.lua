-- Cabin Display View
-- Handles display logic for the cabin

local M = {}

function M.create(cabinData)
    -- Create cabin display object
    local cabinDisplay = {
        x = cabinData.x or display.contentCenterX,
        y = cabinData.y or display.contentCenterY,
        width = cabinData.width or 200,
        height = cabinData.height or 150,
        state = cabinData.state or "normal",
        visible = cabinData.visible or false
    }

    -- In a real implementation, this would create actual display objects
    -- cabinDisplay.object = display.newImage("images/cabin.png")
    -- cabinDisplay.object.x = cabinDisplay.x
    -- cabinDisplay.object.y = cabinDisplay.y

    print("Created cabin display at: " .. cabinDisplay.x .. ", " .. cabinDisplay.y)
    return cabinDisplay
end

function M.show(cabinDisplay)
    cabinDisplay.visible = true
    print("Showing cabin")
    return cabinDisplay
end

function M.hide(cabinDisplay)
    cabinDisplay.visible = false
    print("Hiding cabin")
    return cabinDisplay
end

function M.changeState(cabinDisplay, newState)
    cabinDisplay.state = newState
    print("Changed cabin state to: " .. newState)
    return cabinDisplay
end

return M