# Cabin Scene - Technical Model

## Scene Information
- **Scene Name**: Cabin Scene
- **Location**: Old Cabin in the Woods
- **Time**: Day
- **Setting Transitions**: EXT. Old Cabin → INT. Main Room

---

## Backgrounds

### bg_cabin_exterior
- **Description**: Old cabin exterior, weathered wooden planks, vines crawling up sides, heavy crooked door
- **Usage**: Opening shot

### bg_cabin_interior
- **Description**: Dusty cabin interior, boarded windows with light cracks, gray and dusty atmosphere, wooden table in center, chest in corner, fireplace with arcane markings
- **Usage**: Main scene location

---

## Characters

### Elara
**Description**: 19 years old, determined eyes, practical worn-out clothing, knife at belt

**States/Emotions**:
- `neutral` - Default/determined expression
- `focused` - Whispering to herself, examining objects
- `shocked` - Discovering empty chest
- `panicking` - Trapped, trying to escape

**Sprites Needed**:
- `elara_neutral.png` - Default state
- `elara_focused.png` - Examining/thinking
- `elara_shocked.png` - Face falling, disappointed
- `elara_panicking.png` - Scared, desperate

**Position**: Left or center of screen

---

## Props/Objects

### Lumin Seed
**Description**: Single faintly glowing seed, pulses with soft warm light, only source of color in gray space

**States**:
- `glowing` - Pulsing with soft, warm light (default)

**Images**:
- `lumin_seed_glowing.png`

**Position**: On wooden table, center of room
**Size**: Small (100x100px suggested)

### Cabin Door
**Description**: Heavy wooden door, slightly crooked on hinges

**States**:
- `closed_locked` - Door locked from inside (initial state)
- `open` - Door creaked open
- `closed_sealed` - Door slammed shut, sealed tight (trapped)

**Images**:
- `cabin_door_closed.png`
- `cabin_door_open.png`

**Position**: Right side or background
**Size**: Medium-large (220x320px suggested)
**Interaction**: Can be tried/pulled

### Iron Key (Door Key)
**Description**: Old iron key, glinting in dirt

**States**:
- `hidden` - In dirt near doorstep
- `found` - Picked up by player
- `used` - Inserted in door lock

**Images**:
- `key_iron.png`

**Position**: Ground/inventory
**Size**: Small (50x50px)

### Old Chest
**Description**: Old chest with rusted iron bands, partially hidden in shadow in corner

**States**:
- `locked` - Cannot be opened (initial state)
- `unlocked` - Lock clicked open
- `open` - Lid lifted, revealed to be empty

**Images**:
- `chest_locked.png`
- `chest_unlocked.png`
- `chest_open.png`

**Position**: Corner of room
**Size**: Medium (170x130px suggested)
**Interaction**: Can be tried/opened

### Brass Key (Chest Key)
**Description**: Small brass key

**States**:
- `hidden` - Under loose floorboard
- `found` - Picked up by player
- `used` - Inserted in chest lock

**Images**:
- `key_brass.png`

**Position**: Floor/inventory
**Size**: Small (50x50px)

### Boarded Window
**Description**: Window with boards, crack of light visible

**States**:
- `boarded` - Covered with boards (potential exit)

**Images**:
- `window_boarded.png`

**Position**: Background/wall
**Size**: Medium (150x200px)
**Interaction**: Potential choice option

### Arcane Markings
**Description**: Strange arcane markings carved into wall near fireplace

**States**:
- `visible` - Can be examined

**Images**:
- `markings_arcane.png`

**Position**: Wall near fireplace
**Size**: Medium (200x150px)
**Interaction**: Potential choice option

---

## Sound Effects (SFX)

### door_rattle
- **Description**: Door handle rattling, won't budge
- **File**: `sfx_door_rattle.wav`
- **Trigger**: When Elara tries locked door

### key_turn
- **Description**: Key turning in lock
- **File**: `sfx_key_turn.wav`
- **Trigger**: When iron key used on door

### door_creak
- **Description**: Old door creaking open slowly
- **File**: `sfx_door_creak.wav`
- **Trigger**: Door opening after key turn

### lock_clicks
- **Description**: Lock clicking open
- **File**: `sfx_lock_click.wav`
- **Trigger**: When brass key opens chest lock

