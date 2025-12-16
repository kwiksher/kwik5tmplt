-- Loose Floorboard Object Model
-- Hides the brass key

local M = {}

function M.create()
    return {
        states = {
            normal = "App/TheLastSpark/assets/images/cabin/floorboard_normal.png",
            visible = "App/TheLastSpark/assets/images/cabin/floorboard_normal.png",
            highlighted = "App/TheLastSpark/assets/images/cabin/floorboard_highlighted.png",
            open = "App/TheLastSpark/assets/images/cabin/floorboard_open.png",
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
