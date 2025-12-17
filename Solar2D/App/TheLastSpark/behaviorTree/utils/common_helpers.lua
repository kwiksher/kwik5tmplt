-------------------------------------------------------------------------------
-- Common Helpers - shared utilities across proto_linear scenes
-------------------------------------------------------------------------------

local M = {}
local composer = composer or require("composer")
local widget = require("widget")

local function deepCopy(value)
    if type(value) ~= "table" then
        return value
    end

    local copy = {}
    for k, v in pairs(value) do
        copy[k] = deepCopy(v)
    end
    return copy
end

local IGNORED_MODEL_FIELDS = {
    image = true,
    displayModule = true,
    parentGroup = true,
}

local function cloneModelData(value)
    if type(value) ~= "table" then
        return value
    end

    local copy = {}
    for k, v in pairs(value) do
        if not IGNORED_MODEL_FIELDS[k] then
            copy[k] = cloneModelData(v)
        end
    end
    return copy
end

function M.deepCopy(value)
    return deepCopy(value)
end

function M.buildDisplayModel(template, layoutData, overrides)
    local modelData = deepCopy(template or {})

    layoutData = layoutData or {}
    for key, value in pairs(layoutData) do
        if type(key) == "string" and key:match("State$") then
            modelData.defaultImage = value or modelData.defaultImage
        else
            modelData[key] = deepCopy(value)
        end
    end

    if overrides then
        for key, value in pairs(overrides) do
            modelData[key] = deepCopy(value)
        end
    end

    return modelData
end

-- Create a character/object display from model and layout data
-- Uses DisplayBase as a static class for all display objects
-- @param objectName: string - name of the object (e.g., "elara", "wolf")
-- @param model: table - model data containing objects[objectName]
-- @param layout: table - layout data containing objects[objectName]
-- @param parentGroup: display group - parent display group to add the object to
-- @param overrides: table (optional) - additional overrides for the model data
-- @return: created display object
function M.createCharacter(objectName, model, layout, parentGroup, overrides)
    local template = (model.objects or {})[objectName] or {}
    local layoutData = (layout.objects or {})[objectName] or {}
    local modelData = M.buildDisplayModel(template, layoutData, overrides or { visible = false })
    --
    print("DEBUG createCharacter: objectName=" .. objectName .. ", currentState=" .. tostring(modelData.currentState) .. ", visible=" .. tostring(modelData.visible))
    if M._env.UI then
      print("DEBUG createCharacter: Using Kwik UI mode")
      local lookupName = objectName.."_"..modelData.currentState
      local obj = M._env.UI.sceneGroup[lookupName]
      print("DEBUG createCharacter: Looking for '" .. lookupName .. "' in UI.sceneGroup: " .. tostring(obj ~= nil))

      -- If not found with state suffix, try without it (for Kwik components without state)
      if not obj then
        obj = M._env.UI.sceneGroup[objectName]
        print("DEBUG createCharacter: Looking for '" .. objectName .. "' in UI.sceneGroup: " .. tostring(obj ~= nil))
      end

      if obj then
        print("DEBUG createCharacter: Found existing object in UI.sceneGroup")
        print("DEBUG createCharacter: UI object BEFORE - x=" .. tostring(obj.x) .. ", y=" .. tostring(obj.y) .. ", isVisible=" .. tostring(obj.isVisible) .. ", alpha=" .. tostring(obj.alpha))
        print("DEBUG createCharacter: UI object width=" .. tostring(obj.width) .. ", height=" .. tostring(obj.height))
        print("DEBUG createCharacter: UI object parent=" .. tostring(obj.parent) .. ", parent.isVisible=" .. tostring(obj.parent and obj.parent.isVisible))
        print("DEBUG createCharacter: Target parentGroup=" .. tostring(parentGroup))

        -- Remove from current parent and add to the behavior tree's parentGroup
        if parentGroup and obj.parent ~= parentGroup then
          print("DEBUG createCharacter: Reparenting object to characterGroup")
          parentGroup:insert(obj)
          print("DEBUG createCharacter: After reparenting - new parent=" .. tostring(obj.parent))
        else
          print("DEBUG createCharacter: No reparenting needed (already in correct parent or no parentGroup)")
        end

        print("@@@@@", display.contentWidth, display.contentHeight)
        if M._env.UI.props.editing  then
          obj.x = modelData.x + (display.contentWidth - 480)/2 + display.contentCenterX
          obj.y = modelData.y + (display.contentHeight - 320)/2 + display.contentCenterY
        end
        obj.isVisible = modelData.visible
        -- Store reference to model data
        obj.modelData = modelData
        print("DEBUG createCharacter: Returning UI object, isVisible=" .. tostring(obj.isVisible) .. ", new position x=" .. tostring(obj.x) .. ", y=" .. tostring(obj.y))
        return obj
      else
        print("DEBUG createCharacter: Object not found, creating via DisplayBase")
        local DisplayBase = require("views.display_base")
        local newObj = DisplayBase:create(parentGroup, modelData)
        print("DEBUG createCharacter: Created DisplayBase object, type=" .. type(newObj) .. ", isVisible=" .. tostring(newObj and newObj.isVisible))
        if M._env.UI.props.editing  then
          newObj.x = modelData.x + (display.contentWidth - 480)/2 + display.contentCenterX
          newObj.y = modelData.y + (display.contentHeight - 320)/2 + display.contentCenterY
        end
        return newObj
      end
    else
      print("DEBUG createCharacter: Using pure BehaviorTree mode (no UI)")
      local DisplayBase = require("views.display_base")
      local obj =  DisplayBase:create(parentGroup, modelData)
          obj.x = modelData.x + (display.contentWidth - 480)/2
          obj.y = modelData.y + (display.contentHeight - 320)/2
      return obj
    end
