local name = ...
local parent,root = newModule(name)

local layerProps = require(parent.."{{layer}}").properties

local M = {
  name="{{name}}",
  --
  properties = {
    {{#properties}}
    target = "{{layer}}",
    type  = "{{type}}",
    isActive = "{{isActive}}",
    {{/properties}}
  },
  --
  actions={},
  --
  layerProps = layerProps
}

if M.properties.area == "paragraph" then
  M.properties.widthGroupMember  = {{ggwid}}/4
end

if M.properties.area == "object" then
  M.properties.widthGroupMember = {{ggwid}}/4
end

if M.properties.area == "page" then
  M.properties.gww, M.properties.gwh   = {{gww}}/4, {{gwh}}/4
  M.properties.gwsw, M.properties.gwsh = {{gwsw}}/4, {{gwsh}}/4
end

if M.properties.area == "manual" then
  -- if M.properties.is1x then
  --   local gmt, gml   = {{gmt}}, {{gml}}
  --   local gww, gwh   = {{gww}}, {{gwh}}
  --   local gwsw, gwsh = {{gwsw}}, {{gwsh}}
  -- else
    M.properties.gmt, M.properties.gml   = {{gmt}}, {{gml}}
    M.properties.gww, M.properties.gwh   = {{gww}}/4, {{gwh}}/4
    M.properties.gwsw,M.properties.gwsh = {{gwsw}}/4, {{gwsh}}/4
  -- end
end

function M:create(UI)
  --
  self:setScroll(self.obj)
end

function M:didShow(UI)
end

function M:didHide(UI)
end

return require("components.kwik.layer_scroll").set(M)