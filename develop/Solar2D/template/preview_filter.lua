-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
_W = display.contentWidth
_H = display.contentHeight
local transitionfilter = require("transitionfilter")
-- display.newRect(_W/2, _H/2, _W, _H)
--
--[[
id               {{id}}
pageName         {{pageName}}
filterName       {{filterName}}
layer            {{layer}}
page             {{page}}
group            {{group}}
filter           {{effect}}
composite        {{composite}}
--
animation        {{animation}}
duration         {{duration}}
delay            {{delay}}
loop             {{loop}}
iteration        {{iteration}}
iterationNum     {{iterationNum}}
pause            {{pause}}
reverse          {{reverse}}
return           {{return}}
easing           {{easing}}
onCompleteAudio  {{onCompleteAudio}}
onCompleteAction {{onCompleteAction}}
--]]
--
-- filterFrom
--
--
-- filterTo
--
local filterTable = {}
--
--
--
{{if(options.bloom)}}
filterTable["filter.bloom"] = {
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
        {{if(options.filterFrom)}}
        effect.levels.gamma             = {{levels_gamma}}
        effect.levels.black             = {{levels_black}}
        effect.levels.white             = {{levels_white}}
        effect.blur.vertical.blurSize   = {{blur_vertical_blurSize}}
        effect.blur.vertical.sigma      = {{blur_vertical_sigma}}
        effect.blur.horizontal.blurSize = {{blur_horizontal_blurSize}}
        effect.blur.horizontal.sigma    = {{blur_horizontal_sigma}}
        effect.add.alpha                = {{add_alpha}}
        {{/if}}
      end
    end,
    get = function()
        {{if(options.filterTo)}}
        local effect = {}
        effect.levels = {}
        effect.blur  = {vertical={}, horizontal = {}}
        effect.add = {}
        effect.levels.gamma             = {{levels_gamma}}
        effect.levels.black             = {{levels_black}}
        effect.levels.white             = {{levels_white}}
        effect.blur.vertical.blurSize   = {{blur_vertical_blurSize}}
        effect.blur.vertical.sigma      = {{blur_vertical_sigma}}
        effect.blur.horizontal.blurSize = {{blur_horizontal_blurSize}}
        effect.blur.horizontal.sigma    = {{blur_horizontal_sigma}}
        effect.add.alpha                = {{add_alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.blur)}}
filterTable["filter.blur"] = {
    set = function(effect, value)
    end,
    get = function()
        local effect = {}
        return effect
    end
}
{{/if}}
--
{{if(options.blurGaussian)}}
filterTable["filter.blurGaussian"] = {
    set = function(effect, value)
      if value then
          effect.vertical.blurSize   = value.vertical.blurSize
          effect.vertical.sigma      = value.vertical.sigma
          effect.horizontal.blurSize = value.horizontal.blurSize
          effect.horizontal.sigma    = value.horizontal.sigma
      else
        {{if(options.filterFrom)}}
        effect.vertical.blurSize   = {{vertical_blurSize}}
        effect.vertical.sigma      = {{vertical_sigma}}
        effect.horizontal.blurSize = {{horizontal_blurSize}}
        effect.horizontal.sigma    = {{horizontal_sigma}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.vertical = {}
          effect.horizontal = {}
          effect.vertical.blurSize   = {{vertical_blurSize}}
          effect.vertical.sigma      = {{vertical_sigma}}
          effect.horizontal.blurSize = {{horizontal_blurSize}}
          effect.horizontal.sigma    = {{horizontal_sigma}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.blurHorizontal)}}
