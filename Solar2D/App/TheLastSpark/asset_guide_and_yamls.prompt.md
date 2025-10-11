# Asset Generation Prompt Template

Create a comprehensive asset generation guide for a scene by analyzing its technical model document.

## Instructions

Given a scene model file (`${scene}.model.md`), generate a markdown file (`${scene}_prompts.md`) that contains detailed instructions for generating all required assets using AI tools.

**Additionally, generate two YAML configuration files:**
1. `${scene}_layers.yaml` - For visual layer specifications
2. `${scene}_audios.yaml` - For audio asset specifications

## Required Sections

### 1. Generating Audio

#### A. Voice-Over (Character Lines)
- Extract all dialogue/VO lines from the model's "Dialogue/Voice-Over Lines" section
- For each line, specify:
  - **Character name and line reference**
  - **Emotion/tone** (from line type)
  - **Suggested services:** ElevenLabs, Play.ht, Amazon Polly, Google Wavenet
  - **Process steps:**
    1. Copy the exact dialogue text
    2. Recommend voice characteristics (age, gender, accent, emotion)
    3. Note any specific delivery instructions (whisper, shout, etc.)
    4. Provide the target filename from the model

#### B. Sound Effects (SFX)
- List all SFX from the "Sound Effects (SFX)" section
- For each SFX, provide:
  - **Description** from the model
  - **Suggested sources:** Freesound.org, Unity Asset Store, Humble Bundle SFX packs, AI tools like Audo.ai
  - **Search keywords** for finding/generating the sound
  - **Target filename** from the model
  - **Loop indication** if applicable

#### C. Music/Ambience
- Extract music cues from the "Music/Ambience" section
- For each track, specify:
  - **Description and mood**
  - **Suggested sources:** Royalty-free libraries (YouTube Audio Library, Pixabay Music), composers, or AI tools (AIVA, Soundraw, Mubert)
  - **Musical characteristics** (tempo, genre, instrumentation)
  - **Target filename** from the model

#### D. Audio YAML Generation

Generate a YAML file (`${scene}_audios.yaml`) listing all audio assets with their descriptions:

**IMPORTANT: Include all audio assets (voice-over, SFX, music/ambience) from the model.**

```yaml
- name: <audio_filename_with_extension>
  description: <detailed_description_or_empty_string>
- name: <audio_filename_with_extension>
  description: <detailed_description_or_empty_string>
```

**Property Requirements:**

- **name**: Complete filename including extension (.wav, .mp3, .ogg, etc.) exactly as specified in the model
- **description**: Detailed description of the audio including mood, loop indication, and any special characteristics. Use empty string `""` only if no description is needed.

**Example:**

```yaml
- name: sfx_door_rattle.wav
  description: "Wooden door rattling sound, short duration"
- name: sfx_key_turn.wav
  description: "Metal key turning in lock, clear click"
- name: ambient_cabin_quiet.mp3
  description: "Eerie quiet forest ambience, creaking wood (loop)"
- name: music_cabin_tension.mp3
  description: "Tension building music (triggered after door slams)"
- name: vo_character_hello.wav
  description: "Character greeting, friendly tone, male voice"
```

### 2. Generating Images

#### A. Backgrounds
- List all backgrounds from the "Backgrounds" section
- For each background, create:
  - **Detailed AI image generation prompt** incorporating:
    - Scene description from the model
    - Lighting and atmosphere
    - Art style recommendations
    - Camera angle/framing
    - Keywords: "highly detailed", "digital painting", "fantasy", etc.
  - **Target filename** and dimensions from the model

#### B. Character Sprites
- List all characters from the "Characters" section
- For each character:
  - Create a **base prompt** with consistent character description
  - Generate **variation prompts** for each emotional state/pose
  - Include:
    - Physical description
    - Clothing/accessories
    - Art style consistency notes
    - Background recommendation (usually white/transparent)
  - List all required sprite filenames with their states

#### C. Props/Objects
- List all props from the "Props/Objects" section
- For each prop:
  - Create a **detailed prompt** including:
    - Physical description
    - Magical/special effects if applicable
    - Context/placement hints
    - Detail level and art style
  - List all state variations needed
  - Provide target filenames from the model

### 3. Layered PSD Generation

Create instructions for generating a YAML configuration file for automated PSD layer creation.

**Instructions:**

Parse the model file and extract all visual assets (backgrounds, characters, props/objects) with their specifications. Generate a YAML file (`${scene}_layers.yaml`) with this structure:

**IMPORTANT: All properties listed below MUST be included for each layer. Do not omit any properties.**

```yaml
- name: <asset_name>
  type: <background|character|prop>
  x: <x_position>
  y: <y_position>
  width: <width_in_pixels>
  height: <height_in_pixels>
  z_index: <layer_order>
  color: <hex_color_for_layer_fill>  # Fill color for the layer shape/rectangle
  text: <optional_text_label_or_empty_string>
  font_size: <font_size_or_default_16>
  text_color: <hex_color_for_text>  # MUST be different from 'color' property
  visible: <true|false>
  opacity: <0-100>
```

**Property Requirements:**

- **color**: The fill color for the layer/shape (e.g., "#FF5733", "#3498DB"). This represents the background color of the layer rectangle. Should be distinct and appropriate for the asset type.
- **text_color**: The color for any text labels (e.g., "#FFFFFF", "#000000"). MUST be different from the `color` property to ensure text visibility.
- **text**: If no text is needed, use an empty string `""` - do not omit this property.
- **font_size**: If no text, still provide a default value (e.g., 16).
- **All numeric properties** (x, y, width, height, z_index, font_size, opacity) must have actual values, not placeholders.
- **visible**: Typically `true` unless the layer should start hidden.

**Example:**

```yaml
- name: background_forest
  type: background
  x: 0
  y: 0
  width: 1920
  height: 1080
  z_index: 0
  color: "#2C5F2D"
  text: ""
  font_size: 16
  text_color: "#FFFFFF"
  visible: true
  opacity: 100
- name: character_hero
  type: character
  x: 960
  y: 540
  width: 400
  height: 600
  z_index: 10
  color: "#8B4513"
  text: "Hero"
  font_size: 24
  text_color: "#FFD700"
  visible: true
  opacity: 100
```

Include positioning logic based on the model's "Position" specifications.

## Output Format

The generated files should include:

1. **Markdown file** (`${scene}_prompts.md`):
   - Start with a title: "# ${SceneName} - Asset Generation Guide"
   - Include all sections above with actual data extracted from the model
   - Use clear hierarchical headers (###, ####)
   - Format prompts in code blocks for easy copying
   - Include all filenames exactly as specified in the model
   - Add notes about consistency, style matching, and quality requirements

2. **Audio YAML file** (`${scene}_audios.yaml`):
   - List all audio assets with names and descriptions
   - Follow the structure specified in section 1.D

3. **Layers YAML file** (`${scene}_layers.yaml`):
   - List all visual layers with complete specifications
   - Follow the structure specified in section 3

## Example Usage

```bash
# For a scene called "cabin_scene"
Input:  cabin_scene.model.md
Output: cabin_scene_prompts.md
        cabin_scene_audios.yaml
        cabin_scene_layers.yaml
```

The generated files should provide a complete, actionable guide for creating all assets for the scene.