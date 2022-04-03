-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local widget = require("widget")
local _K            = require "Application"
--
function _M:localVars()
end
--
function _M:localPos()
end
--
{{#ultimate}}
  {{#para}}
  local widthGroupMember  = {{ggwid}}/4
  {{/para}}
  {{#page}}
  local gww, gwh   = {{gww}}/4, {{gwh}}/4
  local gwsw, gwsh = {{gwsw}}/4, {{gwsh}}/4
  {{/page}}
  {{#object}}
  local widthGroupMember = {{ggwid}}/4
  {{/object}}
  {{#manual}}
    {{#b1x}}
    local gmt, gml   = {{gmt}}, {{gml}}
    local gww, gwh   = {{gww}}, {{gwh}}
    local gwsw, gwsh = {{gwsw}}, {{gwsh}}
    {{/b1x}}
    {{^b1x}}
    local gmt, gml   = {{gmt}}, {{gml}}
    local gww, gwh   = {{gww}}/4, {{gwh}}/4
    local gwsw, gwsh = {{gwsw}}/4, {{gwsh}}/4
    {{/b1x}}
  {{/manual}}
{{/ultimate}}
{{^ultimate}}
  {{#para}}
  local widthGroupMember  = {{ggwid}}
  {{/para}}
  {{#page}}
  local gww, gwh   = {{gww}}, {{gwh}}
  local gwsw, gwsh = {{gwsw}}, {{gwsh}}
  {{/page}}
  {{#object}}
  local widthGroupMember  = {{ggwid}}
  {{/object}}
  {{#manual}}
  local gmt, gml   = {{gmt}}, {{gml}}
  local gww, gwh   = {{gww}}, {{gwh}}
  local gwsw, gwsh = {{gwsw}}, {{gwsh}}
  {{/manual}}
{{/ultimate}}
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if layer.{{glayer}} == nil then return end
    local _top          = 0
    local _left         = 0
    local _width        = 0
    local _height       = 0
    local _scrollWidth  = 0
    local _scrollHeight = 0
--
  {{^layer}}
   {{#para}}
    _top         = layer.{{glayer}}.contentBounds.yMin
    _left        = layer.{{glayer}}.contentBounds.xMin
    _width       = layer.{{glayer}}.width + 10 - widthGroupMember
    _height      = layer.{{glayer}}.height
    _scrollWidth = layer.{{glayer}}.width
    _scrollHeight = layer.{{glayer}}.height
  {{/para}}
  {{#page}}
    _top          = layer.{{glayer}}.contentBounds.yMin
    _left         = layer.{{glayer}}.contentBounds.xMin
    _width        = gww or 0
    _height       = gwh or 0
    _scrollWidth  = gwsw or 0
    _scrollHeight = gwsh or 0
  {{/page}}
  {{#object}}
    _top          = layer.{{glayer}}.contentBounds.yMin
    _left         = layer.{{glayer}}.contentBounds.xMin
    _width        = layer.{{glayer}}.width + 10- widthGroupMember
    _height       = layer.{{glayer}}.height
    _scrollWidth  = layer.{{glayer}}.width
    _scrollHeight = layer.{{glayer}}.height
  {{/object}}
  {{#manual}}
    _top          = gmt or _top
    _left         = gml or _left
    _width        = gww or _width
    _height       = gwh or _height
    _scrollWidth  = gwsw or _scrollWidth
    _scrollHeight = gwsh or _scrollHeight
  {{/manual}}
--
  _width        = (_width        ==0) and layer.{{glayer}}.width or _width
  _height       = (_height       ==0) and layer.{{glayer}}.height or _height
  _scrollWidth  = (_scrollWidth  ==0) and layer.{{glayer}}.width or _scrollWidth
  _scrollHeight = (_scrollHeight ==0) and layer.{{glayer}}.height or _scrollHeight
--
  layer.{{gname}} = widget.newScrollView( {
    top          = _top,
    left         = _left,
    width        = _width,
    height       = _height,
    scrollWidth  = _scrollWidth,
    scrollHeight = _scrollHeight,
    baseDir      = _K.systemDir,
  {{#gHide}}
     hideScrollBar = true,
  {{/gHide}}
  {{#gHideBack}}
     hideBackground = true,
  {{/gHideBack}}
  {{#gdH}}
     horizontalScrollDisabled = true,
  {{/gdH}}
  {{#gdV}}
     verticalScrollDisabled = true
  {{/gdV}}
  })

  {{#gmask}}
  local mask = graphics.newMask(_K.imgDir.."{{fileName}}" )
  layer.{{gname}}:setMask( mask )
  {{/gmask}}

  sceneGroup:insert( layer.{{gname}})
  layer.{{gname}}:insert(layer.{{glayer}})

  {{^manual}}
    layer.{{glayer}}.x = layer.{{glayer}}.width / 2
    layer.{{glayer}}.y = layer.{{glayer}}.height / 2
  {{/manual}}
  {{#manual}}
    {{#gdH}}
      layer.{{glayer}}.x = layer.{{glayer}}.width / 2
      --layer.{{glayer}}.y = layer.{{glayer}}.height / 2
    {{/gdH}}
    {{#gdV}}
      -- layer.{{glayer}}.x = layer.{{glayer}}.width / 2
      layer.{{glayer}}.y = layer.{{glayer}}.height / 2
  {{/gdV}}
  {{/manual}}
{{/layer}}

{{#layer}}
  {{#para}}
    _top    = layer.{{glayer}}.y
    _left   = layer.{{glayer}}.x
    _width  = layer.{{glayer}}.originalW
    _height = layer.{{glayer}}.originalH
    _scrollWidth  = gwsw
    _scrollHeight = gwsh
  {{/para}}
  {{#page}}
    _top    = layer.{{glayer}}.y
    _left   = layer.{{glayer}}.x
    _width  = layer.{{glayer}}.width + 10
    _height = gwh
    _scrollWidth  = gwsw
    _scrollHeight = gwsh
  {{/page}}
  {{#object}}
    _top    = layer.{{glayer}}.y
    _left   = layer.{{glayer}}.x
    _width  = layer.{{glayer}}.width + 10
    _height = layer.{{glayer}}.height
    _scrollWidth  = gwsw
    _scrollHeight = gwsh
  {{/object}}
  {{#manual}}
    _top          = gmt
    _left         = gml
    _width        = gww
    _height       = gwh
    _scrollWidth  = gwsw
    _scrollHeight = gwsh
  {{/manual}}
--
  _width        = (_width        ==0) and layer.{{glayer}}.width or _width
  _height       = (_height       ==0) and layer.{{glayer}}.height or _height
  _scrollWidth  = (_scrollWidth  ==0) and layer.{{glayer}}.width or _scrollWidth
  _scrollHeight = (_scrollHeight ==0) and layer.{{glayer}}.height or _scrollHeight
--
  layer.{{gname}} = widget.newScrollView ({
    top          = _top,
    left         = _left,
    width        = _width,
    height       = _height,
    scrollWidth  = _scrollWidth,
    scrollHeight = _scrollHeight,
    baseDir      = _K.systemDir,
  {{#gHide}}
     hideScrollBar = true,
  {{/gHide}}
  {{#gHideBack}}
     hideBackground = true,
  {{/gHideBack}}
  {{#gdH}}
     horizontalScrollDisabled = true,
  {{/gdH}}
  {{#gdV}}
     verticalScrollDisabled = true
  {{/gdV}}
  })

  {{#gmask}}
  local mask = graphics.newMask(_K.imgDir.."{{fileName}}" )
  layer.{{gname}}:setMask( mask )
  {{/gmask}}

  --
  sceneGroup:insert( layer.{{gname}})
  layer.{{gname}}:insert(layer.{{glayer}})
  {{^manual}}
    layer.{{glayer}}.x = layer.{{glayer}}.width / 2;
    layer.{{glayer}}.y = 0;
  {{/manual}}
{{/layer}}
end
--
function _M:toDispose()
end
--
function _M:localVars()
end
--
return _M