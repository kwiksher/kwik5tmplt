local M = {}

function M.create()
    -- Scale factor to convert @4x coordinates to @1x
    local scale = 0.25
    return {
        states = {
            neutral = "App/TheLastSpark/assets/images/cabin/elara_neutral.png",
            scared = "App/TheLastSpark/assets/images/cabin/elara_scared.png",
            determined = "App/TheLastSpark/assets/images/cabin/elara_determined.png",
            happy = "App/TheLastSpark/assets/images/cabin/elara_happy.png",
            shocked = "App/TheLastSpark/assets/images/cabin/elara_shocked.png",
            panicking = "App/TheLastSpark/assets/images/cabin/elara_panicking.png",
        },
        x = 500 * scale,
        y = 300 * scale,
        width = 400 * scale,
        height = 600 * scale,
        currentState = "neutral",
        visible = false
    }
end

return M
