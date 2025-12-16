local M = {}

function M.create()
    return {
        states = {
            open = "App/TheLastSpark/assets/images/cabin/door_open.png",
            closed = "App/TheLastSpark/assets/images/cabin/door_closed.png",
            broken = "App/TheLastSpark/assets/images/cabin/door_broken.png",
            sealed = "App/TheLastSpark/assets/images/cabin/door_sealed.png",
        },
        x = 900,
        y = 380,
        width = 220,
        height = 320,
        currentState = "closed",
        visible = true
    }
end

return M
