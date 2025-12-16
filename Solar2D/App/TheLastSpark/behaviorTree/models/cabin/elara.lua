local M = {}

function M.create()
    return {
        states = {
            neutral = "App/TheLastSpark/assets/images/cabin/elara_neutral.png",
            scared = "App/TheLastSpark/assets/images/cabin/elara_scared.png",
            determined = "App/TheLastSpark/assets/images/cabin/elara_determined.png",
            happy = "App/TheLastSpark/assets/images/cabin/elara_happy.png",
            shocked = "App/TheLastSpark/assets/images/cabin/elara_shocked.png",
            panicking = "App/TheLastSpark/assets/images/cabin/elara_panicking.png",
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
