-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local physics = require("physics")
--
function _M:localVars()
end
--
function _M:localPos()
end
--
{{#ultimate}}
    {{#piston}}
    local bX, bY   = _K.ultimatePosition({{bX}}, {{bY}})
    local aXd, aYd = _K.ultimatePosition({{aXd}}, {{aYd}})
    {{/piston}}
    {{#distance}}
    local bX, bY   = _K.ultimatePosition({{bX}}, {{bY}})
    local bcX, bcY = _K.ultimatePosition({{bcX}}, {{bcY}})
    {{/distance}}
    {{#pulley}}
    local aXd, aYd = _K.ultimatePosition({{aXd}}, {{aYd}})
    local bXd, bYd = _K.ultimatePosition({{bXd}}, {{bYd}})
    local bX, bY   = _K.ultimatePosition({{bX}}, {{bY}})
    local bcX, bcY ={{bcX}}, {{bcY}}
    {{/pulley}}
    {{#default}}
    local bX, bY = _K.ultimatePosition({{bX}}, {{bY}})
    {{/default}}
    {{#rotationx}}
    local rotX, rotY =_K.ultimatePosition( {{rotationx}}, {{rotationy}})
    {{/rotationx}}
{{/ultimate}}
{{^ultimate}}
    {{#piston}}
    local bX, bY   = {{bX}}, {{bY}}
    local aXd, aYd = {{aXd}}, {{aYd}}
    {{/piston}}
    {{#distance}}
    local bX, bY   = {{bX}}, {{bY}}
    local bcX, bcY = {{bcX}}, {{bcY}}
    {{/distance}}
    {{#pulley}}
    local aXd, aYd = {{aXd}}, {{aYd}}
    local bXd, bYd = {{bXd}}, {{bYd}}
    local bX, bY   = {{bX}}, {{bY}}
    local bcX, bcY ={{bcX}}, {{bcY}}
    {{/pulley}}
    {{#default}}
    local bX, bY = {{bX}}, {{bY}}
    {{/default}}
    {{#rotationx}}
    local rotX, rotY = {{rotationx}}, {{rotationy}}
    {{/rotationx}}
{{/ultimate}}
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if layer.{{bname}} == nil then return end

    {{#piston}}
      local {{bgroup}} = physics.newJoint("{{btype}}", layer.{{bconn}}, layer.{{bname}}, bX, bY, aXd, aYd)
    {{/piston}}
    {{#distance}}
      local {{bgroup}} = physics.newJoint("{{btype}}", layer.{{bconn}}, layer.{{bname}}, bX, bY, bcX, bcY)
    {{/distance}}
    {{#pulley}}
      local {{bgroup}} = physics.newJoint("{{btype}}", layer.{{bconn}}, layer.{{bname}}, aXd, aYd, bXd, bYd, bX, bY, bcX, bcY, {{ratio}})
    {{/pulley}}
    {{#default}}
      local {{bgroup}} = physics.newJoint("{{btype}}", layer.{{bconn}}, layer.{{bname}}, bX, bY)
    {{/default}}
    {{#menabled}}
        {{bgroup}}.isMotorEnabled = {{menabled}}
    {{/menabled}}
    {{#mspeed}}
        {{bgroup}}.motorSpeed = {{mspeed}}
    {{/mspeed}}
    {{#mforce}}
        {{bgroup}}.motorForce = {{mforce}}
    {{/mforce}}
    {{#mtorque}}
        {{bgroup}}.maxMotorTorque = {{mtorque}}
    {{/mtorque}}
    {{#rotationx}}
        {{bgroup}}.isLimitEnabled = true
        {{bgroup}}:setRotationLimits(rotX, rotY)
    {{/rotationx}}
end
--
function _M:toDispose()
end
--
function _M:localVars()
end
--
return _M