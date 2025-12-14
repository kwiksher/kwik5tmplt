-------------------------------------------------------------------------------
-- Action Helper - Common utilities for action modules
-- Provides base functionality that all action modules can inherit
-------------------------------------------------------------------------------

local bt = require("utils.btree")
local M = {}

-- Create a new action module with helper methods
-- Usage: local M = require("utils.action_helper").createModule()
function M.createModule()
    local actionModule = {}

    -- Scene objects reference (to be set by initialize)
    actionModule.sceneObjects = {}

    -- Action registry (to be populated by child module)
    actionModule.ACTIONS = {}

    -- Completion tracking: stores which actions have already executed this run
    actionModule._completedActions = {}

    -- Default initialize function
    function actionModule.initialize(objects)
        actionModule.sceneObjects = objects
    end

    -- Reset completion tracking (call when tree restarts)
    function actionModule.reset()
        actionModule._completedActions = {}
    end

    -- Execute an action only once per tree run
    -- actionKey: unique identifier for this action execution (e.g., action name + parameters)
    -- actionFunc: function to execute if not yet completed
    -- Returns: bt.SUCCESS if already completed or after successful execution
    function actionModule.executeOnce(actionKey, actionFunc)
        -- Check if already completed
        if actionModule._completedActions[actionKey] then
            return bt.SUCCESS
        end

        -- Execute the action
        local result = actionFunc()

        -- Mark as completed only if successful
        if result == bt.SUCCESS then
            actionModule._completedActions[actionKey] = true
        end

        return result
    end

    -- Helper: Check if an object exists in sceneObjects
    function actionModule.checkObject(objectName)
        if not actionModule.sceneObjects[objectName] then
            print("Error: " .. objectName .. " object not found")
            return false
        end
        return true
    end

    -- Helper: Show an object with fade-in transition
    function actionModule.showObject(objectName, fadeTime)
        if not actionModule.checkObject(objectName) then
            return bt.FAILED
        end

        fadeTime = fadeTime or 1000
        local obj = actionModule.sceneObjects[objectName]

        obj.isVisible = true
        obj.alpha = 0
        transition.fadeIn(obj, { time = fadeTime })

        print("Showing " .. objectName)
        return bt.SUCCESS
    end

    -- Helper: Hide an object with fade-out transition
    function actionModule.hideObject(objectName, fadeTime)
        if not actionModule.checkObject(objectName) then
            return bt.FAILED
        end

        fadeTime = fadeTime or 1000
        local obj = actionModule.sceneObjects[objectName]

        transition.fadeOut(obj, {
            time = fadeTime,
            onComplete = function()
                obj.isVisible = false
            end
        })

        print("Hiding " .. objectName)
        return bt.SUCCESS
    end

    -- Helper: Change object state using a display view module
    function actionModule.changeState(objectName, stateName, viewModule)
        if not actionModule.checkObject(objectName) then
            return bt.FAILED
        end

        if not viewModule or not viewModule.changeState then
            print("Error: Invalid view module for " .. objectName)
            return bt.FAILED
        end

        local obj = actionModule.sceneObjects[objectName]
        print("DEBUG changeState: Before - obj type: " .. type(obj))
        local newObj = viewModule:changeState(obj, stateName)
        print("DEBUG changeState: After changeState - newObj type: " .. type(newObj))
        actionModule.sceneObjects[objectName] = newObj
        print("DEBUG changeState: After assignment - sceneObjects[" .. objectName .. "] type: " .. type(actionModule.sceneObjects[objectName]))

        print("Changed " .. objectName .. " to " .. stateName)
        return bt.SUCCESS
    end

    -- Helper: Set object visibility
    function actionModule.setVisible(objectName, visible)
        if not actionModule.checkObject(objectName) then
            return bt.FAILED
        end

        actionModule.sceneObjects[objectName].isVisible = visible
        print("Set " .. objectName .. " visibility to " .. tostring(visible))
        return bt.SUCCESS
    end

    -- Helper: Move object to position with transition
    function actionModule.moveTo(objectName, x, y, time)
        if not actionModule.checkObject(objectName) then
            return bt.FAILED
        end

        time = time or 500
        local obj = actionModule.sceneObjects[objectName]

        transition.to(obj, {
            x = x,
            y = y,
            time = time
        })

        print("Moving " .. objectName .. " to (" .. x .. ", " .. y .. ")")
        return bt.SUCCESS
    end

    -- Helper: Scale object with transition
    function actionModule.scaleTo(objectName, xScale, yScale, time)
        if not actionModule.checkObject(objectName) then
            return bt.FAILED
        end

        time = time or 500
        yScale = yScale or xScale
        local obj = actionModule.sceneObjects[objectName]

        transition.to(obj, {
            xScale = xScale,
            yScale = yScale,
            time = time
        })

        print("Scaling " .. objectName .. " to (" .. xScale .. ", " .. yScale .. ")")
        return bt.SUCCESS
    end

    -- Helper: Rotate object with transition
    function actionModule.rotateTo(objectName, rotation, time)
        if not actionModule.checkObject(objectName) then
            return bt.FAILED
        end

        time = time or 500
        local obj = actionModule.sceneObjects[objectName]

        transition.to(obj, {
            rotation = rotation,
            time = time
        })

        print("Rotating " .. objectName .. " to " .. rotation .. " degrees")
        return bt.SUCCESS
    end

    -- Helper: Execute an action by name from the ACTIONS registry
    function actionModule.execute(actionName)
        if not actionName then
            print("Error: No action specified")
            return bt.FAILED
        end

        -- Look up action in registry
        if actionModule.ACTIONS[actionName] then
            return actionModule.ACTIONS[actionName]()
        else
            print("Error: Unknown action - " .. tostring(actionName))
            return bt.FAILED
        end
    end

    -- Helper: Load audio file
    function actionModule.loadAudio(soundName, filePath, isStream)
        if isStream then
            return audio.loadStream(filePath)
        else
            return audio.loadSound(filePath)
        end
    end

    -- Helper: Play audio
    function actionModule.playAudio(audioHandle, options)
        if not audioHandle then
            print("Error: Invalid audio handle")
            return bt.FAILED
        end

        audio.play(audioHandle, options or {})
        return bt.SUCCESS
    end

    -- Helper: Stop audio on channel
    function actionModule.stopAudio(channel)
        audio.stop(channel)
        print("Stopped audio on channel " .. tostring(channel))
        return bt.SUCCESS
    end

    -- Helper: Error handler for missing action
    function actionModule.handleUnknownAction(actionName, moduleName)
        print("Error: Unknown " .. (moduleName or "module") .. " action - " .. tostring(actionName))
        return bt.FAILED
    end

    return actionModule
