#!/usr/bin/env lua

-- convert_background_to_jpeg.lua
-- Converts background PNG images to JPEG format in Solar2D app books

local BASE_DIR = "Solar2D/App"

local SKIP_CONVERSION = {
    "animation:*",
    "asset:*",
    "book:infinity",
    "book:page2",
    "book:portrait",
    "book:shape",
    "book1:*",
    "elevenlab:*",
    "interaction:*",
    "keyboard:*",
    "kwikTheCat:*",
    "lingualSample:*",
    "LULU:*",
    "mybook:*",
    "page:*",
    "particles:*",
    "physics:*",
    "replacement:*",
    "shape:*",
    "snowMan:*",
}

-- Check if ImageMagick convert is available
local function check_convert()
    local handle = io.popen("command -v convert 2>/dev/null")
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end

-- Check if a book:page combination should be skipped
local function should_skip(book, page)
    local pair = book .. ":" .. page

    for _, skip in ipairs(SKIP_CONVERSION) do
        local skip_book, skip_page = skip:match("^([^:]+):(.+)$")
        if skip_book == book then
            if skip_page == "*" or skip_page == page then
                return true
            end
        end
    end

    return false
end

-- Get the first layer name from index.lua
local function get_first_layer(index_file)
    -- Create a mock environment to capture the model
    local model = nil
    local mock_env = {
        require = function(name)
            -- Mock the require function to return a scene controller
            return {
                new = function(sceneName, m)
                    model = m
                    return {}
                end
            }
        end,
        print = function() end,
    }
    setmetatable(mock_env, {__index = _G})

    -- Load and execute the index.lua file
    local chunk, err = loadfile(index_file)
    if not chunk then
        return nil
    end

    -- Set the environment for Lua 5.1/5.2 compatibility
    if setfenv then
        setfenv(chunk, mock_env)
    else
        debug.setupvalue(chunk, 1, mock_env)
    end

    -- Execute the chunk
    local success, result = pcall(chunk)
    if not success then
        return nil
    end

    -- Extract the first layer name from the model
    if model and model.components and model.components.layers then
        local layers = model.components.layers
        if type(layers) == "table" and #layers > 0 then
            local first_layer = layers[1]
            if type(first_layer) == "table" then
                -- Get the first key in this table
                for key, _ in pairs(first_layer) do
                    return key
                end
            end
        end
    end

    return nil
end

-- Check if a file exists
local function file_exists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

-- Check if a directory exists
local function dir_exists(path)
    local handle = io.popen("[ -d '" .. path .. "' ] && echo 'yes' || echo 'no'")
    local result = handle:read("*a")
    handle:close()
    return result:match("yes") ~= nil
end

-- Get all directories in a path
local function get_directories(path)
    local dirs = {}
    local handle = io.popen("ls -1 '" .. path .. "' 2>/dev/null")
    if handle then
        for dir in handle:lines() do
            local full_path = path .. "/" .. dir
            if dir_exists(full_path) then
                table.insert(dirs, dir)
            end
        end
        handle:close()
    end
    return dirs
end

-- Replace text in a file
local function replace_in_file(filepath, pattern, replacement)
    local file = io.open(filepath, "r")
    if not file then
        return false
    end

    local content = file:read("*all")
    file:close()

    local new_content = content:gsub(pattern, replacement)

    -- Create backup
    local backup = filepath .. ".bak"
    os.rename(filepath, backup)

    -- Write new content
    file = io.open(filepath, "w")
    if not file then
        return false
    end

    file:write(new_content)
    file:close()

    return true
end

-- Convert PNG to JPG
local function convert_png_to_jpg(png_path, jpg_path)
    -- Using quality 85 for better compression while maintaining good quality
    local cmd = string.format("convert '%s' -quality 85 '%s' 2>/dev/null", png_path, jpg_path)
    local result = os.execute(cmd)
    return result == 0 or result == true
end

