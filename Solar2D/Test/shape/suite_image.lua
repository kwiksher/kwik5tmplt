local M = require("Test.base_suite").new({
  book = "shape",
  page = "image"
})
local helper = require("Test.shape.helper_shape")

local BOOK = "shape"
local PAGE = "image"
local LAYOUT_PATH = "App/shape/assets/images/image/layout.json"

function M.xtest_create_single_image_from_layout()
  local layout = helper.loadLayout(LAYOUT_PATH)
  local image = layout.images[1]
  assert(image ~= nil, "layout.images[1] is missing")

  local layerName = helper.layerNameFromImage(image)
  local cmd = M.scriptsCommands.createLayerImage(BOOK, PAGE, nil, nil, image)
  helper.assertCommandResult(cmd)

  local layerLua = "App/" .. BOOK .. "/components/" .. PAGE .. "/layers/" .. layerName .. ".lua"
  local layerJson = "App/" .. BOOK .. "/models/" .. PAGE .. "/" .. layerName .. ".json"
  local indexLua = "App/" .. BOOK .. "/" .. PAGE .. ".lua"
  local indexJson = "App/" .. BOOK .. "/models/" .. PAGE .. "/index.json"

  local luaContents = helper.assertResourceFile(layerLua)
  assert(luaContents:find("name%s*=%s*\"" .. layerName .. "\"") ~= nil, "Layer name was not rendered")
  helper.assertResourceFile(layerJson)
  helper.assertResourceFile(indexLua)
  helper.assertResourceFile(indexJson)
end

function M.xtest_create_from_layout()
  local layout = helper.loadLayout(LAYOUT_PATH)
  assert(layout.images ~= nil and #layout.images > 1, "Need at least two images in layout")

  local cmd = M.scriptsCommands.createFromLayout(BOOK, PAGE, layout)
  helper.assertCommandResult(cmd)

  local created = {}
  for i = 1, #layout.images do
    local image = layout.images[i]
    local layerName = helper.layerNameFromImage(image)
    created[#created + 1] = layerName
  end

  local indexContents = helper.assertResourceFile("App/" .. BOOK .. "/" .. PAGE .. ".lua")
  for i = 1, #created do
    local layerName = created[i]
    local layerLua = "App/" .. BOOK .. "/components/" .. PAGE .. "/layers/" .. layerName .. ".lua"
    local layerJson = "App/" .. BOOK .. "/models/" .. PAGE .. "/" .. layerName .. ".json"
    helper.assertResourceFile(layerLua)
    helper.assertResourceFile(layerJson)
    assert(indexContents:find(layerName, 1, true) ~= nil, "Layer missing from index.lua: " .. layerName)
  end
end


return M
