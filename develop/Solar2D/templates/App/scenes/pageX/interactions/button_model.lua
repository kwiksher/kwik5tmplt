-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}

local model = {}

---------------------------
-- common
---------------------------
model.name  = "{{myLName}}"
model.state = "{{state}}"


{{#isTmplt}}
model.isTmplt = true
{{/isTmplt}}

{{#kwk}}
model.image = "{{bn}}.{{fExt}}"
model.commonAsset = true
{{/kwk}}
{{^kwk}}
model.image = "/{{bn}}.{{fExt}}"
{{/kwk}}

model.width = {{elW}}/4
model.height = {{elH}}/4
model.x, model.y = _K.ultimatePosition({{mX}}, {{mY}}, "{{align}}")

{{#randX}}
model.randXStart = _K.ultimatePosition({{randXStart}})
model.randXEnd = _K.ultimatePosition({{randXEnd}})
{{/randX}}

{{#randY}}
local dummy, model.randYStart = _K.ultimatePosition(0, {{randYStart}})
local dummy, model.randYEnd     = _K.ultimatePosition(0, {{randYEnd}})
{{/randY}}

{{#scaleW}}
model.scaleW = {{scaleW}}
{{/scaleW}}

{{#scaleH}}
model.scaleH = {{scaleH}}
{{/scaleH}}

{{#rotate}}
model.rotate =  {{rotate}}
{{/rotate}}

model.alpha = {{oriAlpha}}
model.blend = "{{bmode}}"

------------------------------------------
--
------------------------------------------
model.type  = "{{layerType}}"
model.trigger  "{{triggerName}}"

{{#buyProductHide}}
model.buyProductHide = true
model.product       = "{{inApp}}"
{{/buyProductHide}}


{{#mask}}
model.mask = "p{{docNum}}/".. "{{bn}}".. "_mask.jpg"
{{/mask}}

{{#Press}}
model.over = "{{bOver}}.{{rExt}}"
{{/Press}}
{{^Press}}
model.btaps = {{tabButFunction.btaps}}
{{/Press}}

{{#TV}}
model.TV  true
{{/TV}}


return _M