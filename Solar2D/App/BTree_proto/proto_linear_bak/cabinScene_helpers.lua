-- Cabin Scene Helpers - attaches common scene methods and keeps cabin-specific
-- object state visual effects (broken, shattered, glowing, pulsing)

local M = {}
local common = require("App.TheLastSpark.common_helpers")

function M.attach(scene, env)
    -- Ensure state container exists
    env.state = env.state or { currentDialogueIndex = 1, isChoiceActive = false, choiceGroup = nil }

    -- Define scene-specific condition registry
    env.conditions = {
        hasKey = function()
            return _G.gameData and _G.gameData.hasKey == true
        end,

        hasMagicKey = function()
            return _G.gameData and _G.gameData.hasMagicKey == true
        end,

        chestNotLooted = function()
            return not (_G.gameData and _G.gameData.chestLooted == true)
        end,

        doorUnlocked = function()
            return _G.gameData and _G.gameData.doorUnlocked == true
        end,

        inspectedChest = function()
            return _G.gameData and _G.gameData.inspectedChest == true
        end,

        -- Example: time-based condition
        thirtySecondsPassed = function()
            if not _G.gameData or not _G.gameData.startTime then
                return false
            end
            return (os.time() - _G.gameData.startTime) > 30
        end,

        -- Example: multiple prerequisites
        canOpenMagicDoor = function()
            local g = _G.gameData
            return g and g.hasKey and g.hasMagicKey and g.inspectedChest
        end,
    }

    -- Define scene-specific action registry
    env.actions = {
        setHasKey = function()
            _G.gameData = _G.gameData or {}
            _G.gameData.hasKey = true
            print("Action: Set hasKey = true")
        end,

        setHasMagicKey = function()
            _G.gameData = _G.gameData or {}
            _G.gameData.hasMagicKey = true
            print("Action: Set hasMagicKey = true")
        end,

        markChestLooted = function()
            _G.gameData = _G.gameData or {}
            _G.gameData.chestLooted = true
            print("Action: Chest marked as looted")
        end,

        markChestInspected = function()
            _G.gameData = _G.gameData or {}
            _G.gameData.inspectedChest = true
            print("Action: Chest marked as inspected")
        end,

        unlockDoor = function()
            _G.gameData = _G.gameData or {}
            _G.gameData.doorUnlocked = true
            print("Action: Door unlocked")
        end,

        startTimer = function()
            _G.gameData = _G.gameData or {}
            _G.gameData.startTime = os.time()
            print("Action: Timer started at", _G.gameData.startTime)
        end,

        incrementDoorAttempts = function()
            _G.gameData = _G.gameData or {}
            _G.gameData.doorAttempts = (_G.gameData.doorAttempts or 0) + 1
            print("Action: Door attempts =", _G.gameData.doorAttempts)
        end,

        -- Example: Complex action
        givePlayerReward = function()
            _G.gameData = _G.gameData or {}
            _G.gameData.gold = (_G.gameData.gold or 0) + 100
            _G.gameData.hasReward = true
            print("Action: Player received 100 gold")
        end,
    }

    -- Make sure these keys are present for common methods
    scene._env = env

    -- Install common methods via metatable
    local mt = getmetatable(scene) or {}
    mt.__index = function(t, k)
        return common.methods[k] or rawget(common.methods, k) or rawget(t, k)
    end
    setmetatable(scene, mt)

    -- Cabin-specific overrides/additions
    -- changeEmotion is now in common_helpers.lua

    -- Keep only cabin-specific visual effects; delegate generic work to common
    function scene:changeObjectState(objectName, newState, onComplete)
        -- First, perform the generic behavior (create/swap image, fade in)
        common.methods.changeObjectState(self, objectName, newState)

        -- Then, apply cabin-only effects for certain states
        local env = self._env or {}
        local od = (env.objects or {})[objectName]
        local img = od and od.image
        if img then
            if newState == "broken" or newState == "shattered" then
                transition.to(img, { time = 300, rotation = 5, transition = easing.continuousLoop })
                timer.performWithDelay(300, function() img.rotation = 0 end)
            end
            if newState == "glowing" or newState == "pulsing" then
                transition.to(img, { time = 800, xScale = 1.1, yScale = 1.1, alpha = 0.8, transition = easing.continuousLoop })
            end
        end

        if onComplete then
            timer.performWithDelay(600, onComplete)
        end
    end
end

return M
