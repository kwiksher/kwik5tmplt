# Fountain Script to Technical Model Generator

## Instructions
Generate a comprehensive technical model document (`.model.md`) from the provided Fountain script. This model should describe all necessary elements for implementing the scene in a visual novel or interactive story engine.

---

## Required Output Structure

### 1. Scene Information
- **Scene Name**: Extract from Fountain title/scene heading
- **Location**: Primary location(s) from scene headings
- **Time**: Time of day mentioned in headings
- **Setting Transitions**: List all location changes (EXT/INT transitions)

### 2. Backgrounds
For each unique location mentioned in scene headings:
- **Asset ID**: `bg_[descriptive_name]`
- **Description**: Visual details from action lines describing the setting
- **Usage**: When this background appears in the scene

### 3. Characters
For each character that appears:
- **Name and Description**: Age, physical appearance, clothing from action lines
- **States/Emotions**: List all emotional states shown (neutral, shocked, happy, angry, etc.)
- **Sprites Needed**: `[character]_[state].png` for each state
- **Position**: Where character typically appears on screen
- Extract from: Character introductions, parentheticals, and action descriptions

### 4. Props/Objects
For each interactive or significant object mentioned:
- **Object Name**: Clear identifier
- **Description**: Visual details from action lines
- **States**: All possible states (locked, open, glowing, broken, etc.)
- **Images**: `[object]_[state].png` for each state
- **Position**: Location in scene
- **Size**: Suggested dimensions (small/medium/large or specific pixels)
- **Interaction**: Can it be clicked, examined, used?

### 5. Sound Effects (SFX)
For each sound effect notation in the script:
- **SFX Name**: Descriptive identifier
- **Description**: What the sound is
- **File**: `sfx_[descriptive_name].wav`
- **Trigger**: When/where in the scene it plays
- Extract from: Lines beginning with "SFX:" or sound descriptions in action lines

### 6. Music/Ambience
Infer from scene mood and explicit mentions:
- **Track Name**: Descriptive identifier
- **Description**: Type and mood of music
- **File**: `music_[name].mp3` or `ambient_[name].mp3`
- **Loop**: Yes/No
- **Usage**: When it plays, full scene or specific moments
- **Trigger**: Scene start, specific events, mood changes

### 7. Game Flags/Variables
Identify state tracking needs:
- **Variable Name**: camelCase identifier (e.g., `hasDoorKey`, `isTrapped`)
- **Type**: Boolean, Integer, String
- **Initial Value**: Starting state
- **Set to [value]**: When/where it changes
- **Usage**: How it affects gameplay logic
- Infer from: Locked objects, character knowledge, scene progression requirements

### 8. Dialogue/Voice-Over Lines
For each character dialogue:
- **Character + Line Number**: Format as `[Character] Line X`
- **Text**: Exact dialogue from script
- **Type**: Regular dialogue, whisper, shout, internal monologue (from parentheticals)
- **File**: `vo_[character]_[short_description].wav`
- **Trigger**: When in the scene flow this line appears

### 9. Scene Flow / Event Sequence
Create numbered step-by-step breakdown:
1. Opening state/transition
2. Each significant action or event
3. Object interactions
4. State changes
5. Character reactions
6. Dialogue moments
7. Scene ending/transition

### 10. Player Choices (if applicable)
If scene ends with options or multiple paths:
- **Choice Number + Description**: What the choice is
- **Action**: What happens if selected
- **Next Scene**: File/scene identifier where it leads
- Infer from: "What will she do?", multiple possible actions, FADE OUT with open ending

### 11. Implementation Notes
Technical suggestions:
- Animation transitions
- Visual effects (particle effects, screen shake, highlighting)
- Camera movements
- Special rendering considerations
- Performance notes

### 12. Assets Summary
Provide complete lists at the end:
- **Images**: All image assets with paths (images/[filename])
- **Audio SFX**: All sound effects with paths (audio/[filename])
- **Audio Music**: All music/ambient tracks with paths (audio/[filename])
- **Audio VO**: All voice-over files with paths (audio/[filename])

---

## Analysis Guidelines

### What to Extract:
- **Scene Headings**: Location and time information
- **Action Lines**: Visual descriptions, object details, character actions
- **Character Names**: Who appears and their descriptions
- **Parentheticals**: Emotional states, tone of dialogue
- **Dialogue**: All spoken text
- **SFX Notations**: Sound effect cues
- **Transitions**: FADE OUT, CUT TO, etc.

### What to Infer:
- Object states needed for interactions (if door is locked, need locked/unlocked/open states)
- Background music/ambience from scene mood
- Game flags from logic requirements (if something must be found before progressing)
- Sprite positions from scene blocking
- Asset sizes from object importance and type

### Naming Conventions:
- **Images**: lowercase, underscores, descriptive
  - Backgrounds: `bg_[location].png`
  - Characters: `[character]_[state].png`
  - Props: `[object]_[state].png`
  - UI: `[ui_element].png`
- **Audio**: lowercase, underscores, prefixed by type
  - SFX: `sfx_[description].wav`
  - Music: `music_[name].mp3`
  - Ambient: `ambient_[description].mp3`
  - Voice: `vo_[character]_[description].wav`
- **Variables**: camelCase, descriptive
  - Boolean flags: `has[Item]`, `is[State]`, `can[Action]`
  - Counters: `[noun]Count`, `[action]Attempts`

---

## Output Format

Generate a Markdown document following this structure exactly, with all sections filled in based on the analysis of the provided Fountain script. Be thorough and specific, providing actionable technical specifications that developers and artists can use directly for implementation.