end

-- Methods table for setmetatable __index usage. Each method expects self._env.
M.methods = {}

function M.methods:executeSceneStep(index)
    local env = self._env or {}
    local dialogue = env.sceneDialogue or {}
    local audioFiles = env.audioFiles
    local IMAGE_PATH = env.imagePath or "images/"

    local state = env.state or {}
    state.currentDialogueIndex = index

    if index > #dialogue then return end
    local step = dialogue[index]

    if step.type == "narration" then
        self:showDialogue(step.text)
        -- For simple narration without audio, show button blinking after text renders
        -- Estimate reading time: ~50ms per character
        local textLength = step.text and #step.text or 0
        local readingTime = math.max(1000, textLength * 50)
        timer.performWithDelay(readingTime, function()
            self:showNextButtonBlinking()
        end)

    elseif step.type == "show" then
        self:showObject(step.what)
        timer.performWithDelay(500, function()
            self:executeSceneStep(index + 1)
        end)

    elseif step.type == "scene" then
        self:changeBackground(IMAGE_PATH .. step.background .. ".png")
        timer.performWithDelay(500, function()
            self:executeSceneStep(index + 1)
        end)

    elseif step.type == "sfx" then
        self:playSFX(step.sound, step.loop)
        self:executeSceneStep(index + 1)

    elseif step.type == "vo" then
        self:showDialogue(step.text)
        self:playSFX(step.sound)
        -- playSFX will handle showing the button when audio completes

    elseif step.type == "music" then
        if step.action == "play" and audioFiles then
            local path = audioFiles[step.sound]
            if path then
                audio.play(audio.loadStream(path), { channel = 1, loops = -1 })
            end
        end
        self:executeSceneStep(index + 1)

    elseif step.type == "emotion" then
        self:changeEmotion(step.character, step.state)
        self:executeSceneStep(index + 1)

    elseif step.type == "object_state" then
        if step.object then self:changeObjectState(step.object, step.state) end
        if step.objects then
            for _, objName in ipairs(step.objects) do
                self:changeObjectState(objName, step.state)
            end
        end
        self:executeSceneStep(index + 1)

    elseif step.type == "object_state_conditional" then
        if step.object then self:changeObjectStateConditional(step.object, step.state, step.condition) end
        if step.objects then
            for _, objName in ipairs(step.objects) do
                self:changeObjectStateConditional(objName, step.state, step.condition)
            end
        end
        self:executeSceneStep(index + 1)

    elseif step.type == "custom" then
        -- Execute custom action/function
        if step.action then
            if self.executeAction then
                -- Use scene-specific action execution (supports string lookup)
                self:executeAction(step.action)
            elseif type(step.action) == "function" then
                -- Fallback: direct function call
                step.action()
            elseif type(step.action) == "string" then
                print("Warning: Action string '" .. step.action .. "' provided but scene has no executeAction method!")
            end
        end
        self:executeSceneStep(index + 1)

    elseif step.type == "choice" then
        self:showChoice(step.options)
    end