### chest_creak
- **Description**: Chest creaking open
- **File**: `sfx_chest_creak.wav`
- **Trigger**: When chest lid lifted

### door_slam
- **Description**: Heavy door slamming shut with thunderous bang
- **File**: `sfx_door_slam.wav`
- **Trigger**: Door sealing behind Elara

---

## Music/Ambience

### ambient_cabin
- **Description**: Eerie quiet forest ambience, creaking wood
- **File**: `ambient_cabin_quiet.mp3`
- **Loop**: Yes
- **Usage**: Background throughout scene

### music_tension
- **Description**: Tension building music
- **File**: `music_cabin_tension.mp3`
- **Trigger**: After door slams shut

---

## Game Flags/Variables

### hasIronKey
- **Type**: Boolean
- **Initial**: `false`
- **Set to true**: When Elara finds key near doorstep
- **Usage**: Controls door opening

### hasBrassKey
- **Type**: Boolean
- **Initial**: `false`
- **Set to true**: When Elara finds key under floorboard
- **Usage**: Controls chest opening

### isDoorOpen
- **Type**: Boolean
- **Initial**: `false`
- **Set to true**: When door opens
- **Set to false**: When door slams shut

### isChestOpen
- **Type**: Boolean
- **Initial**: `false`
- **Set to true**: When chest opens

### isTrapped
- **Type**: Boolean
- **Initial**: `false`
- **Set to true**: When door slams shut
- **Usage**: Triggers final choice options

---

## Dialogue/Voice-Over Lines

### Elara Line 1
- **Text**: "The Lumin Seed... I found it."
- **Type**: Whispering to herself
- **File**: `vo_elara_found_seed.wav`
- **Trigger**: Upon seeing Lumin Seed

### Elara Line 2
- **Text**: "There has to be a key somewhere around here..."
- **Type**: Thinking aloud
- **File**: `vo_elara_need_key.wav`
- **Trigger**: When trying locked chest

### Elara Line 3
- **Text**: "No... it can't be!"
- **Type**: Shocked
- **File**: `vo_elara_shocked.wav`
- **Trigger**: Seeing empty chest

### Elara Line 4
- **Text**: "Someone got here first."
- **Type**: Disappointed
- **File**: `vo_elara_someone_first.wav`
- **Trigger**: Continuing from shock

### Elara Line 5
- **Text**: "What?! No!"
- **Type**: Panicking
- **File**: `vo_elara_panic.wav`
- **Trigger**: Door slams shut

---

## Scene Flow / Event Sequence

1. **Exterior** → Show cabin exterior, Elara approaches
2. **Try Door** → Door locked, rattle SFX
3. **Find Iron Key** → Key glints in dirt
4. **Open Door** → Key turn SFX, door creak SFX, door opens
5. **Enter Cabin** → Transition to interior
6. **See Lumin Seed** → Show seed glowing, Elara dialogue
7. **Notice Chest** → Show chest in corner
8. **Try Chest** → Chest locked
9. **Search Room** → Elara searches, finds brass key under floorboard
10. **Open Chest** → Lock click SFX, chest creak SFX
11. **Empty Chest** → Reveal empty interior, Elara shocked
12. **Door Slams** → Door slam SFX, door changes to sealed state
13. **Attempt Escape** → Elara tries door, won't open
14. **Survey Options** → Show three potential choices
15. **Player Choice** → Present options menu

---

## Player Choices (End of Scene)

### Choice 1: "Try to force the door open"
- **Action**: Attempt to break down the heavy wooden door
- **Next Scene**: `force_door_scene.lua`

### Choice 2: "Search for another way out"
- **Action**: Investigate the boarded window
- **Next Scene**: `window_escape_scene.lua`

### Choice 3: "Investigate the strange markings"
- **Action**: Examine arcane markings on wall
- **Next Scene**: `arcane_markings_scene.lua`

---

## Implementation Notes

- All object state changes should be animated with transitions
- Keys should be highlighted or pulsed when discoverable
- Elara's position should shift as she moves between door, table, chest, and back to door
- Consider particle effects for Lumin Seed glow
- Door slam should trigger screen shake effect
- Final pan/focus on each choice option as Elara surveys them
