 -- {{book}}
{{if(options.BookTmplt)}}
local pages = {
{{each(options.pages)}}
{
    page = {{@this.page}}, alias="{{@this.alias}}", isTmplt={{@this.isTmplt}},
    {{each(@this.layers)}}
    {{@this.layer}} ={ x = {{@this.x}}, y = {{@this.y}} , width = {{@this.width}}, height = {{@this.height}},  alpha = {{@this.alpha}} , ext = "{{@this.ext}}" },
    {{/each}}
},
{{/each}}
}
{{/if}}

{{if(options.BookEmbedded)}}
local pages = {isDownloadable = {{isDownloadable}}, pageNum={{pageNum}}, isIAP = {{isIAP}} }
{{/if}}

{{if(options.BookPages)}}
local pages = {}
{{/if}}

return pages
