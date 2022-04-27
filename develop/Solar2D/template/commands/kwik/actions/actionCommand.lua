-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M            = {}
local ActionCommand = {}
--
ActionCommand.Layer      = require("commands.kwik.layerAction")
ActionCommand.Page       = require("commands.kwik.pageAction")
ActionCommand.Action     = require("commands.kwik.actionAction")
ActionCommand.Random     = require("commands.kwik.randomAction")
ActionCommand.App        = require("commands.kwik.appAction")
ActionCommand.Readme        = require("commands.kwik.readmeAction")
ActionCommand.Timer      = require("commands.kwik.timerAction")
ActionCommand.Sprite     = require("commands.kwik.spriteAction")
ActionCommand.Purchase   = require("commands.kwik.purchaseAction")
ActionCommand.Particle   = require("commands.kwik.particleAction")
ActionCommand.Multiplier = require("commands.kwik.multiplierAction")
ActionCommand.Lang       = require("commands.kwik.languageAction")
ActionCommand.Image      = require("commands.kwik.imageAction")
ActionCommand.Countdown  = require("commands.kwik.countdownAction")
ActionCommand.Canvas     = require("commands.kwik.canvasAction")
ActionCommand.Audio      = require("commands.kwik.audioAction")
ActionCommand.Animation  = require("commands.kwik.animationAction")
ActionCommand.Filter     = require("commands.kwik.filterAction")
ActionCommand.Screenshot  = require("commands.kwik.screenshotAction")
ActionCommand.Var         = require("commands.kwik.variableAction")
ActionCommand.Physics     = require("commands.kwik.physicsAction")
ActionCommand.Video     = require("commands.kwik.videoAction")
ActionCommand.Web        = require("commands.kwik.webAction")
ActionCommand.Button        = require("commands.kwik.buttonAction")


--
function ActionCommand:run(params, modName, cmdName)
	local mod = require("commands.page0."..modName)
	mod[cmdName](params)
end
--
return setmetatable( _M, {__index=ActionCommand})