filterTable["filter.blurHorizontal"] = {
    set = function(effect, value)
      if value then
          effect.blurSize   = value.blurSize
          effect.sigma      = value.sigma
      else
        {{if(options.filterFrom)}}
        effect.blurSize   = {{blurSize}}
        effect.sigma      = {{sigma}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.blurSize   = {{blurSize}}
          effect.sigma      = {{sigma}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
--
{{if(options.blurVertical)}}
filterTable["filter.blurVertical"] = {
    set = function(effect, value)
      if value then
          effect.blurSize   = value.blurSize
          effect.sigma      = value.sigma
      else
        {{if(options.filterFrom)}}
        effect.blurSize   = {{blurSize}}
        effect.sigma      = {{sigma}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.blurSize   = {{blurSize}}
          effect.sigma      = {{sigma}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.brightness)}}
filterTable["filter.brightness"] = {
    set = function(effect, value)
      if value then
          effect.intensity   = value.intensity
      else
        {{if(options.filterFrom)}}
        effect.intensity   = {{intensity}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.intensity   = {{intensity}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.bulge)}}
filterTable["filter.bulge"] = {
    set = function(effect, value)
      if value then
          effect.intensity   = value.intensity
      else
        {{if(options.filterFrom)}}
        effect.intensity   = {{intensity}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.intensity   = {{intensity}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.chromaKey)}}
filterTable["filter.chromaKey"] = {
    set = function(effect, value)
      if value then
          effect.sensitivity = value.sensitivity
          effect.smoothing   = value.smoothing
          effect.color       = value.color
      else
        {{if(options.filterFrom)}}
          effect.sensitivity = {{sensitivity}}
          effect.smoothing   = {{smoothing}}
          effect.color       = {
            {{color_0}},
            {{color_1}},
            {{color_2}}
          }
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.sensitivity = {{sensitivity}}
          effect.smoothing   = {{smoothing}}
          effect.color       = {
            {{color_0}},
            {{color_1}},
            {{color_2}}
          }
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.colorChannelOffset)}}
filterTable["filter.colorChannelOffset"] = {
    set = function(effect, value)
      if value then
          effect.yTexels = value.yTexels
          effect.xTexels = value.xTexels
      else
        {{if(options.filterFrom)}}
          effect.yTexels = {{yTexels}}
          effect.xTexels = {{xTexels}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.yTexels = {{yTexels}}
          effect.xTexels = {{xTexels}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.contrast)}}
filterTable["filter.contrast"] = {
    set = function(effect, value)
      if value then
          effect.contrast = value.contrast
      else
        {{if(options.filterFrom)}}
          effect.contrast = {{contrast}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.contrast = {{contrast}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.crosshatch)}}
filterTable["filter.crosshatch"] = {
    set = function(effect, value)
      if value then
          effect.grain = value.grain
      else
        {{if(options.filterFrom)}}
          effect.grain = {{grain}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.grain = {{grain}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.crystallize)}}
filterTable["filter.crystallize"] = {
    set = function(effect, value)
      if value then
          effect.numTiles = value.numTiles
      else
        {{if(options.filterFrom)}}
          effect.numTiles = {{numTiles}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.numTiles = {{numTiles}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.desaturate)}}
filterTable["filter.desaturate"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
        {{if(options.filterFrom)}}
          effect.intensity = {{intensity}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.intensity = {{intensity}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.dissolve)}}
filterTable["filter.dissolve"] = {
    set = function(effect, value)
      if value then
          effect.threshold = value.threshold
      else
        {{if(options.filterFrom)}}
          effect.threshold = {{threshold}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.threshold = {{threshold}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.duotone)}}
filterTable["filter.duotone"] = {
    set = function(effect, value)
      if value then
        effect.darkColor = value.darkColor
        -- effect.darkColor2 = value.darkColor2
        effect.lightColor = value.lightColor
        -- effect.lightColor2 = value.lightColor2
      else
        {{if(options.filterFrom)}}
        effect.darkColor = {
          {{darkColor_0}},
          {{darkColor_1}},
          {{darkColor_2}},
          {{darkColor_3}}
        }
        -- effect.darkColor2 = {
        --   {{darkColor2_0}},
        --   {{darkColor2_1}},
        --   {{darkColor2_2}},
        --   {{darkColor2_3}}
        -- }
        effect.lightColor = {
          {{lightColor_0}},
          {{lightColor_1}},
          {{lightColor_2}},
          {{lightColor_3}}
        }
        -- effect.lightColor2 = {
        --   {{lightColor2_0}},
        --   {{lightColor2_1}},
        --   {{lightColor2_2}},
        --   {{lightColor2_3}}
        -- }
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
        effect.darkColor = {
          {{darkColor_0}},
          {{darkColor_1}},
          {{darkColor_2}},
          {{darkColor_3}}
        }
        -- effect.darkColor2 = {
        --   {{darkColor2_0}},
        --   {{darkColor2_1}},
        --   {{darkColor2_2}},
        --   {{darkColor2_3}}
        -- }
        effect.lightColor = {
          {{lightColor_0}},
          {{lightColor_1}},
          {{lightColor_2}},
          {{lightColor_3}}
        }
        -- effect.lightColor2 = {
        --   {{lightColor2_0}},
        --   {{lightColor2_1}},
        --   {{lightColor2_2}},
        --   {{lightColor2_3}}
        -- }
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.emboss)}}
filterTable["filter.emboss"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
        {{if(options.filterFrom)}}
          effect.intensity = {{intensity}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.intensity = {{intensity}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.exposure)}}
