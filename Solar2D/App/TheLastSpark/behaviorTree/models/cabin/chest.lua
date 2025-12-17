local M = {}

function M.create()
    -- Scale factor to convert @4x coordinates to @1x
    local scale = 0.25
    return {
        states = {
            locked = "App/TheLastSpark/assets/images/cabin/chest_locked.png",
            unlocked = "App/TheLastSpark/assets/images/cabin/chest_unlocked.png",
            open = "App/TheLastSpark/assets/images/cabin/chest_open.png",
            empty = "App/TheLastSpark/assets/images/cabin/chest_empty.png",
        },
        x = 200 * scale,
        y = 700 * scale,
        width = 170 * scale,
        height = 130 * scale,
        currentState = "locked",
        visible = false
    }
end

return M
