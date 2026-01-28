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

    print("[ACTION] goto - going to: " .. sceneName)

    -- Map scene names to their full paths
    -- Check if uiHandler has enableBehaviorTree for component-based paths
    local uiHandler = pcall(require, "App.uiHandler") and require("App.uiHandler")
    local useComponentPaths = uiHandler and uiHandler.enableBehaviorTree

    local scenePathMap
    if useComponentPaths then
        scenePathMap = {
            buttonScene = "App.BTree_test.components.button.index",
            animationScene = "App.BTree_test.components.animation.index",
        }
    else
        scenePathMap = {
            buttonScene = "views.button.buttonScene",
            animationScene = "views.animation.animationScene",
        }
    end

    local fullScenePath = scenePathMap[sceneName] or ("views." .. sceneName)

    print("[ACTION] goto - Using path: " .. fullScenePath .. " (useComponentPaths=" .. tostring(useComponentPaths) .. ")")

    -- Check if we're already on the target scene
    local currentScene = composer.getSceneName("current")
    if currentScene == fullScenePath then
        print("[ACTION] goto - Already on scene " .. fullScenePath .. ", skipping transition")
        return bt.SUCCESS
    end

    if M.DEBUG_ENABLED then
        composer.gotoScene(fullScenePath, {
            effect = "fade",
            time = 500
        })
    else
        print("DEBUG: Would transition to " .. fullScenePath .. " with fade effect")
    end

    return bt.SUCCESS
end

-- Execute function for action controller
function M.execute(actionName)
    -- When using simpleRouting, we receive just the scene name (e.g., "buttonScene")
    -- When not using routing, we receive full action (e.g., "goto buttonScene")

    -- Check if this is a goto action with prefix
    if actionName:match("^goto%s+") then
        return M.gotoScene(actionName)
    else
        -- Assume it's just the scene name, construct the full action
        local fullAction = "goto " .. actionName
        return M.gotoScene(fullAction)
    end
end

return M
