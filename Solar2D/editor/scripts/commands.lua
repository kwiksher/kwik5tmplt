local M = {}

local json = require("json")
local lfs = require("lfs")
local lustache = require "extlib.lustache"
local formatter = require("extlib.formatter")
local platform = system.getInfo( "platformName" )
local util = require("editor.util")
local libUtil = require("lib.util")

local currentScript

local function executeScript(filename, model)
  local ext = "command"
  if platform == "win32" then
    ext = "bat"
  end
  --
  local path = system.pathForFile("editor/scripts/"..filename .. ext .. ".tmplt", system.ResourceDirectory)
  local file, errorString = io.open(path, "r")
  local cmd = filename .. ext -- create_book.command
  local cmdFile

  if not file then
    print("File error: " .. errorString)
  else
    local contents = file:read("*a")
    io.close(file)
    output = lustache:render(contents, model)
    output = output:gsub("&#39;", '"')
    output = output:gsub("&#x2F;", "/")

    local path = system.pathForFile(cmd, system.TemporaryDirectory)
    --print(path)
    local file, errorString = io.open(path, "w+")
    if not file then
      print("File error: " .. errorString)
    else
      output = string.gsub(output, "\r\n", "\n")
      file:write(output)
      io.close(file)
    end
    if platform == "win32" then
      cmdFile = '"' .. path:gsub("/", "\\") .. '"'
    else
      cmdFile = path:gsub(" ", "\\ ")
    end
  end

  if platform == "win32" then
    print("copy " .. cmdFile .. " " .. system.pathForFile("", system.ResourceDirectory))
    os.execute("copy " .. cmdFile .. " " .. system.pathForFile("..\\", system.ResourceDirectory))
    os.execute("cd " .. system.pathForFile("..\\", system.ResourceDirectory) .. " & start cmd /k call " .. cmd)
  else
    print("cd " .. system.pathForFile("../", system.ResourceDirectory) .. "; source " .. cmd)
    os.execute("cp " .. cmdFile .. " " .. system.pathForFile("../", system.ResourceDirectory))
    os.execute("cd " .. system.pathForFile("../", system.ResourceDirectory) .. "; source " .. cmd)
  end
  return cmd
end

function M.createBook(book, _dst, weight)
  local root = _dst or "Solar2D"
  local script = executeScript("create_book.", {dst = root, book=book})
  --
  -- prepare application sandbox folder
  --
  util.mkdir("App", book)
  return M.createPage(book, "page1", root, weight)
end

function M.createPage(book, index, page, _root, _weight)
  local root = _root or "Solar2D"
  local dst = root.."/App/"..book.."/index.lua"
  local tmplt =  "editor/template/index.lua"
  local pages = {}
  local weight = _weight or 1 -- for book.index
  --
  local path =system.pathForFile( "/App/"..book.."/index.lua", system.ResourceDirectory )
  if path  then -- lfs.attributes(path)
    print("File exists")
    local scenes = require("App."..book..".index")
    for i=1, #scenes do
      pages[i] = {name = scenes[1]}
    end
    table.insert(pages, index, {name=page})
    --
    weight = libUtil.readWeight("/App/"..book, "index.lua")
  else
    print("Could not get attributes")
    pages[1] = {name=page}
  end
  local newIndex = util.saveLua(tmplt, "App/"..book.."/index.lua", {pages = pages, weight=weight})
  -- page index
  util.mkdir("App", book, "components", page)

  local updatedModel = util.createIndexModel(nil, nil, nil)
  local newPageIndex = util.renderIndex(book, page, updatedModel)
  newPageIndex =  system.pathForFile( newPageIndex, system.TemporaryDirectory)
  return executeScript("create_page.", {dst = root, book=book, page=page, newIndex = newIndex, newPageIndex = newPageIndex})
end


function M.renamePage(book, page, newName, _dst)
  local root = _dst or "Solar2D"
  -- assets/images/page1
  -- commands/page1
  -- components/page1

  -- index.lua gsub
  local newFile = system.pathForFile("index.lua", system.TemporaryDirectory)
  local path = system.pathForFile("App/"..book.."/index.lua", system.ResourceDirectory)
  local contents
  local file = io.open( path, "r" )
  if file then
    contents = file:read("*a")
    io.close(file)
    file = nil
  end

  print('"'..page..'"', '"'..newName..'"', contents)
  contents = contents:gsub('"'..page..'"', '"'..newName..'"')


  local nfile = io.open( newFile, "w+" )
  if nfile then
    contents = nfile:write(contents)
    io.close(nfile)
    nfile = nil
  end

  return executeScript("rename_page.", {dst = root, book=book,page=page, newName = newName, newIndex = newFile})
end

