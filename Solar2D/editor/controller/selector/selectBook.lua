local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("lib.util")
local App = require("controller.Application")
local composer = require("composer")
--
local useModelJSON = false
--
local command = function (params)
  -- print("----------- initBook -----------")
	local UI    = params.UI
  local bookName = params.book or App.get().name
  UI.editor.currentBook = bookName

  local function loadPage(UI)
    --
    local path =system.pathForFile( "App/"..bookName.."/models", system.ResourceDirectory)
    if useModelJSON then
      local success = lfs.chdir( path ) -- isDir works with current dir
      if success then
        local pages = {}
        for file in lfs.dir( path ) do
          if util.isDir(file) then
            -- print( "Found file: " .. file )
            -- set them to nanostores
            if file:len() > 3 and file ~='assets' then
              table.insert(pages, {name = file, path= util.PATH(path.."/"..file)})
            end
          end
        end
        if #pages > 0 then
          UI.editor.pageStore:set(pages)
        end
      end
    else
      local sceneIndex = require( "App."..bookName..".index")
      local success = lfs.chdir( path ) -- isDir works with current dir
      if success then
        local pages = {}
        for i, scene in next, sceneIndex do
            table.insert(pages, {name = scene, path= util.PATH(path.."/"..scene)})
        end
        if #pages > 0 then
          UI.editor.pageStore:set(pages)
        end
      end
    end

    -- assets
    UI.editor.assets = require("editor.asset.index").controller:read(bookName)
    UI.editor.assetStore:set({decoded=UI.editor.assets})
  end

  if UI.book ~= bookName then
    local scenes = require("App."..bookName..".index")
    Runtime:dispatchEvent{name="changeThisMug", appName=bookName, goPage=scenes[1], editing = true }
    --- set pages ----
   local currScene = composer.getSceneName( "current" )
   print(currScene)
   timer.performWithDelay( 2000, function()
    local UI = require(currScene).UI
    loadPage(UI)
   end)
  else
    -- print("selectBook same book")
    loadPage(UI)
  end

  --
  --UI.editor.labelStore:set{currentBook= UI.editor.currentBook, currentPage= UI.page, currentLayer = UI.editor.currentayer}
  --
--

end
--
local instance = AC.new(command)
return instance
