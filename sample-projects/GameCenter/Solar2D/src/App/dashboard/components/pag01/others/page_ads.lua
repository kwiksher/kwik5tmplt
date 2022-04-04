-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local ads = require "ads"
---------------------
{{#ultimate}}
local adX, adY = _K.ultimatePosition({{adX}}, {{adY}})
{{/ultimate}}
{{^ultimate}}
local adX, adY = {{adX}}, {{adY}}
{{/ultimate}}

function _M:didShow()
  {{#addShow}}
    -- Monetization with Ads
    ads.show("banner", { x=adX, y=adY } )
  {{/addShow}}
  {{^addShow}}
    -- Monetization with Ads
    ads.hide()
  {{/addShow}}
end

return _M