end

-- Helper function to merge action registries
function M.mergeActions(target, source)
    for key, value in pairs(source) do
        target[key] = value
    end
end

-- Helper function to validate action module structure
function M.validateModule(module)
    local required = { "initialize", "execute" }

    for _, funcName in ipairs(required) do
        if type(module[funcName]) ~= "function" then
            print("Warning: Action module missing required function: " .. funcName)
            return false
        end
    end

    return true
end

-------------------------------------------------------------------------------
-- Action Controller Utilities
-- Generic functions for managing action modules and routing actions
-------------------------------------------------------------------------------

-- Parse action name into type and target
-- Supports formats: "type what" (e.g., "show elara", "sfx rustling")
-- Returns: actionType, actionWhat
function M.parseTreeAction(actionName)
    return string.match(actionName, "^(%S+)%s+(.+)$")
end

-- Parse module-style action name
-- Supports format: "module.action" (e.g., "elara.show", "audio.play")
-- Returns: moduleName, specificAction
function M.parseModuleAction(actionName)
    return string.match(actionName, "([^.]+)%.(.+)")
end

-- Parse compound action with character/target
-- Supports format: "character state" (e.g., "elara scared")
-- Returns: character, state
function M.parseCompoundAction(actionWhat)
    return string.match(actionWhat, "(%S+)%s+(.+)")
end