filterTable["filter.exposure"] = {
    set = function(effect, value)
      if value then
          effect.exposure = value.exposure
      else
        {{if(options.filterFrom)}}
          effect.exposure = {{exposure}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.exposure = {{exposure}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.frostedGlass)}}
filterTable["filter.frostedGlass"] = {
    set = function(effect, value)
      if value then
          effect.scale = value.scale
      else
        {{if(options.filterFrom)}}
          effect.scale = {{scale}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.scale = {{scale}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.grayscale)}}
filterTable["filter.grayscale"] = {
    set = function(effect, value)
    end,
    get = function()
          local effect = {}
        return effect
    end
}
{{/if}}
--
{{if(options.hue)}}
filterTable["filter.hue"] = {
    set = function(effect, value)
      if value then
          effect.angle = value.angle
      else
        {{if(options.filterFrom)}}
          effect.angle = {{angle}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.angle = {{angle}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.invert)}}
filterTable["filter.invert"] = {
    set = function(effect, value)
    end,
    get = function()
          local effect = {}
        return effect
    end
}
{{/if}}
--
{{if(options.iris)}}
filterTable["filter.iris"] = {
    set = function(effect, value)
      if value then
          effect.smoothness = value.smoothness
          effect.aspectRatio = value.aspectRatio
          effect.center_0 = value.center_0
          effect.center_1 = value.center_0
          effect.aperture = value.aperture
      else
        {{if(options.filterFrom)}}
          effect.smoothness = {{smoothness}}
          effect.aspectRatio = {{aspectRatio}}
          effect.center_0 = {{center_0}}
          effect.center_1 = {{center_1}}
          effect.aperture = {{aperture}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.smoothness = {{smoothness}}
          effect.aspectRatio = {{aspectRatio}}
          effect.center_0 = {{center_0}}
          effect.center_1 = {{center_1}}
          effect.aperture = {{aperture}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.levels)}}
filterTable["filter.levels"] = {
    set = function(effect, value)
      if value then
          effect.gamma = value.gamma
          effect.white = value.white
          effect.black = value.black
      else
        {{if(options.filterFrom)}}
          effect.gamma = {{gamma}}
          effect.white = {{white}}
          effect.black = {{black}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.gamma = {{gamma}}
          effect.white = {{white}}
          effect.black = {{black}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.linearWipe)}}
filterTable["filter.linearWipe"] = {
    set = function(effect, value)
      if value then
          effect.progress = value.progress
          effect.smoothness = value.smoothness
          effect.direction_0 = value.direction_0
          effect.direction_1 = value.direction_1
      else
        {{if(options.filterFrom)}}
          effect.progress = {{progress}}
          effect.smoothness = {{smoothness}}
          effect.direction_0 = {{direction_0}}
          effect.direction_1 = {{direction_1}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.progress = {{progress}}
          effect.smoothness = {{smoothness}}
          effect.direction_0 = {{direction_0}}
          effect.direction_1 = {{direction_1}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.median)}}
