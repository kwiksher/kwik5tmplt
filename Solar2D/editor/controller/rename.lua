local name = ...
local parent, root = newModule(name)
local toolbar = require("editor.parts.toolbar")
local picker = require("editor.picker.name")
local confirmation = require("editor.picker.confirmation")
local scripts = require("editor.scripts.commands")
--
local function getListener(props, selections)
  if selections and  #selections > 1 then
    return nil, nil
  elseif props then
    if props.book then
      print("rename book" )
      return props.book, "book", scripts.renameBook
    elseif props.page then
      print("rename page", props.page)
      return props.page, "page", scripts.renamePage
    elseif props.audio then
      print("rename audio", props.audio, props.type)
      return props.audio, "audio/"..props.type, scripts.renameAudio
    elseif props.class == "group" then
      return props.group, "group", scripts.renameGroup
    elseif props.class == "timer" then
      return props.timer, "timer", scripts.renameTimer
    elseif props.class == "joint" then
      return props.joint,  "joint", scripts.renameJoint
    elseif props.class == "variable" then
      return props.variable, "variable", scripts.renameVariable
    end
  else
    print("rename layer")
    return  props.layer, "layer", scripts.renameLayer
  end
return
end
--
local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    --
    local oldValue,_type, script = getListener(params.props, UI.editor.selections)
    --
    if _type then
      local function listener(value)
         print("newValue=", value)
        if value and value == "Continue" and picker.obj.field.text:len() > 0 then
          script(UI.book, UI.page, oldValue, picker.obj.field.text) -- _dst == Solar2D
        else
          print("user cancel")
        end
        confirmation:destroy()
        picker:destroy()
      end
      confirmation:create(listener, "Press Continue to rename "..oldValue, nil)
      picker:create(nil,  "Please input a ".. _type.." name")
      picker.obj.text = ""
    end
  end
)
--
return instance
