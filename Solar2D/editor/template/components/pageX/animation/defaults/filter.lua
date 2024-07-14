local M = {
  name = "filter",
  class = "Filter",
  properties ={
    target     = NIL,
    animation  = false,
    delay      = 0,
    duration   = 1000,
    autoPlay   = true,
    loop       = 1,        -- 0 to play once
    easing     = "inQuad",
    reverse    = nil,
    resetAtEnd = nil,
  },
  -- composite = {
  --   effect   = "composite.normalMapWith1PointLight",
  --   paint1 = "image01.png",
  --   paint2 = "texture.png",
  --   folder = NIL,
  -- },
  filter = {
    effect = "filter.bloom",
  } ,
  actions = {onComplete = NIL},
}
--
M.filterTable = {}
--
local json = require("json")
local path = system.pathForFile( "editor/template/components/pageX/animation/defaults/filters.json", system.ResourceDirectory )
local file, errorString = io.open( path, "r" )
local contents = file:read( "*a" )
io.close( file )
local data = json.decode(contents)

local function getFilterParams(name)
  for i, v in next, data do
    if v.name == name then
      return v
    end
  end
end

--
M.filterTable["filter.bloom"] = {
    set = function(effect, value)
      if value then
        effect.levels.gamma             = value.levels.gamma
        effect.levels.black             = value.levels.black
        effect.levels.white             = value.levels.white
        effect.blur.vertical.blurSize   = value.blur.vertical.blurSize
        effect.blur.vertical.sigma      = value.blur.vertical.sigma
        effect.blur.horizontal.blurSize = value.blur.horizontal.blurSize
        effect.blur.horizontal.sigma    = value.blur.horizontal.sigma
        effect.add.alpha                = value.add.alpha
      end
    end,
    get = function()
        if M.effect == nil then
          local params = getFilterParams("filter.bloom")
          local effect = {}
          effect.levels = {}
          effect.blur  = {vertical={}, horizontal = {}}
          effect.add = {}
          effect.levels.gamma             = params.levels.gamma
          effect.levels.black             = params.levels.black
          effect.levels.white             = params.levels.white
          effect.blur.vertical.blurSize   = params.blur.vertical.blurSize
          effect.blur.vertical.sigma      = params.blur.vertical.sigma
          effect.blur.horizontal.blurSize = params.blur.horizontal.blurSize
          effect.blur.horizontal.sigma    = params.blur.horizontal.sigma
          effect.add.alpha                = params.add.alpha
          M.effect = effect
        end
        return M.effect
    end
}

M.filterTable["composite.normalMapWith1PointLight"] = {
    set = function(effect, value)
      if value then
          effect.pointLightPos = value.pointLightPos
          effect.pointLightColor = value.pointLightColor
          effect.ambientLightIntensity = value.ambientLightIntensity
          effect.attenuationFactors = value.attenuationFactors
       end
    end,
    get = function(param)
      if M.effect == nil then
        local params = getFilterParams("composite.normalMapWith1PointLight")
        local effect = {}
        effect.pointLightPos      =  {}
        effect.pointLightColor    =  {}
        effect.attenuationFactors = {}
        effect.pointLightPos ={
          params.pointLightPos[1],
          params.pointLightPos[2],
          params.pointLightPos[3]
        }
        effect.pointLightColor = {
           params.pointLightColor[1],
           params.pointLightColor[2],
           params.pointLightColor[3],
           params.pointLightColor[4]
         }
        effect.ambientLightIntensity = params.ambientLightIntensity
        effect.attenuationFactors = {
          params.attenuationFactors[1],
          params.attenuationFactors[2],
          params.attenuationFactors[3],
        }
        M.effect = effect
      end
      return M.effect
    end
}

return M