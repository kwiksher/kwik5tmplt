# Forest Scene - Technical Model

## Scene Information
- **Scene Name**: Forest Scene
- **Location**: Forest path outside/around the abandoned cabin
- **Time**: Day / Dappled sunlight
- **Setting Transitions**: INT. Cabin → EXT. Forest

---

## Backgrounds

### bg_cabin_interior
- **Description**: Dusty cabin interior background (used at start of sequence)
- **Usage**: Opening shot before transition to forest
 - **Size**: 1280x720 (suggested fullscreen/background)

### bg_forest
- **Description**: Dense, quiet forest clearing with broken branches and shafts of light
- **Usage**: Main scene location after transition
 - **Size**: 1280x720 (suggested fullscreen/background)

---

## Characters

### Elara
**Description**: 19 years old, thoughtful, carrying the Lumin Seed

**States/Emotions**:
- `neutral` - Default/determined expression
- `scared` - Alarmed, frightened (used when wolf shows)
- `determined` - Ready to act
- `happy` - Calm / relieved

**Sprites Needed**:
- `elara_neutral.png`
- `elara_scared.png`
- `elara_determined.png`
- `elara_happy.png`

**Position**: Left/center of screen
**Size**: 300x500px (suggested character sprite size)

---

### Wolf (Corrupted Wolf)
**Description**: Aggressive corrupted wolf appearing from the trees

**States**:
- `aggro` - Hostile (initial hostile show)
- `calm` - Calmed state if player chooses non-violent option

**Sprites Needed**:
- `corrupted_wolf_aggro.png`
- `corrupted_wolf_calm.png`

**Position**: Right/upper-right of screen
**Size**: 400x300px (suggested creature sprite size)

---

## Props/Objects

### Lumin Seed
**Description**: Small glowing seed, the scene's focal item

**States**:
- `normal` - Visible but not pulsing
- `glowing` - Pulsing gently (default when shown)

**Images**:
- `item_lumin_seed.png`
- `item_lumin_seed_glowing.png`

**Position**: Table/ground/center depending on staging
**Size**: Small (100x100px suggested)

---

## Sound Effects (SFX)

The scene references a small set of SFX used to build atmosphere and action beats.

### rustling
- **Description**: Cloth or foliage rustling
- **File**: `audio/sfx_rustling_cloth.wav`
- **Trigger**: Entrance/character movement / ambient detail

### wind
- **Description**: Gentle wind ambience
- **File**: `audio/sfx_wind_gentle.wav`
- **Loop**: Yes
- **Trigger**: Background ambience (looped)

### footsteps
- **Description**: Footsteps on forest floor
- **File**: `audio/sfx_footsteps_forest.wav`
- **Loop**: Yes (when moving)
- **Trigger**: Elara or approaching creature movement

### caw
- **Description**: Distant crow caw
- **File**: `audio/sfx_crow_caw_distant.wav`
- **Trigger**: Ambient punctuation

### growl
- **Description**: Wolf growl (corrupted)
- **File**: `audio/sfx_wolf_growl_corrupted.wav`
- **Trigger**: Wolf appear / threat

---

## Music/Ambience

### tension
- **Description**: Tension-building music bed
- **File**: `audio/Music_Tension_Builds.mp3`
- **Trigger**: Played when wolf appears / during confrontation

---

## Game Flags/Variables

### hasLuminSeed
- **Type**: Boolean
- **Initial**: `false` (set when player takes or sees the seed)
- **Usage**: Tracks whether Elara has the Lumin Seed

### wolfAggro
- **Type**: Boolean
- **Initial**: `false` (set to true when growl/wolf shown)
- **Usage**: Controls wolf behaviour and available choices

### isTensionMusicPlaying
- **Type**: Boolean
- **Initial**: `false`
- **Usage**: Tracks if tension music is playing (so it can be stopped/looped correctly)

---

## Dialogue/Voice-Over Lines

### Elara VO 01
- **Text**: "The Lumin Seed was the last one. The last spark of the Great Tree's light..."
- **Type**: Whisper/nostalgic
- **File**: `audio/elara_vo_01.wav`
- **Trigger**: When Lumin Seed is shown / early narration

### Elara VO 02
- **Text**: "Oh no."
- **Type**: Short vocal reaction (panicked)
- **File**: `audio/elara_whisper_ohno.wav`
- **Trigger**: When wolf appears / threat

---

## Scene Flow / Event Sequence

1. **Cabin Interior** → Start with dusty cabin interior narration and ambience
2. **Show Lumin Seed** → Reveal the Lumin Seed on screen (visual pulse)
3. **Show Elara** → Bring Elara onto screen
4. **Ambient SFX** → Play rustling and start gentle wind loop
5. **VO (Elara)** → Play `vo_elara_01` with narration text
6. **Transition** → Change scene background to forest (`bg_forest`)
7. **Footsteps** → Start footsteps SFX (loop) to imply movement
8. **Caw** → Play distant crow to punctuate silence
9. **Narration** → Display: "The forest is unnervingly quiet. No birdsong, no rustle of creatures."
10. **Growl** → Play growl SFX
11. **Show Wolf** → Wolf appears (set `wolfAggro = true`)
12. **Music Tension** → Play tension music (`tension`) and mark as playing
13. **Elara Emotion** → Set Elara state to `scared`
14. **VO (Elara)** → Play `vo_elara_02` ("Oh no.")
15. **Choice** → Present player with three options

---

## Player Choices (Confrontation)

### Choice 1: "Fight it!"
- **Action**: Engage the wolf in combat (resolve in fight encounter)
- **Next Scene**: `fight_wolf_scene.lua`

### Choice 2: "Try to calm it."
- **Action**: Attempt non-violent interaction (use Lumin Seed / calm mechanic)
- **Next Scene**: `calm_wolf_scene.lua`

### Choice 3: "Run back to the cabin!"
- **Action**: Retreat to cabin interior (fall back / defensive option)
- **Next Scene**: `cabin_escape_scene.lua`

---

## Implementation Notes

- Pre-load characters and objects but keep them hidden until shown (as in `forestScene.lua`).
- Wind and footsteps SFX are looped where indicated; track loops so they can be stopped on scene hide.
- Tension music should be started when the wolf appears and stopped/managed by choice outcomes.
- Attach helper methods (helpers.attach) to the scene to manage object state changes and dialogue sequencing.
- Visuals: pulse the Lumin Seed when shown; change Elara's sprite to `scared` on threat; animate wolf entrance.
- Consider small camera shake or screen rumble when the growl / wolf appear to emphasize threat.
- Clean up audio on scene `hide` (`audio.stop()` is used in `forestScene.lua`).

---

## Assets referenced

- images/elara_neutral.png
- images/elara_scared.png
- images/elara_determined.png
- images/elara_happy.png
- images/item_lumin_seed.png
- images/item_lumin_seed_glowing.png
- images/corrupted_wolf_aggro.png
- images/corrupted_wolf_calm.png
- images/bg_cabin.png
- images/bg_forest.png

- audio/sfx_rustling_cloth.wav
- audio/sfx_wind_gentle.wav
- audio/sfx_footsteps_forest.wav
- audio/sfx_crow_caw_distant.wav
- audio/sfx_wolf_growl_corrupted.wav
- audio/elara_vo_01.wav
- audio/elara_whisper_ohno.wav
- audio/Music_Tension_Builds.mp3
