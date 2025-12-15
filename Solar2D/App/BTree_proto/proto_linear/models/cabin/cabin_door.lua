local M = {}

function M.create()
    return {
        states = {
            open = "images/door_open.png",
            closed = "images/door_closed.png",
            broken = "images/door_broken.png",
        },
        x = 900,
        y = 380,
        width = 220,
        height = 320,
    }
end

return M
