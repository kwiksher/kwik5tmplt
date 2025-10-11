# Cabin Scene - Asset Generation Guide

This guide provides detailed instructions for generating all required assets for the Cabin Scene using AI tools and other resources.

---

## 1. Generating Audio

### A. Voice-Over (Character Lines)

#### Elara Line 1: "The Lumin Seed... I found it."
- **Character**: Elara (19 years old, determined)
- **Emotion/Tone**: Whispering to herself
- **Suggested Services**: ElevenLabs, Play.ht, Amazon Polly, Google Wavenet
- **Process Steps**:
  1. Copy text: "The Lumin Seed... I found it."
  2. Voice characteristics: Female, young adult (19), determined yet cautious, slight breathiness (whisper)
  3. Delivery: Soft whisper with wonder and relief
  4. Target filename: `vo_elara_found_seed.wav`

#### Elara Line 2: "There has to be a key somewhere around here..."
- **Character**: Elara
- **Emotion/Tone**: Thinking aloud
- **Suggested Services**: ElevenLabs, Play.ht, Amazon Polly, Google Wavenet
- **Process Steps**:
  1. Copy text: "There has to be a key somewhere around here..."
  2. Voice characteristics: Female, young adult, thoughtful, slightly frustrated
  3. Delivery: Normal speaking volume, contemplative, trailing off
  4. Target filename: `vo_elara_need_key.wav`

#### Elara Line 3: "No... it can't be!"
- **Character**: Elara
- **Emotion/Tone**: Shocked
- **Suggested Services**: ElevenLabs, Play.ht, Amazon Polly, Google Wavenet
- **Process Steps**:
  1. Copy text: "No... it can't be!"
  2. Voice characteristics: Female, young adult, sudden shock and disbelief
  3. Delivery: Rising pitch, emphasis on "can't", convey sudden realization
  4. Target filename: `vo_elara_shocked.wav`

#### Elara Line 4: "Someone got here first."
- **Character**: Elara
- **Emotion/Tone**: Disappointed
- **Suggested Services**: ElevenLabs, Play.ht, Amazon Polly, Google Wavenet
- **Process Steps**:
  1. Copy text: "Someone got here first."
  2. Voice characteristics: Female, young adult, defeated and disappointed
  3. Delivery: Flat, dejected tone, resignation
  4. Target filename: `vo_elara_someone_first.wav`

#### Elara Line 5: "What?! No!"
- **Character**: Elara
- **Emotion/Tone**: Panicking
- **Suggested Services**: ElevenLabs, Play.ht, Amazon Polly, Google Wavenet
- **Process Steps**:
  1. Copy text: "What?! No!"
  2. Voice characteristics: Female, young adult, sudden panic and fear
  3. Delivery: Loud, urgent, fearful, quick delivery
  4. Target filename: `vo_elara_panic.wav`

---

### B. Sound Effects (SFX)

#### SFX 1: Door Rattle
- **Description**: Door handle rattling, won't budge
- **Suggested Sources**: Freesound.org, Unity Asset Store, Humble Bundle SFX packs, Audo.ai
- **Search Keywords**: door rattle, door handle shake, locked door, wooden door rattle
- **Target Filename**: `sfx_door_rattle.wav`
- **Loop**: No

#### SFX 2: Key Turn
- **Description**: Key turning in lock
- **Suggested Sources**: Freesound.org, Unity Asset Store, Humble Bundle SFX packs, Audo.ai
- **Search Keywords**: key turn lock, metal key, lock mechanism, key unlock
- **Target Filename**: `sfx_key_turn.wav`
- **Loop**: No

#### SFX 3: Door Creak
- **Description**: Old door creaking open slowly
- **Suggested Sources**: Freesound.org, Unity Asset Store, Humble Bundle SFX packs, Audo.ai
- **Search Keywords**: door creak, old door open, wooden door squeak, creaky door
- **Target Filename**: `sfx_door_creak.wav`
- **Loop**: No

#### SFX 4: Lock Click
- **Description**: Lock clicking open
- **Suggested Sources**: Freesound.org, Unity Asset Store, Humble Bundle SFX packs, Audo.ai
- **Search Keywords**: lock click, chest lock, padlock open, lock mechanism
- **Target Filename**: `sfx_lock_click.wav`
- **Loop**: No