filterTable["filter.median"] = {
    set = function(effect, value)
    end,
    get = function()
        local effect = {}
        return effect
    end
}
{{/if}}
--
{{if(options.monotone)}}
filterTable["filter.monotone"] = {
    set = function(effect, value)
      if value then
          effect.a = value.a
          effect.b = value.b
          effect.g = value.g
          effect.r = value.r
      else
        {{if(options.filterFrom)}}
          effect.a = {{a}}
          effect.b = {{b}}
          effect.g = {{g}}
          effect.r = {{r}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.a = {{a}}
          effect.b = {{b}}
          effect.g = {{g}}
          effect.r = {{r}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.opTile)}}
filterTable["filter.opTile"] = {
    set = function(effect, value)
      if value then
          effect.scale = value.scale
          effect.angle = value.angle
          effect.numPixels = value.numPixels
      else
        {{if(options.filterFrom)}}
          effect.scale = {{scale}}
          effect.angle = {{angle}}
          effect.numPixels = {{numPixels}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.scale = {{scale}}
          effect.angle = {{angle}}
          effect.numPixels = {{numPixels}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.pixelate)}}
filterTable["filter.pixelate"] = {
    set = function(effect, value)
      if value then
          effect.numPixels = value.numPixels
      else
        {{if(options.filterFrom)}}
          effect.numPixels = {{numPixels}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.numPixels = {{numPixels}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.polkaDots)}}
filterTable["filter.polkaDots"] = {
    set = function(effect, value)
      if value then
          effect.aspectRatio = value.aspectRatio
          effect.dotRadius = value.dotRadius
          effect.numPixels = value.numPixels
      else
        {{if(options.filterFrom)}}
          effect.aspectRatio = {{aspectRatio}}
          effect.dotRadius = {{dotRadius}}
          effect.numPixels = {{numPixels}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.aspectRatio = {{aspectRatio}}
          effect.dotRadius = {{dotRadius}}
          effect.numPixels = {{numPixels}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.posterize)}}
filterTable["filter.posterize"] = {
    set = function(effect, value)
      if value then
          effect.colorsPerChannel = value.colorsPerChannel
      else
        {{if(options.filterFrom)}}
          effect.colorsPerChannel = {{colorsPerChannel}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.colorsPerChannel = {{colorsPerChannel}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.radialWipe)}}
filterTable["filter.radialWipe"] = {
    set = function(effect, value)
      if value then
          effect.smoothness = value.smoothness
          effect.progress = value.progress
          effect.center_0 = value.center_0
          effect.center_1 = value.center_0
          effect.axisOrientation = value.axisOrientation
      else
        {{if(options.filterFrom)}}
          effect.smoothness = {{smoothness}}
          effect.progress = {{progress}}
          effect.center_0 = {{center_0}}
          effect.center_1 = {{center_1}}
          effect.axisOrientation = {{axisOrientation}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.smoothness = {{smoothness}}
          effect.progress = {{progress}}
          effect.center_0 = {{center_0}}
          effect.center_1 = {{center_1}}
          effect.axisOrientation = {{axisOrientation}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.saturate)}}
filterTable["filter.saturate"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
        {{if(options.filterFrom)}}
          effect.intensity = {{intensity}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.intensity = {{intensity}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.scatter)}}
filterTable["filter.scatter"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
        {{if(options.filterFrom)}}
          effect.intensity = {{intensity}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.intensity = {{intensity}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.sepia)}}
filterTable["filter.sepia"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
        {{if(options.filterFrom)}}
          effect.intensity = {{intensity}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.intensity = {{intensity}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.sharpenLuminance)}}
filterTable["filter.sharpenLuminance"] = {
    set = function(effect, value)
      if value then
          effect.sharpness = value.sharpness
      else
        {{if(options.filterFrom)}}
          effect.sharpness = {{sharpness}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.sharpness = {{sharpness}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.sobel)}}
