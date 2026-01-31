-------------------------------------------------------------------------------
-- Scene Actions
-- Generic scene transition actions
-- Parses scene name from action and transitions using composer
-------------------------------------------------------------------------------
local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")
local composer = require("composer")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Debug flag - set to false to only show debug logs
M.DEBUG_ENABLED = true

-- Scene objects reference
local sceneObjects = {}

-- Override initialize to store scene objects
function M.initialize(objects)
    sceneObjects = objects
    M.sceneObjects = objects
end

-- Parse scene name from action string
-- Example: "goto buttonScene" -> "buttonScene"
--          "goto button" -> "buttonScene"
--          "goto animationScene" -> "animationScene"
local function parseSceneName(actionName)
    -- Extract the scene name after "goto "
    local sceneName = actionName:match("^goto%s+(.+)$")
    if sceneName then
        -- Only add "Scene" suffix if not already present
        if not sceneName:match("Scene$") then
            sceneName = sceneName .. "Scene"
        end
        return sceneName
    end
    return nil
end

-- Generic scene transition
function M.gotoScene(actionName)
    local sceneName = parseSceneName(actionName)

    if not sceneName then
        print("[ACTION] goto - ERROR: Could not parse scene name from: " .. tostring(actionName))
        return bt.FAILED
    end

    print("[ACTION] goto " .. sceneName)
    composer.gotoScene(sceneName, {
        effect = "fade",
        time = 300
    })
    return bt.SUCCESS
end

-- Handle reload action
function M.reload()
    print("[ACTION] scene reload")
    local currentScene = composer.getSceneName("current")
    if currentScene then
        -- Use recycleOnSceneChange to force scene recreation without removing
        -- This avoids the kwik framework cleanup that expects appName
        composer.recycleOnSceneChange = true
        composer.gotoScene(currentScene, {
            effect = "fade",
            time = 300,
            params = { reload = true }
        })
        return bt.SUCCESS
    else
        print("[ACTION] scene reload - ERROR: No current scene")
        return bt.FAILED
    end
end

-- Handle next action (go to empty scene)
function M.next()
    print("[ACTION] scene next")

    -- Get current scene to copy props if available
    local currentSceneName = composer.getSceneName("current")
    local currentScene = composer.getScene(currentSceneName)
    local params = {}

    -- Store the current scene name (Kwik component scene is fine)
    params.returnToScene = currentSceneName
    print("[scene_actions] Setting returnToScene to: " .. tostring(currentSceneName))

    -- If current scene has UI props, pass them to the next scene
    if currentScene and currentScene.UI and currentScene.UI.props then
        params.sceneProps = {
            UI = currentScene.UI,
            model = currentScene.model,
            getCommands = currentScene.getCommands,
            app = currentScene.app,
            classType = currentScene.classType
        }
    end

    composer.gotoScene("App.BTree_test.behaviorTree.views.emptyScene", {
        effect = "slideLeft",
        time = 300,
        params = params
    })

    return bt.SUCCESS
end

-- Main execute function
function M.execute(actionTarget)
    if not actionTarget then
        print("[ACTION] scene - ERROR: No action target specified")
        return bt.FAILED
    end

    -- Handle specific scene actions
    if actionTarget == "reload" then
        return M.reload()
    elseif actionTarget == "next" then
        return M.next()
    elseif actionTarget:match("^goto%s+") then
        return M.gotoScene(actionTarget)
    else
        print("[ACTION] scene - Unknown action: " .. tostring(actionTarget))
        return bt.FAILED
    end
end

return M
