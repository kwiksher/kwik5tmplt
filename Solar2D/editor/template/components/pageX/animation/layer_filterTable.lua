local M = {
  to = NIL,
  from = NIL
}
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
      else
        effect.levels.gamma             = from.levels_gamma
        effect.levels.black             = from.levels_black
        effect.levels.white             = from.levels_white
        effect.blur.vertical.blurSize   = from.blur_vertical_blurSize
        effect.blur.vertical.sigma      = from.blur_vertical_sigma
        effect.blur.horizontal.blurSize = from.blur_horizontal_blurSize
        effect.blur.horizontal.sigma    = from.blur_horizontal_sigma
        effect.add.alpha                = from.add_alpha
      end
    end,
    get = function()
        local effect = {}
        effect.levels = {}
        effect.blur  = {vertical={}, horizontal = {}}
        effect.add = {}
        effect.levels.gamma             = to.levels_gamma
        effect.levels.black             = to.levels_black
        effect.levels.white             = to.levels_white
        effect.blur.vertical.blurSize   = to.blur_vertical_blurSize
        effect.blur.vertical.sigma      = to.blur_vertical_sigma
        effect.blur.horizontal.blurSize = to.blur_horizontal_blurSize
        effect.blur.horizontal.sigma    = to.blur_horizontal_sigma
        effect.add.alpha                = to.add_alpha
        return effect
    end
}
--
M.filterTable["filter.blur"] = {
    set = function(effect, value)
    end,
    get = function()
        local effect = {}
        return effect
    end
}
--
M.filterTable["filter.blurGaussian"] = {
    set = function(effect, value)
      if value then
          effect.vertical.blurSize   = value.vertical.blurSize
          effect.vertical.sigma      = value.vertical.sigma
          effect.horizontal.blurSize = value.horizontal.blurSize
          effect.horizontal.sigma    = value.horizontal.sigma
      else
        effect.vertical.blurSize   = from.vertical_blurSize
        effect.vertical.sigma      = from.vertical_sigma
        effect.horizontal.blurSize = from.horizontal_blurSize
        effect.horizontal.sigma    = from.horizontal_sigma
       end
    end,
    get = function()
          local effect = {}
          effect.vertical = {}
          effect.horizontal = {}
          effect.vertical.blurSize   = to.vertical_blurSize
          effect.vertical.sigma      = to.vertical_sigma
          effect.horizontal.blurSize = to.horizontal_blurSize
          effect.horizontal.sigma    = to.horizontal_sigma
        return effect
    end
}
M.filterTable["filter.blurHorizontal"] = {
    set = function(effect, value)
      if value then
          effect.blurSize   = value.blurSize
          effect.sigma      = value.sigma
      else
        effect.blurSize   = from.blurSize
        effect.sigma      = from.sigma
       end
    end,
    get = function()
          local effect = {}
          effect.blurSize   = to.blurSize
          effect.sigma      = to.sigma
        return effect
    end
}
--
--
M.filterTable["filter.blurVertical"] = {
    set = function(effect, value)
      if value then
          effect.blurSize   = value.blurSize
          effect.sigma      = value.sigma
      else
        effect.blurSize   = from.blurSize
        effect.sigma      = from.sigma
       end
    end,
    get = function()
          local effect = {}
          effect.blurSize   = to.blurSize
          effect.sigma      = to.sigma
        return effect
    end
}
--
M.filterTable["filter.brightness"] = {
    set = function(effect, value)
      if value then
          effect.intensity   = value.intensity
      else
        effect.intensity   = from.intensity
       end
    end,
    get = function()
          local effect = {}
          effect.intensity   = to.intensity
        return effect
    end
}
--
M.filterTable["filter.bulge"] = {
    set = function(effect, value)
      if value then
          effect.intensity   = value.intensity
      else
        effect.intensity   = from.intensity
       end
    end,
    get = function()
          local effect = {}
          effect.intensity   = to.intensity
        return effect
    end
}
--
M.filterTable["filter.chromaKey"] = {
    set = function(effect, value)
      if value then
          effect.sensitivity = value.sensitivity
          effect.smoothing   = value.smoothing
          effect.color       = value.color
      else
          effect.sensitivity = from.sensitivity
          effect.smoothing   = from.smoothing
          effect.color       = from.color
       end
    end,
    get = function()
          local effect = {}
          effect.sensitivity = to.sensitivity
          effect.smoothing   = to.smoothing
          effect.color       = to.color
        return effect
    end
}
--
M.filterTable["filter.colorChannelOffset"] = {
    set = function(effect, value)
      if value then
          effect.yTexels = value.yTexels
          effect.xTexels = value.xTexels
      else
          effect.yTexels = from.yTexels
          effect.xTexels = from.xTexels
       end
    end,
    get = function()
          local effect = {}
          effect.yTexels = to.yTexels
          effect.xTexels = to.xTexels
        return effect
    end
}
--
M.filterTable["filter.contrast"] = {
    set = function(effect, value)
      if value then
          effect.contrast = value.contrast
      else
          effect.contrast = from.contrast
       end
    end,
    get = function()
          local effect = {}
          effect.contrast = to.contrast
        return effect
    end
}
--
M.filterTable["filter.crosshatch"] = {
    set = function(effect, value)
      if value then
          effect.grain = value.grain
      else
          effect.grain = from.grain
       end
    end,
    get = function()
          local effect = {}
          effect.grain = to.grain
        return effect
    end
}
--
M.filterTable["filter.crystallize"] = {
    set = function(effect, value)
      if value then
          effect.numTiles = value.numTiles
      else
          effect.numTiles = from.numTiles
       end
    end,
    get = function()
          local effect = {}
          effect.numTiles = to.numTiles
        return effect
    end
}
--
M.filterTable["filter.desaturate"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
          effect.intensity = from.intensity
       end
    end,
    get = function()
          local effect = {}
          effect.intensity = to.intensity
        return effect
    end
}
--
M.filterTable["filter.dissolve"] = {
    set = function(effect, value)
      if value then
          effect.threshold = value.threshold
      else
          effect.threshold = from.threshold
       end
    end,
    get = function()
          local effect = {}
          effect.threshold = to.threshold
        return effect
    end
}
--
M.filterTable["filter.duotone"] = {
    set = function(effect, value)
      if value then
        effect.darkColor = value.darkColor
        -- effect.darkColor2 = value.darkColor2
        effect.lightColor = value.lightColor
        -- effect.lightColor2 = value.lightColor2
      else
        effect.darkColor = from.darkColor
        -- effect.darkColor2 = {
        --   {{darkColor2_0}},
        --   {{darkColor2_1}},
        --   {{darkColor2_2}},
        --   {{darkColor2_3}}
        -- }
        effect.lightColor = from.lightColor
        -- effect.lightColor2 = {
        --   {{lightColor2_0}},
        --   {{lightColor2_1}},
        --   {{lightColor2_2}},
        --   {{lightColor2_3}}
        -- }
       end
    end,
    get = function()
          local effect = {}
        effect.darkColor = to.darkColor
        -- effect.darkColor2 = {
        --   {{darkColor2_0}},
        --   {{darkColor2_1}},
        --   {{darkColor2_2}},
        --   {{darkColor2_3}}
        -- }
        effect.lightColor = to.lightColor
        -- effect.lightColor2 = {
        --   {{lightColor2_0}},
        --   {{lightColor2_1}},
        --   {{lightColor2_2}},
        --   {{lightColor2_3}}
        -- }
        return effect
    end
}
--
M.filterTable["filter.emboss"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
          effect.intensity = from.intensity
       end
    end,
    get = function()
          local effect = {}
          effect.intensity = to.intensity
        return effect
    end
}
--
M.filterTable["filter.exposure"] = {
    set = function(effect, value)
      if value then
          effect.exposure = value.exposure
      else
          effect.exposure = from.exposure
       end
    end,
    get = function()
          local effect = {}
          effect.exposure = to.exposure
        return effect
    end
}
--
M.filterTable["filter.frostedGlass"] = {
    set = function(effect, value)
      if value then
          effect.scale = value.scale
      else
          effect.scale = from.scale
       end
    end,
    get = function()
          local effect = {}
          effect.scale = to.scale
        return effect
    end
}
--
M.filterTable["filter.grayscale"] = {
    set = function(effect, value)
    end,
    get = function()
          local effect = {}
        return effect
    end
}
--
M.filterTable["filter.hue"] = {
    set = function(effect, value)
      if value then
          effect.angle = value.angle
      else
          effect.angle = from.angle
       end
    end,
    get = function()
          local effect = {}
          effect.angle = to.angle
        return effect
    end
}
--
M.filterTable["filter.invert"] = {
    set = function(effect, value)
    end,
    get = function()
          local effect = {}
        return effect
    end
}
--
M.filterTable["filter.iris"] = {
    set = function(effect, value)
      if value then
          effect.smoothness = value.smoothness
          effect.aspectRatio = value.aspectRatio
          effect.center_0 = value.center_0
          effect.center_1 = value.center_0
          effect.aperture = value.aperture
      else
          effect.smoothness = from.smoothness
          aspectRatio = from.aspectRatio
          effect.center_0 = from.center_0
          effect.center_1 = from.center_1
          effect.aperture = from.aperture
       end
    end,
    get = function()
          local effect = {}
          effect.smoothness = to.smoothness
          effect.aspectRatio = to.aspectRatio
          effect.center_0 = to.center_0
          effect.center_1 = to.center_1
          effect.aperture = to.aperture
        return effect
    end
}
--
M.filterTable["filter.levels"] = {
    set = function(effect, value)
      if value then
          effect.gamma = value.gamma
          effect.white = value.white
          effect.black = value.black
      else
          effect.gamma = from.gamma}
          effect.white = from.white
          effect.black = from.black
       end
    end,
    get = function()
          local effect = {}
          effect.gamma = to.gamma
          effect.white = to.white
          effect.black = to.black
        return effect
    end
}
--
M.filterTable["filter.linearWipe"] = {
    set = function(effect, value)
      if value then
          effect.progress = value.progress
          effect.smoothness = value.smoothness
          effect.direction_0 = value.direction_0
          effect.direction_1 = value.direction_1
      else
          effect.progress = from.progress
          effect.smoothness = from.smoothness
          effect.direction_0 = from.direction_0
          effect.direction_1 = from.direction_1
       end
    end,
    get = function()
          local effect = {}
          effect.progress = to.progress
          effect.smoothness = to.smoothness
          effect.direction_0 = to.direction_0
          effect.direction_1 = to.direction_1
        return effect
    end
}
--
M.filterTable["filter.median"] = {
    set = function(effect, value)
    end,
    get = function()
        local effect = {}
        return effect
    end
}
--
M.filterTable["filter.monotone"] = {
    set = function(effect, value)
      if value then
          effect.a = value.a
          effect.b = value.b
          effect.g = value.g
          effect.r = value.r
      else
          effect.a = from.a
          effect.b = from.b
          effect.g = from.g
          effect.r = from.r
       end
    end,
    get = function()
          local effect = {}
          effect.a = to.a
          effect.b = to.b
          effect.g = to.g
          effect.r = to.r
        return effect
    end
}
--
M.filterTable["filter.opTile"] = {
    set = function(effect, value)
      if value then
          effect.scale = value.scale
          effect.angle = value.angle
          effect.numPixels = value.numPixels
      else
          effect.scale = from.scale
          effect.agnle = from.angle
          effect.numPixels = from.numPixels
       end
    end,
    get = function()
          local effect = {}
          effect.scale = to.scale
          effect.angle = to.angle
          effect.numPixels = to.numPixels
        return effect
    end
}
--
M.filterTable["filter.pixelate"] = {
    set = function(effect, value)
      if value then
          effect.numPixels = value.numPixels
      else
          effect.numPixels = from.numPixels
       end
    end,
    get = function()
          local effect = {}
          effect.numPixels = to.numPixels
        return effect
    end
}
--
M.filterTable["filter.polkaDots"] = {
    set = function(effect, value)
      if value then
          effect.aspectRatio = value.aspectRatio
          effect.dotRadius = value.dotRadius
          effect.numPixels = value.numPixels
      else
          effect.aspectRatio = from.aspectRatio
          effect.doRadius = from.dotRadius
          effect.numPixels = from.numPixels
       end
    end,
    get = function()
          local effect = {}
          effect.aspectRatio = to.aspectRatio
          effect.dotRadius = to.dotRadius
          effect.numPixels = to.numPixels
        return effect
    end
}
--
M.filterTable["filter.posterize"] = {
    set = function(effect, value)
      if value then
          effect.colorsPerChannel = value.colorsPerChannel
      else
          effect.colorsPerChannel = from.colorsPerChannel
       end
    end,
    get = function()
          local effect = {}
          effect.colorsPerChannel = to.colorsPerChannel
        return effect
    end
}
--
M.filterTable["filter.radialWipe"] = {
    set = function(effect, value)
      if value then
          effect.smoothness = value.smoothness
          effect.progress = value.progress
          effect.center_0 = value.center_0
          effect.center_1 = value.center_0
          effect.axisOrientation = value.axisOrientation
      else
          effect.smoothness = from.smoothness
          effect.progress = from.progress
          effect.center_0 = from.center_0
          effect.center_1 = from.center_1
          effect.axisOrientation = from.axisOrientation
       end
    end,
    get = function()
          local effect = {}
          effect.smoothness = to.smoothness
          effect.progress = to.progress
          effect.center_0 = to.center_0
          effect.center_1 = to.center_1
          effect.axisOrientation = to.axisOrientation
        return effect
    end
}
--
M.filterTable["filter.saturate"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
          effect.intensity = from.intensity
       end
    end,
    get = function()
          local effect = {}
          effect.intensity = to.intensity
        return effect
    end
}
--
M.filterTable["filter.scatter"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
          effect.intensity = from.intensity
       end
    end,
    get = function()
          local effect = {}
          effect.intensity = to.intensity
        return effect
    end
}
--
M.filterTable["filter.sepia"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
          effect.intensity = from.intensity
       end
    end,
    get = function()
          local effect = {}
          effect.intensity = to.intensity
        return effect
    end
}
--
M.filterTable["filter.sharpenLuminance"] = {
    set = function(effect, value)
      if value then
          effect.sharpness = value.sharpness
      else
          effect.sharpness = from.sharpness
       end
    end,
    get = function()
          local effect = {}
          effect.sharpness = to.sharpness
        return effect
    end
}
--
M.filterTable["filter.sobel"] = {
    set = function(effect, value)
      if value then
      else
get = function()
        local effect = {}
        return effect
    end
}
--
M.filterTable["filter.straighten"] = {
    set = function(effect, value)
      if value then
          effect.height = value.height
          effect.angle = value.angle
          effect.width = value.width
      else
          effect.height = from.height
          effect.angle = from.angle
          effect.width = from.width
       end
    end,
    get = function()
          local effect = {}
          effect.height = to.height
          effect.angle = to.angle
          effect.width = to.width
        return effect
    end
}
--
M.filterTable["filter.swirl"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
          effect.intensity = from.intensity
       end
    end,
    get = function()
          local effect = {}
          effect.intensity = to.intensity
        return effect
    end
}
--
M.filterTable["filter.vignette"] = {
    set = function(effect, value)
      if value then
          effect.radius = value.radius
      else
          effect.radius = from.radius
       end
    end,
    get = function()
          local effect = {}
          effect.radius = to.radius
        return effect
    end
}
--
M.filterTable["filter.vignetteMask"] = {
    set = function(effect, value)
      if value then
          effect.outerRadius = value.outerRadius
          effect.innerRadius = value.innerRadius
      else
          effect.outerRadius = from.outerRadius
          effect.innerRadius = from.innerRadius
       end
    end,
    get = function()
          local effect = {}
          effect.outerRadius = to.outerRadius
          effect.innerRadius = to.innerRadius
        return effect
    end
}
--
M.filterTable["filter.wobble"] = {
    set = function(effect, value)
      if value then
          effect.amplitude = value.amplitude
      else
          effect.amplitude = from.amplitude
       end
    end,
    get = function()
          local effect = {}
          effect.amplitude = to.amplitude
        return effect
    end
}
--
M.filterTable["filter.woodCut"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
          effect.intensity = from.intensity
       end
    end,
    get = function()
          local effect = {}
          effect.intensity = to.intensity
        return effect
    end
}
--
M.filterTable["filter.zoomBlur"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
          effect.u = value.u
          effect.v = value.v
      else
          effect.intensity = from.intensity}}
          effect.u = from.u
          effect.v = from.v

       end
    end,
    get = function()
          local effect = {}
          effect.intensity = to.intensity
          effect.u = to.u
          effect.v = to.v
        return effect
    end
}
--
M.filterTable["generator.checkerboard"] = {
    set = function(effect, value)
      if value then
        effect.color1 = value.color1
        effect.color2 = value.color2
        effect.xStep  = value.xStep
        effect.yStep  = value.yStep
      else
        effect.color1 = from.color1
        effect.color2 = from.color2
        effect.xStep  = from.xStep
        effect.yStep  = from.yStep
       end
    end,
    get = function()
          local effect = {}
        effect.color1 = to.color1
        effect.color2 = to.color2
        effect.xStep  = to.xStep
        effect.yStep  = to.yStep
        return effect
    end
}
--
M.filterTable["generator.lenticularHalo"] = {
    set = function(effect, value)
      if value then
        effect.seed  = value.seed
        effect.aspectRatio  = value.aspectRatio
        effect.posY  = value.posY
        effect.posX  = value.posX
      else
        effect.seed  = from.seed
        effect.aspectRatio  = from.aspectRatio
        effect.posY  = from.posY
        effect.posX  = from.posX
       end
    end,
    get = function()
          local effect = {}
        effect.seed  = to.seed
        effect.aspectRatio  = to.aspectRatio
        effect.posY  = to.posY
        effect.posX  = to.posX
        return effect
    end
}
--
M.filterTable["generator.linearGradient"] = {
    set = function(effect, value)
      if value then
        effect.color1 = value.color1
        effect.color2 = value.color2
        effect.position1 = value.position1
        effect.position2 = value.position2
      else
        effect.color1 = from.color1
        effect.color2 = from.color2
        effect.position1 = from.poistion1
        effect.position2 = from.position2
       end
    end,
    get = function()
          local effect = {}
        effect.color1 = to.color1
        effect.color2 = to.color2
        effect.position1 = to.position1
        effect.position2 = to.position2
        return effect
    end
}
--
M.filterTable["generator.marchingAnts"] = {
    set = function(effect, value)
    end,
    get = function()
        local effect = {}
        return effect
    end
}
--
M.filterTable["generator.perlinNoise"] = {
    set = function(effect, value)
      if value then
        effect.color1 = value.color1
        effect.color2 = value.color2
        effect.scale  = value.scale
      else
        effect.color1 = from.color1
        effect.color2 = from.color2
        effect.scale  = from.scale
       end
    end,
    get = function()
          local effect = {}
        effect.color1 = to.color1
        effect.color2 = to.color2
        effect.scale  = to.scale
        return effect
    end
}
--
M.filterTable["generator.radialGradient"] = {
    set = function(effect, value)
      if value then
        effect.color1 = value.color1
        effect.color2 = value.color2
        effect.center_and_radiuses = value.center_and_radiuses
        effect.aspectRatio = value.aspectRatio
      else
        effect.color1 = from.color1
        effect.color2 = from.color2
        effect.center_and_radiuses = from.center_and_radiuses
        effect.aspectRatio = from.aspectRatio
       end
    end,
    get = function()
          local effect = {}
          effect.color1 = to.color1
          effect.color2 = to.color2
          effect.center_and_radiuses = to.center_and_radiuses
          effect.aspectRatio = to.aspectRatio
          return effect
    end
}
--
M.filterTable["generator.random"] = {
    set = function(effect, value)
    end,
    get = function()
        local effect = {}
        return effect
    end
}
--
M.filterTable["generator.stripes"] = {
    set = function(effect, value)
      if value then
        effect.periods = value.periods
        effect.angle = value.angle
        effect.translation = value.translation
      else
        effect.periods = from.periods
        effect.angle = from.angle
        effect.translation = from.translation
       end
    end,
    get = function()
          local effect = {}
          effect.periods = to.periods
          effect.angle = to.angle
          effect.translation = to.translation
          return effect
    end
}
--
M.filterTable["generator.sunbeams"] = {
    set = function(effect, value)
      if value then
        effect.seed = value.seed
        effect.aspectRatio = value.aspectRatio
        effect.posY = value.posY
        effect.posX = value.posX

      else
        effect.seed = from.seed
        effect.aspectRatio =from.aspectRatio
        effect.posY =from.posY
        effect.posX =from.posX
       end
    end,
    get = function()
          local effect = {}
          effect.seed = to.seed
          effect.aspectRatio =to.aspectRatio
          effect.posY =to.posY
          effect.posX =to.posX
          return effect
    end
}
--
M.filterTable["composite.add"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.average"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.colorBurn"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.colorDodge"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.darken"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.difference"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.exclusion"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.glow"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.hardLight"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.hardMix"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.lighten"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.linearLight"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.multiply"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.negation"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.normalMapWith1DirLight"] = {
    set = function(effect, value)
      if value then
          effect.dirLightDirection = value.dirLightDirection
          effect.dirLightColor = value.dirLightColor
          effect.ambientLightIntensity = value.ambientLightIntensity
        else
          effect.dirLightDirection = from.dirLightDirection
          effect.dirLightColor = from.dirLightColor
          effect.ambientLightIntensity = from.ambientLightIntensity
       end
    end,
    get = function()
        local effect = {}
        effect.dirLightDirection = to.dirLightDirection
        effect.dirLightColor = to.dirLightColor
        effect.ambientLightIntensity = to.ambientLightIntensity
      return effect
    end
}
--
M.filterTable["composite.normalMapWith1PointLight"] = {
    set = function(effect, value)
      if value then
          effect.pointLightPos = value.pointLightPos
          effect.pointLightColor = value.pointLightColor
          effect.ambientLightIntensity = value.ambientLightIntensity
          effect.attenuationFactors = value.attenuationFactors

      else
          effect.pointLightPos = from.pointLightPos
          effect.pointLightColor = from.pointLightColor
          effect.ambientLightIntensity = from.ambientLightIntensity
          effect.attenuationFactors = from.attenuationFactors
       end
    end,
    get = function(param)
        local effect = {}
        effect.pointLightPos = to.pointLightPos
        effect.pointLightColor = to.pointLightColor
        effect.ambientLightIntensity = to.ambientLightIntensity
        effect.attenuationFactors = to.attenuationFactors
      return effect
    end
}
--
M.filterTable["composite.overlay"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.phoenix"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.pinLight"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.screen"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.softLight"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.subtract"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}
--
M.filterTable["composite.vividLight"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}

M.filterTable["composite.reflect"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
          effect.alpha    = from.alpha
       end
    end,
    get = function()
          local effect = {}
          effect.alpha    = to.alpha
        return effect
    end
}

return M

