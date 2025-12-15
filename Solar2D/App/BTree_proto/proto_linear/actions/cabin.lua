local M = {}

local function ensureGameData()
    _G.gameData = _G.gameData or {}
    return _G.gameData
end

function M.new()
    local actions = {}

    function actions.setHasKey()
        local g = ensureGameData()
        g.hasKey = true
        print("Action: Set hasKey = true")
    end

    function actions.setHasMagicKey()
        local g = ensureGameData()
        g.hasMagicKey = true
        print("Action: Set hasMagicKey = true")
    end

    function actions.markChestLooted()
        local g = ensureGameData()
        g.chestLooted = true
        print("Action: Chest marked as looted")
    end

    function actions.markChestInspected()
        local g = ensureGameData()
        g.inspectedChest = true
        print("Action: Chest marked as inspected")
    end

    function actions.unlockDoor()
        local g = ensureGameData()
        g.doorUnlocked = true
        print("Action: Door unlocked")
    end

    function actions.startTimer()
        local g = ensureGameData()
        g.startTime = os.time()
        print("Action: Timer started at", g.startTime)
    end

    function actions.incrementDoorAttempts()
        local g = ensureGameData()
        g.doorAttempts = (g.doorAttempts or 0) + 1
        print("Action: Door attempts =", g.doorAttempts)
    end

    function actions.givePlayerReward()
        local g = ensureGameData()
        g.gold = (g.gold or 0) + 100
        g.hasReward = true
        print("Action: Player received 100 gold")
    end

    return actions
end

return M
