local current = ...
local parent,  root = newModule(current)
--
local json = require("json")

local pointA
local pointB
local AtoBbutton
local selectbox
local classProps
local pointABbox
local actionbox
local popup
local buttons

local M = require("editor.controller.index").new("animation")

function M:init(viewGroup)
  self.viewGroup = viewGroup
  --
  pointA        = viewGroup.pointA
  pointB        = viewGroup.pointB
  AtoBbutton    = viewGroup.AtoBbutton
  selectbox      = viewGroup.selectbox
  classProps    = viewGroup.classProps
  pointABbox    = viewGroup.pointABbox
  actionbox = viewGroup.actionbox
  popup         = viewGroup.popup
  buttons       = viewGroup.buttons


  AtoBbutton.useClassEditorProps = function() return self:useClassEditorProps() end
  buttons.useClassEditorProps = function() return self:useClassEditorProps() end

  --AtoBbutton.useBreadcrumbProps = useBreadcrumbProps
  -- buttons.useBreadcrumbProps = useBreadcrumbProps

  -- selectbox.setValue = function(decoded, index)
  --   setValue(decoded, index)
  --   self:redraw()
  -- end
  -- --
  selectbox.useClassEditorProps = function() self:useClassEditorProps() end

  selectbox.classEditorHandler = function(decoded, index)
    self:reset()
    self:setValue(decoded, index)
    self:redraw()
  end


end
  -------
-- I/F
--
function M:useClassEditorProps()
  -- print("useClassEditorProps")
  local props = {
    properties = {},
    easing="Linear",
    to = {},
    from={},
    actionName = nil,
    layerOptions = {
      isGroup = tostring(false),
      isSceneGroup = tostring(false),
      isSpritesheet = tostring(false),
      referencePoint = "Center",
      -- for text
      deltaX         = 0,
      deltaY         = 0
    },
    -- path = false,
    -- breadcrumb = false
    xSwipe = "nil",
    ySwipe = "nil",
    reverse = "nil",
    resetAtEnd = "nil",
  }

  if selectbox.selectedObj then
    props.index = selectbox.selectedIndex
    props.name = selectbox.selectedObj.text -- UI.editor.currentLayer,
    props.class=selectbox.selectedText.text
  end
  --
  local properties = classProps:getValue()
  for i=1, #properties do
    -- print("", properties[i].name, type(properties[i].value))
    props.properties[properties[i].name] = properties[i].value
  end
  --from
  --to
  local AB = pointABbox:getValue()
  for i=1, #AB do
    props.from[AB[i].name] = tonumber(AB[i].A )
    props.to[AB[i].name] = tonumber(AB[i].B )
  end
  props.actionName = actionbox.getValue("onComplete") --selectedTextLabel
  --breadcrumbs
  return props
end

function M:usetBreadcrumbProps()
  return {}
end

--

-- this handler should be called from selectbox to set one of animtations user selected
function M:setValue(decoded, index, template)
  if decoded == nil then print("## Error setValue ##") return end
  if not template then
    -- print(json.encode(decoded[index]))
    selectbox:setValue(decoded, index)  -- "linear 1", "rotation 1" ...
    classProps:setValue(decoded[index].properties)
    pointA:setValue(decoded[index].from)
    pointB:setValue(decoded[index].to)
    -- -- breadcrumbs:setValue(decoded[index].breadcrumbs)
    pointABbox:setValue(decoded[index].from, decoded[index].to)
    actionbox:setValue({name = "onComplete", value=decoded[index].actions.onComplete})
  else
    selectbox:setTemplate(decoded)  -- "linear 1", "rotation 1" ...
    classProps:setValue(decoded.properties)
    pointA:setValue(decoded.from)
    pointB:setValue(decoded.to)
    -- -- breadcrumbs:setValue(decoded.breadcrumbs)
    pointABbox:setValue(decoded.from, decoded.to)
    actionbox:setValue({name="onComplete", decoded.actions.onComplete})
  end
end

return M