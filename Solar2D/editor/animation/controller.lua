local current = ...
local parent,  root = newModule(current)
--
local json = require("json")

local pointA
local pointB
local AtoBbutton
local selectbox
local classProps
local breadcrumbsProps
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
  breadcrumbsProps = viewGroup.breadcrumbsProps
  pointABbox    = viewGroup.pointABbox
  actionbox = viewGroup.actionbox
  popup         = viewGroup.popup
  buttons       = viewGroup.buttons

  AtoBbutton.useClassEditorProps = function(UI) return self:useClassEditorProps(UI) end
  buttons.useClassEditorProps = function(UI) return self:useClassEditorProps(UI) end

  --AtoBbutton.useBreadcrumbProps = useBreadcrumbProps
  -- buttons.useBreadcrumbProps = useBreadcrumbProps

  -- selectbox.setValue = function(decoded, index)
  --   setValue(decoded, index)
  --   self:redraw()
  -- end
  -- --
  selectbox.useClassEditorProps = function(UI) self:useClassEditorProps(UI) end

  selectbox.classEditorHandler = function(decoded, index)
    self:reset()
    self:setValue(decoded, index)
    self:redraw()
  end

end

--- this is a callback from redraw
function M:onShow(UI)
  pointA:setActiveEntryObjs(pointABbox.objs.A[1],pointABbox.objs.A[2])
  pointB:setActiveEntryObjs(pointABbox.objs.B[1],pointABbox.objs.B[2])
  breadcrumbsProps.targetObject = nil
  classProps.targetObject = nil
  local basePropsControl = require("editor.parts.basePropsControl")
  basePropsControl.enableFillColor = false

  if UI.editor.currentClass ~= "Linear" then
    pointA:hide()
    pointB:hide()
  end
end
-------
-- I/F
--
function M:useClassEditorProps(UI)
  print("useClassEditorProps", UI)
  local props = {
    properties = {},
    breadcrumbs = {},
    easing="Linear",
    to = {},
    from={},
    actionName = nil,
    layerOptions = {
      isGroup = false,
      isSceneGroup = false,
      isSpritesheet = false,
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
    props.layer = selectbox.selectedObj.text -- UI.editor.currentLayer,
    props.class=selectbox.selectedText.text
  else
    props.layer = UI.editor.currentLayer
  end
  --
  local properties = classProps:getValue()
  for i=1, #properties do
    -- print("", properties[i].name, type(properties[i].value))
    props.properties[properties[i].name] = properties[i].value
  end
  --
  local breadcrumbsProperties = breadcrumbsProps:getValue()
  if #breadcrumbsProperties == 0 then
    props.breadcrumbs = nil
  else
    for i=1, #breadcrumbsProperties do
      print("", properties[i].name, type(properties[i].value))
      local name = breadcrumbsProperties[i].name
      if name == "_width" then
        props.breadcrumbs.width = breadcrumbsProperties[i].value
      elseif name == "_height" then
        props.breadcrumbs.height = breadcrumbsProperties[i].value
      else
        props.breadcrumbs[name] = breadcrumbsProperties[i].value
      end
    end
  end

  --from
  --to
  local AB = pointABbox:getValue()
  for i=1, #AB do
    props.from[AB[i].name] = tonumber(AB[i].A )
    props.to[AB[i].name] = tonumber(AB[i].B )
  end
  props.actions = {onComplete = actionbox.getValue("onComplete")} --selectedTextLabel
  --breadcrumbs
  return props
end

function M:usetBreadcrumbProps()
  return {}
end

--

-- this handler should be called from selectbox to set one of animtations user selected
function M:setValue(decoded, index, template)
  -- print(debug.traceback())
  if decoded == nil then print("## Error setValue ##") return end
  if not template then
    -- print(json.encode(decoded[index]))
    selectbox:setValue(decoded, index)  -- "linear 1", "rotation 1" ...
    classProps:setValue(decoded[index].properties)
    breadcrumbsProps:setValue(decoded[index].breadcrumbs)
    pointA:setValue(decoded[index].from)
    pointB:setValue(decoded[index].to)
    -- -- breadcrumbs:setValue(decoded[index].breadcrumbs)
    pointABbox:setValue(decoded[index].from, decoded[index].to)
    actionbox:setValue{{name = "onComplete", value=decoded[index].actions.onComplete}}
  else
    if decoded.properties.target then
      decoded.properties.target = self.layer
    end
    selectbox:setTemplate(decoded)  -- "linear 1", "rotation 1" ...
    classProps:setValue(decoded.properties)
    breadcrumbsProps:setValue(decoded.breadcrumbs)
    pointA:setValue(decoded.from)
    pointB:setValue(decoded.to)
    -- -- breadcrumbs:setValue(decoded.breadcrumbs)
    pointABbox:setValue(decoded.from, decoded.to)
    actionbox:setValue{{name="onComplete", decoded.actions.onComplete}}
  end
end

return M