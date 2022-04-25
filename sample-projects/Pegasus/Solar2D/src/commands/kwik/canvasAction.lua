-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K            = require "Application"
--
function _M:brushSize(canvas, psize, pal)
  canvas.brushSize = psize
  canvas.brushAlpha = pal
end
--
function _M:brushColor( canvas, r, g, b)
  canvas.cR, canvas.cG, canvas.cB = r, g, b
end
--
function _M:eraseCanvas(canvas)
  _K.reloadCanvas = 0
  local lineTable = canvas.lineTable
  for i=1, #lineTable do
     lineTable[i]:removeSelf(); lineTable[i] = nil
  end
  canvas.undone   = {}
  canvas.lineTable = {}
end
--
function _M:undo(canvas)
  local lineTable = canvas.lineTable
  local undone    = canvas.undone

  if #lineTable>0 then
      local n = #lineTable
      local stroke = lineTable[n]
      table.remove(lineTable, n)
      lineTable[n] = nil
      undone[#undone+1] = stroke
      stroke.isVisible = false
   end
end
--
function _M:redo(canvas)
  local lineTable = canvas.lineTable
  local undone    = canvas.undone

 if #undone>0 then
     local n = #undone
     local stroke = undone[n]
     table.remove(undone, n)
     undone[n] = nil
     lineTable[#lineTable+1] = stroke
     stroke.isVisible = true
  end
end
--
return _M