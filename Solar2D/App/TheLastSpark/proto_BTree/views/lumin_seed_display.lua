-- Lumin Seed Display View
-- Handles display logic for the lumin seed

local M = {}

function M.create(seedData)
    -- Create lumin seed display object
    local seedDisplay = {
        x = seedData.x or display.contentCenterX,
        y = seedData.y or display.contentCenterY,
        width = seedData.width or 50,
        height = seedData.height or 50,
        state = seedData.state or "normal",
        visible = seedData.visible or false
    }

    -- In a real implementation, this would create actual display objects
    -- seedDisplay.object = display.newImage("images/lumin_seed.png")
    -- seedDisplay.object.x = seedDisplay.x
    -- seedDisplay.object.y = seedDisplay.y

    print("Created lumin seed display at: " .. seedDisplay.x .. ", " .. seedDisplay.y)
    return seedDisplay
end

function M.show(seedDisplay)
    seedDisplay.visible = true
    print("Showing lumin seed")
    return seedDisplay
end

function M.hide(seedDisplay)
    seedDisplay.visible = false
    print("Hiding lumin seed")
    return seedDisplay
end

function M.changeState(seedDisplay, newState)
    seedDisplay.state = newState
    print("Changed lumin seed state to: " .. newState)
    return seedDisplay
end

return M