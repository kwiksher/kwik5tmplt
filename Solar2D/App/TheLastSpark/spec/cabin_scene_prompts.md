# Cabin Scene - Asset Generation Guide

This guide provides detailed instructions for generating all required assets for the Cabin Scene using AI tools and asset libraries.

---

## 1. Generating Audio

### A. Voice-Over (Character Lines)

#### Elara Line 1 - "The Lumin Seed... I found it."
- **Character**: Elara (19 years old, determined)
- **Emotion/Tone**: Whispering to herself, quiet discovery
- **Suggested Services**: ElevenLabs, Play.ht, Amazon Polly, Google Wavenet
- **Process Steps**:
  1. Copy the exact dialogue text: "The Lumin Seed... I found it."
  2. Voice characteristics:
     - Female voice, young adult (19 years old)
     - Slightly breathy whisper
     - Tone: Wonder mixed with quiet satisfaction
     - Accent: Neutral or slightly fantasy-influenced
  3. Delivery instructions:
     - Speak in a hushed whisper as if talking to herself
     - Emphasis on "found"
     - Slight pause after "Seed..."
  4. Target filename: `vo_elara_found_seed.wav`

#### Elara Line 2 - "There has to be a key somewhere around here..."
- **Character**: Elara
- **Emotion/Tone**: Thinking aloud, determined focus
- **Suggested Services**: ElevenLabs, Play.ht, Amazon Polly, Google Wavenet
- **Process Steps**:
  1. Copy the exact dialogue text: "There has to be a key somewhere around here..."
  2. Voice characteristics:
     - Same female voice as Line 1
     - Normal speaking volume, not whispering
     - Tone: Determined, slightly frustrated
  3. Delivery instructions:
     - Speaking to herself while searching
     - Trail off slightly at the end ("here...")
     - Emphasis on "has to be"
  4. Target filename: `vo_elara_need_key.wav`

#### Elara Line 3 - "No... it can't be!"
- **Character**: Elara
- **Emotion/Tone**: Shocked, disappointed
- **Suggested Services**: ElevenLabs, Play.ht, Amazon Polly, Google Wavenet
- **Process Steps**:
  1. Copy the exact dialogue text: "No... it can't be!"
  2. Voice characteristics:
     - Same female voice as previous lines
     - Sudden emotional shift to shock
     - Tone: Disbelief and disappointment
  3. Delivery instructions:
     - Start soft on "No..."
     - Quick intake of breath
     - Stronger, more urgent on "it can't be!"
     - Emphasis on "can't"
  4. Target filename: `vo_elara_shocked.wav`

#### Elara Line 4 - "Someone got here first."
- **Character**: Elara
- **Emotion/Tone**: Disappointed, resigned
- **Suggested Services**: ElevenLabs, Play.ht, Amazon Polly, Google Wavenet
- **Process Steps**:
  1. Copy the exact dialogue text: "Someone got here first."
  2. Voice characteristics:
     - Same female voice as previous lines
     - Continuing from shock, settling into disappointment
     - Tone: Defeated, resigned
  3. Delivery instructions:
     - Slower pace, processing the realization
     - Emphasis on "first"
     - Slightly bitter or deflated tone
  4. Target filename: `vo_elara_someone_first.wav`

#### Elara Line 5 - "What?! No!"
- **Character**: Elara
- **Emotion/Tone**: Panicking, desperate
- **Suggested Services**: ElevenLabs, Play.ht, Amazon Polly, Google Wavenet
- **Process Steps**:
  1. Copy the exact dialogue text: "What?! No!"
  2. Voice characteristics:
     - Same female voice as previous lines
     - High emotion - panic and fear
     - Tone: Desperate, scared
  3. Delivery instructions:
     - Sharp exclamation on "What?!"
     - Urgent, louder on "No!"
     - Voice should convey fear and disbelief
     - Quick pacing, both words delivered rapidly
  4. Target filename: `vo_elara_panic.wav`

---

### B. Sound Effects (SFX)

#### SFX 1: Door Rattle
- **Description**: Door handle rattling, won't budge
- **Suggested Sources**: Freesound.org, Unity Asset Store, Humble Bundle SFX packs, Audo.ai
- **Search Keywords**: "door rattle", "door handle shake", "locked door", "door won't open", "metal handle rattle"
- **Target Filename**: `sfx_door_rattle.wav`
- **Loop**: No (single action)
- **Notes**: Should sound old and heavy, metal handle rattling against wood

