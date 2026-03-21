local M = require("Test.base_suite").new({
  book = "layer",
  page = "lang",
})

local bookName = "layer"
local pageName = "lang"

local helper = require("Test.helper")
--local actionTable = require("editor.action.actionTable")

-- https://stackoverflow.com/questions/66379488/pyttsx3-does-not-read-text-in-other-languages

function M.xtest_timecodes()
  local timecodes = require("lib.timecodes")
    -- Example usage
    local script1 = [[
    JOHN
    Hello, how are you?

    JANE
    I'm doing well, thank you for asking.

    JOHN
    That's great to hear!
    ]]

    -- https://ia.net/topics/ia-writer-fountain-template
  local script = [[
  NEO
  Wait. Who was it?
  Who was the man?

  She leans close, her lips almost touching his ear as she
  whispers.

  TRINITY
  You know who.

  She turns and he watches her melt into the shifting wall
  of bodies.

  A SOUND RISES steadily, growing out of the music,
  pressing in on Neo until it is all he can hear as we --

  CUT TO:

  INT. NEO'S APARTMENT

  The sound is an ALARM CLOCK, slowly dragging Neo to
  consciousness. He strains to read the clock face:
  9:15 A.M.

  NEO
  Shitshitshit.
  ]]

    local dialogue = timecodes.parse_fountain(script)
    local timecoded_dialogue = timecodes.generate(dialogue)

    local chars = {}
    for _, v in ipairs(timecoded_dialogue) do
      local character, line, _start, _end = unpack(v)
      if chars[character] == nil then
        chars[character] = {}
      end
      table.insert(chars[character], {_start, _end, line})
      -- print(string.format("%s (%s - %s): %s", character, _start, _end, line))
    end

    for k, v in pairs(chars) do
      print(k)
      for i, timecode in next, v do
        print("", timecode[1], timecode[2], timecode[3])
      end
    end
end

function M.xtest_edit_action()
  M.UI.editor.actionEditor.iconHander()

  M.actionTable.altDown = true
  helper.selectAction("flyAnim")
  M.actionTable.altDown = false

  -- select a command
  local commandsTable = require("editor.action.actionCommandTable")
  local obj = commandsTable.objs[1]
  commandsTable:singleClickEvent(obj)

  local actionCommandPropsTable = require("editor.action.actionCommandPropsTable")
  helper.clickProp(actionCommandPropsTable.objs, "_target")

  helper.selectLayer("witch/en", "linear")

  -- save manually

end

function M.xtest_new_sync()
  local obj = helper.selectLayer("father/en")

  helper.selectLayer("text1")
  helper.selectIcon("Replacements", "Sync")

  local textProps = require("editor.replacement.textProps")
  helper.clickProp(textProps.objs, "_filename")
  helper.selectAssetIcon("SyncText")
  helper.clickAsset(M.assetTable.objs, "en/my_father_is_nice.txt")

  local audioProps = require("editor.replacement.audioProps")
  helper.clickProp(audioProps.objs, "_filename")
  helper.selectAssetIcon("SyncText")
  helper.clickAsset(M.assetTable.objs, "en/my_father_is_nice.mp3")

  -- helper.setProp(classProps.objs, "autoPlay", false)
  --[[
  -- select text & audio
  ---- helper.clickProp(classProps.objs, "text")

  local obj = M.actionbox.objs[1] -- onComplete
  obj:dispatchEvent({name="tap", target=obj})
  helper.clickAction("eventOne")

  local obj = helper.getObj(M.listbox.objs, "A")
  M.listbox.singleClickEvent(obj)

  helper.setProp(M.listPropsTable.objs, "dur", "1000")

  -- select an action
  helper.clickProp(M.listPropsTable.objs, "action")
  -- helper.clickProp(listPropsTable.objs, "action") -- why needs twice?
  helper.clickAction("eventTwo")

  helper.setProp(M.listPropsTable.objs, "dur", "1000")

  obj = helper.getObj(M.listButtons.objs, "Save")
  obj:tap()
--]]

