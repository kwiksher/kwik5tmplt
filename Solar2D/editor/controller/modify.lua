local name = ...
local parent, root = newModule(name)
local toolbar = require("editor.parts.toolbar")

local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    local target = params.props
    print(target.layer, target.class)
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
      -- local layer = UI.editor.selections[1]
      if target.class then
        UI.scene.app:dispatchEvent {
          name = "editor.selector.selectTool",
          UI = UI,
          class = target.class,
          isNew = false,
          layer = target.layer,
          -- toogle = true -- <========
        }
      else
        UI:dispatchEvent {
          name = "editor.selector.selectLayer",
          UI = UI,
          layer = target.layer,
        }
      end
    end

    -- local props = UI.useClassEditorProps()
    -- for k, v in pairs(props) do
    --   print("", k, v)
    -- end

    -- toolbar:toogleToolMap()

    --
    -- TBI
    --  show layerProps table for editing with save/cancel buttons
    --
  end
)
--
return instance
