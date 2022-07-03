---
title: "Lua Code"
chapter: true
weight: 10
---

## Lua

you don't need to use kwik-generate-model nor kwik-editor to output lua files. You can skip making .json files of these tools, and you create a lua file manually into a folder, and append a name of additional file to scenes/pageX/index.lua


- commands/pageX/**/*.lua
- components/pageX/**/*.lua
- scenes/pageX/**/*.lua

At runtime, Kwik Code Framework reads scenes/pageX/index.lua to load each .lua files of pageX. The object names for commands, compnents, scenes are defined in the index.lua.

- scenes/pageX/index.lua

**kwik-genereate-index** is a tool to update the index.lua from traversing the folders above.

1. create .lua for commands, components, layers of pageX,
1. run the tool to generate scenes/pageX/index.lua

> you don't need to use kwik-generate-index tool. You can manually edit it but it would be better to generate the index.lua with the tool.

> Alternatively, there is another tool named **kwik-scaffold-lua**. This tool scafolds .lua files from scenes/pageX/index.lua. The tool does not overwrite .lua if exists, and may delete .lua if not defined in index.lua

Which Workflow do you like?

- A

    use kwik-generate-index everytime after you update commands, components, senes lua files.

- B

    use kwik-scaffold-lua to create a lua for commands, components, scenes then edit the lua file.

> I like A because thinking about files/folders strcure with a file explorer, and coping/pasting an exsiting file could be easier when coding is in progress.

> To initiate a project, B would work quicky to make a skelton structure.
