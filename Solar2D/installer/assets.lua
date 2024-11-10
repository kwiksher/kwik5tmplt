local json = require( "json" )

local M = {
  template={
    name="template_",
    path="template",
    latestName = "",
    url = "",
    label = "template"
  },
  editor={
    name="editor_",
    path="editor",
    latestName = "",
    url = "",
    label = "editor"
  },
  framework = {
    name="framework_",
    path=".",
    folders = {
      "assets",
      "commands",
      "components",
      "controller",
      "extlib",
      "lib      ",
    },
    latestName = "",
    url = "",
    label="framework"
  },

  API="https://api.github.com/repos/kwiksher/kwik5tmplt/releases/latest",
  token="",
  version = "",
  latestVersion = "",
  params = {}
}

local headers = {}
headers["Content-Type"] = "application/json"
headers["Authorization"] = "token "..M.token
--
M.params.headers = headers
--
function M:init()
    local filename = system.pathForFile( "kwkversion.json", system.ApplicationSupportDirectory )
    local decoded, pos, msg = json.decodeFile( filename )
    self.template = decoded.template
    self.editors = decoded.editor
    self.framework = decoded.framework
    self.version = decoded.version
 end

function M:save()
   local output = json.encode{template = self.template, editor = self.editor, framework=self.framework, version = self.version}
    local path = system.pathForFile("kwkversion.json", system.ApplicationSupportDirectory )
    local file, errorString = io.open( path, "w" )
    file:write(output)
    io.close( file )
end

return M
