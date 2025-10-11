### Generating Assets from the Script

Now, let's break down how you would generate the audio and images for this specific scene.

#### 1. Generating Audio

**A. Voice-Over (Elara's Lines)**
You would extract all of Elara's dialogue lines and use an AI TTS service.

*   **Services:** ElevenLabs, Play.ht, Amazon Polly, Google Wavenet.
*   **Process:**
    1.  Copy the lines: `"The Lumin Seed was the last one...", "Oh no."`
    2.  Choose a voice (e.g., "Young Female, Determined, American").
    3.  Adjust tone and pacing for each line. The first line is a somber voice-over, the second is a scared whisper.
    4.  Generate the audio files and name them logically:
        *   `elara_vo_01.wav`
        *   `elara_whisper_ohno.wav`

**B. Sound Effects (SFX)**
The script calls for specific sounds.

*   **Sources:** Freesound.org, Unity Asset Store, Humble Bundle SFX packs, or AI generation with tools like Audo.ai.
*   **Process:** Search for or generate:
    *   `sfx_rustling_cloth.wav`
    *   `sfx_wind_gentle.wav`
    *   `sfx_footsteps_forest.wav`
    *   `sfx_crow_caw_distant.wav`
    *   `sfx_wolf_growl_corrupted.wav`

**C. Music**
The script has two music cues.

*   **Sources:** Royalty-free libraries (YouTube Audio Library, Pixabay Music), hire a composer, or use AI tools like AIVA, Soundraw, or Mubert.
*   **Process:** Find or generate two tracks:
    *   `Music_Tension_Builds.mp3` - A slow-building, suspenseful track.
    *   `Music_Tension_Sting.mp3` - A short, sharp, startling sound.

#### 2. Generating Images

This is where AI image generation shines. You need to create detailed, consistent prompts.

**A. Backgrounds**
*   **Prompt for `bg_old_cabin_interior.png`:**
    `"interior of an abandoned, small wooden cabin, a dusty sunbeam shines through a broken window, dust motes in the air, highly detailed, painterly style, fantasy, soft lighting, wide-angle shot"`
*   **Prompt for `bg_forest_path.png`:**
    `"an overgrown forest path, daytime but gloomy, muted colors, eerie and quiet, fantasy, digital painting, cinematic, Unreal Engine 5"`

**B. Character Sprites**
Consistency is key. You will create a "character sheet" with a base description you reuse.

*   **Base Prompt for Elara:**
    `"character sprite of a 19-year-old woman named Elara, determined green eyes, brown hair in a practical braid, wearing worn-out traveler's clothing and a leather satchel, full-body or half-body, neutral pose, fantasy style, consistent with previous images, white background"`
    You would then generate variations for different emotions (`elara_determined.png`, `elara_scared.png`).

*   **Prompt for `corrupted_wolf_aggro.png`:**
    `"a corrupted wolf made of twisted dark bark and shadows, glowing red eyes, snarling with jagged wooden teeth, fantasy creature, aggressive pose, half-body shot, dark and menacing, digital painting"`

**C. Props**
*   **Prompt for `item_lumin_seed.png`:**
    `"a single magical seed glowing with a soft, warm inner light, intricate markings on the shell, resting on a wooden table, close-up, highly detailed, fantasy"`

#### 3. yaml for create layered psd

Create a YAML file for layered PSD generation based on the Forest Scene technical model.

Instructions:

    $scene=forst_scene

    Parse the `${scene}.model.md` file and extract all visual assets (backgrounds, characters, props/objects) with their specifications. Generate a YAML file in the format of `${scene}_layers.yaml` with the following structure for each layer:

    ```yaml
    - name: <asset_name>
      x: <x_position>
      y: <y_position>
      width: <width_in_pixels>
      height: <height_in_pixels>
      color: <hex_color_or_placeholder>
      text: <optional_text_label>
      font_size: <optional_font_size>
      text_color: <optional_text_color>
    ```