filterTable["filter.sobel"] = {
    set = function(effect, value)
      if value then
      else
        {{if(options.filterFrom)}}
         {{/if}}
       end
    end,
    get = function()
        local effect = {}
        return effect
    end
}
{{/if}}
--
{{if(options.straighten)}}
filterTable["filter.straighten"] = {
    set = function(effect, value)
      if value then
          effect.height = value.height
          effect.angle = value.angle
          effect.width = value.width
      else
        {{if(options.filterFrom)}}
          effect.height = {{height}}
          effect.angle = {{angle}}
          effect.width = {{width}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.height = {{height}}
          effect.angle = {{angle}}
          effect.width = {{width}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.swirl)}}
filterTable["filter.swirl"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
        {{if(options.filterFrom)}}
          effect.intensity = {{intensity}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.intensity = {{intensity}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.vignette)}}
filterTable["filter.vignette"] = {
    set = function(effect, value)
      if value then
          effect.radius = value.radius
      else
        {{if(options.filterFrom)}}
          effect.radius = {{radius}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.radius = {{radius}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.vignetteMask)}}
filterTable["filter.vignetteMask"] = {
    set = function(effect, value)
      if value then
          effect.outerRadius = value.outerRadius
          effect.innerRadius = value.innerRadius
      else
        {{if(options.filterFrom)}}
          effect.outerRadius = {{outerRadius}}
          effect.innerRadius = {{innerRadius}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.outerRadius = {{outerRadius}}
          effect.innerRadius = {{innerRadius}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.wobble)}}
filterTable["filter.wobble"] = {
    set = function(effect, value)
      if value then
          effect.amplitude = value.amplitude
      else
        {{if(options.filterFrom)}}
          effect.amplitude = {{amplitude}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.amplitude = {{amplitude}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.woodCut)}}
filterTable["filter.woodCut"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
      else
        {{if(options.filterFrom)}}
          effect.intensity = {{intensity}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.intensity = {{intensity}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.zoomBlur)}}
filterTable["filter.zoomBlur"] = {
    set = function(effect, value)
      if value then
          effect.intensity = value.intensity
          effect.u = value.u
          effect.v = value.v
      else
        {{if(options.filterFrom)}}
          effect.intensity = {{intensity}}
          effect.u = {{u}}
          effect.v = {{v}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.intensity = {{intensity}}
          effect.u = {{u}}
          effect.v = {{v}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.checkerboard)}}
filterTable["generator.checkerboard"] = {
    set = function(effect, value)
      if value then
        effect.color1 = value.color1
        effect.color2 = value.color2
        effect.xStep  = value.xStep
        effect.yStep  = value.yStep
      else
        {{if(options.filterFrom)}}
        effect.color1 = {
          {{color1_0}},
          {{color1_1}},
          {{color1_2}},
          {{color1_3}}
        }
        effect.color2 = {
          {{color2_0}},
          {{color2_1}},
          {{color2_2}},
          {{color2_3}}
        }
        effect.xStep  = {{xStep}}
        effect.yStep  = {{yStep}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
        effect.color1 = {
          {{color1_0}},
          {{color1_1}},
          {{color1_2}},
          {{color1_3}}
        }
        effect.color2 = {
          {{color2_0}},
          {{color2_1}},
          {{color2_2}},
          {{color2_3}}
        }
        effect.xStep  = {{xStep}}
        effect.yStep  = {{yStep}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.lenticularHalo)}}
filterTable["generator.lenticularHalo"] = {
    set = function(effect, value)
      if value then
        effect.seed  = value.seed
        effect.aspectRatio  = value.aspectRatio
        effect.posY  = value.posY
        effect.posX  = value.posX
      else
        {{if(options.filterFrom)}}
        effect.seed  = {{seed}}
        effect.aspectRatio  = {{aspectRatio}}
        effect.posY  = {{posY}}
        effect.posX  = {{posX}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
        effect.seed  = {{seed}}
        effect.aspectRatio  = {{aspectRatio}}
        effect.posY  = {{posY}}
        effect.posX  = {{posX}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.linearGradient)}}
