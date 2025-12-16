-- Wolf Character Model
-- Data structure for wolf character

local M = {}

function M.create()
    return {
        states = {
            normal = "App/TheLastSpark/assets/images/forest/wolf_normal.png",
            aggressive = "App/TheLastSpark/assets/images/forest/wolf_aggressive.png",
            calm = "App/TheLastSpark/assets/images/forest/wolf_calm.png",
            retreating = "App/TheLastSpark/assets/images/forest/wolf_retreating.png",
        },
        x = 800,
        y = 400,
        width = 400,
        height = 300,
        currentState = "normal",
        visible = false
    }
end

return M