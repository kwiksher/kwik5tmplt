local M = {}

function M.create()
    return {
        states = {
            locked = "App/TheLastSpark/assets/images/cabin/chest_locked.png",
            unlocked = "App/TheLastSpark/assets/images/cabin/chest_unlocked.png",
            open = "App/TheLastSpark/assets/images/cabin/chest_open.png",
            empty = "App/TheLastSpark/assets/images/cabin/chest_empty.png",
        },
        x = 600,
        y = 420,
        width = 170,
        height = 130,
        currentState = "locked",
        visible = false
    }
end

return M