#### SFX 5: Chest Creak
- **Description**: Chest creaking open
- **Suggested Sources**: Freesound.org, Unity Asset Store, Humble Bundle SFX packs, Audo.ai
- **Search Keywords**: chest open, wooden chest creak, old chest, hinges creak
- **Target Filename**: `sfx_chest_creak.wav`
- **Loop**: No

#### SFX 6: Door Slam
- **Description**: Heavy door slamming shut with thunderous bang
- **Suggested Sources**: Freesound.org, Unity Asset Store, Humble Bundle SFX packs, Audo.ai
- **Search Keywords**: door slam, heavy door close, wooden door bang, door shut hard
- **Target Filename**: `sfx_door_slam.wav`
- **Loop**: No

---

### C. Music/Ambience

#### Ambient 1: Cabin Quiet
- **Description**: Eerie quiet forest ambience, creaking wood
- **Mood**: Mysterious, tense, isolated
- **Suggested Sources**: YouTube Audio Library, Pixabay Music, Freesound.org, AIVA, Soundraw, Mubert
- **Musical Characteristics**:
  - Tempo: Very slow or ambient (no clear tempo)
  - Genre: Ambient, atmospheric, dark ambient
  - Instrumentation: Subtle forest sounds, distant wind, occasional wood creaks, minimal music
  - Volume: Low, background level
- **Target Filename**: `ambient_cabin_quiet.mp3`
- **Loop**: Yes

#### Music 1: Tension Building
- **Description**: Tension building music
- **Mood**: Suspenseful, ominous, threatening
- **Suggested Sources**: YouTube Audio Library, Pixabay Music, composers, AIVA, Soundraw, Mubert
- **Musical Characteristics**:
  - Tempo: Moderate, building
  - Genre: Cinematic tension, horror/thriller
  - Instrumentation: Low strings, dissonant chords, rising tension, possibly percussion
  - Trigger: After door slams shut
- **Target Filename**: `music_cabin_tension.mp3`
- **Loop**: Optional (can loop until player makes choice)

---

## 2. Generating Images

### A. Backgrounds

#### Background 1: Cabin Exterior
```
A weathered old cabin in the woods, exterior view, wooden planks aged and gray,
vines and moss crawling up the sides, heavy crooked wooden door slightly ajar,
surrounded by dark forest, overcast daylight filtering through trees, mysterious
and foreboding atmosphere, highly detailed, digital painting, fantasy art style,
wide cinematic shot, 4K quality, muted color palette with greens and browns
```
- **Target Filename**: `bg_cabin_exterior.png`
- **Suggested Dimensions**: 1920x1080 or 2048x1536
- **Art Style**: Fantasy digital painting, slightly dark and moody
- **Usage**: Opening shot

#### Background 2: Cabin Interior
```
Interior of an old dusty cabin, abandoned and gray atmosphere, boarded windows
with cracks of light streaming through, dusty air with visible light rays,
wooden table in center of room, old chest in shadowy corner, stone fireplace
with strange arcane markings carved into wall beside it, worn wooden floorboards,
cobwebs in corners, highly detailed, digital painting, fantasy art style,
wide interior shot, dim lighting, 4K quality, desaturated color palette
```
- **Target Filename**: `bg_cabin_interior.png`
- **Suggested Dimensions**: 1920x1080 or 2048x1536
- **Art Style**: Fantasy digital painting, dusty and atmospheric
- **Usage**: Main scene location

---

### B. Character Sprites

#### Character: Elara (19 years old)

**Base Character Description for Consistency:**
```
Young woman, 19 years old, determined eyes, practical worn-out traveling clothing,
leather vest, simple tunic, pants, boots, knife at belt, brown hair tied back,
strong but lean build, fantasy art style, character portrait, white/transparent
background, highly detailed, digital painting, full body or three-quarter view
```

##### Sprite 1: Elara Neutral
```
Young woman adventurer, 19 years old, neutral determined expression, standing pose,
practical worn-out traveling clothing, leather vest, simple tunic, pants, boots,
knife at belt, brown hair tied back, strong stance, fantasy art style, character
sprite, transparent background, highly detailed, digital painting
```
- **Target Filename**: `elara_neutral.png`
- **Suggested Dimensions**: 400x600 or 512x768
- **State**: Default/determined expression

