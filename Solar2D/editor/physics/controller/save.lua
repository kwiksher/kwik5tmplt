local name = ...
local parent, root = newModule(name)
local util = require("editor.util")
local controller = require("editor.physics.index").controller
local scripts = require("editor.scripts.commands")
local json = require("json")
--
local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    print("@@@@@@@@", name, params.class)
    local UI = params.UI
    local props = controller:useClassEditorProps(UI)
    local args = {
      UI = params.UI,
      book = params.book or params.UI.editor.currentBook,
      page = params.page or params.UI.page,
      updatedModel = util.createIndexModel(params.UI.scene.model),
      props = props,
      -- completebox   = params.actionbox or controller.actionbox,
      isNew = props.isNew,
      class = props.class,
    }
    local selectbox = params.selectbox or controller.selectbox
    args.selected = selectbox.selection or {}

    if args.isNew then
      if props.class == "joint" then
        local function isJoint()
          for i, v in next, args.updatedModel.components.joints do
            if v == props.name then
              return true
            end
          end
          return false
        end
        if not isJoint() then
          print("@@@@@@@@")
          local index = params.index or #args.updatedModel.components.joints + 1
          table.insert(args.updatedModel.components.joints, index, props.name)
          print(json.encode(args.updatedModel.components))
        end

        scripts.publish(UI, args, controller)

        -- args.append = function(value, index)
        --   local dst = args.updatedModel.components.joints or {}
        --   if index then
        --     dst[index] = value
        --   else
        --     dst[#dst + 1] = value
        --   end
        -- end
      end
    else
        -- scripts.publishForSelections(
        --   UI,
        --   {
        --     book = props.book,
        --     page = props.page,
        --     layer = props.layer,
        --     class = props.class,
        --     props = props
        --   },
        --   controller,
        --   params.decoded or {}
        -- )
    end
  end
)
return instance
