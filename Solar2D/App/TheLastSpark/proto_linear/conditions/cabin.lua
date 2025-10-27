local M = {}

local function gameData()
    return _G.gameData
end

function M.new()
    local conditions = {}

    function conditions.hasKey()
        local g = gameData()
        return g and g.hasKey == true
    end

    function conditions.hasMagicKey()
        local g = gameData()
        return g and g.hasMagicKey == true
    end

    function conditions.chestNotLooted()
        local g = gameData()
        return not (g and g.chestLooted == true)
    end

    function conditions.doorUnlocked()
        local g = gameData()
        return g and g.doorUnlocked == true
    end

    function conditions.inspectedChest()
        local g = gameData()
        return g and g.inspectedChest == true
    end

    function conditions.thirtySecondsPassed()
        local g = gameData()
        if not g or not g.startTime then
            return false
        end
        return (os.time() - g.startTime) > 30
    end

    function conditions.canOpenMagicDoor()
        local g = gameData()
        return g and g.hasKey and g.hasMagicKey and g.inspectedChest
    end

    return conditions
end

return M