end

function M.methods:advanceDialogue()
    local env = self._env or {}
    local state = env.state or { currentDialogueIndex = 0 }
    local nextButton = env.nextButton
    if nextButton then
        nextButton.isVisible = false
        -- Stop any existing blink animation
        if state.blinkTransition then
            transition.cancel(state.blinkTransition)
            state.blinkTransition = nil
        end
    end
    self:executeSceneStep((state.currentDialogueIndex or 0) + 1)
end

function M.methods:showDialogue(text)
    local env = self._env or {}
    local dialogueText = env.dialogueText
    local nextButton = env.nextButton
    local state = env.state or {}

    if dialogueText then dialogueText.text = text or "" end

    if nextButton then
        -- Hide button initially during narration
        nextButton.isVisible = false
        nextButton.alpha = 1.0

        -- Stop any existing blink animation
        if state.blinkTransition then
            transition.cancel(state.blinkTransition)
            state.blinkTransition = nil
        end
    end
end

-- Make the next button blink after narration/audio completes
function M.methods:showNextButtonBlinking()
    local env = self._env or {}
    local nextButton = env.nextButton
    local state = env.state or {}

    if not nextButton then return end

    -- Stop any existing blink animation
    if state.blinkTransition then
        transition.cancel(state.blinkTransition)
    end

    -- Make button visible and start blinking
    nextButton.isVisible = true
    nextButton.alpha = 1.0

    -- Create infinite blinking effect
    local function blinkCycle()
        state.blinkTransition = transition.to(nextButton, {
            alpha = 0.3,
            time = 500,
            onComplete = function()
                if nextButton and nextButton.removeSelf then
                    state.blinkTransition = transition.to(nextButton, {
                        alpha = 1.0,
                        time = 500,
                        onComplete = blinkCycle
                    })
                end
            end
        })
    end

    blinkCycle()
end

function M.methods:changeBackground(imagePath)
    local env = self._env or {}
    local background = env.background
    local vignette = env.vignette
    if not background then return end
    transition.fadeOut(background, { time = 800 })
    timer.performWithDelay(800, function()
        if background.numChildren and background.numChildren > 0 then
            pcall(function() background:remove(1) end)
        end
        local newBg = display.newImageRect(background, imagePath, display.actualContentWidth or 320, display.actualContentHeight or 480)
        newBg.x = display.contentCenterX
        newBg.y = display.contentCenterY
        newBg.alpha = 0
        if vignette then background:insert(1, vignette) end
        transition.fadeIn(newBg, { time = 800 })
    end)
end