##### Sprite 2: Elara Focused
```
Young woman adventurer, 19 years old, focused examining expression, slightly leaning
forward pose, hand near chin or reaching out, practical worn-out traveling clothing,
leather vest, knife at belt, brown hair tied back, concentrated gaze, fantasy art
style, character sprite, transparent background, highly detailed, digital painting
```
- **Target Filename**: `elara_focused.png`
- **Suggested Dimensions**: 400x600 or 512x768
- **State**: Examining/thinking, whispering to herself

##### Sprite 3: Elara Shocked
```
Young woman adventurer, 19 years old, shocked expression, eyes wide, mouth slightly
open, hand to chest or reaching forward, practical worn-out traveling clothing,
leather vest, knife at belt, brown hair tied back, surprised body language, fantasy
art style, character sprite, transparent background, highly detailed, digital painting
```
- **Target Filename**: `elara_shocked.png`
- **Suggested Dimensions**: 400x600 or 512x768
- **State**: Face falling, disappointed, discovering empty chest

##### Sprite 4: Elara Panicking
```
Young woman adventurer, 19 years old, panicked fearful expression, eyes wide with
fear, defensive or reaching pose, both hands up or reaching desperately, practical
worn-out traveling clothing, leather vest, knife at belt, brown hair slightly
disheveled, scared body language, fantasy art style, character sprite, transparent
background, highly detailed, digital painting
```
- **Target Filename**: `elara_panicking.png`
- **Suggested Dimensions**: 400x600 or 512x768
- **State**: Scared, desperate, trapped

---

### C. Props/Objects

### C. Props/Objects

#### Prop 1: Lumin Seed
```
A small magical seed, glowing with soft warm golden light, pulsing gently, only
source of color in gray environment, lying on wooden surface, magical fantasy item,
highly detailed, digital painting, close-up view, warm light emanating, particle
effects around seed, transparent or white background, isolated object, 4K quality
```
- **Target Filename**: `lumin_seed_glowing.png`
- **Suggested Dimensions**: 100x100 or 128x128
- **States**: glowing (default)
- **Special Notes**: Consider adding glow/particle effects in-engine

#### Prop 2: Cabin Door (Closed)
```
Heavy old wooden door, slightly crooked on rusted hinges, weathered dark wood,
iron handle and lock visible, cabin interior or exterior view, fantasy art style,
highly detailed, door closed state, front view, semi-transparent or white background,
isolated object
```
- **Target Filename**: `cabin_door_closed.png`
- **Suggested Dimensions**: 220x320 or 256x384
- **States**: closed_locked, closed_sealed

#### Prop 3: Cabin Door (Open)
```
Heavy old wooden door, slightly crooked on rusted hinges, weathered dark wood,
swung open position, showing door from angle, fantasy art style, highly detailed,
door open state, semi-transparent or white background, isolated object
```
- **Target Filename**: `cabin_door_open.png`
- **Suggested Dimensions**: 220x320 or 256x384
- **States**: open

#### Prop 4: Iron Key
```
Old iron key, medieval style, rusted and weathered, glinting slightly, simple
design with ornate bow, lying flat or at angle, fantasy art style, highly detailed,
close-up view, isolated object, transparent or white background
```
- **Target Filename**: `key_iron.png`
- **Suggested Dimensions**: 50x50 or 64x64
- **States**: hidden, found, used

#### Prop 5: Old Chest (Locked)
```
Old wooden chest with rusted iron bands and padlock, medieval treasure chest,
weathered wood, closed and locked, slightly in shadow, fantasy art style, highly
detailed, front three-quarter view, isolated object, transparent or white background
```
- **Target Filename**: `chest_locked.png`
- **Suggested Dimensions**: 170x130 or 256x192
- **States**: locked

