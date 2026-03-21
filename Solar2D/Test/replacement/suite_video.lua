local M = require("Test.base_suite").new()

local helper = require("Test.helper")

function M.xtest_new()
  local name = "rect_0"
  helper.selectLayer(name)
  helper.selectIcon("Replacements", "Video"):done(function() end)
end

function M.xtest_select()
  local name = "rect_0"
  M.layerTable.altDown = true
  helper.selectLayer(name, "video")
  M.layerTable.altDown = false
end

function M.test_select_video_asset()
  -- save a replacement component e.x. kwikplanent.mp4 to layerOne
  -- save UI.editor.assets with the linked layer value in videos as json in model folder
  --
  -- TBI load(readAsset) the json model and merge to make UI.editor.assets
  --   if an asset not found in App/book folder delete the entry in json model
  --
  -- REST api to add a new asset to App/book folder
  ---
  -- Ensure the asset selector/table is visible and available for the test
  helper.defaultSuiteSetupWithComponent("assetTable")
  -- expose the assets selector UI and set a local ref to the preloaded assetTable
  M.selectors.assetsSelector:show()
  local assetTable = M.assetTable

  M.selectors.assetsSelector:onClick(true, "videos")

  --M.selectors.assetsSelector:onClick(true, nil)
  --[[
    local video_index = 5
    local target = M.selectors.assetsSelector.objs[video_index]
  target:dispatchEvent({name="tap", target=target})

  --select kwikplanet.mp4
  M.assetTable.objs[2]:touch({phase="ended"})

  -- click video icon
  M.assetTable:iconsHandler({target={muiOptions={name="repVideo-icon"}}}, "video", "selectTool")

  -- click a layer
  local args = {"book", "page1", "imageTwo"}
  local layerObj = M.layerTable.findObj(M.layerTable.objs, args, 3)
  layerObj:touch({phase="ended"})

  local videoEditor = require("editor.replacement.index")
  local urlField = videoEditor.controller.classProps.objs[5]
  urlField:dispatchEvent{name="tap", target=urlField}

  --select Gen2
  M.assetTable.objs[1]:touch({phase="ended"})
  --TBI touching Gen2, dipatch event to update url's value to be Gen2

  -- click save. Internally calls publishForSelections() in scripts.commands.lua
  --buttons.objs["save"]:tap()
  --
  -- TBI UI.editor.assets entry is updated with the layer name that is linked with it when a replacement component is created
  --
  -- TBI merge the saved UI.editor.assets json model with the assets model read with lfs? YES
--]]

end

return M