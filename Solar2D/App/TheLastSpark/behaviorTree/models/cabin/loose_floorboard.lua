-- Loose Floorboard Object Model
-- Hides the brass key

local M = {}

function M.create()
    return {
        states = {
            normal = "images/floorboard_normal.png",
            visible = "images/floorboard_normal.png",
            highlighted = "images/floorboard_highlighted.png",
            open = "images/floorboard_open.png",
        },
        x = 512,  -- Center of typical 1024 width screen
        y = 384,  -- Center of typical 768 height screen
        width = 300,  -- Much larger for visibility
        height = 200,  -- Much larger for visibility
        currentState = "normal",
        visible = false
    }
end

return M