#### Prop 6: Old Chest (Unlocked)
```
Old wooden chest with rusted iron bands, medieval treasure chest, weathered wood,
padlock open and hanging to side, closed but unlocked, fantasy art style, highly
detailed, front three-quarter view, isolated object, transparent or white background
```
- **Target Filename**: `chest_unlocked.png`
- **Suggested Dimensions**: 170x130 or 256x192
- **States**: unlocked

#### Prop 7: Old Chest (Open)
```
Old wooden chest with rusted iron bands, medieval treasure chest, weathered wood,
lid lifted open revealing empty dark interior, fantasy art style, highly detailed,
front three-quarter view showing inside, isolated object, transparent or white background
```
- **Target Filename**: `chest_open.png`
- **Suggested Dimensions**: 170x130 or 256x192
- **States**: open

#### Prop 8: Brass Key
```
Small brass key, shiny brass material with slight tarnish, ornate design, simple
medieval style, lying flat or at angle, fantasy art style, highly detailed, close-up
view, isolated object, transparent or white background
```
- **Target Filename**: `key_brass.png`
- **Suggested Dimensions**: 50x50 or 64x64
- **States**: hidden, found, used

#### Prop 9: Boarded Window
```
Window with wooden boards nailed across it, cracks of light visible between boards,
weathered gray wood, rusty nails, interior view, fantasy art style, highly detailed,
front view, isolated object, semi-transparent or white background
```
- **Target Filename**: `window_boarded.png`
- **Suggested Dimensions**: 150x200 or 192x256
- **States**: boarded
- **Interaction**: Potential exit choice

#### Prop 10: Arcane Markings
```
Strange arcane magical markings carved into stone or wood wall, glowing faintly
with ethereal blue or purple light, mystical symbols and runes, ancient and mysterious,
fantasy art style, highly detailed, front view of wall section with markings,
isolated object, dark background or transparent
```
- **Target Filename**: `markings_arcane.png`
- **Suggested Dimensions**: 200x150 or 256x192
- **States**: visible
- **Interaction**: Potential investigation choice

---

## 3. Asset Consistency Notes

### Art Style Guidelines
- **Overall Style**: Fantasy digital painting, semi-realistic with stylized elements
- **Color Palette**: Muted and desaturated for cabin interior (grays, dusty browns), with Lumin Seed as only bright warm color
- **Lighting**: Dim interior lighting with dramatic light shafts through boarded windows
- **Detail Level**: High detail, painterly style, 4K quality where possible

### Character Consistency
- Elara must be consistent across all 4 sprite states
- Same outfit, hair style, and physical appearance
- Only facial expressions and body language should change
- Consider creating from same base pose and modifying

### Prop Consistency
- All wooden items (door, chest, table) should share similar weathered wood texture
- Keys should be distinct (iron vs brass) but similar medieval style
- Magical elements (Lumin Seed, arcane markings) should have similar glow style

### Quality Requirements
- All images should be high resolution (at least 2x the display size)
- Use transparent backgrounds for sprites and props
- Backgrounds should be full scene without transparency
- All assets should work well when composited together

---

## Asset Checklist

### Images (16 assets)
- [ ] bg_cabin_exterior.png
- [ ] bg_cabin_interior.png
- [ ] elara_neutral.png
- [ ] elara_focused.png
- [ ] elara_shocked.png
- [ ] elara_panicking.png
- [ ] lumin_seed_glowing.png
- [ ] cabin_door_closed.png
- [ ] cabin_door_open.png
- [ ] key_iron.png
- [ ] chest_locked.png
- [ ] chest_unlocked.png
- [ ] chest_open.png
- [ ] key_brass.png
- [ ] window_boarded.png
- [ ] markings_arcane.png

### Audio (13 assets)
- [ ] vo_elara_found_seed.wav
- [ ] vo_elara_need_key.wav
- [ ] vo_elara_shocked.wav
- [ ] vo_elara_someone_first.wav
- [ ] vo_elara_panic.wav
- [ ] sfx_door_rattle.wav
- [ ] sfx_key_turn.wav
- [ ] sfx_door_creak.wav
- [ ] sfx_lock_click.wav
- [ ] sfx_chest_creak.wav
- [ ] sfx_door_slam.wav
- [ ] ambient_cabin_quiet.mp3
- [ ] music_cabin_tension.mp3

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

## 3. Asset Consistency Notes

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
