-- Loose Floorboard Object Model
-- Hides the brass key

local M = {}

function M.create()
    return {
        states = {
            normal = "images/floorboard_normal.png",
            highlighted = "images/floorboard_highlighted.png",
            open = "images/floorboard_open.png",
        },
        x = 450,
        y = 650,
        width = 120,
        height = 80,
        currentState = "normal",
        visible = false
    }
end

return M
