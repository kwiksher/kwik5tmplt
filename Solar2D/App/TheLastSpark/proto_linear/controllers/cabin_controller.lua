local common = require("utils.common_helpers")
local cabinActions = require("actions.cabin")
local cabinConditions = require("conditions.cabin")

local M = {}

local function installCommonMethods(scene)
    local mt = getmetatable(scene) or {}
    mt.__index = function(t, k)
        return common.methods[k] or rawget(common.methods, k) or rawget(t, k)
    end
    setmetatable(scene, mt)
end

function M.attach(scene, env)
    env.state = env.state or { currentDialogueIndex = 1, isChoiceActive = false, choiceGroup = nil }
    env.objects = env.objects or {}
    env.conditions = cabinConditions.new()
    env.actions = cabinActions.new()

    scene._env = env
    installCommonMethods(scene)

    -- Extend the generic state change with cabin-specific flair
    function scene:changeObjectState(objectName, newState, onComplete)
        local changed = common.methods.changeObjectState(self, objectName, newState)

        local sceneEnv = self._env or {}
        local od = (sceneEnv.objects or {})[objectName]
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

        return changed
    end
end

return M