-- Load and initialize action modules from a list
-- modules: table of { name = "path.to.module" }
-- objects: scene objects to pass to initialize
-- Returns: table of loaded modules
function M.loadActionModules(modules, objects)
    local loadedModules = {}
    local count = 0

    -- Return empty table if modules is nil or not a table
    if not modules or type(modules) ~= "table" then
        print("No modules to load (modules is nil or not a table)")
        return loadedModules
    end

    for name, modulePath in pairs(modules) do
        local success, module = pcall(require, modulePath)
        if success then
            loadedModules[name] = module
            if module.initialize then
                module.initialize(objects)
            end
            count = count + 1
        else
            print("Error loading module " .. name .. ": " .. tostring(module))
        end
    end

    print("Loaded " .. count .. " action modules")
    return loadedModules
end

-- Execute action on a specific module
-- Returns: result (bt.SUCCESS, bt.FAILED, or false)
function M.executeOnModule(module, actionName, moduleName)
    if not module then
        print("Error: Module '" .. (moduleName or "unknown") .. "' not found")
        return false
    end

    if not module.execute then
        print("Error: Module '" .. (moduleName or "unknown") .. "' has no execute function")
        return false
    end

    return module.execute(actionName)
end-- Route action to appropriate module based on type mapping
-- typeMapping: table of { actionType = module }
-- Example: { show = actions.display, sfx = actions.audio }
function M.routeActionByType(actionType, actionWhat, typeMapping)
    local module = typeMapping[actionType]
    if module then
        return M.executeOnModule(module, actionWhat, actionType)
    else
        print("Error: Unknown action type - " .. tostring(actionType))
        return false
    end
end

-- Route action to module based on target mapping
-- targetMapping: table of { target = module }
-- Example: { elara = actions.elara, wolf = actions.wolf }
function M.routeActionByTarget(target, action, targetMapping)
    local module = targetMapping[target]

    if module then
        return M.executeOnModule(module, action, target)
    else
        print("Error: Unknown target - " .. tostring(target))
        return false
    end
end

-- Build a list of all available actions from loaded modules
-- Returns: sorted array of action names in "module.action" format
function M.buildActionList(modules)
    local actionList = {}

    for moduleName, module in pairs(modules) do
        if module.ACTIONS then
            for actionName, _ in pairs(module.ACTIONS) do
                table.insert(actionList, moduleName .. "." .. actionName)
            end
        end
    end

    table.sort(actionList)
    return actionList
end

-- Count loaded action modules
function M.countModules(modules)
    local count = 0
    for _ in pairs(modules) do
        count = count + 1
    end
    return count
end

-- Create a simple action router that handles multiple formats
-- Returns a router table with execute() function
function M.createActionRouter(modules, routingRules)
    local router = {
        modules = modules,
        rules = routingRules or {}
    }

    function router.execute(actionName)
        -- Try tree format (type what)
        local actionType, actionWhat = M.parseTreeAction(actionName)
        if actionType and actionWhat then
            return router.executeTreeAction(actionType, actionWhat)
        end

        -- Try module format (module.action)
        local moduleName, specificAction = M.parseModuleAction(actionName)
        if moduleName and specificAction then
            return M.executeOnModule(router.modules[moduleName], specificAction, moduleName)
        end

        print("Error: Unknown action format - " .. actionName)
        return false
    end

    function router.executeTreeAction(actionType, actionWhat)
        -- Look up routing rule for this action type
        local rule = router.rules[actionType]
        if not rule then
            print("Error: No routing rule for action type - " .. actionType)
            return false
        end

        -- Simple routing: direct module name
        if type(rule) == "string" then
            return M.executeOnModule(router.modules[rule], actionWhat, rule)
        end

        -- Complex routing: function that determines module
        if type(rule) == "function" then
            local targetModule, targetAction = rule(actionWhat, router.modules)
            if targetModule then
                return M.executeOnModule(targetModule, targetAction or actionWhat, "custom")
            end
        end

        -- Mapping routing: table of targets to modules
        if type(rule) == "table" then
            return M.routeActionByTarget(actionWhat, actionWhat, rule)
        end

        return false
    end

    return router
end

-------------------------------------------------------------------------------
-- Generic Execute Function for Action Controllers
-- Handles both tree format and module.action format with routing rules
-------------------------------------------------------------------------------

