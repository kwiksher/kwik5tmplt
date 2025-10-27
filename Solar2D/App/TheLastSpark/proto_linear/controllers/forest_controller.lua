local common = require("utils.common_helpers")
local forestActions = require("actions.forest")
local forestConditions = require("conditions.forest")

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
    env.conditions = forestConditions.new()
    env.actions = forestActions.new()

    scene._env = env
    installCommonMethods(scene)

    function scene:showObject(object)
        local sceneEnv = self._env or {}
        if object == "elara" then
            local elara = sceneEnv.elara
            if elara then transition.fadeIn(elara, { time = 1000 }) end
        elseif object == "luminseed" then
            local luminSeed = sceneEnv.luminSeed
            if luminSeed then
                luminSeed.isVisible = true
                transition.scaleTo(luminSeed, { xScale = 1.2, yScale = 1.2, time = 500 })
                transition.scaleTo(luminSeed, { xScale = 1.0, yScale = 1.0, time = 500, delay = 500 })
            end
        elseif object == "wolf" then
            local wolf = sceneEnv.wolf
            if wolf then
                wolf.isVisible = true
                transition.from(wolf, { x = 1400, time = 800, transition = easing.outBack })
            end
        else
            common.methods.showObject(self, object)
        end
    end

    function scene:transitionToNextScene()
        common.gotoSceneByChoice({
            [1] = "scenes.fightScene",
            [2] = "scenes.calmScene",
            default = "scenes.retreatScene",
        }, { effect = "fade", time = 1000 })
    end
end

return M
