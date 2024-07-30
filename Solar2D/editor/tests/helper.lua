local exports = {}

local json = require( "json" )

local selectors
local UI
local bookTable
local pageTable
local layerTable
local actionTable
local groupTable
local variableTable
local timerTable
local assetTable
local buttons

function exports.init(props)
  selectors = props.selectors
  UI = props.UI
  bookTable = props.bookTable
  pageTable = props.pageTable
  layerTable = props.layerTable
  actionTable = props.actionTable
  groupTable = props.groupTable
  timerTable = props.timerTable
  variableTable = props.variableTable
  assetTable = props.assetTable
  ---
  buttons = props.buttons
  audioTable = props.audioTable
end

function exports.clickIcon(toolGroup, tool)
  local toolbar = require("editor.parts.toolbar")
  local obj = toolbar.layerToolMap[toolGroup]
  obj.callBack{target=obj}
  -- for k, v in pairs(toolbar.toolMap) do print(k, v) end
  local tool = toolbar.toolMap[obj.id.."-"..tool]
  tool.callBack{target=tool}
end

function exports.selectIcon(toolGroup, tool)
  -- local toolbar = UI.editor.toolbar
  if toolGroup == "action" then
    local obj = UI.editor.actionIcon
    obj.callBack{target=obj}
  else
    local toolbar = require("editor.parts.toolbar")
    local obj = toolbar.layerToolMap[toolGroup]
    obj.callBack{target=obj}
    if tool then
      local obj = toolbar.toolMap[obj.id.."-"..tool]
      obj.callBack{target=obj}
    end
  end
end

function exports.selectActionGroup(name)
  local muiName = "action.commandView-"
  local controller = require("editor.action.controller.index")
  controller.commandGroupHandler{target={muiOptions={name=muiName..name}}}
end

function exports.selectActionCommand(class, name)
  local controller = require("editor.action.controller.index")
  controller.commandHandler{model={commandClass=class}}
  local commandbox = require("editor.action.commandbox")
  for i, obj in next, commandbox.objs do
    if obj.text == name then
      obj:tap{numTaps=1}
      break
    end
  end
end

function exports.hasObj(tbl, name)
  if tbl.objs == nil then return false end
  for i, obj in next, tbl.objs do
    if obj.text == name then
      return true
    end
  end
  return false
end

function exports.clickProp(objs, name)
  for i, obj in next, objs do
    if obj.text == name then
      obj:dispatchEvent{name="tap", target=obj, x=obj.x, y=obj.y}
      return
    end
  end
end

exports.clickObj = exports.clickProp

function exports.setProp(objs, name, value)
  for i, obj in next, objs do
    if obj.text == name then
      obj.field.text = value
      return
    end
  end
end

function exports.clickAsset(objs, name)
  for i, obj in next, objs do
    if obj.text == name then
        obj:touch({phase="ended"})
      return
   end
  end
end

function exports.singelClick(tbl, name)
  for i, obj in next, tbl.objs do
    -- print(obj.text:len(), name:len(), obj.text == name)
    if obj.text:gsub("%s+", "") == name then
      tbl:singleClickEvent(obj)
      return
    end
  end
end


function exports.touchAction(name)
  local actionTable = actionTable or exports.actionTable
  --actionTable.altDown = true
  for i, v in next, actionTable.objs do
    if v.text == name then
      -- v:dispatchEvent{name="touch", pahse="ended", target=v}
      v:touch{phase = "ended"}
      break
    end
  end
  --actionTable.altDown = false
end

function exports.selectLayer(name, class, isRightClick)
  -- print(name, class)
  for i, obj in next,layerTable.objs do
    if obj.text == name then
      -- print("", i, obj.text, obj.name)
      if class == nil then
        if isRightClick then
          obj:dispatchEvent{name="mouse", target=obj, isSecondaryButtonDown=true, x =obj.x, y=obj.y}
        else
          obj:touch({phase="ended"})
        end
      else
        for i, classObj in next, obj.classEntries do
          print("", "", classObj.class)
          if classObj.class == class then
              if isRightClick then
                  print("", "", "isRightClick")
                  classObj:dispatchEvent{name= "mouse", target=classObj, isSecondaryButtonDown=true, x = classObj.x, y = classObj.y}
              else
                print("", "", "touch ended")
                classObj:touch({phase="ended"})
              end
            break
          end
        end
      end
      -- obj.classEntries[1]:touch({phase="ended"}) -- animation
      return obj
    end
  end
