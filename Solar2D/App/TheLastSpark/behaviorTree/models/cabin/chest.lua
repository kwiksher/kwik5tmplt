local M = {}

function M.create()
    return {
        states = {
            locked = "images/chest_locked.png",
            unlocked = "images/chest_unlocked.png",
            open = "images/chest_open.png",
            empty = "images/chest_empty.png",
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
