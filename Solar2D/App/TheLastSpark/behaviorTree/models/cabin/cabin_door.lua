local M = {}

function M.create()
    -- Scale factor to convert @4x coordinates to @1x
    local scale = 0.25
    return {
        states = {
            open = "App/TheLastSpark/assets/images/cabin/door_open.png",
            closed = "App/TheLastSpark/assets/images/cabin/door_closed.png",
            broken = "App/TheLastSpark/assets/images/cabin/door_broken.png",
            sealed = "App/TheLastSpark/assets/images/cabin/door_sealed.png",
        },
        x = 1600 * scale,
        y = 300 * scale,
        width = 220 * scale,
        height = 320 * scale,
        currentState = "closed",
        visible = true
    }
end

return M