-- Create a complete execute function with routing configuration
-- config: {
--   modules = { name = module },
--   simpleRouting = { actionType = module },
--   complexRouting = { actionType = { handler = function or { target = module } } },
--   logPrefix = "Action Controller" (optional)
-- }
function M.createExecuteFunction(config)
    local modules = config.modules
    local simpleRouting = config.simpleRouting or {}
    local complexRouting = config.complexRouting or {}
    local logPrefix = config.logPrefix or "Action Controller"

    -- Debug: print what's in complexRouting
    print(logPrefix .. ": createExecuteFunction - complexRouting keys:")
    for key, _ in pairs(complexRouting) do
        print(logPrefix .. ":   - " .. key)
    end

    return function(actionName)
        -- Parse action name in various formats:
        -- 1. "type what" format from .tree file (e.g., "narration cabin_scene", "show luminseed")
        -- 2. "module.action" format (e.g., "elara.show")

        -- Try tree format (type what)
        local actionType, actionWhat = M.parseTreeAction(actionName)

        if actionType and actionWhat then
            print(logPrefix .. ": Executing tree action [" .. actionType .. " " .. actionWhat .. "]")

            -- Check simple routing first (direct type -> module mapping)
            if simpleRouting[actionType] then
                -- Special case: choice action needs the full action name for pattern matching
                if actionType == "choice" then
                    local fullActionName = actionType .. " " .. actionWhat
                    return M.executeOnModule(simpleRouting[actionType], fullActionName, actionType)
                else
                    return M.executeOnModule(simpleRouting[actionType], actionWhat, actionType)
                end
            end

            -- Check complex routing (target mapping or custom handler)
            if complexRouting[actionType] then
                local handler = complexRouting[actionType]

                -- Handler is a target mapping table
                if type(handler) == "table" then
                    print(logPrefix .. ": Found complex routing for '" .. actionType .. "', routing target: " .. actionWhat)
                    return M.routeActionByTarget(actionWhat, actionWhat, handler)
                end

                -- Handler is a custom function
                if type(handler) == "function" then
                    return handler(actionWhat, modules)
                end
            end

            print(logPrefix .. ": Unknown action type - " .. actionType)
            return false
        end

        -- Try module.action format
        local moduleName, specificAction = M.parseModuleAction(actionName)

        if moduleName and specificAction then
            print(logPrefix .. ": Executing " .. moduleName .. "." .. specificAction)
            return M.executeOnModule(modules[moduleName], specificAction, moduleName)
        end

        print(logPrefix .. ": Unknown action format - " .. actionName)
        return false
    end
end

-------------------------------------------------------------------------------
-- Factory Function for Default Action Controller Configuration
-- Creates a standard configuration template with common routing patterns
-------------------------------------------------------------------------------

-- Create a default action controller configuration
-- params: {
--   modules = { name = module } (required),
--   logPrefix = "Controller Name" (optional),
--   audioModule = module (optional, defaults to modules.audio),
--   uiModule = module (optional, defaults to modules.ui),
--   sceneModule = module (optional, defaults to modules.scene),
--   focusModule = module (optional, defaults to modules.focus),
--   additionalSimpleRouting = { type = module } (optional),
--   additionalComplexRouting = { type = handler } (optional)
-- }
function M.createDefaultConfig(params)
    local modules = params.modules
    local logPrefix = params.logPrefix or "Action Controller"

    -- Default module references
    local audioModule = params.audioModule or modules.audio
    local uiModule = params.uiModule or modules.ui
    local sceneModule = params.sceneModule or modules.scene
    local focusModule = params.focusModule or modules.focus

    local config = {
        modules = modules,
        logPrefix = logPrefix,
        simpleRouting = {},
        complexRouting = {}
    }

    -- Build simple routing with defaults
    if audioModule then
        config.simpleRouting.sfx = audioModule
        config.simpleRouting.vo = audioModule
        config.simpleRouting.music = audioModule
    end

    if uiModule then
        config.simpleRouting.narration = uiModule
        config.simpleRouting.choice = uiModule
    end

    if sceneModule then
        config.simpleRouting.scene = sceneModule
    end

    if focusModule then
        config.simpleRouting.focus = focusModule
    end

    -- Add default emotion handler (parses "character state" format)
    config.complexRouting.emotion = function(actionWhat, mods)
        local character, state = M.parseCompoundAction(actionWhat)
        if character and state then
            -- Try to find character module
            local characterModule = mods[character]
            if characterModule then
                return M.executeOnModule(characterModule, state, character)
            else
                print(logPrefix .. ": Unknown emotion character - " .. character)
                return false
            end
        else
            print(logPrefix .. ": Invalid emotion format - " .. actionWhat)
            return false
        end
    end

    -- Merge additional simple routing
    if params.additionalSimpleRouting then
        for actionType, module in pairs(params.additionalSimpleRouting) do
            config.simpleRouting[actionType] = module
        end
    end

    -- Merge additional complex routing
    if params.additionalComplexRouting then
        for actionType, handler in pairs(params.additionalComplexRouting) do
            config.complexRouting[actionType] = handler
        end
    end

    return config
