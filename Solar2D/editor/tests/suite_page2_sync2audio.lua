local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable
local bookName = "book" -- "bookTest01"
local pageName = "page2"
local listbox = require("editor.replacement.listbox")
local listPropsTable = require("editor.replacement.listPropsTable")

local helper = require("editor.tests.helper")
local classProps = require("editor.parts.classProps")
local assetTable = require("editor.asset.assetTable")
local listButtons = require("editor.replacement.listButtons")

function M.init(props)
  selectors = props.selectors
  UI = props.UI
  bookTable = props.bookTable
  pageTable = props.pageTable
  layerTable = props.layerTable
end

function M.suite_setup()
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  selectors.componentSelector.iconHander()
  selectors.componentSelector:onClick(true, "layerTable")
end

function M.setup()
end

function M.teardown()
end

function M.xtest_new_sync()

  helper.selectLayer("text1")
  helper.selectIcon("Replacements", "Sync")

  -- helper.clickProp(classProps.objs, "_filename")
  -- helper.clickAsset(assetTable.objs, "sprites/SpriteTiles/sprites.png")
  -- helper.setProp(classProps.objs, "numFrames", 64)
  -- -- this calculates w, h of sprite
  -- helper.clickProp(classProps.objs, "_filename")

  -- local obj = helper.getObj(listbox.objs, "default")
  -- listbox.singleClickEvent(obj)
  -- helper.setProp(listPropsTable.objs, "loopCount", "")


  -- obj = helper.getObj(listButtons.objs, "Preview")
  -- obj:tap()

end

function M.xtest_new_sync_add_save()
  UI.scene.app:dispatchEvent(
    {
      name = "editor.selector.selectTool",
      UI = UI,
      class = "sync", -- obj.class,
      -- toolbar = self,
      isNew = true
    }
  )

  UI.scene.app:dispatchEvent(
    {
      name = "editor.replacement.list.add",
      UI = UI,
      type = "line", -- for sync,
      index = 3 -- number of entries
    }
  )

  local listPropsTable = require("editor.replacement.listPropsTable")
  -- name props
  listPropsTable.objs[1].field.text = "myName"
  -- start
  listPropsTable.objs[2].field.text = "3000"

  UI.scene.app:dispatchEvent(
    {
      name = "editor.replacement.list.save",
      UI = UI,
      class = "sync", -- obj.class,
      index = 4
    }
  )
end

local jsonFile = function(filename )
  local path = system.pathForFile(filename, system.ResourceDirectory )
  local contents
  local file = io.open( path, "r" )
  if file then
     contents = file:read("*a")
     io.close(file)
     file = nil
  end
  return contents
end



function M.test_decode64_words()
  local json = require("json")
  local mime = require("mime")
  local path = "server/tests/outputRedirection.json"
  local data = json.decode(jsonFile(path))
  local alignment = data.alignment
  local normalized_alignment = data.normalized_alignment

  print(#alignment.characters, normalized_alignment.characters)
  local wordEntries = {}
  local word  = ""
  local s, e = 0, 0
  for i, v in next, alignment.characters do
    word = word ..v
    if v == " " or v =="\n" then
      e = alignment.character_end_times_seconds[i]
      wordEntries[#wordEntries + 1] = {word=word, startTime=s, endTime =e}
      local t = word:gsub("\n", "\\n")
      print(s, e, t)
      word = ""
      s = alignment.character_end_times_seconds[i+1]
    end
  end
  local dst = system.pathForFile( "myAudio.txt", system.DocumentsDirectory )
  -- Open the file handle
  local file, errorString = io.open( dst, "w+" )
  if not file then
      print( "File error: " .. errorString )
  else
      for i, v in next, wordEntries do
        local text = v.word:gsub("\n", "\\n")
        file:write(string.format("%.3f %.3f %s \n",  v.startTime, v.endTime, text ))
      end
      io.close( file )
  end

  -- character_start_times_seconds
  -- character_end_times_seconds
end


function M.xtest_decode64_mp3()
  local json = require("json")
  local mime = require("mime")
  local path = "server/tests/outputRedirection.json"
  local data = json.decode(jsonFile(path))
  local bin = mime.unb64(data.audio_base64)
  local dst = system.pathForFile( "myAudio_jp_wakati.mp3", system.DocumentsDirectory )
    -- Open the file handle
  local file, errorString = io.open( dst, "wb+" )
  if not file then
      print( "File error: " .. errorString )
  else
      file:write( bin )
      io.close( file )
  end
end

function M.xtest_loadAudio()
  local myAudio = audio.loadStream( "myAudio_jp.mp3", system.DocumentsDirectory )
  local options =
  {
      channel = 1,
      loops = -1,
      duration = 30000,
      fadein = 5000,
      onComplete = function() print("onComplete") end
  }
  audio.play(myAudio, options)

end

function M.xtest_loadAudio()
  local myAudio = audio.loadStream( "App/book/assets/audios/sync/ElevenLabs_jp_wakati.mp3")
  local options =
  {
      channel = 1,
      loops = -1,
      duration = 30000,
      fadein = 5000,
      onComplete = function() print("onComplete") end
  }
  audio.play(myAudio, options)

end

return M