function M.methods:playSFX(soundName, shouldLoop)
    local env = self._env or {}
    local audioFiles = env.audioFiles
    local options = { channel = 2 }
    if shouldLoop then options.loops = -1 end
    local path = audioFiles and audioFiles[soundName]
    if path then
        local audioHandle = audio.loadSound(path)
        audio.play(audioHandle, options)

        -- If not looping, track audio duration and show button when done
        if not shouldLoop then
            local duration = audio.getDuration(audioHandle)
            if duration and duration > 0 then
                timer.performWithDelay(duration, function()
                    self:showNextButtonBlinking()
                end)
            else
                -- Fallback if duration can't be determined
                timer.performWithDelay(1000, function()
                    self:showNextButtonBlinking()
                end)
            end
        end
    end
end

-- Generic object visibility helper using the scene's objects registry
function M.methods:showObject(name)
    local env = self._env or {}
    local objects = env.objects or {}
    local od = objects[name]
    if od and od.image then
        od.image.isVisible = true
        od.visible = true
    end
end

-- Generic object state change: swap image for a named object/state
-- Expects env.objects[objectName] = { states={ [state]=imagePath }, width,height,x,y, image? }
function M.methods:changeObjectState(objectName, newState, onComplete)
    local env = self._env or {}
    local objects = env.objects or {}
    local characterGroup = env.characterGroup or self.view
    local objectData = objects[objectName]
    if not objectData then
        print("Warning: Object '" .. tostring(objectName) .. "' not found!")
        return false
    end

    local stateImage = objectData.states and objectData.states[newState]
    if not stateImage then
        print("Warning: State '" .. tostring(newState) .. "' not found for object '" .. tostring(objectName) .. "'!")
        return false
    end

    local parentGroup = objectData.parentGroup or characterGroup or self.view
    if not parentGroup then
        print("Warning: No display group available for object '" .. tostring(objectName) .. "'")
        return false
    end

    local factory = objectData.displayModule
    local previousImage = objectData.image
    local wasVisible = true
    local oldX, oldY, oldW, oldH

    if previousImage then
        wasVisible = previousImage.isVisible ~= false
        oldX, oldY = previousImage.x, previousImage.y
        oldW, oldH = previousImage.width, previousImage.height
        pcall(function() previousImage:removeSelf() end)
    elseif objectData.visible ~= nil then
        wasVisible = objectData.visible
    end

    local modelData
    if factory and type(factory.create) == "function" then
        modelData = cloneModelData(objectData)
        modelData.defaultImage = stateImage
        modelData.visible = wasVisible
    end

    local newImage
    if modelData then
        newImage = factory.create(parentGroup, modelData)
    else
        local width = objectData.width or oldW or 100
        local height = objectData.height or oldH or 100
        newImage = display.newImageRect(parentGroup, stateImage, width, height)
        newImage.x = objectData.x or oldX or display.contentCenterX
        newImage.y = objectData.y or oldY or display.contentCenterY
    end

    if not newImage then
        print("Warning: Failed to create display for object '" .. tostring(objectName) .. "'")
        return false
    end

    if wasVisible then
        newImage.isVisible = true
        newImage.alpha = 0
        transition.fadeIn(newImage, { time = 500 })
    else
        newImage.isVisible = false
        newImage.alpha = 0
    end

    objectData.image = newImage
    objectData.parentGroup = parentGroup
    if factory and type(factory.create) == "function" then
        objectData.displayModule = factory
    end
    objectData.currentState = newState
    objectData.defaultImage = stateImage
    objectData.visible = wasVisible
    objectData.width = objectData.width or newImage.width
    objectData.height = objectData.height or newImage.height
    objectData.x = objectData.x or newImage.x
    objectData.y = objectData.y or newImage.y

    if env[objectName] then
        env[objectName] = newImage
    end

    if onComplete then
        timer.performWithDelay(600, onComplete)
    end

    return true
end

