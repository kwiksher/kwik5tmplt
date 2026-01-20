1. create a Book & Page

   ```
   ln -s ../kwik5-project-template/Scripts Scripts
   Scripts/create_book.command Solar2D BTree_test "animation button"
   ```

   ```
   bash Scripts/create_book.command Solar2D BTree_test "animation button"
   ```

1. create yamls for images

  your task is described here, create yaml files in Solar2D/App/BTree_test/spec folder

   **Instructions:**

   Generate a YAML file (`${scene}_layers.yaml`) by finding image assets(objects) in Solar2D/App/BTree_test/behaivorTree/views folders.

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



2. create the psd

   ```sh
   book=BTree_test
   page=animation

   python Scripts/psd_tools/create_layered_psd.py \
     Solar2D/App/$book/spec/$page_scene_layers.yaml \
     /Photoshop/$book/$page.psd

   ```