local H = {}

local json = require("json")

function H.readFile(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local contents = file:read("*a")
  io.close(file)
  return contents
end

function H.loadLayout(layoutPath)
  local path = system.pathForFile(layoutPath, system.ResourceDirectory)
  assert(path ~= nil, "layout.json not found")
  local contents = H.readFile(path)
  assert(contents ~= nil, "Failed to read layout.json")
  local decoded = json.decode(contents)
  assert(decoded ~= nil, "Failed to decode layout.json")
  return decoded
end

function H.assertResourceFile(path)
  local fullPath = system.pathForFile(path, system.ResourceDirectory)
  assert(fullPath ~= nil, "Missing resource path: " .. path)
  local contents = H.readFile(fullPath)
  assert(contents ~= nil, "Missing resource file: " .. path)
  return contents
end

function H.assertCommandResult(cmd)
  if cmd ~= nil then
    assert(type(cmd) == "string", "Expected command result to be string")
    assert(cmd:find("copy_lua") ~= nil, "Expected copy_lua command")
  end
end

function H.layerNameFromImage(image)
  local path = (image and image.path) or (image and image.originalPath) or ""
  local filename = path:match("([^/\\]+)$") or ""
  return filename:gsub("%.[^%.]+$", "")
end

return H