local function copyFiles(files, _dst)
  local root = _dst or "Solar2D"
  --
  -- cp (system.TemporaryDirectory)copy_lua.command ( system.ResourceDirectory)../copy_lua.command
  -- cd (system.ResourceDirectory)..; source copy_lua.command
  --
  local commands = {}
  for i = 1, #files do
    print(files[i])
    local src = system.pathForFile(files[i], system.TemporaryDirectory)
    --local dst = system.pathForFile(nil, system.ResourceDirectory )
    local dir = util.getPath(files[i])
    local dst = files[i]
    local tmp
    if platform == "win32" then
      tmp = "copy " .. src .. " " .. dst
      tmp = '"' .. tmp:gsub("/", "\\") .. '"'
      commands[#commands + 1] = tmp
    else
      src = src:gsub(" ", "\\ ")
      dst = dst:gsub(" ", "\\ ")
      dir = dir:gsub(" ", "\\ ")
      tmp = "mkdir -p " .. dir .. ";cp " .. src .. " " .. dst
      -- tmp = tmp:gsub('/','')

      -- print ("cp "..tmp.." "..pathDst)
      commands[#commands + 1] = tmp
    end
  end
  return executeScript("copy_lua.", {dst = root, cmd = commands})
end

function M.createLayer(book, page, index, layer, _props)
  local files = {}
  local scene = require("App."..book..".components."..page..".index")
  local updatedModel = util.createIndexModel(scene.model)
  local entry = {}
  entry[layer] = {}
  --
  table.insert(updatedModel.layers, index, entry)
  --
  local props = _props or {name=layer, shape="rect", x=display.contentCenterX, y=display.contentCenterY, width=100, height=100}
  local controller = require("editor.controller")
  --
  files[#files+1] = controller:renderIndex(book, page, updatedModel)
  files[#files+1] = controller:saveIndex(book, page, layer, nil, updatedModel)
  -- save lua
  files[#files+1] = controller:render(book, page, layer, "layers", "shape", props)
  -- save json
  files[#files+1] = controller:save(book, page, layer, nil, props)
  currentScript = copyFiles(files)
end

function M.createLayerWithClass(book, page, layer, class, _dst)

end

function M.renameLayer(book, page, layer, newName, _dst)
  local newFile = system.pathForFile("index.lua", system.TemporaryDirectory)
  local path = system.pathForFile("App/"..book.."/index.lua", system.ResourceDirectory)
  local contents
  local file = io.open( path, "r" )
  if file then
    contents = file:read("*a")
    io.close(file)
    file = nil
  end

  print('"'..layer..'"', '"'..newName..'"', contents)
  contents = contents:gsub('"'..layer..'"', '"'..newName..'"')

  local nfile = io.open( newFile, "w+" )
  if nfile then
    contents = nfile:write(contents)
    io.close(nfile)
    nfile = nil
  end
  local class = {}

  local scene = require("App."..book..".components."..page..".index")
  local model = util.selectFromIndexModel(scene, {layer})

  for k, v in pairs(model) do
    print(k ,v)
    if k=="class" then
      for class in v do
        print(class)
      end
    end
  end

  return executeScript("rename_layer.",
    {dst = root, book=book, page=page,layer=layer, newName = newName, newIndex = newFile, class=class})

end

--------------------------------------------------------
-- this publish () is for timer & group with own save()
--  append is a function implemented in the local save function
--
--     args.updatedModel= util.createIndexModel(args.UI.scene.model)
--     args.append = function(value, index)
  --    local dst = args.updatedModel.components.timers or {}
  --    if index then
  --      dst[index] = value
  --    else
  --      dst[#dst + 1] = value
  --    end
  --  end
--
--
local function getProps(args)
  local   selected      = args.selected or {} -- args.selectbox.selection
  local   append           = args.append      -- args.updatedModel.components.timers or {}
  local   isNew         = args.isNew

  local props = {
    index = selected.index
  }
  --
  local settings = args.settings
  for i = 1, #settings do
    print("", settings[i].name, settings[i].value)
    local name = settings[i].name
    if name == "_name" then
      props["name"] = settings[i].value
    elseif name == "_type" then
      props["type"] = settings[i].value
    elseif name == "_file" then
      props["file"] = settings[i].value
    else
      props[name] = settings[i].value
    end
  end
  -- args.actionName
  -- args.actionName = actionbox.selectedTextLabel
  --
  -- TODO check if name is not duplicated or not
  ---
  -- Append the new entry to components.{timers, variables ...} in index.lua
  if  props.settings then
    if isNew or selected.index == nil then
      append(props.settings.name)
    else
      append(props.settings.name, props.index)
    end
  end
  --
  return props
end

local function saveSelection(book, page, selections)
-- Data (string) to write
local saveData = {book=book, page=page, selections = selections}

-- Path for the file to write
local path = system.pathForFile( "kwik.json", system.ApplicationSupportDirectory )

-- Open the file handle
local file, errorString = io.open( path, "w" )

if not file then
    -- Error occurred; output the cause
    print( "File error: " .. errorString )
else
    -- Write data to file
    file:write( json.encode(saveData) )
    -- Close the file handle
    io.close( file )
end

file = nil
end

local pageTools = table:mySet{"page", "timer", "group", "variable"}
local classWithAssets = table:mySet{"audio", "video", "sprite", "particles", "www", "thumbnail", "font"}
--
function M.publish(UI, args, controller ,decoded)
  local   book          = args.book or UI.editor.currentBook
  local   page          = args.page
  local   updatedModel  = args.updatedModel
  local   layer         = args.layer or UI.editor.currentLayer
  local   class         = args.class    -- timer
  --local actionbox = args.actionbox
  local   name          = args.name     -- args.selected.timer
  --
  local props = args.props or getProps(args) -- getProps uses args.settings
  ---
  local files = {}
  files[#files + 1] = util.renderIndex(book, page, updatedModel)
  files[#files + 1] = util.saveIndex(book, page, layer, class, updatedModel)

  if pageTools[class] then
    -- save lua
    files[#files + 1] = controller:render(book, page, class, name, props)
    -- save json
    files[#files + 1] = controller:save(book, page, class, name, props)
  else
    --
    --  'shape' class will be avairable and expected here for creating a new layer if isNew
    --  for modifying a layer props will have a class value as 'image' when created by UXP plugin.
    --
    local classFolder = UI.editor:getClassFolderName(args.class)
    -- save lua
    -- print("@@@", props.name)
    files[#files+1] = controller:render(book, page, layer, classFolder, class, props)
    -- save json
    files[#files+1] = controller:save(book, page, layer,classFolder, decoded) -- decoded will be nil
    -- save asset
    if classWithAssets[class] then
      files[#files+1] = controller:renderAssets(book, page, layer, classFolder, class, props)
    end
  end
  -- save the lastSelection

  saveSelection(book, page, {{name=layer, class=class}})
  -- publish
  currentScript = copyFiles(files)
end

function M.publishForSelections(UI, args, controller, decoded)
  --
  local files = {}
  local classFolder = UI.editor:getClassFolderName(args.class)
  -------------
  local book = args.book or UI.editor.currentBook
  local page = args.page or UI.page
  local layer = args.layer or UI.editor.currentLayer
  local class = args.class:lower()

  print(book, page, layer,classFolder, class)

  local props = getProps(args)

  -----------
  --- Update components/pageX/index.lua model/pageX/index.json
  local scene = require("App."..book..".components."..page..".index")

  for i, obj in next, UI.editor.selections do
    layer = obj.text
    local updatedModel = util.createIndexModel(scene.model, layer, class)
    --- save json
    -----------
    -- print(book, page, layer, classFolder, args.index)
    decoded[props.index] = props
    -- decoded[props.index].settings = props.settings
    -- decoded[props.index].actionName = props.actionName
    -- decoded[props.index].name=props.name
    --
    files[#files+1] = controller:renderIndex(book, page, updatedModel)
    files[#files+1] = controller:saveIndex(book, page, layer, class, updatedModel)
    -- save lua
    files[#files+1] = controller:render(book, page, layer, classFolder, class, props)
    -- save json
    files[#files+1] = controller:save(book, page, layer,classFolder, decoded)
    -- save asset
    if classWithAssets[class] then
      files[#files+1] = controller:renderAssets(book, page, layer, classFolder, class, props)
    end
  end
  --
  saveSelection(book, page, UI.editor.selections)
  ----------
  currentScript = copyFiles(files)
end

function M.getScript()
  return currentScript
end

----
function M.openEditorForCommand(book, page, name)
  local path = system.pathForFile("App/"..book.."/commands/"..page.."/"..name..".lua", system.ResourceDirectory)
  local cmd = "code " ..path
  os.execute( cmd )
end

-- type == audios, groups, page, timers, variables
function M.openEditor(book, page, type, name)
  local path = system.pathForFile("App/"..book.."/components/"..page.."/"..type.."/"..name..".lua", system.ResourceDirectory)
  local cmd = "code " ..path
  os.execute( cmd )
end

function M.openEditorForLayer(book, page, layer, class)
  print("App/"..book .."/components/" ..page.."/" .. layer, class)
  local path = system.pathForFile("App/"..book, system.ResourceDirectory)
  if class and class:len() > 3 and class~=layer then
    path = path.. "/components/" ..page.."/layers/" .. layer .."_"..class..".lua"
  elseif layer=="index" then
    path = path.. "/components/" ..page.."/index.lua"
  else
    path = path.. "/components/" ..page.."/layers/" .. layer ..".lua"
  end
  --
  -- local url = "vscode://file/" .. path
  -- if ( system.canOpenURL( url ) ) then
  --     system.openURL( url )
  -- else
  --     print( "WARNING: Facebook app is not installed!" )
  -- end
  --
  local cmd = "code " ..path
  os.execute( cmd )
end

function M.openFinder(book, folder)
  local path = system.pathForFile("App/"..book.."/assets/"..folder, system.ResourceDirectory)
  local cmd = "open " ..path
  os.execute( cmd )
end


M.copyFiles = copyFiles

return M