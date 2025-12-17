-- Iron Key Object Model
-- Used to unlock the cabin door

local M = {}

function M.create()
    -- Scale factor to convert @4x coordinates to @1x
    local scale = 0.25
    return {
        states = {
            hidden = "App/TheLastSpark/assets/images/cabin/iron_key_hidden.png",
            visible = "App/TheLastSpark/assets/images/cabin/iron_key.png",
            collected = "App/TheLastSpark/assets/images/cabin/iron_key_collected.png",
        },
        x = 1700 * scale,
        y = 900 * scale,
        width = 50 * scale,
        height = 50 * scale,
        currentState = "hidden",
        visible = false,
        collected = false
    }
end

return M
