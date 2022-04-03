 -- {{book}}
{{#BookTmplt}}
local pages = {
{{#pages}}
{
    page = {{page}}, alias="{{alias}}", isTmplt={{isTmplt}},
    {{#layers}}
    {{layer}} ={ x = {{x}}, y = {{y}} , width = {{width}}, height = {{height}},  alpha = {{alpha}} , ext = "{{ext}}" },
    {{/layers}}
},
{{/pages}}
}
{{/BookTmplt}}

{{#BookEmbedded}}
local pages = {isDownloadable = {{isDownloadable}}, pageNum={{pageNum}}, isIAP = {{isIAP}} }
{{/BookEmbedded}}

{{#BookPages}}
local pages = {}
{{/BookPages}}

return pages
