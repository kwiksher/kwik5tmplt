local M = require("components.kwik.layer_base").new()
--
local json = require("json")

function M:create (UI)
  local sceneGroup = UI.sceneGroup
  local layerName  = self.properties.target
  local target     = sceneGroup[layerName]
  -- local group      = display.newGroup()
  -- local particleCanvas = display.newContainer(target.width*2, target.height*10)
  -- local rect = display.newRect(target.x, target.y,target.width*2, target.height*10)
  -- rect:setFillColor(0)
  -- -- particleCanvas:insert(rect)
  --
  local emitterParams
  -- print(self.properties.filename)
  if self.properties.filename:find(".json") then
    print("---- json -----")
    local filePath = system.pathForFile( UI.props.particleDir.. self.properties.filename,UI.props.systemDir )
    local f = io.open( filePath, "r" )
    local fileData = f:read( "*a" )
    f:close()
    emitterParams = json.decode( fileData )
  elseif self.properties.filename:find(".lua") then
    print("---- lua -----")
    local mod = "App."..UI.book..".assets."..self.properties.filename:gsub(".lua", "")
    mod = mod:gsub("/", ".")
    emitterParams = require(mod)
  else
    print("Error reading",self.properties.filename)
  end

  local params = {}
  for k, v in pairs (emitterParams) do
    params[k] = v
  end
  params.textureFileName = UI.props.particleDir .. params.textureFileName
  print( UI.props.particleDir )
  --
  printKeys(params)
  local obj = display.newEmitter( params, UI.props.systemDir )
  -- print("@@@", target.x, target.y, obj)
  -- if obj == nil then return end
  -- obj.alpha = 1
  obj.x        = target.x
  obj.y        = target.y
  obj.oriX     = target.oriX
  obj.oriY     = target.oriY
  obj.oriXs    = target.scaleX
  obj.oriYs    = target.scaleY
  obj.oldAlpha = target.alpha
  obj.class    = "particles"

  -- particleCanvas:insert(obj)
  -- particleCanvas.x = target.x
  -- particleCanvas.y = target.y

  -- particleCanvas.x, particleCanvas.y = display.contentCenterX, display.contentCenterY
  -- sceneGroup:insert(rect)
  sceneGroup:insert(obj)

  -- particleCanvas:toFront()
  -- obj.alpha   = target.alpha
  -- group:insert(obj)
  -- group:toFront()
  -- sceneGroup:toBack()
  -- sceneGroup:insert(obj)
  -- obj:toFront()
  -- --
  -- target target should be removed
  target.alpha  = 0 -- removeSelf?
  --
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