function M.methods:changeObjectStateConditional(objectName, newState, condition)
    -- Evaluate condition using scene's checkCondition method if available
    local conditionMet = false

    if self.checkCondition then
        -- Use scene-specific condition checking
        conditionMet = self:checkCondition(condition)
    else
        -- Fallback to basic evaluation
        if type(condition) == "function" then
            conditionMet = condition()
        elseif type(condition) == "boolean" then
            conditionMet = condition
        else
            conditionMet = (condition ~= nil and condition ~= false)
        end
    end

    if conditionMet then
        self:changeObjectState(objectName, newState)
    else
        local env = self._env or {}
        local objects = env.objects or {}
        local od = objects[objectName]
        local default = od and od.defaultState
        if default then
            self:changeObjectState(objectName, default)
        end
    end
end

function M.methods:showChoice(options)
    local env = self._env or {}
    local dialogueText = env.dialogueText
    local state = env.state or {}
    state.isChoiceActive = true

    if dialogueText then dialogueText.text = "What will you do?" end

    -- clear previous group
    if state.choiceGroup then
        pcall(function() state.choiceGroup:removeSelf() end)
        state.choiceGroup = nil
    end

    local choiceGroup = display.newGroup()
    if self.view then self.view:insert(choiceGroup) end
    state.choiceGroup = choiceGroup

    for i, option in ipairs(options or {}) do
        local choiceButton = widget.newButton({
            label = option,
            shape = "roundedRect",
            width = 350,
            height = 60,
            cornerRadius = 8,
            fillColor = { default={0.3,0.3,0.4,1}, over={0.4,0.4,0.5,1} },
            labelColor = { default={1,1,1}, over={0.8,0.8,0.8} },
            onRelease = function() self:handleChoice(i, option) end
        })
        choiceButton.x = display.contentCenterX
        choiceButton.y = 400 + (i * 80)
        choiceGroup:insert(choiceButton)
    end
end

function M.methods:handleChoice(choiceIndex, choiceText)
    local env = self._env or {}
    local state = env.state or {}
    if not state.isChoiceActive then return end
    state.isChoiceActive = false

    if state.choiceGroup then
        pcall(function() state.choiceGroup:removeSelf() end)
        state.choiceGroup = nil
    end

    self:showDialogue("You chose: " .. tostring(choiceText))

    if type(gameData) == "table" then
        gameData.playerChoice = choiceIndex
    else
        _G.gameData = _G.gameData or {}
        _G.gameData.playerChoice = choiceIndex
    end

    timer.performWithDelay(2000, function()
        if self.transitionToNextScene then self:transitionToNextScene() end
    end)
end

-- Generic condition/action registry methods
function M.methods:setCondition(key, value)
    _G.gameData = _G.gameData or {}
    _G.gameData[key] = value
    print("Set condition: " .. key .. " = " .. tostring(value))
end

function M.methods:getCondition(key)
    return _G.gameData and _G.gameData[key]
end

function M.methods:checkCondition(condition)
    if type(condition) == "function" then
        return condition()
    elseif type(condition) == "boolean" then
        return condition
    elseif type(condition) == "string" then
        -- Look up in scene-specific condition registry
        local env = self._env or {}
        local conditions = env.conditions or {}
        local conditionFunc = conditions[condition]
        if conditionFunc then
            return conditionFunc()
        else
            print("Warning: Condition '" .. condition .. "' not found in registry!")
            return false
        end
    end
    return false
end

function M.methods:executeAction(actionName)
    if type(actionName) == "function" then
        -- Fallback: allow inline functions for backward compatibility
        actionName()
    elseif type(actionName) == "string" then
        -- Look up in scene-specific action registry
        local env = self._env or {}
        local actions = env.actions or {}
        local actionFunc = actions[actionName]
        if actionFunc then
            actionFunc()
        else
            print("Warning: Action '" .. actionName .. "' not found in registry!")
        end
    else
        print("Warning: Invalid action type:", type(actionName))
    end
end

function M.methods:changeEmotion(character, state)
    local env = self._env or {}
    local objects = env.objects or {}

    local charObj = objects[character]
    if not charObj then
        print("Warning: Character '" .. tostring(character) .. "' not found in objects registry!")
        return
    end

    local changed = self:changeObjectState(character, state)
    if not changed then
        return
    end

    if env[character] then
        env[character] = charObj.image
    end

    print("Changed " .. character .. " emotion to: " .. state)
