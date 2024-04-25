local M = {}
---------------------
local app = require "controller.Application"
---------------------
-- local canvas
--
function M:setCanvas(obj)
  self.obj            = obj --obj--display.newRect(0, 0, {{cw}}, {{ch}})
  -- self.x          = {{mX}}
  -- self.y          = {{mY}}
  -- self.alpha      = 0.01;
  -- print("canvas")
  self.name                           = "UI.canvas"
  -- self.brushSize                      = 10
  self.brushAlpha                     = 1
  self.lineTable                      = {}
  self.undone                         = {}

  self.obj:setFillColor(self.color)
  -- sceneGroup:insert( self)
end
--
-- self code
function M:newLine( event )
  local lineTable  = self.lineTable
  local linePoints = self.linePoints
  local sceneGroup = self.sceneGroup
  local obj = self.obj
  local index = 1
  local cR, cG, cB = self.brushColor[1], self.brushColor[2], self.brushColor[3]
  --
  local function drawLine()
     local line = display.newLine(linePoints[#linePoints-1].x,linePoints[#linePoints-1].y,linePoints[#linePoints].x,linePoints[#linePoints].y)
     local circle = display.newCircle(linePoints[#linePoints].x,linePoints[#linePoints].y,self.brushSize/2)

     if (circle~=nil and line~= nil and lineTable[index]~= nil) then
         line:setStrokeColor(cR/255, cG/255, cB/255, self.brushAlpha)
         line.strokeWidth=self.brushSize
         lineTable[index]:insert(line)
         circle:setFillColor(cR/255, cG/255, cB/255,self.brushAlpha)
         lineTable[index]:insert(circle)
         --
         if self.outline then
           -- OUTLINE ON
           sceneGroup:insert( lineTable[index])
           sceneGroup:remove(obj)
           sceneGroup:insert( obj)
           sceneGroup[self.name] = obj
         else
           -- OUTLINE OFF
           sceneGroup:insert( lineTable[index]);
         end
     else
        print("something wrong with drawing lines")
     end
  end
  if event.phase == "began" then
     index = #lineTable+1
     lineTable[index]=display.newGroup()
     local circle = display.newCircle (event.x, event.y, self.brushSize*0.5, 100)
     circle:setFillColor(cR/255, cG/255, cB/255,self.brushAlpha)
     lineTable[index]:insert(circle)
     --
     if self.outline then
       -- OUTLINE ON
       sceneGroup:insert( lineTable[index])
       sceneGroup:remove(obj)
       sceneGroup:insert( obj)
       sceneGroup[self.name] = obj
     else
       -- OUTLINE OFF
       sceneGroup:insert( lineTable[index]);
     end

     self.linePoints = {}
     local pt = {}
     pt.x = event.x
     pt.y = event.y
     table.insert(self.linePoints,pt)
  elseif event.phase == "moved" then
     local pt = {}
     pt.x = event.x
     pt.y = event.y
     if (#linePoints == 0) then
        index = #lineTable+1
        lineTable[index]=display.newGroup()
        -- self.linePoints = {}
        table.insert(linePoints,pt)
     end
     if not (pt.x==linePoints[#linePoints].x and pt.y==linePoints[#linePoints].y) then
        table.insert(linePoints,pt)
        drawLine()
     end
  elseif event.phase =="ended" or "cancelled" then
  --  if self.outline then
  --    self.linePoints = {}
  --  end
  end
  return true
end

--
function M:didShow(UI)
  local sceneGroup = UI.sceneGroup
  self.linePoints = nil
  self.lineTable = {}
  local obj = self.obj
  --
  obj:addEventListener("touch", function(event) self:newLine(event) end)
  --
  if self.autoSave then
    -- Auto load previous paint in the canvas
    app.reloadCanvas = 1
    local path = system.pathForFile(app.appName.."canvas_p"..UI.curPage..".jpg", system.TemporaryDirectory )
    local fhd = io.open(path)
    if fhd then --file exists
        fhd:close()
        --
        local x,y,w,h,a = obj.x, obj.y, obj.width, obj.height, obj.alpha
        obj_asf = display.newImageRect (app.appName.."canvas_p"..UI.curPage..".jpg", system.TemporaryDirectory, w, h)
        obj_asf.x = x
        obj_asf.y = y
        obj_asf.alpha = a
        obj_asf.oldAlpha = a
        --
        -- why?
        display.remove(obj)
        sceneGroup:insert(obj_asf)
        sceneGroup:insert(obj)
      if self.outline then
          obj = display.newImageRect( app.imgDir.. self.imagePath, app.systemDir, w, h );
          obj.x = x
          obj.y = y
          obj.alpha = a
          obj.oldAlpha = a
          sceneGroup:insert( obj)
          sceneGroup[self.name] = obj
      end
    end
  end
end
--
function M:willHide(UI)
  local sceneGroup = UI.sceneGroup
  local layer      = UI.layer
  app.reloadCanvas = 0
   if self.lineTable then
      for index=1, #self.lineTable do
         self.lineTable[index]:removeSelf()
         self.lineTable[index] = nil
      end
   end

  local obj = self.obj
  --
  obj:removeEventListener("touch")

end
--
function M:destroy(UI)
  local sceneGroup = UI.sceneGroup
  local layer      = UI.layer
      -- Auto save paint in the canvas
  if app.reloadCanvas == 1 then
    local myCaptureImage = display.captureBounds(self.obj.contentBounds)
    myCaptureImage.x     = display.contentWidth * 0.5
    myCaptureImage.y     = display.contentHeight * 0.5
    display.save(myCaptureImage, app.appName.."canvas_p"..UI.curPage..".jpg", system.TemporaryDirectory )
    myCaptureImage:removeSelf()
    myCaptureImage = nil
  else
    os.remove(system.pathForFile( app.appName.."canvas_p"..UI.curPage..".jpg", system.TemporaryDirectory ))
  end
end
--
return M