#### SFX 2: Key Turn
- **Description**: Key turning in lock
- **Suggested Sources**: Freesound.org, Unity Asset Store, Humble Bundle SFX packs
- **Search Keywords**: "key turn lock", "key in lock", "lock mechanism", "key unlock", "metal key turn"
- **Target Filename**: `sfx_key_turn.wav`
- **Loop**: No (single action)
- **Notes**: Should sound like an old iron key turning in a rusty lock

#### SFX 3: Door Creak
- **Description**: Old door creaking open slowly
- **Suggested Sources**: Freesound.org, Unity Asset Store, Humble Bundle SFX packs
- **Search Keywords**: "door creak open", "old door opening", "wooden door creak", "creaky hinges", "slow door open"
- **Target Filename**: `sfx_door_creak.wav`
- **Loop**: No (single action)
- **Notes**: Should be long and slow, conveying age and heaviness

#### SFX 4: Lock Click
- **Description**: Lock clicking open
- **Suggested Sources**: Freesound.org, Unity Asset Store, Humble Bundle SFX packs
- **Search Keywords**: "lock click", "lock open", "chest lock", "padlock click", "mechanism unlock"
- **Target Filename**: `sfx_lock_click.wav`
- **Loop**: No (single action)
- **Notes**: Crisp, satisfying click sound

#### SFX 5: Chest Creak
- **Description**: Chest creaking open
- **Suggested Sources**: Freesound.org, Unity Asset Store, Humble Bundle SFX packs
- **Search Keywords**: "chest open", "wooden chest creak", "treasure chest", "box creak", "old chest"
- **Target Filename**: `sfx_chest_creak.wav`
- **Loop**: No (single action)
- **Notes**: Similar to door creak but shorter, lighter tone

#### SFX 6: Door Slam
- **Description**: Heavy door slamming shut with thunderous bang
- **Suggested Sources**: Freesound.org, Unity Asset Store, Humble Bundle SFX packs
- **Search Keywords**: "door slam", "heavy door close", "door bang", "loud door slam", "wood door impact"
- **Target Filename**: `sfx_door_slam.wav`
- **Loop**: No (single action)
- **Notes**: Should be dramatic, loud, and final-sounding; may want slight reverb for emphasis

---

### C. Music/Ambience

#### Track 1: Cabin Ambience
- **Description**: Eerie quiet forest ambience with creaking wood
- **Mood**: Quiet, unsettling, atmospheric
- **Suggested Sources**: Royalty-free libraries (YouTube Audio Library, Pixabay Music, Freesound.org), composers, AI tools (AIVA, Soundraw, Mubert)
- **Musical Characteristics**:
  - Genre: Ambient, atmospheric
  - Tempo: N/A (ambient soundscape)
  - Instrumentation: Natural forest sounds, occasional wood creaks, distant wind, subtle low drone
  - Keywords: "forest ambience", "eerie quiet", "cabin atmosphere", "creaking wood", "haunting ambience"
- **Target Filename**: `ambient_cabin_quiet.mp3`
- **Loop**: Yes (continuous background)
- **Notes**: Should be subtle enough not to overpower dialogue, maintain tension throughout

#### Track 2: Tension Music
- **Description**: Tension building music for trap/danger moment
- **Mood**: Tense, threatening, building dread
- **Suggested Sources**: Royalty-free libraries (YouTube Audio Library, Pixabay Music), composers, AI tools (AIVA, Soundraw, Mubert)
- **Musical Characteristics**:
  - Genre: Cinematic tension/suspense
  - Tempo: Slow to moderate (60-80 BPM)
  - Instrumentation: Low strings, percussion hits, dissonant tones, possible electronic elements
  - Keywords: "tension music", "suspense", "horror tension", "trapped", "danger music", "building dread"
- **Target Filename**: `music_cabin_tension.mp3`
- **Loop**: Optional (depends on scene length)
- **Notes**: Should start immediately after door slam, crescendo with realization of being trapped

---

## 2. Generating Images

### A. Backgrounds