end

function exports.selectLayerProps(name, class)
  layerTable.altDown = true
  exports.selectLayer(name, class)
  layerTable.altDown = false
end


function exports.selectTool(args)
  UI.scene.app:dispatchEvent(
    {
      name = "editor.selector.selectTool",
      UI = UI,
      class = args.class, -- obj.class,
      -- toolbar = self,
      isNew = args.isNew
    }
  )
end

local function _selectComponent(name, isRightClick, targetTable)
  for i, v in next, targetTable.objs do
    -- print("###", v.text)
    if v.text == name then
      -- v:dispatchEvent{name="touch", pahse="ended", target=v}
      if isRightClick then
        v:dispatchEvent{name= "mouse", target=v, isSecondaryButtonDown=true, x = v.x, y = v.y}
      else
        v:touch{target=v}
      end
      return
    end
  end
end

function exports.selectAsset(name, isRightClick)
  _selectComponent(name, isRightClick, assetTable)
end

function exports.selectAudio(name, isRightClick)
    _selectComponent(name, isRightClick, audioTable)
end

function exports.selectAction(name, isRightClick)
  _selectComponent(name, isRightClick, actionTable)
end

function exports.selectGroup(name, isRightClick)
  _selectComponent(name, isRightClick, groupTable)
end

function exports.selectTimer(name, isRightClick)
  _selectComponent(name, isRightClick, groupTable)
end

function exports.selectVariable(name, isRightClick)
  _selectComponent(name, isRightClick, variableTable)
end

function exports.selectComponent(name)
  for i, v in next, selectors.componentSelector.objs do
    if v.text == name then
      v:dispatchEvent{name="tap", target=v}
      return
    end
  end
end

function exports.getBook(name, isRightClick)
  for i, v in next, bookTable.objs do
    if v.text == name then
       return v
    end
  end
end

function exports.getPage(name, isRightClick)
  for i, v in next, pageTable.objs do
    if v.text == name then
       return v
    end
  end
end

function exports.clickButton(name, buttonsContext)
  local _buttons = buttonsContext or buttons
  for i, v in next, _buttons.objs do
    -- print(v.text)
    if v.eventName == name then -- {name="add", label="->"}
        if v.rect.tap then
          v.rect:tap()
        else
          v:tap()
        end
      break
    end
  end
end

function exports.clickButtonInRow(parent, name)
  for i, v in next, buttons.objs do
    print(v.eventName)
    if v.eventName == parent then -- {name="add", label="->"}
        for k, o in next, v.rect.buttonsInRow do
          if o.eventName == name then
            o.rect:tap()
            break
          end
        end
      break
    end
  end
end

function exports.selectEntries(box, names)
  for k, n in next, names do
    for i, v in next, box.objs do
      if v.layer == n then
        -- print("n", n)
        --v:dispatchEvent{name="touch", phase="began", target=v}
        -- v:dispatchEvent{name="touch", phase="ended", target=v}
        v:touch{phase="ended"}
        break
      end
    end
  end
end

function exports.getEntries(box, names)
  local ret = {}
  for k, n in next, names do
    for i, v in next, box.objs do
      if v.layer == n then
        print("n", n)
        ret[#ret+1] = v
        break
      end
    end
  end
  return ret
end

function exports.getObjs(t, names)
  local ret = {}
  for k, n in next, names do
    for i, target in next, t.objs do
      if target.text == n then
        print("n", n)
        ret[#ret+1] = target
        break
      end
    end
  end
  return ret
end

function exports.getObj(objs, n)
    for i, obj in next, objs do
      if obj.text == n then
        return obj
      end
    end
end


function exports.getFillColor(object)
  local decoded, pos, msg = json.decode( object._properties )
  if not decoded then
      -- handle the error (which you're not likely to get)
  else
      local fill = decoded.fill
      print( fill.r, fill.g, fill.b, fill.a )
      return fill
  end
end


return exports
