#!/usr/bin/env lua

-- cleanup_shared_assets.lua
-- Removes PNG files for layers that are marked as shared assets

local BASE_DIR = "Solar2D/App"

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

-- Parse index.lua to find layers with "properties" class
local function get_layers_with_properties(index_file)
    local layers = {}
    local model = nil

    -- Create a mock environment to capture the model
    local mock_env = {
        require = function(name)
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
        return layers
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
        return layers
    end

    -- Extract layers with "properties" class
    if model and model.components and model.components.layers then
        for _, layer_entry in ipairs(model.components.layers) do
            if type(layer_entry) == "table" then
                for layer_name, layer_data in pairs(layer_entry) do
                    if type(layer_data) == "table" and layer_data.class then
                        -- Check if "properties" is in the class array
                        for _, class_name in ipairs(layer_data.class) do
                            if class_name == "properties" then
                                table.insert(layers, layer_name)
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    return layers
end

-- Check if a layer is a shared asset
local function is_shared_asset(properties_file)
    local file = io.open(properties_file, "r")
    if not file then
        return false
    end

    local content = file:read("*all")
    file:close()

    -- Look for isSharedAsset = true
    return content:match("isSharedAsset%s*=%s*true") ~= nil
end

-- Remove PNG files for a layer
local function remove_layer_pngs(book_name, page_name, layer_name)
    local suffixes = {"", "@2x", "@4x"}
    local removed_count = 0

    for _, suffix in ipairs(suffixes) do
        local png_path = string.format("%s/%s/assets/images/%s/%s%s.png",
            BASE_DIR, book_name, page_name, layer_name, suffix)

        if file_exists(png_path) then
            local success = os.remove(png_path)
            if success then
                print(string.format("Removed: %s", png_path))
                removed_count = removed_count + 1
            else
                print(string.format("Failed to remove: %s", png_path))
            end
        end
    end

    return removed_count
end

-- Main processing function
local function process()
    local total_removed = 0
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
                    print(string.format("\nProcessing %s:%s", book_name, page_name))

                    -- Get layers with properties class
                    local layers_with_props = get_layers_with_properties(index_file)

                    for _, layer_name in ipairs(layers_with_props) do
                        local properties_file = page_path .. "/layers/" .. layer_name .. "_properties.lua"

                        if file_exists(properties_file) then
                            if is_shared_asset(properties_file) then
                                print(string.format("  Found shared asset: %s", layer_name))
                                local removed = remove_layer_pngs(book_name, page_name, layer_name)
                                total_removed = total_removed + removed
                            end
                        end
                    end
                end
            end
        end
    end

    print(string.format("\n=== Cleanup complete ==="))
    print(string.format("Total PNG files removed: %d", total_removed))
end

-- Run the script
process()