#### Background 1: Cabin Exterior (`bg_cabin_exterior`)
- **Target Filename**: `bg_cabin_exterior.png`
- **Dimensions**: 1920x1080px (standard HD) or project-specific size
- **AI Image Generation Prompt**:
```
A weathered old cabin in a dark forest, exterior view. The cabin has aged wooden planks covered with creeping vines climbing up the sides. Heavy crooked wooden door at the entrance, slightly off its hinges. Surrounded by tall trees with dappled daylight filtering through. Mysterious, slightly ominous atmosphere. Digital painting style, fantasy game art, highly detailed, muted color palette with greens and browns. Wide establishing shot, slight low angle to emphasize the cabin's imposing presence.
```
- **Style Notes**: Dark fantasy, painterly, atmospheric
- **Lighting**: Daylight but filtered through trees, creating shadows
- **Keywords**: weathered cabin, forest, vines, crooked door, ominous, fantasy art

#### Background 2: Cabin Interior (`bg_cabin_interior`)
- **Target Filename**: `bg_cabin_interior.png`
- **Dimensions**: 1920x1080px (standard HD) or project-specific size
- **AI Image Generation Prompt**:
```
Interior of an old dusty cabin, abandoned and mysterious. Boarded windows with thin cracks of light penetrating through, creating dramatic light rays in the dusty air. Gray and dusty atmosphere, desaturated colors. Wooden table in the center of the room. Old chest in the corner, partially in shadow. Stone fireplace on one wall with strange arcane markings carved around it. Wooden floorboards, some loose. Cobwebs in corners. Fantasy game environment, isometric or side view perspective, highly detailed, digital painting, mysterious and slightly eerie mood.
```
- **Style Notes**: Dark fantasy, painterly, dusty and abandoned feel
- **Lighting**: Dim with cracks of light through boarded windows, emphasizing dust particles
- **Keywords**: cabin interior, dusty, boarded windows, mysterious, arcane markings, fireplace, old chest

---

### B. Character Sprites

#### Character: Elara

**Base Character Description**:
```
19-year-old young woman with determined eyes and practical appearance. Wears worn-out, practical adventurer clothing suitable for travel - leather vest, simple tunic, pants, boots. Has a knife sheathed at her belt. Medium-length hair tied back practically. Strong, capable build. Fantasy game character sprite, 2D digital art style, clean lines, painterly shading, transparent background.
```

**Sprite 1: Elara Neutral** (`elara_neutral.png`)
- **Dimensions**: 400x600px (or project-specific size)
- **AI Image Generation Prompt**:
```
Full body character sprite of a 19-year-old female adventurer named Elara. Determined expression, standing pose. Wears worn leather vest, simple tunic, practical pants and boots. Knife sheathed at belt. Medium-length hair tied back. Strong capable build. Neutral stance, confident posture. Fantasy game character art, 2D sprite, digital painting style, clean lines, detailed shading, white/transparent background. Front-facing or slight 3/4 view.
```

**Sprite 2: Elara Focused** (`elara_focused.png`)
- **Dimensions**: 400x600px (or project-specific size)
- **AI Image Generation Prompt**:
```
Full body character sprite of Elara, 19-year-old female adventurer. Focused, examining expression - eyes narrowed in concentration, slight frown. Same clothing as neutral: worn leather vest, tunic, pants, boots, knife at belt. Pose: leaning forward slightly, hand near chin in thinking gesture or reaching to examine something. Fantasy game character art, 2D sprite, digital painting style, clean lines, detailed shading, white/transparent background. Same character design consistency.
```

**Sprite 3: Elara Shocked** (`elara_shocked.png`)
- **Dimensions**: 400x600px (or project-specific size)
- **AI Image Generation Prompt**:
```
Full body character sprite of Elara, 19-year-old female adventurer. Shocked, disappointed expression - eyes wide, mouth slightly open, face fallen. Same clothing: worn leather vest, tunic, pants, boots, knife at belt. Pose: leaning back slightly, hands up in disbelief gesture or one hand to face. Body language showing surprise and disappointment. Fantasy game character art, 2D sprite, digital painting style, clean lines, detailed shading, white/transparent background. Same character design consistency.
```

**Sprite 4: Elara Panicking** (`elara_panicking.png`)
- **Dimensions**: 400x600px (or project-specific size)
- **AI Image Generation Prompt**:
```
Full body character sprite of Elara, 19-year-old female adventurer. Panicked, scared expression - wide fearful eyes, mouth open in alarm, worried brow. Same clothing: worn leather vest, tunic, pants, boots, knife at belt. Pose: tense, defensive stance, hands raised or reaching forward desperately. Body language showing fear and desperation. Fantasy game character art, 2D sprite, digital painting style, clean lines, detailed shading, white/transparent background. Same character design consistency.
```