filterTable["generator.linearGradient"] = {
    set = function(effect, value)
      if value then
        effect.color1 = value.color1
        effect.color2 = value.color2
        effect.position1 = value.position1
        effect.position2 = value.position2
      else
        {{if(options.filterFrom)}}
        effect.color1 = {
          {{color1_0}},
          {{color1_1}},
          {{color1_2}},
          {{color1_3}}
        }
        effect.color2 = {
          {{color2_0}},
          {{color2_1}},
          {{color2_2}},
          {{color2_3}}
        }
        effect.position1 = {
          {{position1_0}},
          {{position1_1}},
        }
        effect.position2 = {
          {{position2_0}},
          {{position2_1}},
        }
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
        effect.color1 = {
          {{color1_0}},
          {{color1_1}},
          {{color1_2}},
          {{color1_3}}
        }
        effect.color2 = {
          {{color2_0}},
          {{color2_1}},
          {{color2_2}},
          {{color2_3}}
        }
        effect.position1 = {
          {{position1_0}},
          {{position1_1}},
        }
        effect.position2 = {
          {{position2_0}},
          {{position2_1}},
        }
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.marchingAnts)}}
filterTable["generator.marchingAnts"] = {
    set = function(effect, value)
    end,
    get = function()
        local effect = {}
        return effect
    end
}
{{/if}}
--
{{if(options.perlinNoise)}}
filterTable["generator.perlinNoise"] = {
    set = function(effect, value)
      if value then
        effect.color1 = value.color1
        effect.color2 = value.color2
        effect.scale  = value.scale
      else
        {{if(options.filterFrom)}}
        effect.color1 = {
          {{color1_0}},
          {{color1_1}},
          {{color1_2}},
          {{color1_3}}
        }
        effect.color2 = {
          {{color2_0}},
          {{color2_1}},
          {{color2_2}},
          {{color2_3}}
        }
        effect.scale  = {{scale}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
        effect.color1 = {
          {{color1_0}},
          {{color1_1}},
          {{color1_2}},
          {{color1_3}}
        }
        effect.color2 = {
          {{color2_0}},
          {{color2_1}},
          {{color2_2}},
          {{color2_3}}
        }
        effect.scale  = {{scale}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.radialGradient)}}
filterTable["generator.radialGradient"] = {
    set = function(effect, value)
      if value then
        effect.color1 = value.color1
        effect.color2 = value.color2
        effect.center_and_radiuses = value.center_and_radiuses
        effect.aspectRatio = value.aspectRatio
      else
        {{if(options.filterFrom)}}
        effect.color1 = {
          {{color1_0}},
          {{color1_1}},
          {{color1_2}},
          {{color1_3}}
        }
        effect.color2 = {
          {{color2_0}},
          {{color2_1}},
          {{color2_2}},
          {{color2_3}}
        }
        effect.center_and_radiuses = {
          {{center_and_radiuses_0}},
          {{center_and_radiuses_1}},
          {{center_and_radiuses_2}},
          {{center_and_radiuses_3}}
        }
        effect.aspectRatio ={{aspectRatio}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
        effect.color1 = {
          {{color1_0}},
          {{color1_1}},
          {{color1_2}},
          {{color1_3}}
        }
        effect.color2 = {
          {{color2_0}},
          {{color2_1}},
          {{color2_2}},
          {{color2_3}}
        }
        effect.center_and_radiuses = {
          {{center_and_radiuses_0}},
          {{center_and_radiuses_1}},
          {{center_and_radiuses_2}},
          {{center_and_radiuses_3}}
        }
        effect.aspectRatio = {{aspectRatio}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.random)}}
