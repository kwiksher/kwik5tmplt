-- Elara Character Model
-- Data structure for Elara character

local M = {}

function M.create()
    return {
        states = {
            neutral = "App/TheLastSpark/assets/images/forest/elara_neutral.png",
            scared = "App/TheLastSpark/assets/images/forest/elara_scared.png",
            determined = "App/TheLastSpark/assets/images/forest/elara_determined.png",
            happy = "App/TheLastSpark/assets/images/forest/elara_happy.png",
        },
        x = 300,
        y = 500,
        width = 300,
        height = 500,
        currentState = "neutral",
        visible = false
    }
end

return M