**Character Consistency Notes**:
- Maintain exact same outfit, hair style, and facial features across all sprites
- Same color palette for clothing and hair
- Keep knife at belt visible in all poses
- Ensure same art style and level of detail
- Recommend generating all sprites in same session or using character reference feature

---

### C. Props/Objects

#### Prop 1: Lumin Seed
**Files**: `lumin_seed_glowing.png`
- **Dimensions**: 100x100px
- **AI Image Generation Prompt**:
```
A single magical glowing seed, fantasy game item. The Lumin Seed pulses with soft warm golden light, creating a gentle glow effect. Small seed shape, roughly acorn-sized, with luminescent quality. The only source of warm color in the scene. Isolated on transparent background. Digital painting style, highly detailed, magical particle effects around edges, fantasy game item art, 2D sprite, soft light rays emanating from center.
```
- **Style Notes**: Should be the only warm-colored item, emphasize glow effect
- **Additional Variants**: Consider creating animation frames with different glow intensities for pulsing effect

#### Prop 2: Cabin Door
**Files**:
- `cabin_door_closed.png` (used for both locked and sealed states)
- `cabin_door_open.png`

**Door Closed** (`cabin_door_closed.png`)
- **Dimensions**: 220x320px
- **AI Image Generation Prompt**:
```
Heavy old wooden door for cabin, closed position. Weathered dark wood planks held together with iron bands. Slightly crooked on hinges. Visible iron door handle. Rustic, aged appearance with scratches and wear. Fantasy game prop, 2D asset, digital painting style, detailed texture, isometric or straight-on view, transparent background. Medieval fantasy aesthetic.
```

**Door Open** (`cabin_door_open.png`)
- **Dimensions**: 220x320px
- **AI Image Generation Prompt**:
```
Same heavy old wooden door as closed version, but in open position. Door swung inward or outward (match your scene layout). Same weathered dark wood, iron bands, and hardware. Show the edge/thickness of the door. Fantasy game prop, 2D asset, digital painting style, detailed texture, isometric or straight-on view, transparent background. Maintain exact same door design as closed version.
```
- **Consistency Notes**: Door must look identical in both states, only position differs

#### Prop 3: Iron Key (Door Key)
**Files**: `key_iron.png`
- **Dimensions**: 50x50px
- **AI Image Generation Prompt**:
```
Old iron skeleton key, medieval fantasy style. Dark gray iron metal with some rust spots. Traditional key shape with ornate head and simple teeth. Slightly glinting despite age. Fantasy game item, 2D sprite, digital painting style, highly detailed, isometric or top-down view, transparent background. Small inventory item size.
```

#### Prop 4: Old Chest
**Files**:
- `chest_locked.png`
- `chest_unlocked.png`
- `chest_open.png`

**Chest Locked** (`chest_locked.png`)
- **Dimensions**: 170x130px
- **AI Image Generation Prompt**:
```
Old wooden treasure chest with rusted iron bands across it. Visible padlock or lock mechanism on front, clearly locked. Weathered wood, aged appearance. Partially in shadow. Fantasy game prop, 2D asset, digital painting style, detailed texture, isometric 3/4 view showing front and top, transparent background. Medieval fantasy aesthetic, mysterious feel.
```

**Chest Unlocked** (`chest_unlocked.png`)
- **Dimensions**: 170x130px
- **AI Image Generation Prompt**:
```
Same old wooden treasure chest as locked version. Rusted iron bands. Lock mechanism open or hanging loose. Same weathered appearance and viewing angle. Fantasy game prop, 2D asset, digital painting style, detailed texture, isometric 3/4 view, transparent background. Maintain exact same chest design, only lock state differs.
```

**Chest Open** (`chest_open.png`)
- **Dimensions**: 170x130px
- **AI Image Generation Prompt**:
```
Same old wooden treasure chest, now with lid open/lifted. Show empty interior - dusty, bare wood inside, completely empty with no contents. Rusted iron bands. Same weathered appearance. Fantasy game prop, 2D asset, digital painting style, detailed texture, isometric 3/4 view showing inside, transparent background. Emphasize emptiness of interior.
```
- **Consistency Notes**: All three states must be same chest, only lid position and lock state differ

#### Prop 5: Brass Key (Chest Key)
**Files**: `key_brass.png`
- **Dimensions**: 50x50px
- **AI Image Generation Prompt**:
```
Small brass skeleton key, medieval fantasy style. Golden brass metal, slightly tarnished but still shiny. Smaller and more delicate than iron key. Traditional key shape with decorative head and fine teeth. Fantasy game item, 2D sprite, digital painting style, highly detailed, isometric or top-down view, transparent background. Small inventory item size.
```
- **Differentiation Note**: Should look noticeably different from iron key - smaller, brass/gold color vs dark iron