filterTable["generator.random"] = {
    set = function(effect, value)
    end,
    get = function()
        local effect = {}
        return effect
    end
}
{{/if}}
--
{{if(options.stripes)}}
filterTable["generator.stripes"] = {
    set = function(effect, value)
      if value then
        effect.periods = value.periods
        effect.angle = value.angle
        effect.translation = value.translation
      else
        {{if(options.filterFrom)}}
        effect.periods = {
          {{periods_0}},
          {{periods_1}},
          {{periods_2}},
          {{periods_3}}
        }
        effect.angle ={{angle}}
        effect.translation ={{translation}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
        effect.periods = {
          {{periods_0}},
          {{periods_1}},
          {{periods_2}},
          {{periods_3}}
        }
        effect.angle = {{angle}}
        effect.translation = {{translation}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.sunbeams)}}
filterTable["generator.sunbeams"] = {
    set = function(effect, value)
      if value then
        effect.seed = value.seed
        effect.aspectRatio = value.aspectRatio
        effect.posY = value.posY
        effect.posX = value.posX

      else
        {{if(options.filterFrom)}}
        effect.seed ={{seed}}
        effect.aspectRatio ={{aspectRatio}}
        effect.posY ={{posY}}
        effect.posX ={{posX}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
        effect.seed = {{seed}}
        effect.aspectRatio = {{aspectRatio}}
        effect.posY = {{posY}}
        effect.posX = {{posX}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.add)}}
filterTable["composite.add"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.average)}}
filterTable["composite.average"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.colorBurn)}}
filterTable["composite.colorBurn"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.colorDodge)}}
filterTable["composite.colorDodge"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.darken)}}
filterTable["composite.darken"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.difference)}}
filterTable["composite.difference"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.exclusion)}}
filterTable["composite.exclusion"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.glow)}}
filterTable["composite.glow"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.hardLight)}}
filterTable["composite.hardLight"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.hardMix)}}
filterTable["composite.hardMix"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.lighten)}}
filterTable["composite.lighten"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.linearLight)}}
filterTable["composite.linearLight"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.multiply)}}
filterTable["composite.multiply"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.negation)}}
filterTable["composite.negation"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.normalMapWith1DirLight)}}
filterTable["composite.normalMapWith1DirLight"] = {
    set = function(effect, value)
      if value then
          effect.dirLightDirection = value.dirLightDirection
          effect.dirLightColor = value.dirLightColor
          effect.ambientLightIntensity = value.ambientLightIntensity
        else
        {{if(options.filterFrom)}}
          effect.dirLightDirection ={
            {{dirLightDirection_0}},
            {{dirLightDirection_1}},
            {{dirLightDirection_2}}
          }
          effect.dirLightColor = {
             {{dirLightColor_0}},
             {{dirLightColor_1}},
             {{dirLightColor_2}},
             {{dirLightColor_3}}
           }
          effect.ambientLightIntensity = {{ambientLightIntensity}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
        local effect = {}
        effect.dirLightDirection=  {}
        effect.dirLightColor    =  {}
        effect.dirLightDirection ={
          {{dirLightDirection_0}},
          {{dirLightDirection_1}},
          {{dirLightDirection_2}}
        }
        effect.dirLightColor = {
           {{dirLightColor_0}},
           {{dirLightColor_1}},
           {{dirLightColor_2}},
           {{dirLightColor_3}}
         }
        effect.ambientLightIntensity = {{ambientLightIntensity}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.normalMapWith1PointLight)}}
