-- Wolf Character Model
-- Data structure for wolf character

local M = {}

function M.create()
    -- Scale factor to convert @4x coordinates to @1x
    local scale = 0.25
    return {
        states = {
            normal = "App/TheLastSpark/assets/images/forest/wolf_normal.png",
            aggressive = "App/TheLastSpark/assets/images/forest/wolf_aggressive.png",
            calm = "App/TheLastSpark/assets/images/forest/wolf_calm.png",
            retreating = "App/TheLastSpark/assets/images/forest/wolf_retreating.png",
        },
        x = 1320 * scale,
        y = 165 * scale,
        width = 600 * scale,
        height = 450 * scale,
        currentState = "normal",
        visible = false
    }
end

return M