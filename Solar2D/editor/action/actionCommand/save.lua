local AC = require("commands.kwik.actionCommand")
local json = require("json")
local actionCommandTable = require("editor.action.actionCommandTable")
local util = require("editor.util")
local controller = require("editor.action.controller.index")
local scripts = require("editor.scripts.commands")
--
local command = function (params)
	local UI    = params.UI
  local page = params.page or UI.page
  print("actionCommand.save")
  UI.editor.actionEditor:hideCommandPropsTable(true)
  UI.editor.actionEditor.viewStore.actionButtons:show()
  --
  local props, selected = UI.editor.actionEditor.viewStore.actionCommandPropsTable:getValue()
  print("",selected, json.encode(props))
  ---
  local actions = actionCommandTable.actions

  local action = {command=props.type.."."..(selected or ""), params = {}}
  for i=1, #props.entries do
    local entry = props.entries[i]
    print(entry.name, entry.value)
    if entry.name == '_target' then
      action.params.target = entry.value
    else
      action.params[entry.name] = entry.value
    end
  end
  --
  --local updatedModel = util.createIndexModel(UI.scene.model, "", "")
  local updatedModel = util.createIndexModel(UI.scene.model)
  local nameText     = UI.editor.actionEditor.selectbox.selectedObj.text
  local currentIndex = UI.editor.currentActionCommandIndex
  local files = {}

  --
  if props.isNew then
    actions[#actions + 1] = action
    local newAction = {
      name= nameText,
      actions = actions
    }
    UI.editor.currentAction = newAction
    UI.editor.actionCommandStore:set(newAction)
    print(json.encode(newAction))
    -- Update components/pageX/index.lua model/pageX/index.json
    updatedModel.commands[#updatedModel.commands + 1] = newAction.name
    --
    files[#files+1] = util.renderIndex(UI.editor.currentBook, page,updatedModel)
    files[#files+1] = util.saveIndex(UI.editor.currentBook, page, props.layer,props.class, updatedModel)
    --
    -- if name contains '.', should we create a folder? maybe later
    --
  else
    print("",currentIndex)
    actions[currentIndex] = action
    UI.editor.actionCommandStore:set{actions=actions}
    UI.editor.currentAction = {
      name= nameText,
      actions = actions
    }
    --
    local current = updatedModel.commands[currentIndex]
    -- Update components/pageX/index.lua model/pageX/index.json
    if current.name ~= nameText then
      --
      -- TODO
      -- delete .json, .lua
      --
      updatedModel.commands[currentIndex] = UI.editor.currentAction
      --
      files[#files+1] = util.renderIndex(UI.editor.currentBook, page, updatedModel)
      files[#files+1] = util.saveIndex(UI.editor.currentBook, page, props.layer,props.class, updatedModel)
    end
  end
  -- save lua
  files[#files+1] = controller:render(UI.editor.currentBook, page, nameText, actions)
  -- save json
  files[#files+1] = controller:save(UI.editor.currentBook, page, nameText, {name=nameText, actions = actions})
  -- publish
  scripts.copyFiles(files)

  --[[
    {
      "name": "eventOne",
      "actions" :[
        { "command":"animation.play", "params":{"target":"title-animation"}},
        {"command":"audio.play", "params":{
          "target" : "bgm",
          "type" : "",
          "channel" : "",
          "repeatable" : true,
          "delay" : "",
          "loop" : -1,
          "fade" : "",
          "volume" : "",
          "trigger" : "eventTwo"
        }}
        ]
      }
  ]]

  --
  -- should use selectAction or call UI.editor.actionCommandStore:set()?
  --
  -- UI.scene.app:dispatchEvent {
  --   name = "editor.action.selectAction",
  --   action = event.action,
  --   UI = UI
  -- }
--
end
--
local instance = AC.new(command)
return instance