filterTable["composite.normalMapWith1PointLight"] = {
    set = function(effect, value)
      if value then
          effect.pointLightPos = value.pointLightPos
          effect.pointLightColor = value.pointLightColor
          effect.ambientLightIntensity = value.ambientLightIntensity
          effect.attenuationFactors = value.attenuationFactors

      else
        {{if(options.filterFrom)}}
          effect.pointLightPos ={
            {{pointLightPos_0}},
            {{pointLightPos_1}},
            {{pointLightPos_2}}
          }
          effect.pointLightColor = {
             {{pointLightColor_0}},
             {{pointLightColor_1}},
             {{pointLightColor_2}},
             {{pointLightColor_3}}
           }
          effect.ambientLightIntensity = {{ambientLightIntensity}}
          effect.attenuationFactors = {
            {{attenuationFactors_0}},
            {{attenuationFactors_1}},
            {{attenuationFactors_2}},
          }
         {{/if}}
       end
    end,
    get = function(param)
        {{if(options.filterTo)}}
        local effect = {}
        effect.pointLightPos      =  {}
        effect.pointLightColor    =  {}
        effect.attenuationFactors = {}
        effect.pointLightPos ={
          {{pointLightPos_0}},
          {{pointLightPos_1}},
          {{pointLightPos_2}}
        }
        effect.pointLightColor = {
           {{pointLightColor_0}},
           {{pointLightColor_1}},
           {{pointLightColor_2}},
           {{pointLightColor_3}}
         }
        effect.ambientLightIntensity = {{ambientLightIntensity}}
        effect.attenuationFactors = {
          {{attenuationFactors_0}},
          {{attenuationFactors_1}},
          {{attenuationFactors_2}},
        }
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.overlay)}}
filterTable["composite.overlay"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.phoenix)}}
filterTable["composite.phoenix"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.pinLight)}}
filterTable["composite.pinLight"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.screen)}}
filterTable["composite.screen"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.softLight)}}
filterTable["composite.softLight"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.subtract)}}
filterTable["composite.subtract"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
{{if(options.vividLight)}}
filterTable["composite.vividLight"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}

{{if(options.reflec)}}
filterTable["composite.reflect"] = {
    set = function(effect, value)
      if value then
          effect.alpha    = value.alpha
      else
        {{if(options.filterFrom)}}
          effect.alpha    = {{alpha}}
         {{/if}}
       end
    end,
    get = function()
        {{if(options.filterTo)}}
          local effect = {}
          effect.alpha    = {{alpha}}
        {{/if}}
        return effect
    end
}
{{/if}}
--
function filters(name, effect)
    if effect then
        filterTable[name].set(effect)
    else
        local param = {}
        {{if(options.animation)}}
        param.time   = {{duration}} * 1000
        param.delay  = {{delay}}
        param.filterTable = filterTable[name]
        -- param.effectTo = filterTable[name].get()
        -- param.effectFrom = {}
        -- filterTable[name].set(param.effectFrom)
        {{/if}}
        return param
    end
end
--
--
local object = display.newImage("{{layer}}.{{paint1fExt}}", _W/2, _H/2)
--
--
{{if(options.compositeLight)}}
  local compositePaint = {
      type="composite",
      paint1={ type="image", filename="{{layer}}.{{paint1fExt}}" },
      paint2={ type="image", filename="{{composite}}.{{paint2fExt}}" }
  }
  object.fill = compositePaint
  object.fill.effect = "{{effect}}"

    filters("{{effect}}", object.fill.effect)
    {{if(options.animation)}}
        transition.kwikFilter(object, filters("{{effect}}") )
    {{/if}}

{{/if}}
{{^compositeLight}}
  {{if(options.composite)}}
    local compositePaint = {
        type="composite",
      paint1={ type="image", filename="{{layer}}.{{paint1fExt}}" },
      paint2={ type="image", filename="{{composite}}.{{paint2fExt}}" }
    }
    object.fill = compositePaint
    object.fill.effect = "{{effect}}"
    filters("{{effect}}", object.fill)
      {{if(options.animation)}}
          local param = filters("{{effect}}")
          transition.to(object, {time = param.time, delay = param.delay, alpha = param.effect.alpha} )
      {{/if}}
  {{/if}}
{{/if}}

--
--

{{if(options.filter)}}
  {{if(options.marchingAnts)}}
    object.strokeWidth = 2
    object.stroke.effect = "{{effect}}"
  {{/if}}
  {{^marchingAnts}}
    object.fill.effect = "{{effect}}"
  {{/if}}
  filters("{{effect}}", object.fill.effect)
  {{if(options.animation)}}
    transition.kwikFilter(object, filters("{{effect}}") )
  {{/if}}
{{/if}}