end

function M.xtest_edit_button()
  M.layerTable.altDown = true
  local obj = helper.selectLayer("fly/en", "button")
  M.layerTable.altDown = false

  helper.clickProp(M.actionbox.objs, "onTap")
  objs = require("editor.parts.buttonContext").objs
  objs.Select.rect:tap()
  helper.clickAction("flyAnim")
end

function M.xtest_delete_button()
  if helper.hasObj(M.layerTable, "fly/en", "button") then
    helper.selectLayer("fly/en", "button", false) -- isRightClick
    helper.selectLayer("fly/en", "button", true) -- isRightClick
    -- then
    -- manially delete it
  end
end

function M.xtest_delete_flyOver()
  if helper.hasObj(M.layerTable, "flyOver", "lang") then
    helper.selectLayer("flyOver", "lang", false) -- isRightClick
    helper.selectLayer("flyOver", "lang", true) -- isRightClick
    -- local actionButtonContext = require("editor.parts.actionButtonContext")
    --
    -- then delete it manually
  end
end

function M.xtest_updateIndexModel()
  local book = "page"
  local page = "lang"
  local layer = "witch/en"
  local obj = helper.selectLayer("witch/en", "linear")
  local scene = require("App." .. book .. ".components." .. page .. ".index")
  local updatedModel = scene.model
  assert(layer, obj.parentObj.layer.."/"..layer)

  updatedModel = M.editorUtil.updateIndexModel(updatedModel, layer, class)
  --print(json.prettify(updatedModel))

  local renderdModel = M.editorUtil.createIndexModel(updatedModel)

  -- controler.renderIndex is wrapping util.renderIndex
  -- local controller = require("editor.controller.index")

  local file = M.editorUtil.renderIndex(book, page, renderdModel)
  --print(file)
   print(M.json.prettify(renderdModel))

end

function M.xtest_select_en_anim()
  M.layerTable.altDown = true
  helper.selectLayer("witch/en", "linear")
  M.layerTable.altDown = false
end

function M.xtest_read_timecode()
  local textProps  = require("editor.replacement.textProps")
  textProps:read("App/book/assets/audios/sync/alphabet.txt")
end

function M.xtest_select_sync()
  M.layerTable.altDown = true
  helper.selectLayer("text1", "sync")
  M.layerTable.altDown = false
end

function M.xtest_new_sync_select_listbox()

  helper.selectLayer("text1")
  helper.selectIcon("Replacements", "Sync")

  local obj = helper.getObj(M.listbox.objs, "A")
  M.listbox.singleClickEvent(obj)

  helper.setProp(M.listPropsTable.objs, "dur", "1000")

end

function M.xtest_new_sync_add_save()
  M.UI.scene.app:dispatchEvent(
    {
      name = "editor.selector.selectTool",
      UI = M.UI,
      class = "sync", -- obj.class,
      -- toolbar = self,
      isNew = true
    }
  )

  M.UI.scene.app:dispatchEvent(
    {
      name = "editor.replacement.list.add",
      UI = M.UI,
      type = "line", -- for sync,
      index = 3 -- number of entries
    }
  )

  -- name props
  M.listPropsTable.objs[1].field.text = "myName"
  -- start
  M.listPropsTable.objs[2].field.text = "3000"

  M.UI.scene.app:dispatchEvent(
    {
      name = "editor.replacement.list.save",
      UI = M.UI,
      class = "sync", -- obj.class,
      index = 4
    }
  )
end

function M.xtest_decode64_words()
  local mime = require("mime")
  local path = "server/tests/outputRedirection.json"
  local data = M.json.decode(M.util.jsonFile(path))
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
  local mime = require("mime")
  local path = "server/tests/outputRedirection.json"
  local data = M.json.decode(jsonFile(path))
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