-- Get file size in bytes
local function get_file_size(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end
    local size = file:seek("end")
    file:close()
    return size
end

-- Main processing function
local function process()
    if not check_convert() then
        print("Error: ImageMagick 'convert' command not found")
        print("Please install ImageMagick:")
        print("  - On macOS: brew install imagemagick")
        print("  - On Ubuntu/Debian: sudo apt-get install imagemagick")
        print("  - On CentOS/RHEL: sudo yum install ImageMagick")
        os.exit(1)
    end

    local books = get_directories(BASE_DIR)

    for _, book_name in ipairs(books) do
        local book_path = BASE_DIR .. "/" .. book_name
        local components_path = book_path .. "/components"

        if dir_exists(components_path) then
            local pages = get_directories(components_path)

            for _, page_name in ipairs(pages) do
                local page_path = components_path .. "/" .. page_name
                local index_file = page_path .. "/index.lua"

                if file_exists(index_file) then
                    local layer_name = get_first_layer(index_file)

                    if layer_name then
                        local layer_file = page_path .. "/layers/" .. layer_name .. ".lua"

                        if file_exists(layer_file) then
                            -- Check if this book:page should be skipped
                            if should_skip(book_name, page_name) then
                                print(string.format("Skipping conversion for %s:%s", book_name, page_name))
                            else
                                -- Convert PNG to JPG for normal, @2x, @4x and compare all sizes
                                local suffixes = {"", "@2x", "@4x"}
                                local conversion_data = {}
                                local all_jpg_smaller = true
                                local total_saved = 0

                                -- First pass: convert all and compare sizes
                                for _, suffix in ipairs(suffixes) do
                                    local png_path = string.format("%s/%s/assets/images/%s/%s%s.png",
                                        BASE_DIR, book_name, page_name, layer_name, suffix)
                                    local jpg_path = string.format("%s/%s/assets/images/%s/%s%s.jpg",
                                        BASE_DIR, book_name, page_name, layer_name, suffix)

                                    if file_exists(png_path) then
                                        if convert_png_to_jpg(png_path, jpg_path) then
                                            local png_size = get_file_size(png_path)
                                            local jpg_size = get_file_size(jpg_path)

                                            if png_size and jpg_size then
                                                local diff = png_size - jpg_size
                                                table.insert(conversion_data, {
                                                    png_path = png_path,
                                                    jpg_path = jpg_path,
                                                    png_size = png_size,
                                                    jpg_size = jpg_size,
                                                    diff = diff,
                                                    suffix = suffix
                                                })

                                                if jpg_size >= png_size then
                                                    all_jpg_smaller = false
                                                else
                                                    total_saved = total_saved + diff
                                                end
                                            end
                                        else
                                            print(string.format("Failed to convert %s", png_path))
                                            all_jpg_smaller = false
                                        end
                                    end
                                end

                                -- Second pass: decide whether to keep JPEG or PNG
                                if all_jpg_smaller and #conversion_data > 0 then
                                    -- All JPEGs are smaller, keep them and remove PNGs
                                    for _, data in ipairs(conversion_data) do
                                        os.remove(data.png_path)
                                        print(string.format("Converted %s to %s (saved %d bytes)",
                                            data.png_path, data.jpg_path, data.diff))
                                    end

                                    -- Update layer file to use JPEG
                                    local success = replace_in_file(layer_file,
                                        'type%s*=%s*"png"',
                                        'type = "jpg"')
                                    if success then
                                        print(string.format('Updated %s: type = "jpg" (total saved: %d bytes)',
                                            layer_file, total_saved))
                                    end
                                else
                                    -- Keep PNGs, remove all JPEGs
                                    for _, data in ipairs(conversion_data) do
                                        os.remove(data.jpg_path)
                                        if data.diff < 0 then
                                            print(string.format("Keeping PNG %s (JPEG would be %d bytes larger)",
                                                data.png_path, -data.diff))
                                        else
                                            print(string.format("Keeping PNG %s (not all resolutions benefit from JPEG)",
                                                data.png_path))
                                        end
                                    end
                                    print(string.format("No conversion for %s:%s (PNG is more efficient overall)",
                                        book_name, page_name))
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Run the script
process()
