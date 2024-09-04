-- Lua doesn't have built-in file system commands like 'cp' and 'sed'
-- We'll use the LuaFileSystem library for file operations
local lfs = require("lfs")
local M = {}

local book = "book"
local page = "page12"

-- File to copy
local source_action = "brushBlack"
-- Word to replace
local old_word = "0,0,0,1"

-- new action events to be created
local new_actions = {"brushWhite", "brushYellow", "brushLightBlue", "brushBlue", "brushPink", "brushGreen"}
-- New words
local new_words = {
  "1,1,1,1",
  "1,1,0,1",
  "150/255,200/255,0,1",
  "1,0,0,1",
  "0,0,0,1",
  "1,0,1,1",
  "0,1,0,1"
}

-- Function to read the entire content of a file
local function read_file(filename)
  local file = io.open(filename, "r")
  if file then
    local content = file:read("*a")
    file:close()
    return content
  else
    return nil, "Error opening file: " .. filename
  end
end

-- Function to write content to a file
local function write_file(filename, content)
  local file = io.open(filename, "w")
  if file then
    file:write(content)
    file:close()
    return true
  else
    return false, "Error writing to file: " .. filename
  end
end
---
---
local source_file = lfs.currentdir() .. "/App/" .. book .. "/commands/" .. page .. "/" .. source_action .. ".lua"
---

local function find_lines_containing(filename, pattern)
  -- local filename = system.pathForFile(_filename, system.ResourceDirectory)
  print(filename)
  local file = io.open(filename, "r")
  if not file then
    print("Error opening file:", filename)
    return
  end

  local line_number = 0
  for line in file:lines() do
    line_number = line_number + 1
    if string.match(line, pattern, 1) then
      print("Line", line_number, ":", line)
      file:close()
      return line
    end
  end

  file:close()
end

function M:createFiles()
  local content, err = read_file(source_file)
  if not content then
    print("Error reading source file:", err)
  else
    ---
    for i, action in next, new_actions do
      -- New file name
      local new_file = lfs.currentdir() .. "/App/" .. book .. "/commands/" .. page .. "/" .. action .. ".lua"
      local new_word = new_words[i]
      print(action, new_word)

      -- Replace all occurrences of the old word with the new word
      local _content = string.gsub(content, old_word, new_word)

      -- Write the modified content to the new file
      local success, err = write_file(new_file, _content)
      if success then
        print("File copied and word replaced successfully!")
      else
        print("Error writing to new file:", err)
      end
    end
  end
end

---
-- update index.lua
---
function M:updateIndex()
  local source_index = lfs.currentdir() .. "/App/" .. book .. "/components/" .. page .. "/index.lua"
  local content, err = read_file(source_index)
  if not content then
    print("Error reading source file:", err)
  else
    local new_text = ""
    for i, v in next, new_actions do
      new_text = new_text .. '"' .. v .. '", '
    end

    local pattern = "commands = {"
    local old_line = find_lines_containing(source_index, pattern)

    local last_bracket_index = string.find(old_line, "}")
    if last_bracket_index then
      new_text = string.sub(old_line, 1, last_bracket_index - 1) .. new_text .. string.sub(old_line, last_bracket_index)
      print(new_text)
    else
      print("No closing bracket '}' found.")
    end

    -- Replace all occurrences of the old word with the new word
    local _content = string.gsub(content, old_line, new_text)

    -- Write the modified content to the new file
    local success, err = write_file(source_index, _content)
    if success then
      print("File copied and word replaced successfully!")
    else
      print("Error writing to new file:", err)
    end
  end
end

return M
