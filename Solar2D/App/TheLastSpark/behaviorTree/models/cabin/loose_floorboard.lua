-- Loose Floorboard Object Model
-- Hides the brass key

local M = {}

function M.create(scale)
    -- Scale factor to convert @4x coordinates to @1x
    scale = scale or 0.25
    return {
        states = {
            normal = "App/TheLastSpark/assets/images/cabin/floorboard_normal.png",
            visible = "App/TheLastSpark/assets/images/cabin/floorboard_normal.png",
            highlighted = "App/TheLastSpark/assets/images/cabin/floorboard_highlighted.png",
            open = "App/TheLastSpark/assets/images/cabin/floorboard_open.png",
        },
        x = 900 * scale,
        y = 650 * scale,
        width = 120 * scale,
        height = 80 * scale,
        currentState = "normal",
        visible = false
    }
end

return M
