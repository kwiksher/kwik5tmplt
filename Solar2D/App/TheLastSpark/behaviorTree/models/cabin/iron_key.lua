-- Iron Key Object Model
-- Used to unlock the cabin door

local M = {}

function M.create()
    return {
        states = {
            hidden = "App/TheLastSpark/assets/images/cabin/iron_key_hidden.png",
            visible = "App/TheLastSpark/assets/images/cabin/iron_key.png",
            collected = "App/TheLastSpark/assets/images/cabin/iron_key_collected.png",
        },
        x = 850,
        y = 300,
        width = 50,
        height = 80,
        currentState = "hidden",
        visible = false,
        collected = false
    }
end

return M
