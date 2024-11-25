local M = require("components.kwik.layer_base").new()
--

function M:create (UI)
  local sceneGroup = UI.sceneGroup
  local layerName  = self.properties.target
  local obj        = sceneGroup[layerName]
  local posX,       posY  = obj.x,      obj.y
  local scaleX,     saleY = obj.xScale, obj.yScale
  local alpha      = obj.alpha
  --
  -- target obj should be removed
  obj.alpha  = 0 -- removeSelf?
  --

  local emitterParams

  if self.properties.url:find(".json") then
    local filePath = system.pathForFile( UI.props.particleDir.. self.properties.url,UI.props.systemDir )
    local f = io.open( filePath, "r" )
    local fileData = f:read( "*a" )
    f:close()
    emitterParams = json.decode( fileData )
    emitterParams.textureFileName = _K.particleDir .. emitterParams.textureFileName
  elseif self.properties.url:find(".lua") then
    emitterParams = require("App."..UI.book..".assets.particles."..self.properties.url:gsub(".lua", ""))
  end

  local _obj = display.newEmitter( emitterParams, UI.props.systemDir )
  if _obj == nil then return end
  obj = _obj
  obj.x        = posX
  obj.y        = posY
  obj.oriX     = posX
  obj.oriY     = posY
  obj.oriXs    = scaleX
  obj.oriYs    = scaleY
  obj.oldAlpha = alpha
  obj.class    = "particles"
  sceneGroup: insert( obj)
end

function M:didShow(UI)
  if self.properties.autoPlay == false then
    self.obj:pause();
  end
end

M.new = function(instance)
  -- print(instance.x, instance.y, instance.width, instance.height)
  return setmetatable(instance, {__index = M})
end

return M