#### Prop 6: Boarded Window
**Files**: `window_boarded.png`
- **Dimensions**: 150x200px
- **AI Image Generation Prompt**:
```
Window covered with wooden boards nailed across it. Dark wood planks crisscrossing the window frame. Visible cracks between boards with thin rays of light coming through. Aged, weathered wood. View from interior side. Fantasy game environment prop, 2D asset, digital painting style, detailed texture, straight-on view, transparent background or can be part of wall texture. Mysterious, offering potential escape route feel.
```

#### Prop 7: Arcane Markings
**Files**: `markings_arcane.png`
- **Dimensions**: 200x150px
- **AI Image Generation Prompt**:
```
Strange arcane magical markings carved into old wood or stone wall. Mysterious runes and symbols in circular pattern. Ancient, mystical appearance. Faint glow or just carved indentations. Located near fireplace area. Fantasy game prop, mysterious magical symbols, 2D asset, digital painting style, detailed carved texture, front view, transparent or blendable background. Should look ancient and mysterious, hinting at magic.
```
- **Style Notes**: Can have subtle glow or be purely carved; should look ancient and hint at magical properties

---

## 3. Layered PSD Generation

**Instructions**: Parse the cabin scene model and generate a YAML configuration file for automated PSD layer creation with proper positioning and layering.

**Generated YAML File**: `cabin_scene_layers.yaml`

```yaml
layers:
  # Background Layer
  - name: bg_cabin_interior
    type: background
    x: 0
    y: 0
    width: 1920
    height: 1080
    z_index: 0
    visible: true
    opacity: 100

  # Environment Props (back to front)
  - name: window_boarded
    type: prop
    x: 1600
    y: 200
    width: 150
    height: 200
    z_index: 10
    visible: true
    opacity: 100
    text: "Boarded Window"
    font_size: 12
    text_color: "#FFFFFF"

  - name: markings_arcane
    type: prop
    x: 200
    y: 400
    width: 200
    height: 150
    z_index: 15
    visible: true
    opacity: 100
    text: "Arcane Markings"
    font_size: 12
    text_color: "#FFFFFF"

  # Chest in corner (multiple states as separate layers)
  - name: chest_locked
    type: prop
    x: 1650
    y: 700
    width: 170
    height: 130
    z_index: 20
    visible: true
    opacity: 100
    text: "Chest (Locked)"
    font_size: 12
    text_color: "#FFFFFF"

  - name: chest_unlocked
    type: prop
    x: 1650
    y: 700
    width: 170
    height: 130
    z_index: 20
    visible: false
    opacity: 100
    text: "Chest (Unlocked)"
    font_size: 12
    text_color: "#FFFFFF"

  - name: chest_open
    type: prop
    x: 1650
    y: 700
    width: 170
    height: 130
    z_index: 20
    visible: false
    opacity: 100
    text: "Chest (Open/Empty)"
    font_size: 12
    text_color: "#FFFFFF"

  # Table (center of room)
  - name: table_wooden
    type: prop
    x: 860
    y: 540
    width: 200
    height: 120
    z_index: 25
    color: "#8B7355"
    visible: true
    opacity: 100
    text: "Wooden Table (placeholder)"
    font_size: 12
    text_color: "#FFFFFF"

  # Lumin Seed (on table, center focus)
  - name: lumin_seed_glowing
    type: prop
    x: 910
    y: 490
    width: 100
    height: 100
    z_index: 30
    visible: true
    opacity: 100
    text: "Lumin Seed"
    font_size: 12
    text_color: "#FFD700"

  # Keys (small items, position varies)
  - name: key_iron
    type: prop
    x: 100
    y: 950
    width: 50
    height: 50
    z_index: 35
    visible: true
    opacity: 100
    text: "Iron Key"
    font_size: 10
    text_color: "#FFFFFF"

  - name: key_brass
    type: prop
    x: 800
    y: 850
    width: 50
    height: 50
    z_index: 35
    visible: false
    opacity: 100
    text: "Brass Key (Hidden)"
    font_size: 10
    text_color: "#FFFFFF"

  # Character (Elara - multiple states)
  - name: elara_neutral
    type: character
    x: 400
    y: 300
    width: 400
    height: 600
    z_index: 40
    visible: true
    opacity: 100
    text: "Elara (Neutral)"
    font_size: 12
    text_color: "#FFFFFF"

  - name: elara_focused
    type: character
    x: 400
    y: 300
    width: 400
    height: 600
    z_index: 40
    visible: false
    opacity: 100
    text: "Elara (Focused)"
    font_size: 12
    text_color: "#FFFFFF"

  - name: elara_shocked
    type: character
    x: 400
    y: 300
    width: 400
    height: 600
    z_index: 40
    visible: false
    opacity: 100
    text: "Elara (Shocked)"
    font_size: 12
    text_color: "#FFFFFF"

  - name: elara_panicking
    type: character
    x: 400
    y: 300
    width: 400
    height: 600
    z_index: 40
    visible: false
    opacity: 100
    text: "Elara (Panicking)"
    font_size: 12
    text_color: "#FFFFFF"

  # Door (foreground or side)
  - name: cabin_door_closed
    type: prop
    x: 1700
    y: 200
    width: 220
    height: 320
    z_index: 50
    visible: true
    opacity: 100
    text: "Door (Closed)"
    font_size: 12
    text_color: "#FFFFFF"

  - name: cabin_door_open
    type: prop
    x: 1700
    y: 200
    width: 220
    height: 320
    z_index: 50
    visible: false
    opacity: 100
    text: "Door (Open)"
    font_size: 12
    text_color: "#FFFFFF"
```

