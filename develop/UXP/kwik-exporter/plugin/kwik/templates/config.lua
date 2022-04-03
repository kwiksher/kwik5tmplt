-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
{{#ultimate}}
local kScale = "{{kk}}"
--calculate the aspect ratio of the device:
local aspectRatio = display.pixelHeight / display.pixelWidth
application = {
   content = {
      width = aspectRatio > 1.5 and 320 or math.ceil( 480 / aspectRatio ),
      height = aspectRatio < 1.5 and 480 or math.ceil( 320 * aspectRatio ),
      scale = kScale,
      fps = 30,
      imageSuffix = {
         ["@2x"] = 1.5,
         ["@4x"] = 3.0,
      },
   },
    {{#expansion}}
   license  =
   {
        google  =
        {
            key  = "{{googleKey}}"
        },
    },
    {{/expansion}}
}
{{/ultimate}}
{{^ultimate}}
local kScale = "{{kk}}"
if ( string.sub( system.getInfo("model"), 1, 4 ) == "iPad" and display.pixelHeight == 1024) then     -- all iPads checking
  application =
  {
    {{#expansion}}
        license  =
        {
          google  =
          {
              key  = "{{googleKey}}"
          },
        },
    {{/expansion}}
    content  =
    {
       width = {{myW}},
       height = {{myH}},
       fps = 60,
       scale = kScale,
       imageSuffix = {
          ["@2x"] = .5,
       }
    },
 }
elseif ( display.pixelHeight > 1024 ) then  -- iPhone 5 (and all other high-res devices) checking - uses the iPad Air Retina image
  application =
  {
    {{#expansion}}
      license  =
      {
        google  =
        {
            key  = "{{googleKey}}"
        },
      },
    {{/expansion}}
    content  =
    {
       width = {{myW}},
       height = {{myH}},
       fps = 60,
       scale = kScale,
    },
 }
else  -- all other devices
  application =
  {
    {{#expansion}}
      license  =
      {
        google  =
        {
          key  = "{{googleKey}}"
        },
      },
    {{/expansion}}
    content  =
    {
       width = {{myW}},
       height = {{myH}},
       fps = 60,
       scale = kScale,
       imageSuffix = {
          ["@2x"] = .4,
       }
    },
  }
end
{{/ultimate}}
