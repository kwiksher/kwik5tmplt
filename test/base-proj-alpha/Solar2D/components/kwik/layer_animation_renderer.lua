-- Code created by Kwik - Copyright: kwiksher.com Props.year
-- Version: Props.vers
-- Project: Props.ProjName
--
--
local app = require "Application"
local _M = require("components.kwik.layer_animation").new()
---
--
_M.ultimate = parseValue(Props.ultimate)
_M.isComic  = parseValue(Props.isComic)
---------------------------
_M.layerName = Props.gtName
_M.layerWidth = Props.elW
_M.layerHeight = Props.elH
_M.randXStart = parseValue(Props.randXStart)
_M.randXEnd   = parseValue(Props.randXEnd)
_M.randYStart = parseValue(Props.randYStart)
_M.randYEnd   = parseValue(Props.randYEnd)
_M.nX         = Props.nX
_M.nY         = Props.nY
_M.layerX     = Props.elX
_M.layerY     = Props.elY
--
function _M:getLayer(UI)
	local layer = UI.layer
	return Props.gtLayer
end
--
function _M:getDssolvedLayer(UI)
	local layer = UI.layer
	return layer.Props.gtDissolve
end
--
_M.restart = parseValue(Props.gtRestart)
--
_M.actionName = Props.gtAction
--
_M.animationEndX     = parseValue(Props.endX)
_M.animationEndY     = parseValue(Props.endY)
_M.animationEndAlpha = parseValue(Props.gtEndAlpha)
_M.animationDuration = parseValue(Props.gtDur)
_M.animationScaleY   = parseValue(Props.scalH)
_M.animationScaleX   = parseValue(Props.scalW)
_M.animationRotation = parseValue(Props.rotation)
_M.animationEasing   = parseValue(Props.gtEase)
_M.animationReverse  = parseValue(Props.gtReverse)
_M.animationSwipeX   = parseValue(Props.gtSwipeX)
_M.animationSwipeY   = parseValue(Props.gtSwipeY)
_M.animationDelay    = parseValue(Props.gtDelay)
_M.animationLoop     = parseValue(Props.gtLoop)
_M.animationNewAngle = parseValue(Props.gtNewAngle)
--
_M.isSceneGroup = parseValue(Props.isSceneGroup)
--
_M.audioVolume  = parseValue(Props.avol)
_N.audioChannel = parseValue(Props.achannel)
_M.audioName    = Props.gtAudio
_M.audioLoop    = parseValue(Props.aloop)
_M.audioFadeIn  = parseValue(Props.tofade)
_M.allowRepeat  = parseValue(Props.allowRepeat)
--
_M.breadcrumb = parseValue(Props.gtBread)
if _M.breadcrumb then
	_M.breadcrumbDispose = parseValue(Props.gtbdispose)
	_M.breadShape      = Props.gtbshape
	_M.breadcrumbColor  = parseValue(Props.gtbcolor)
	_M.breadcrumbInterval = parseValue(Props.gtbinter)
	_M.breadcrumbTime     = parseValue(Props.gtbsec)
	if _M.ultimate then
		_M.breadcrumWidth = parseValue(Props.gtbw)/4
		_M.breadcrumHeight = parseValue(Props.gtbh)/4
	else
		_M.breadcrumWidth = parseValue(Props.gtbw)
		_M.breadcrumHeight = parseValue(Props.gtbh)
	end
end
--

_M.referencePoint = parseValue(parseValue(Props.CenterReferencePoint), "CenterReferencePoint")
	or parseValue(parseValue(Props.TopLeftReferencePoint), "TopLeftReferencePoint")
	or parseValue(parseValue(Props.TopCenterReferencePoint), "TopCenterReferencePoint")
	or parseValue(parseValue(Props.TopRightReferencePoint), "TopRightReferencePoint")
	or parseValue(parseValue(Props.CenterLeftReferencePoint), "CenterLeftReferencePoint")
	or parseValue(parseValue(Props.CenterLeftReferencePoint), "CenterRightReferencePoint")
	or parseValue(parseValue(Props.BottomLeftReferencePoint), "BottomLeftReferencePoint")
	or parseValue(parseValue(Props.BottomRightReferencePoint), "BottomLeftReferencePoint")
	or parseValue(parseValue(Props.BottomCenterReferencePoint), "BottomRightReferencePoint")

_M.defaultReference = parseValue(Props.DefaultReference)
_M.textReference  = parseValue(Props.TextReference)

_M.animationType = parseValue(parseValue(Props.gtDissolve), "Dissolve")
	or parseValue(parseValue(Props.gtTypePath), "Path")
    or "Default"

_M.animationSubType = parseValue(parseValue(Props.Linear), "Linear")
	or parseValue(parseValue(Props.Pulse), "Pulse")
	or parseValue(parseValue(Props.Rotation), "Rotation")
	or parseValue(parseValue(Props.Shake), "Shake")
	or parseValue(parseValue(Props.Bounce), "Bounce")
	or parseValue(parseValue(Props.Blink), "Blink")

_M.audioPlay     = parseValue(Props.aplay)
_M.isTypeShape   = parseValue(Props.getTypeShake)
_M.isSpritesheet = parseValue(Props.tabSS)
_M.isMovieClip   = parseValue(Props.tabMC)

if _M.animationType == "Path" then
	_M.pathAnimation = {
		Props.pathCurve, angle = Props.gtAngle
	}
end

_M.positionFuncName = parseValue(parseValue(Props.groupAndPage), "grpupAndPage") or "default"

---------------------------
--
function _M:localVars()
end
--
function _M:localPos()
end
--
function _M:didShow(UI)
	-- UI.scene:dispatchEvent({name="Props.myLName_Props.layerType_Props.triggerName", phase = "didShow", UI=UI})	}
	self:repoHeader(UI)
	self:buildAnim(UI)
	if self.audioPlay then
		if self.animationType == "Dissolve" then
			app.trans[self.layerName]:play()
		else
			--	if app.gt[self.layerName] then
			--		app.gt[self.layerName]:play()
			--	end
		end
	end
end
--
function _M:toDispose()
	app.cancelAllTweens()
	app.cancelAllTransitions()
end
--
function _M:toDestory()
end
---
function _M:play(UI)
	if self.animationType =="Dissolve" then
		app.trans[self.layerName]:play()
	else
		-- app.gt[self.layerName]:toBeginning()
		app.gt[self.layerName]:play()
	end
end
--
function _M:resume(UI)
	if self.animationType =="Dissolve" then
		app.trans[self.layerName]:resume()
	else
		app.gt[self.layerName]:play()
	end
end
--
return _M