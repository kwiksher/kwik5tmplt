-- Elara Character Model
-- Data structure for Elara character

local M = {}

function M.create()
    -- Scale factor to convert @4x coordinates to @1x
    local scale = 0.25
    return {
        states = {
            neutral = "App/TheLastSpark/assets/images/forest/elara_neutral.png",
            scared = "App/TheLastSpark/assets/images/forest/elara_scared.png",
            determined = "App/TheLastSpark/assets/images/forest/elara_determined.png",
            happy = "App/TheLastSpark/assets/images/forest/elara_happy.png",
        },
        x = 450 * scale,
        y = 165 * scale,
        width = 450 * scale,
        height = 750 * scale,
        currentState = "neutral",
        visible = false
    }
end

return M