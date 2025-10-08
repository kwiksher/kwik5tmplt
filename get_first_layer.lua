#!/usr/bin/env lua

-- Simple Lua parser to extract the first layer name from index.lua
-- Usage: lua get_first_layer.lua <index.lua file path>

local index_file = arg[1]

if not index_file then
    os.exit(1)
end

-- Read the file
local file = io.open(index_file, "r")
if not file then
    os.exit(1)
end

local content = file:read("*all")
file:close()

-- Simple pattern matching approach
-- Looking for the first layer in the structure:
-- layers = {
--   {
--     layer_name = {
--     }
--   },

-- Find the layers section
local in_layers = false
local brace_count = 0

for line in content:gmatch("[^\r\n]+") do
    -- Detect when we enter the layers array
    if line:match("layers%s*=%s*{") then
        in_layers = true
        brace_count = 1
    elseif in_layers then
        -- Count braces to track nesting
        local opens = select(2, line:gsub("{", ""))
        local closes = select(2, line:gsub("}", ""))
        brace_count = brace_count + opens - closes

        -- Look for layer name pattern: "name = {"
        local layer_name = line:match("^%s*([%w_]+)%s*=%s*{")
        if layer_name then
            print(layer_name)
            os.exit(0)
        end

        -- Exit if we've closed all braces
        if brace_count == 0 then
            break
        end
    end
end

os.exit(1)