**Layer Organization Notes**:
- z_index 0: Background
- z_index 10-20: Wall-mounted props and furniture (back layer)
- z_index 25-35: Mid-ground props (table, small items)
- z_index 40: Character layer
- z_index 50+: Foreground props (door)
- Multiple state variations for same object share same x, y, dimensions but toggle visibility
- Text labels help identify layers in PSD
- Positions are estimated for 1920x1080 canvas, adjust based on actual composition needs

---

## Asset Quality Requirements

### Consistency Guidelines
- **Art Style**: Maintain consistent fantasy digital painting style across all assets
- **Color Palette**: Muted, desaturated tones for environment; warm glow for Lumin Seed only
- **Lighting**: Dim interior lighting with cracks of light through windows
- **Resolution**: All assets should be high resolution (at least 2x intended display size for quality)
- **Character Consistency**: Use same character reference for all Elara sprites

### Technical Specifications
- **Image Format**: PNG with transparency where applicable
- **Audio Format**:
  - SFX: WAV, 44.1kHz, 16-bit minimum
  - Music/Ambience: MP3, 192kbps minimum or WAV
  - Voice-Over: WAV, 44.1kHz, 16-bit
- **Naming Convention**: Follow exact filenames specified in model document

### Style Matching
- Reference dark fantasy games like "The Banner Saga", "Darkest Dungeon", or similar for art direction
- Environment should feel abandoned, mysterious, slightly ominous
- Character should be practical and grounded, not overly fantastical
- Props should look aged and weathered

---

## Recommended Workflow

1. **Generate Voice-Over First**: Record all Elara lines with same voice actor/AI voice for consistency
2. **Create Character Base**: Generate Elara neutral sprite first, then use as reference for other emotional states
3. **Build Backgrounds**: Create both backgrounds, ensuring they match in style and lighting
4. **Generate Props in Groups**:
   - Keys together (maintain size difference)
   - Chest states together (maintain consistency)
   - Door states together (maintain consistency)
5. **Source/Generate SFX**: Find or generate all sound effects
6. **Create Music Tracks**: Generate or source ambient and tension music
7. **Assemble PSD**: Use YAML configuration to create layered PSD file for scene composition
8. **Test Integration**: Import all assets into game engine and test state transitions

---

## Additional Notes

- Consider creating **glow animation frames** for Lumin Seed (5-8 frames for smooth pulse)
- **Screen shake effect** needed for door slam (implement in game engine)
- **Particle effects** for Lumin Seed glow can be generated in game engine
- May want **light ray effects** for window cracks (can be overlays or built into background)
- Consider **ambient sound layers**: forest background, wind, distant sounds
- **Test all dialogue clips** together to ensure voice consistency across emotional states

---

**Scene Name**: Cabin Scene
**Total Assets**:
- 5 Voice-Over files
- 6 SFX files
- 2 Music/Ambience files
- 2 Background images
- 4 Character sprites
- 10 Prop images
- 1 YAML configuration file

**Estimated Production Time**: 15-25 hours (depending on asset sources and iteration needs)
