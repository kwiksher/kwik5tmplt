-- Scene Actions (Cabin Scene)
-- Consolidated actions for scene transitions in cabin scene
-- Accepts action parameter to specify which scene transition
-- Uses action_helper for common functionality

local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")
local composer = require("composer")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Scene objects reference
local sceneObjects = {}

--local IMG_PATH = "images/"
local IMG_PATH = "App/TheLastSpark/assets/images/cabin/"

-- Override initialize to store scene objects
function M.initialize(objects)
    sceneObjects = objects
    M.sceneObjects = objects
end

-- Register Scene-specific actions
M.ACTIONS = {
    cabin_exterior = function()
        return M.executeOnce("cabin_exterior", M.changeToCabinExterior)
    end,

    cabin_door = function()
        return M.executeOnce("cabin_door", M.changeToCabinDoor)
    end,

    door_open = function()
        return M.executeOnce("door_open", M.changeToDoorOpen)
    end,

    cabin_interior = function()
        return M.executeOnce("cabin_interior", M.changeToCabinInterior)
    end,

    chest_open = function()
        return M.executeOnce("chest_open", M.changeToChestOpen)
    end,

    empty_chest = function()
        return M.executeOnce("empty_chest", M.changeToEmptyChest)
    end,

    door_sealed = function()
        return M.executeOnce("door_sealed", M.changeToDoorSealed)
    end,

    force_door = function()
        return M.executeOnce("force_door", M.goToForceDoorScene)
    end,

    window_escape = function()
        return M.executeOnce("window_escape", M.goToWindowEscapeScene)
    end,

    arcane_markings = function()
        return M.executeOnce("arcane_markings", M.goToArcaneMarkingsScene)
    end,
}

function M.changeToCabinExterior()
    print("Changing to cabin exterior scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground(IMG_PATH.."bg_cabin_exterior.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.changeToCabinDoor()
    print("Focusing on cabin door")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground(IMG_PATH.."bg_cabin_door.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.changeToDoorOpen()
    print("Door opening scene")

    -- Change the background
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground(IMG_PATH.."bg_door_open.png")
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end

    -- Change the door state to "open" so (is door open) condition becomes true
    if sceneObjects.cabin_door then
        local DisplayBase = require("views.display_base")
        sceneObjects.cabin_door = DisplayBase:changeState(sceneObjects.cabin_door, "open")
        if sceneObjects.cabin_door.modelData then
            sceneObjects.cabin_door.modelData.currentState = "open"
        end
        print("Door state changed to 'open'")
    else
        print("Warning: cabin_door object not available")
        return bt.FAILED
    end

    return bt.SUCCESS
end

function M.changeToCabinInterior()
    print("Changing to cabin interior scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground(IMG_PATH.."bg_cabin_interior.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.changeToChestOpen()
    print("Chest opening scene")

    -- Change the background
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground(IMG_PATH.."bg_chest_open.png")
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end

    -- Change the chest state to "open" so (is chest open) condition becomes true
    if sceneObjects.chest then
        local DisplayBase = require("views.display_base")
        sceneObjects.chest = DisplayBase:changeState(sceneObjects.chest, "open")
        sceneObjects.chest.currentState = "open"
        if sceneObjects.chest.modelData then
            sceneObjects.chest.modelData.currentState = "open"
        end
        print("Chest state changed to 'open'")
    else
        print("Warning: chest object not available")
        return bt.FAILED
    end

    return bt.SUCCESS
end

function M.changeToEmptyChest()
    print("Empty chest revealed scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground(IMG_PATH.."bg_empty_chest.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.changeToDoorSealed()
    print("Door sealing scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground(IMG_PATH.."bg_door_sealed.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.goToForceDoorScene()
    print("Force door attempt scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground(IMG_PATH.."bg_force_door.png")
    end
    composer.gotoScene("views.force_door.forceDoorScene", {
        effect = "fade",
        time = 500
    })
    return bt.SUCCESS
end

function M.goToWindowEscapeScene()
    print("Going to window escape scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground(IMG_PATH.."bg_window_escape.png")
    end
    composer.gotoScene("views.window_escape.windowEscapeScene", {
        effect = "fade",
        time = 500
    })
    return bt.SUCCESS
end

function M.goToArcaneMarkingsScene()
    print("Going to arcane markings scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground(IMG_PATH.."bg_arcane_markings.png")
    end
    composer.gotoScene("views.arcane_markings.arcaneMarkingsScene", {
        effect = "fade",
        time = 500
    })
    return bt.SUCCESS
end

return M