end

-- Determine player's choice from global gameData (or _G fallback)
local function getPlayerChoice()
    if type(gameData) == "table" and gameData.playerChoice ~= nil then
        return gameData.playerChoice
    end
    if _G.gameData and _G.gameData.playerChoice ~= nil then
        return _G.gameData.playerChoice
    end
    return nil
end

-- Go to a scene based on player's choice using the provided mapping.
-- mapping: table like { [1] = "sceneA", [2] = "sceneB", default = "sceneC" }
-- options: composer options (e.g., { effect = "fade", time = 1000 })
function M.gotoSceneByChoice(mapping, options)
    local choice = getPlayerChoice()
    local nextScene = (choice and mapping[choice]) or mapping.default
    if not nextScene then return end
    composer.gotoScene(nextScene, options or { effect = "fade", time = 800 })
end

-------------------------------------------------------------------------------
-- BTree Helper Functions
-------------------------------------------------------------------------------

-- Load behavior tree from file and register action/condition handlers
-- treeFileName: path to .tree file
-- actionController: controller with execute function (optional, can be set later)
-- conditionController: controller with evaluate function (optional, can be set later)
function M.loadBehaviorTree(treeFileName, actionController, conditionController)
    local bt = require("utils.btree")
    local treeFilePath = system.pathForFile(treeFileName, system.ResourceDirectory)

    if not treeFilePath then
        print("ERROR: Could not find " .. treeFileName)
        return nil
    end

    local file = io.open(treeFilePath, "r")
    if not file then
        print("ERROR: Could not open " .. treeFileName)
        return nil
    end

    local treeText = file:read("*a")
    file:close()

    local tree = bt.BehaviorTree.fromText(treeText)
    if not tree then
        print("ERROR: Could not parse behavior tree")
        return nil
    end

    print("Behavior tree loaded successfully from " .. treeFileName)

    -- Register action handler if provided
    if actionController and actionController.execute then
        tree:onActionActivation(function(_, actionNode)
            if actionNode and actionNode:active() then
                local actionName = actionNode.name
                print("BTree: Executing action [" .. actionName .. "]")
                local result = actionController.execute(actionName)

                -- Convert result to bt status
                if result == bt.SUCCESS then
                    actionNode:setStatus(bt.SUCCESS)
                elseif result == bt.RUNNING then
                    actionNode:setStatus(bt.RUNNING)
                else
                    actionNode:setStatus(bt.FAILED)
                end
            end
        end)
        print("Behavior tree: Action handler registered")
    end

    -- Conditions are handled via tree:setConditionStatus()
    -- Called manually before each tick in the game loop
    -- Example: tree:setConditionStatus("player choice fight", conditionController.evaluate("fight"))

    return tree
