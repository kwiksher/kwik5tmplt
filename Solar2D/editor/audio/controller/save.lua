local name = ...
local parent,root = newModule(name)
local util = require("editor.util")
local scripts = require("editor.scripts.commands")
local json = require("json")

local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    local selectbox    = params.selectbox or require(root.."audioTable")
    local controller   = require(root.."index").controller
    local classProps = controller.classProps
    local actionbox = params.actionbox or controller.actionbox
    local selected      = selectbox.selection or {}
    local book = params.book or UI.editor.currentBook
    local page = params.page or UI.page,

    print(name)
    local props = {
      name       = selected.audio,               -- UI.editor.currentLayer,
      class      = "audio",
      subclass   = selected.subclass or "short",
      settings   = {},
      actionName = nil,
      -- the following vales come from read()
      --class = self.class,
      index   = selected.index,
    }
    --
    local settings = params.settings or classProps:getValue()
    for i=1, #settings do
      -- print("", settings[i].name, type(settings[i].value), settings[i].value)
      print("", settings[i].name, settings[i].value)
      --
      -- props.subclass
      --
      local name = settings[i].name
      if name =="_type" then
        local t = settings[i].value or "short"
        if t:len() == 0 then
          t = "short"
        elseif t=="audioshort"then
          t = "short"
        elseif t=="audiolong" then
          t= "long"
        elseif t=="audiosync" then
          t= "sync"
        end
        props.subclass =  t
        name = "type"
      elseif name== "_file" then
        name = "filename"
      end
      props.settings[name] = settings[i].value
    end
    --
    -- props.name
    --
    if props.name == nil then -- NEW
      print("#NEW",props.settings.name)
      -- local t = util.split(props.settings.file or "", '.')
      -- props.name = t[1]
      props.name = props.settings.name
    end
    -- props.actionName
    props.actionName = actionbox.selectedTextLabel
    print("porps")
    for k, v in pairs(props) do print("", k, v) end
    --
    local updatedModel = util.createIndexModel(UI.scene.model)
    -- print(json.encode(updatedModel))
    local files = {}
    if params.isNew or selected.index == nil then
      local dst = updatedModel.components.audios[props.subclass] or {}
      dst[#dst + 1] = props.name
    else
      local dst = updatedModel.components.audios[props.subclass]
      dst[props.index] = props.name -- TBI for audio's name
    end
    --
    -- TODO check if name is not duplicated or not
    --
    -- index
    files[#files+1] = util.renderIndex(book, page,updatedModel)
    files[#files+1] = util.saveIndex(book, page, props.layer,props.class, updatedModel)
    -- save lua
    files[#files+1] = controller:render(book, page, props.subclass, props.name, props.settings)
    -- save json
    files[#files+1] = controller:save(book, page, props.subclass, props.name, props.settings)
    -- publish
    scripts.copyFiles(files)
  end
)
--[[
components
  ├── audios
  │   ├── long
  │   │   ├── GentleRain.lua
  │   │   └── Tranquility.lua
  │   └── short
  │       └── ballsCollision.lua
  ├── index.lua

  models
  ├── audios
  │   ├── long
  │   │   ├── GentleRain.json
  │   │   └── Tranquility.json
  │   └── short
  │       └── ballsCollision.json

index.json
  {
  "commands": [],
  "name": "page3",
  "pageNum": 3,
  "components": {
    "layers": [
    ],
    "groups": [],
    "audios": {"long":[], "short":[], sync:[]},
    "variables": [],
    "page": [],
    "timers": []
  }
}

TODO
  "audio": {
    "loop": 1,
    "name": "",
    "volume": 5,
    "channel": 1,
    "fadeIn": false,
    "repeatable": false,
    "actionName":""
  }

short/ballsCollision.json
{
  "name"     : "ballsCollision",
  "type"     : "event",
  "autoPlay" : false,
  "channel"  : 3,
  "folder"   : null,
  "delay"    : 1000,
  "loops"    : 3,
  "filename" : "ballsCollision.mp3"
}

]]
--
return instance