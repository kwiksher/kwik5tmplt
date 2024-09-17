local name = ...
local parent, root = newModule(name)
local toolbar = require("editor.parts.toolbar")
--
--
local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    print(name)
    if params.props and params.props.book then
      print("rename book")
    else
      print("rename layer")
      for i, v in next, UI.editor.selections do
        print("", v.text)
      end
      --
      if UI.editor.selections and #UI.editor.selections > 1 then
        -- use selection to load the props and if saved, apply it to the selected layers
        -- how to tell multiple editing to save button' event?
        --
      else
        -- edit one layer
      end
      local props = UI.useClassEditorProps()
      for k, v in pairs(props) do
        print("", k, v)
      end

      toolbar:toogleToolMap()
    end
    --
    -- TBI
    --  show layerProps table for editing with save/cancel buttons
    --
  end
)
--
return instance
