-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local composer = require("composer")
local _K            = require "Application"
--
function _M:setLanguage(lang, reload)
   _K.lang = lang
   if reload and (composer.reloading == nil or not composer.reloading )then
     composer.reloading = true
     composer.gotoScene("extlib.page_reload")
   else
     composer.reloading = false
   end
end
--
return _M