-- Brass Key Actions
-- Consolidated actions for brass key object
-- Accepts action parameter to specify which key action to execute
-- Uses action_helper for common functionality

local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Brass Key-specific actions
M.ACTIONS = {
    brass_key = function()
        -- Use changeToVisible instead of showObject to properly set state
        return M.changeToVisible()
    end,

    visible = function()
        return M.changeToVisible()
    end,

    collected = function()
        return M.changeToCollected()
    end,

    enable_tap_interaction = function()
        return M.enableTapInteraction()
    end,

    disable_tap_interaction = function()
        return M.disableTapInteraction()
    end,
}

function M.changeToVisible()
    local DisplayBase = require("behaivor.display_base_common")
    print("=== BRASS KEY SHOW ACTION CALLED ===")
    print("DEBUG: Before changeState - brass_key type: " .. type(M.sceneObjects.brass_key))
    local result = M.changeState("brass_key", "visible", DisplayBase)
    print("DEBUG: After changeState - result: " .. tostring(result))
    print("DEBUG: After changeState - brass_key type: " .. type(M.sceneObjects.brass_key))
    print("DEBUG: After changeState - brass_key value: " .. tostring(M.sceneObjects.brass_key))
    print("=== BRASS KEY SHOW ACTION COMPLETE - Returned: " .. tostring(result) .. " ===")

    -- Automatically enable tap interaction when showing brass_key
    if result == bt.SUCCESS then
        print("Brass key shown, automatically enabling tap interaction...")
        M.enableTapInteraction()
        M.enableDragInteraction()
    end

    return result
end

function M.changeToCollected()
    local DisplayBase = require("behaivor.display_base_common")
    local result = M.changeState("brass_key", "collected", DisplayBase)

    -- Mark as collected in object and enable dragging
    if M.sceneObjects and M.sceneObjects.brass_key then
        M.sceneObjects.brass_key.collected = true

        -- Enable drag functionality for collected brass key
        M.enableDragInteraction()
    end

    return result
end