end

-------------------------------------------------------------------------------
-- Complete Action Controller Setup
-- One-call setup for action controllers with minimal configuration
-------------------------------------------------------------------------------

-- Setup complete action controller with execute function
-- params: {
--   modulePaths = { name = "path.to.module" } (required),
--   objects = scene objects (required),
--   logPrefix = "Controller Name" (optional),
--   showMapping = { target = moduleName } (optional) e.g., { elara = "elara", wolf = "wolf" },
--   additionalSimpleRouting = { type = moduleName } (optional),
--   additionalComplexRouting = { type = handler } (optional)
-- }
-- Returns: { actions = modules, execute = function, getAction, listActions, getActionCount }
function M.setupActionController(params)
    local modulePaths = params.modulePaths
    local objects = params.objects
    local logPrefix = params.logPrefix or "Action Controller"

    -- Load all action modules
    local actions = M.loadActionModules(modulePaths, objects)
    print(logPrefix .. ": Loaded " .. M.countModules(actions) .. " consolidated action modules")

    -- Build complex routing
    local complexRouting = {}

    -- Add show mapping if provided
    if params.showMapping then
        local showRouting = {}
        for target, moduleName in pairs(params.showMapping) do
            showRouting[target] = actions[moduleName]
            print(logPrefix .. ": Show mapping: " .. target .. " -> " .. moduleName .. " (module: " .. tostring(actions[moduleName] ~= nil) .. ")")
        end
        complexRouting.show = showRouting
        print(logPrefix .. ": Registered 'show' complex routing with " .. M.countModules(showRouting) .. " targets")
    end

    -- Merge additional complex routing
    if params.additionalComplexRouting then
        for actionType, handler in pairs(params.additionalComplexRouting) do
            complexRouting[actionType] = handler
        end
    end

    -- Create configuration
    local config = M.createDefaultConfig({
        modules = actions,
        logPrefix = logPrefix,
        additionalSimpleRouting = params.additionalSimpleRouting,
        additionalComplexRouting = complexRouting
    })

    -- Create execute function
    local executeFunc = M.createExecuteFunction(config)

    -- Return controller interface
    return {
        actions = actions,
        execute = executeFunc,
        getAction = function(actionName)
            return actions[actionName]
        end,
        listActions = function()
            return M.buildActionList(actions)
        end,
        getActionCount = function()
            return M.countModules(actions)
        end
    }
end

-- Create a simple action controller from module paths
-- modulePaths: table of { name = "path.to.module" }
-- showMapping: table of { target = moduleName } (optional)
-- logPrefix: optional log prefix (default: "Action Controller")
-- Returns: a controller module with initialize, execute, getAction, listActions, getActionCount
function M.new(modulePaths, showMapping, logPrefix)
    local controller

    local M_controller = {}

    function M_controller.initialize(objects)
        controller = M.setupActionController({
            modulePaths = modulePaths,
            objects = objects,
            logPrefix = logPrefix or "Action Controller",
            showMapping = showMapping
        })
    end

    function M_controller.execute(actionName)
        return controller and controller.execute(actionName) or false
    end

    function M_controller.getAction(actionName)
        return controller and controller.getAction(actionName) or nil
    end

    function M_controller.listActions()
        return controller and controller.listActions() or {}
    end

    function M_controller.getActionCount()
        return controller and controller.getActionCount() or 0
    end

    return M_controller
end

return M
