-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}

model.name = {{gtName}}

model.layer = {{gtLayer}}

{{#aplay}}
model.play = true
{{/aplay}}

model.type = "dissolve" -- "linear" -- pulse, rotation, shake, bounce, blink

model.rotation = {{rotation}}
model.xScale = {{scalW}}
model.yScale = {{scalH}}

{{#groupAndPage}}
model.groupAndPage = true
{{/groupAndPage}}


model.referencePoint = { 
    h = {right = true, center = false, left = false}
	v = {top = true, center = false, bottom = false}
}

{{#randX}}
	model.xRandom  = {width = {{elW}}, xStart = ({{randXStart}}, xEnd = {{randXEnd}} }
{{/randX}}
{{#randY}}
	model.yRandom =  {height = {{elH}}, yStart = {{randYStart}},  yEnd = {{randYEnd}} }
{{/randY}}

{{#DefaultReference}}
model.defaultReferencePoint = true
{{/DefaultReference}}

{{#TextReference}}
model.xText = {{nX}} - {{elX}} 
model.yText = {{nY}} - {{elY}}
{{/TextReference}}

--
{{#gtBread}}
model.widthBread = {{gtbw}}/4
model.heigthBread = {{gtbh}}/4
{{/gtBread}}

{{#gtRestart}}
model.restart = {{gtRestart}}
{{/gtRestart}}

{{#isComic}}
model.isComic = true
{{/isComic}}

model.complete = {{gtComplete}}

{{#getTypeShake}}
model.getTypeShake  true
{{/getTypeShake}}

{{#tabSS}}
model.pauseCurrentFrameOne = true
{{/tabSS}}

{{#tabMC}}
model.stopAtFrameOne = true
{{/tabMC}}

{{#gtAction}}
model.action = "{{gtAction}}"
{{/gtAction}}

{{#gtAudio}}
model.audio = {
	name = {{gtAudio}},
	volume = {{avol}},
	channel = {{achannel}},
	repeat = true,
	loops = {{aloop}}{{tofade}}
}
{{/getAudio}}



{{#endX}}
model.xEnd = {{endX}}
model.yEnd = {{endY}}
{{/endX}}

model.isSceneGroup = {{isSceneGroup}}

{{#gtTypePath}}
model.type = "path"
{{/gtTypePath}}

{{#Linear}}
model.type = "linear" -- pulse, rotation, shake, bounce, blink
{{/Linear}}

model.rotation = {{rotation}}
model.xScale   = {{scalW}}
model.yScale   = {{scalH}}
model.alpha    = {{gtEndAlpha}}

model.ease = "{{getEase}}"
model.repeatCount = {{gtLoop}}

model.reflect = {{gtReverse}}{{gtSwipes}}
model.delay={{gtDelay}}

{{#gtBread}}
	model.breadShape = "{{gtbshape}}"
	{{#gtbcolor}}
	model.breadColor = {{gtbcolor}}
	{{/gtbcolor}}
	{{^gtbcolor}}
	model.breadColor = "rand"
	{{/gtbcolor}}
	model.breadInterval = {{gtbinter}}
	{{#gtbdispose}}
	model.breadTimer = {{gtbsec}}
	{{/gtbdispose}}
{{/gtBread}}

{{#gtTypePath}}
	model.duration = {{gtDur}}
	model.path = {{pathCurve}}
	model.angle = {{gtAngle}}
	{{#gtNewAngle}}
	model.newAngle = {{gtNewAngle}}
	{{/gtNewAngle}}
{{/gtTypePath}}


