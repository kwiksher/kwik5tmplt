local name = ...
local parent, root = newModule(name)
local toolbar = require("editor.parts.toolbar")
local commands = require("editor.scripts.commands")

local commonType= table:mySet{"group", "timer", "variables", "page"}

local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    local options = params.props.options
    print(name, UI.page)
    if options then
      if  options.type == "action" then
        for i, v in next, options.selections  do
          commands.openEditorForCommand(UI.book, UI.page, v.action )
        end
      elseif options.type =="audio" then
        -- for k, value in pairs(v) do print(k, value) end
        for i, v in next, options.selections  do
          commands.openEditor(UI.book, UI.page, "audios/"..v.subclass, v.audio )
        end
      elseif commonType[options.type] then
        for i, v in next, options.selections  do
          commands.openEditor(UI.book, UI.page, options.type, v[options.type] )
        end
      elseif options.type =="asset" then
        print(UI.book, options.folder )
        commands.openFinder(UI.book, options.folder )
      end
    elseif UI.editor.selections == nil  then
      commands.openEditorForLayer(UI.book, UI.page, "index")
    else
      for i, v in next, UI.editor.selections do
        print("", v.layer, v.text, v.class )
        commands.openEditorForLayer(UI.book, UI.page, v.layer, v.class)
      end
    end
    --
  end
)
--
return instance
