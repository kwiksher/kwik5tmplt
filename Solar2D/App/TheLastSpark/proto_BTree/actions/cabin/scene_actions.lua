-- Scene Actions (Cabin Scene)
-- Consolidated actions for scene transitions in cabin scene
-- Accepts action parameter to specify which scene transition
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")
local composer = require("composer")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Scene objects reference
local sceneObjects = {}

-- Override initialize to store scene objects
function M.initialize(objects)
    sceneObjects = objects
    M.sceneObjects = objects
end

-- Register Scene-specific actions
M.ACTIONS = {
    cabin_exterior = function()
        return M.changeToCabinExterior()
    end,

    cabin_door = function()
        return M.changeToCabinDoor()
    end,

    door_open = function()
        return M.changeToDoorOpen()
    end,

    cabin_interior = function()
        return M.changeToCabinInterior()
    end,

    chest_open = function()
        return M.changeToChestOpen()
    end,

    empty_chest = function()
        return M.changeToEmptyChest()
    end,

    door_sealed = function()
        return M.changeToDoorSealed()
    end,

    force_door = function()
        return M.goToForceDoorScene()
    end,

    window_escape = function()
        return M.goToWindowEscapeScene()
    end,

    arcane_markings = function()
        return M.goToArcaneMarkingsScene()
    end,
}

function M.changeToCabinExterior()
    print("Changing to cabin exterior scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_cabin_exterior.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.changeToCabinDoor()
    print("Focusing on cabin door")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_cabin_door.png")
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
        sceneObjects.changeBackground("images/bg_door_open.png")
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end

    -- Change the door state to "open" so (is door open) condition becomes true
    if sceneObjects.cabin_door then
        local DisplayBase = require("views.display_base")
        sceneObjects.cabin_door = DisplayBase:changeState(sceneObjects.cabin_door, "open")
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
        sceneObjects.changeBackground("images/bg_cabin_interior.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.changeToChestOpen()
    print("Chest opening scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_chest_open.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.changeToEmptyChest()
    print("Empty chest revealed scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_empty_chest.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.changeToDoorSealed()
    print("Door sealing scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_door_sealed.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.goToForceDoorScene()
    print("Going to force door scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_force_door.png")
    end
    composer.gotoScene("views.cabin.forceDoorScene", {
        effect = "fade",
        time = 500
    })
    return bt.SUCCESS
end

function M.goToWindowEscapeScene()
    print("Going to window escape scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_window_escape.png")
    end
    composer.gotoScene("views.cabin.windowEscapeScene", {
        effect = "fade",
        time = 500
    })
    return bt.SUCCESS
end

function M.goToArcaneMarkingsScene()
    print("Going to arcane markings scene")
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_arcane_markings.png")
    end
    composer.gotoScene("views.cabin.arcaneMarkingsScene", {
        effect = "fade",
        time = 500
    })
    return bt.SUCCESS
end

return M
