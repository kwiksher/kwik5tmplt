local M = require("Test.base_suite").new({
  book = "shape",
  page = "image"
})

local json = require("json")

local BOOK = "shape"
local PAGE = "image"
local LAYOUT_PATH = "App/shape/assets/images/image/layout.json"

local function readFile(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local contents = file:read("*a")
  io.close(file)
  return contents
end

local function loadLayout()
  local path = system.pathForFile(LAYOUT_PATH, system.ResourceDirectory)
  assert(path ~= nil, "layout.json not found")
  local contents = readFile(path)
  assert(contents ~= nil, "Failed to read layout.json")
  local decoded = json.decode(contents)
  assert(decoded ~= nil, "Failed to decode layout.json")
  return decoded
end

local function assertResourceFile(path)
  local fullPath = system.pathForFile(path, system.ResourceDirectory)
  assert(fullPath ~= nil, "Missing resource path: " .. path)
  local contents = readFile(fullPath)
  assert(contents ~= nil, "Missing resource file: " .. path)
  return contents
end

local function assertCommandResult(cmd)
  if cmd ~= nil then
    assert(type(cmd) == "string", "Expected command result to be string")
    assert(cmd:find("copy_lua") ~= nil, "Expected copy_lua command")
  end
end

local function layerNameFromImage(image)
  local path = (image and image.path) or (image and image.originalPath) or ""
  local filename = path:match("([^/\\]+)$") or ""
  return filename:gsub("%.[^%.]+$", "")
end

function M.test_create_single_image_from_layout()
  local layout = loadLayout()
  local image = layout.images[1]
  assert(image ~= nil, "layout.images[1] is missing")

  local layerName = layerNameFromImage(image)
  local cmd = M.scriptsCommands.createLayerImage(BOOK, PAGE, nil, nil, image)
  assertCommandResult(cmd)

  local layerLua = "App/" .. BOOK .. "/components/" .. PAGE .. "/layers/" .. layerName .. ".lua"
  local layerJson = "App/" .. BOOK .. "/models/" .. PAGE .. "/" .. layerName .. ".json"
  local indexLua = "App/" .. BOOK .. "/" .. PAGE .. ".lua"
  local indexJson = "App/" .. BOOK .. "/models/" .. PAGE .. "/index.json"

  local luaContents = assertResourceFile(layerLua)
  assert(luaContents:find("name%s*=%s*\"" .. layerName .. "\"") ~= nil, "Layer name was not rendered")
  assertResourceFile(layerJson)
  assertResourceFile(indexLua)
  assertResourceFile(indexJson)
end

function M.xtest_create_multiple_images_from_layout()
  local layout = loadLayout()
  assert(layout.images ~= nil and #layout.images > 1, "Need at least two images in layout")

  local created = {}
  for i = 1, #layout.images do
    local image = layout.images[i]
    local layerName = layerNameFromImage(image)
    local cmd = M.scriptsCommands.createLayerImage(BOOK, PAGE, nil, nil, image)
    assertCommandResult(cmd)
    created[#created + 1] = layerName
  end

  local indexContents = assertResourceFile("App/" .. BOOK .. "/" .. PAGE .. ".lua")
  for i = 1, #created do
    local layerName = created[i]
    local layerLua = "App/" .. BOOK .. "/components/" .. PAGE .. "/layers/" .. layerName .. ".lua"
    local layerJson = "App/" .. BOOK .. "/models/" .. PAGE .. "/" .. layerName .. ".json"
    assertResourceFile(layerLua)
    assertResourceFile(layerJson)
    assert(indexContents:find(layerName, 1, true) ~= nil, "Layer missing from index.lua: " .. layerName)
  end
end

function M.xtest_create_group_from_layout()
  local layout = loadLayout()
  local groupEntry = layout.groups and layout.groups[1]
  assert(groupEntry ~= nil, "layout.groups[1] is missing")

  local byId = {}
  for i = 1, #groupEntry.imageIds do
    local id = groupEntry.imageIds[i]
    local image
    for j = 1, #layout.images do
      if layout.images[j].id == id then
        image = layout.images[j]
        break
      end
    end
    assert(image ~= nil, "Missing image for group imageId=" .. tostring(id))

    local layerName = layerNameFromImage(image)
    byId[id] = layerName
    local cmd = M.scriptsCommands.createLayerImage(BOOK, PAGE, nil, nil, image)
    assertCommandResult(cmd)
  end

  local groupCmd = M.scriptsCommands.createGroup(BOOK, PAGE, nil, groupEntry, byId)
  assertCommandResult(groupCmd)

  local groupName = "group_" .. tostring(groupEntry.id)
  local groupLuaPath = "App/" .. BOOK .. "/components/" .. PAGE .. "/groups/" .. groupName .. ".lua"
  local groupJsonPath = "App/" .. BOOK .. "/models/" .. PAGE .. "/" .. groupName .. ".json"
  local groupLua = assertResourceFile(groupLuaPath)

  for i = 1, #groupEntry.imageIds do
    local memberName = byId[groupEntry.imageIds[i]]
    assert(groupLua:find(memberName, 1, true) ~= nil, "Group member missing in rendered lua: " .. memberName)
  end

  assertResourceFile(groupJsonPath)
end

return M