end-- Create a manual behavior tree controller
-- Returns a controller object with manual tick function and state tracking
function M.createManualBehaviorTree(behaviorTree, conditionController)
    local bt = require("utils.btree")

    if not behaviorTree then
        print("ERROR: Cannot create manual behavior tree - tree not provided")
        return nil
    end

    local controller = {
        tree = behaviorTree,
        conditionController = conditionController,
        failureCount = 0,
        MAX_FAILURES = 10,
        isComplete = false,
        lastResult = nil
    }

    -- Update conditions before ticking
    function controller:updateConditions()
        if not self.conditionController or not self.conditionController.evaluate then
            return
        end

        -- Get all conditions from the tree and evaluate them
        local conditions = self.tree.conditions
        if conditions then
            conditions:forEach(function(_, conditionList)
                for i = 1, #conditionList do
                    local condition = conditionList[i]
                    local conditionName = condition.name
                    local result = self.conditionController.evaluate(conditionName)

                    if result then
                        self.tree:setConditionStatus(conditionName, bt.SUCCESS)
                    else
                        self.tree:setConditionStatus(conditionName, bt.FAILED)
                    end
                end
            end)
        end
    end

    -- Manual tick function - call this when button is pressed
    function controller:tick()
        if self.isComplete then
            print("Controller: Tree already complete, skipping tick")
            return self.lastResult
        end

        -- Update condition statuses before ticking
        self:updateConditions()

        print("Controller: Ticking tree...")
        local result = self.tree:tick()
        self.lastResult = result
        print("Controller: Tree returned " .. tostring(result))

        -- Check the result
        if result == bt.SUCCESS then
            self.failureCount = 0
            self.isComplete = true
            print("Controller: Tree completed with SUCCESS")
            return result
        elseif result == bt.FAILURE then
            self.failureCount = self.failureCount + 1

            if self.failureCount >= self.MAX_FAILURES then
                print("ERROR: Behavior tree failed " .. self.MAX_FAILURES .. " times. Stopping execution.")
                self.isComplete = true
            end
            return result
        elseif result == bt.RUNNING then
            -- Reset failure count when tree is running successfully
            self.failureCount = 0
            print("Controller: Tree is RUNNING")
            return result
        end

        return result
    end

    -- Reset the controller
    function controller:reset()
        self.failureCount = 0
        self.isComplete = false
        self.lastResult = nil

        -- Reset the tree nodes' internal state
        if self.tree and self.tree.root then
            self:resetNode(self.tree.root)
        end

        -- Reset action controller completion tracking
        if self.actionController and self.actionController.reset then
            self.actionController.reset()
            print("Controller: Reset action completion tracking")
        end
    end

    -- Recursively reset all nodes in the tree
    function controller:resetNode(node)
        if not node then return end

        -- Reset Sequence/Fallback currentChildIndex
        if node.currentChildIndex then
            node.currentChildIndex = 1
        end

        -- Reset node status
        if node.setStatus then
            node:setStatus(nil)
        end

        -- Recursively reset children
        if node.children then
            for i = 1, #node.children do
                self:resetNode(node.children[i])
            end
        end
    end

    print("\n=== Manual Behavior Tree Created ===")
    print("Call controller:tick() to advance the tree")

    return controller
end

-- Start behavior tree with automatic ticking
-- Returns the timer ID for later cleanup
function M.startBehaviorTree(behaviorTree, tickInterval)
    local bt = require("utils.btree")

    if not behaviorTree then
        print("ERROR: Cannot start behavior tree - tree not provided")
        return nil
    end

    tickInterval = tickInterval or 50 -- Default 50ms tick rate
    local failureCount = 0
    local MAX_FAILURES = 10

    print("\n=== Starting Behavior Tree ===")

    -- Create a timer that ticks the behavior tree
    local tickTimer = timer.performWithDelay(tickInterval, function()
        local result = behaviorTree:tick()

        -- Check the result to determine if the tree has completed
        if result == bt.SUCCESS then
            print("Behavior tree completed successfully")
            failureCount = 0  -- Reset failure count on success
            if tickTimer then
                timer.cancel(tickTimer)
                tickTimer = nil
            end
        elseif result == bt.FAILURE then
            failureCount = failureCount + 1
            print("Behavior tree failed (failure " .. failureCount .. "/" .. MAX_FAILURES .. ")")

            if failureCount >= MAX_FAILURES then
                print("ERROR: Behavior tree failed " .. MAX_FAILURES .. " times. Stopping execution.")
                if tickTimer then
                    timer.cancel(tickTimer)
                    tickTimer = nil
                end
            end
        elseif result == bt.RUNNING then
            -- Reset failure count when tree is running successfully
            failureCount = 0
        end
        -- RUNNING means the tree is still executing, so we continue ticking
    end, 0)  -- 0 means repeat indefinitely

    return tickTimer
end

return M
