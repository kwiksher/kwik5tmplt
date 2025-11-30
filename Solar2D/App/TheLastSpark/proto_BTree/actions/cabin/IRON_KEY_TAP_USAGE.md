# Iron Key Tap Interaction Usage Guide

## Overview
The iron key object now supports tap interaction, allowing players to collect it by tapping when the behavior tree enables it.

## Implementation Details

### Files Modified
- `actions/cabin/iron_key_actions.lua` - Added tap handler functions

### New Actions Available
1. **`enable_tap_interaction`** - Makes the iron key tappable
2. **`disable_tap_interaction`** - Removes tap interaction

## How to Use in Behavior Tree

### Basic Pattern
```
sequence
    action: iron_key visible           # Show the iron key
    action: enable_tap_interaction     # Make it tappable
    condition: has iron key            # Wait for player to tap and collect
    action: disable_tap_interaction    # Clean up (optional, auto-disabled on tap)
    # Continue story...
```

### Example: Discovery and Collection Flow
```
sequence
    # Show the iron key after player examines the doorstep
    action: iron_key visible
    action: narration "You notice a glint of metal near the door..."

    # Enable tap interaction
    action: enable_tap_interaction

    # Wait for player to collect it
    condition: has iron key

    # Continue after collection
    action: narration "You picked up the iron key!"
    action: iron_key collected
```

### Example: Conditional Collection
```
selector
    # Try to unlock door first
    sequence
        condition: has iron key
        action: cabin_door open

    # If no key, show it and wait for collection
    sequence
        action: iron_key visible
        action: narration "You need to find the key first..."
        action: enable_tap_interaction
        condition: has iron key
        action: narration "Perfect! You found the key!"
```

## How It Works

1. **Visibility**: The key must be in `visible` state before enabling tap interaction
2. **Tap Handler**: When enabled, tapping the key automatically:
   - Calls `changeToCollected()` to update the visual state
   - Sets `iron_key.collected = true`
   - Triggers the `has iron key` condition
   - Auto-disables further taps to prevent double-collection
3. **BTree Flow**: The `condition: has iron key` node blocks until the player taps
4. **State Management**: The collected state persists throughout the scene

## Important Notes

- **BTree-Controlled**: Tap interaction is only active when explicitly enabled by the behavior tree
- **One-Time Collection**: Once tapped, the key is automatically marked as collected and tap is disabled
- **Condition Integration**: Uses existing `has iron key` condition - no new conditions needed
- **Visual Feedback**: The key changes to `collected` state after being tapped (shows collected image)

## State Flow Diagram

```
[hidden state]
      ↓
[action: iron_key visible]
      ↓
[visible state] → Key visible but NOT tappable yet
      ↓
[action: enable_tap_interaction]
      ↓
[visible state + tap enabled] → Player can tap
      ↓
[Player taps key]
      ↓
[changeToCollected() called automatically]
      ↓
[collected state + iron_key.collected = true]
      ↓
[condition: has iron key = TRUE]
      ↓
[BTree continues to next node]
```

## Testing Checklist

- [ ] Key appears when `iron_key visible` action runs
- [ ] Key responds to taps after `enable_tap_interaction` action
- [ ] Tapping key changes it to collected state
- [ ] `has iron key` condition becomes true after tap
- [ ] Key no longer responds to taps after collection
- [ ] BTree continues properly after collection

## Related Files

- **Action Module**: `actions/cabin/iron_key_actions.lua`
- **Condition Module**: `conditions/cabin/has_iron_key.lua`
- **Model**: `models/cabin/iron_key.lua`
- **Scene**: `views/cabin/cabinScene.lua`
- **Behavior Tree**: `cabin_scene.tree`