-- Enable drag interaction on brass_key
-- This allows the user to drag the brass_key to the chest
function M.enableDragInteraction()
    if not M.sceneObjects then
        print("ERROR: enableDragInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local brassKey = M.sceneObjects.brass_key
    local hitThreshold = 100

    if not brassKey then
        print("ERROR: enableDragInteraction - brass_key object not found")
        return bt.FAILED
    end

    -- Create drag handler if it doesn't exist
    if not brassKey.dragHandler then
        local startX, startY

        brassKey.dragHandler = function(event)
            local phase = event.phase

            if phase == "began" then
                local chest = M.sceneObjects and M.sceneObjects.chest
                if not chest then
                    print("ERROR: brass_key.drag began - chest object not found")
                    return true
                end
                display.getCurrentStage():setFocus(brassKey)
                brassKey.isFocus = true
                startX = brassKey.x
                startY = brassKey.y

                -- Allow drag even before tap-to-collect; dragging implies pickup intent.
                if brassKey.modelData then
                    brassKey.modelData.collected = true
                end
                print("[TRACE brass_key.drag] began x=" .. tostring(startX) .. ", y=" .. tostring(startY) ..
                    ", chestX=" .. tostring(chest and chest.x) .. ", chestY=" .. tostring(chest and chest.y) ..
                    ", threshold=" .. tostring(hitThreshold))

            elseif brassKey.isFocus then
                if phase == "moved" then
                    brassKey.x = event.x
                    brassKey.y = event.y
                    print("[TRACE brass_key.drag] moved x=" .. tostring(brassKey.x) .. ", y=" .. tostring(brassKey.y))

                elseif phase == "ended" or phase == "cancelled" then
                    local chest = M.sceneObjects and M.sceneObjects.chest
                    if not chest then
                        print("ERROR: brass_key.drag " .. tostring(phase) .. " - chest object not found")
                        display.getCurrentStage():setFocus(nil)
                        brassKey.isFocus = false
                        return true
                    end
                    display.getCurrentStage():setFocus(nil)
                    brassKey.isFocus = false

                    -- Check collision with chest
                    local dx = brassKey.x - chest.x
                    local dy = brassKey.y - chest.y
                    local distance = math.sqrt(dx*dx + dy*dy)
                    print("[TRACE brass_key.drag] " .. tostring(phase) ..
                        " dropX=" .. tostring(brassKey.x) .. ", dropY=" .. tostring(brassKey.y) ..
                        ", chestX=" .. tostring(chest.x) .. ", chestY=" .. tostring(chest.y) ..
                        ", distance=" .. string.format("%.2f", distance) ..
                        ", threshold=" .. tostring(hitThreshold))

                    -- If brass key is close enough to chest (within 100 pixels)
                    if distance < hitThreshold then
                        print("Brass key hit the chest! Unlocking...")
                        print("[TRACE brass_key.drag] hit chest -> applying model flags and restarting tree")

                        -- Mark brass key as used in modelData (persists across state changes)
                        if brassKey.modelData then
                            brassKey.modelData.collected = true
                            brassKey.modelData.usedOnChest = true
                            print("[TRACE brass_key.drag] brassKey.modelData.collected=" .. tostring(brassKey.modelData.collected) ..
                                ", usedOnChest=" .. tostring(brassKey.modelData.usedOnChest))
                        end

                        -- Also set on sceneObjects reference
                        if M.sceneObjects.brass_key then
                            if M.sceneObjects.brass_key.modelData then
                                M.sceneObjects.brass_key.modelData.usedOnChest = true
                                print("[TRACE brass_key.drag] sceneObjects.brass_key.modelData.usedOnChest=" ..
                                    tostring(M.sceneObjects.brass_key.modelData.usedOnChest))
                            end
                        end

                        -- Mark iron key as collected so (has iron key) condition becomes true
                        if M.sceneObjects.iron_key then
                            if M.sceneObjects.iron_key.modelData then
                                M.sceneObjects.iron_key.modelData.collected = true
                                print("[TRACE brass_key.drag] iron_key.modelData.collected=" ..
                                    tostring(M.sceneObjects.iron_key.modelData.collected))
                            end
                        end

                        -- Don't set chest state here - let the tree execute [scene chest_open] action
                        -- which will properly set the chest state

                        -- Hide the brass key
                        brassKey.isVisible = false
                        brassKey.alpha = 0

                        -- Queue chest_open to run right after restart (without modifying the tree)
                        if M.sceneObjects then
                            M.sceneObjects.pendingAction = "scene chest_open"
                            print("[TRACE brass_key.drag] queued pendingAction=" .. tostring(M.sceneObjects.pendingAction))
                        end

                        -- Restart the tree so it can re-evaluate conditions with the new brass key state
                        if M.sceneObjects and M.sceneObjects.restartTree then
                            print("Brass key used on chest - restarting behavior tree...")
                            M.sceneObjects.restartTree()
                        end
                    else
                        -- Return to start position if not near chest
                        print("[TRACE brass_key.drag] miss chest -> returning to start x=" .. tostring(startX) ..
                            ", y=" .. tostring(startY))
                        transition.to(brassKey, {
                            x = startX,
                            y = startY,
                            time = 200
                        })
                    end
                end
            end

            return true
        end
    end

    brassKey.isHitTestable = true

    -- Add touch listener for dragging (avoid duplicate registration)
    if brassKey._dragEnabled then
        brassKey:removeEventListener("touch", brassKey.dragHandler)
    end
    brassKey:addEventListener("touch", brassKey.dragHandler)
    brassKey._dragEnabled = true
    print("Drag interaction enabled for brass_key")
    return bt.SUCCESS
end

-- Disable drag interaction on brass_key
function M.disableDragInteraction()
    if not M.sceneObjects then
        print("ERROR: disableDragInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local brassKey = M.sceneObjects.brass_key
    if not brassKey then
        print("ERROR: disableDragInteraction - brass_key object not found")
        return bt.FAILED
    end

    -- Remove touch listener
    if brassKey.dragHandler then
        brassKey:removeEventListener("touch", brassKey.dragHandler)
        brassKey._dragEnabled = false
        print("Drag interaction disabled for brass_key")
    end

    return bt.SUCCESS
end

-- Enable tap interaction on brass_key
-- This allows the user to tap the brass_key to collect it
function M.enableTapInteraction()
    if not M.sceneObjects then
        print("ERROR: enableTapInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local brassKey = M.sceneObjects.brass_key
    print("DEBUG: enableTapInteraction - brassKey type: " .. type(brassKey))
    print("DEBUG: enableTapInteraction - brassKey value: " .. tostring(brassKey))

    if not brassKey then
        print("ERROR: enableTapInteraction - brass_key object not found")
        return bt.FAILED
    end

    if type(brassKey) ~= "table" then
        print("ERROR: enableTapInteraction - brass_key is not a table, it's a " .. type(brassKey))
        return bt.FAILED
    end

    -- Create tap handler if it doesn't exist
    if not brassKey.tapHandler then
        brassKey.tapHandler = function(event)
            print("Brass key tapped! Collecting...")
            print("[TRACE brass_key.tap] before collect modelData.collected=" ..
                tostring(brassKey.modelData and brassKey.modelData.collected) ..
                ", modelData.usedOnChest=" .. tostring(brassKey.modelData and brassKey.modelData.usedOnChest))

            -- Call the collected action to change state and enable dragging
            M.changeToCollected()

            print("[TRACE brass_key.tap] after collect modelData.collected=" ..
                tostring(brassKey.modelData and brassKey.modelData.collected) ..
                ", modelData.usedOnChest=" .. tostring(brassKey.modelData and brassKey.modelData.usedOnChest))

            -- Disable tap interaction (we'll use drag instead)
            M.disableTapInteraction()

            -- Don't restart the tree yet - let the user drag the key to the chest
            print("Brass key collected - now draggable")

            return true
        end
    end

    -- Add tap listener directly to the display object (brassKey IS the display object)
    brassKey:addEventListener("tap", brassKey.tapHandler)
    print("Tap interaction enabled for brass_key")
    return bt.SUCCESS
end

-- Disable tap interaction on brass_key
-- Removes the tap listener to prevent further interaction
function M.disableTapInteraction()
    if not M.sceneObjects then
        print("ERROR: disableTapInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local brassKey = M.sceneObjects.brass_key
    if not brassKey then
        print("ERROR: disableTapInteraction - brass_key object not found")
        return bt.FAILED
    end

    -- Remove tap listener directly from the display object
    if brassKey.tapHandler then
        brassKey:removeEventListener("tap", brassKey.tapHandler)
        print("Tap interaction disabled for brass_key")
    end

    return bt.SUCCESS
end

return M
