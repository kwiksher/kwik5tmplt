local current = ...
local parent,root = newModule(current)
local util = require("editor.util")
local json = require("json")
--
local model = {
  id ="asset",
  props = {
    {name="filename", value = ""},
    {name="name", value = ""},
    {name="type", value = ""},
  }
}

local selectbox      = require(parent .. "assetTable")
local classProps    = require(parent.."classProps")
local buttons       = require(parent.."buttons")
local controller = require("editor.controller.index").new("asset")

--
local M = require(root.."baseClassEditor").new(model, controller)

M.x = display.contentCenterX/2
M.y	= 20
M.width = 80
M.height = 16

function M:init(UI)
  self.UI = UI
  self.group = display.newGroup()
  UI.editor.assetEditorGroup = self.group
  --
  selectbox:init()
  classProps:init(UI, self.x + self.width*1.5, self.y,  self.width, self.height)
  classProps.model = model.props
  classProps.UI = UI
  --
  --actionbox:init(UI)
  buttons:init(UI)

  -- --
  controller:init{
    selectbox      = selectbox, -- Audio, Particles, Spritesheet, SyncText, Video
    classProps    = classProps, -- select a media entry then click the icon to insert media, it can be a layer replacement
    buttons       = buttons
  }
  controller.view = self
  --
  UI.useAssetEditorProps = function() return controller:useAssetEditorProps() end
  --
end

function controller:toggle()
  self.isVisible = not self.isVisible
  if self.isVisible then
    self:show()
  else
    self:hide()
  end
end

function controller:render(book, page, class, name, model)
  local dst = "App/"..book.."/"..page .."/components/audios/"..class.."/"..name ..".lua"
  local tmplt =  "editor/template/components/pageX/audios/audio.lua"
  util.mkdir("App", book, page, "components", "audios", class)
  util.saveLua(tmplt, dst, model)
  return dst
end

function controller:save(book, page, class, name, model)
  local dst = "App/"..book.."/models/"..page .."/audios/"..class.."/"..name..".json"
  util.mkdir("App", book, "models", page, "audios", class)
  util.saveJson(dst, model)
  return dst
end

local function readAsset(path, folder, map)
  -- print(path.."/"..folder)
  local entries = {}
  local success = lfs.chdir( path.."/"..folder )
  if success then
    for file in lfs.dir( path.."/"..folder ) do
      if util.isDir(file) and file:len() > 3 then
        -- print("", "@Found dir " .. file )
        local children = readAsset(path.."/"..folder, file, map)
        for i=1, #children do
          entries[#entries + 1] = children[i]
        end
      elseif file:len() > 3  then
        local mapEntry = map[file]
        if mapEntry == nil then
          entries[#entries + 1] = {name=file, path=folder, links={}}
        else
          mapEntry.isExist = true
          entries[#entries + 1] = {name=mapEntry.name, path=mapEntry.path, links=mapEntry.links}
        end
      end
    end
    lfs.chdir( path )
  end
  return entries
end

function controller:read(book, _model)
  local assets = {}
  local model = _model or require("App." ..book..".assets.model")
  local map = {}
  for k, v in pairs(model) do
    for i, entry in next, v do
      entry.index = i
      map[entry.name] = entry
      print(k, i, entry.name)
    end
  end
  --
  local path =system.pathForFile( "App/"..book.."/assets", system.ResourceDirectory)
	local success = lfs.chdir( path ) -- isDir works with current dir
	if success then
		for folder in lfs.dir( path ) do
			if util.isDir(folder) and folder:len() > 3 then
				-- print( "Found dir " .. folder )
        assets[folder] = readAsset(path, folder, map)
			end
		end
	end
  -- print(json.encode(assets))
  return assets, map
end

function controller:updateAsset(book, page, layer, classFolder, class, model, assets)
  local ret   = assets
  local name  = model.filename
  local path = class.."s"
  if class == nil then
    -- audio
    entry.path = path .."/".. model.type -- short/long
  else
    -- spritesheet, particles, videos, web
    --
    -- is layer_xxx.lua exist?
    local props = {}
    if util.isExist(book, page, layer, class) then
      props = require("App."..book..".components." ..page..".layers."..layer.."_"..class)
    end

    local currentName = props.name
    if class == "video" then
      name = model.url
      currentName = props.url
    end

    local target = assets[path]
    ---------------------------------
    local function findEntry(target, name)
      for i, entry in next, target do
        if entry.name == name then
          -- update
          return entry
        end
      end
      local newEntry = {
        name = name,
        path = path,
        links = {}
      }
      target[#target+1] = newEntry
      return newEntry
    end
    --
    local entry = findEntry(target, name)
    entry.path = path
    ---------------------------------
    local function findLinkEntry(target, page)
      for i, entry in next, target do
        if entry.page == page then
          -- update
          return entry
        end
      end
      local newEntry = {
        page = page,
        layers = {}
      }
      target[#target+1] = newEntry
      return newEntry
    end
    --
    local linkEntry = findLinkEntry(entry.links, page)
    ---------------------------------
    local function findLayerEntry(target, layer)
      for i, entry in next, target do
        if entry == layer then
          -- do nothing, the layer has been linked to the media
          return i
        end
      end
      target[#target+1] = layer
      return #target
    end
    --
    local layerEntryIndex = findLayerEntry(linkEntry.layers, layer)
    --
    -- if layer is updated with different asset, let(s remove the layer name from the links of the old asset table)
    --
    local oldEntry = findEntry(target, currentName)
    local oldLinkEntry = findLinkEntry(oldEntry.links, page)
    local oldLayerEntryIndex = findLayerEntry(oldLinkEntry.layers, layer)
    --
    print("oldLayerEntryIndex", oldLayerEntryIndex)
    table.remove(oldLinkEntry.layers, oldLayerEntryIndex)
    --
    -- for replacements, layer can not be linked with mutiple media files
    -- so remove the layer name from links[x].layers
    local function removeDuplicatedLayer(class, layer)
      local target = assets[class]
      for i, entry in next, target do
        if entry.name ~= name then -- ex videoA.mp4
          for j, linkEntry in next, entry.links do
            if linkEntry.page == page then
              for k, layerEntry in next, linkEntry.layers do
                print(k, layerEntry)
                if layerEntry == layer then
                  table.remove(linkEntry.layers, k)
                end
              end
            end
          end
        end
      end
    end
    removeDuplicatedLayer("videos", layer)

  end
  print(json.encode(ret))
  return ret
end
--print(M.hide)
return M
