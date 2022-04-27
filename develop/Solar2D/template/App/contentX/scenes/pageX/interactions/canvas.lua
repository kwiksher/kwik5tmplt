-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
---------------------
local _K = require "Application"
---------------------
{{#ultimate}}
local bs = {{bs}}/4
{{/ultimate}}
{{^ultimate}}
{{/autoSave}}
local bs = {{bs}}
{{/ultimate}}
-- local canvas
--
function _M:localPos(UI)
  local sceneGroup     = UI.scene.view
  local layer          = UI.layer
  UI.canvas            = layer.{{myLName}}--display.newRect(0, 0, {{cw}}, {{ch}})
  -- UI.canvas.x          = {{mX}}
  -- UI.canvas.y          = {{mY}}
  -- UI.canvas.alpha      = 0.01;
  -- print("canvas")
  UI.canvas.name                           = "UI.canvas"
  UI.canvas.cR, UI.canvas.cG, UI.canvas.cB = {{bc}}
  UI.canvas.brushSize                      = {{bs}}
  UI.canvas.brushAlpha                     = 1
  UI.canvas.lineTable                      = {}
  UI.canvas.undone                         = {}

  UI.canvas:setFillColor({{cc}})
  -- sceneGroup:insert( UI.canvas)
end
--
function _M:didShow(UI)
  local sceneGroup = UI.scene.view
  local layer      = UI.layer
  local linePoints = nil
  local i = 1
  -- UI.Canvas code
  local function newLine( event )
     local lineTable  = UI.canvas.lineTable
     local function drawLine()
        local line = display.newLine(linePoints[#linePoints-1].x,linePoints[#linePoints-1].y,linePoints[#linePoints].x,linePoints[#linePoints].y)
        local circle = display.newCircle(linePoints[#linePoints].x,linePoints[#linePoints].y,UI.canvas.brushSize/2)

        if (circle~=nil and line~= nil and lineTable[i]~= nil) then
            line:setStrokeColor(UI.canvas.cR/255, UI.canvas.cG/255, UI.canvas.cB/255, UI.canvas.brushAlpha)
            line.strokeWidth=UI.canvas.brushSize
            lineTable[i]:insert(line)
            circle:setFillColor(UI.canvas.cR/255, UI.canvas.cG/255, UI.canvas.cB/255,UI.canvas.brushAlpha)
            lineTable[i]:insert(circle)
            --
            {{#outline}}
            -- OUTLINE ON
            sceneGroup:insert( lineTable[i])
            sceneGroup:remove(layer.{{myLName}})
            sceneGroup:insert( layer.{{myLName}})
            sceneGroup.{{myLName}} = layer.{{myLName}}
          {{/outline}}
          {{^outline}}
            -- OUTLINE OFF
            sceneGroup:insert( lineTable[i]);
          {{/outline}}
        else
           print("something wrong with drawing lines")
        end
     end
     if event.phase == "began" then
        i = #lineTable+1
        lineTable[i]=display.newGroup()
        local circle = display.newCircle (event.x, event.y, UI.canvas.brushSize*0.5, 100)
        circle:setFillColor(UI.canvas.cR/255, UI.canvas.cG/255, UI.canvas.cB/255,UI.canvas.brushAlpha)
        lineTable[i]:insert(circle)
        --
        {{#outline}}
          -- OUTLINE ON
          sceneGroup:insert( lineTable[i])
          sceneGroup:remove(layer.{{myLName}})
          sceneGroup:insert( layer.{{myLName}})
          sceneGroup.{{myLName}} = layer.{{myLName}}
        {{/outline}}
        {{^outline}}
          -- OUTLINE OFF
          sceneGroup:insert( lineTable[i]);
        {{/outline}}

        linePoints = nil
        linePoints = {}
        local pt = {}
        pt.x = event.x
        pt.y = event.y
        table.insert(linePoints,pt)
     elseif event.phase == "moved" then
        local pt = {}
        pt.x = event.x
        pt.y = event.y
        if (#linePoints == 0) then
           i = #lineTable+1
           lineTable[i]=display.newGroup()
           linePoints = nil
           linePoints = {}
           table.insert(linePoints,pt)
        end
        if not (pt.x==linePoints[#linePoints].x and pt.y==linePoints[#linePoints].y) then
           table.insert(linePoints,pt)
           drawLine()
        end
     elseif event.phase =="ended" or "cancelled" then
      {{#outline}}
        linePoints = nil
        linePoints = {}
      {{/outline}}
     end
     return true
  end
  UI.canvas:addEventListener("touch", newLine)
  {{#autoSave}}
      -- Auto load previous paint in the canvas
      _K.reloadCanvas = 1
      local path = system.pathForFile(_K.appName.."canvas_p"..UI.curPage..".jpg", system.TemporaryDirectory )
      local fhd = io.open(path)
      if fhd then --file exists
         fhd:close()
         local x,y,w,h,a = layer.{{myLName}}.x, layer.{{myLName}}.y, layer.{{myLName}}.width, layer.{{myLName}}.height, layer.{{myLName}}.alpha
         display.remove(layer.{{myLName}})
         layer.{{myLName}}_asf = display.newImageRect (_K.appName.."canvas_p"..UI.curPage..".jpg", system.TemporaryDirectory, w, h)
         layer.{{myLName}}_asf.x = x
         layer.{{myLName}}_asf.y = y
         layer.{{myLName}}_asf.alpha = a
         layer.{{myLName}}_asf.oldAlpha = a
         sceneGroup:insert(layer.{{myLName}}_asf)
         sceneGroup:insert(layer.{{myLName}})
        {{#outline}}
            layer.{{myLName}} = display.newImageRect( _K.imgDir.. UI.canvas.imagePath, _K.systemDir, w, h );
            layer.{{myLName}}.x = x
            layer.{{myLName}}.y = y
            layer.{{myLName}}.alpha = a
            layer.{{myLName}}.oldAlpha = a
            sceneGroup:insert( layer.{{myLName}})
            sceneGroup.{{myLName}} = layer.{{myLName}}
      {{/outline}}
      end
  {{/autoSave}}
end
--
function _M:willHide(UI)
  local sceneGroup = UI.scene.view
  local layer      = UI.layer
  _K.reloadCanvas = 0
   if UI.canvas.lineTable then
      for i=1, #UI.canvas.lineTable do
         UI.canvas.lineTable[i]:removeSelf()
         UI.canvas.lineTable[i] = nil
      end
   end
end
--
function _M:toDispose(UI)
  local sceneGroup = UI.scene.view
  local layer      = UI.layer
      -- Auto save paint in the canvas
  if _K.reloadCanvas == 1 then
    local myCaptureImage = display.captureBounds(layer.{{myLName}}.contentBounds)
    myCaptureImage.x     = display.contentWidth * 0.5
    myCaptureImage.y     = display.contentHeight * 0.5
    display.save(myCaptureImage, _K.appName.."canvas_p"..UI.curPage..".jpg", system.TemporaryDirectory )
    myCaptureImage:removeSelf()
    myCaptureImage = nil
  else
    os.remove(system.pathForFile( _K.appName.."canvas_p"..UI.curPage..".jpg", system.TemporaryDirectory ))
  end
end
--
function _M:toDestroy()
    --_K.reloadCanvas = nil
end

return _M