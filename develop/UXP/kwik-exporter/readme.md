npm install --save @types/photoshop ts-loader typescript

https://kawano-shuji.com/justdiary/2021/11/30/photoshop-uxp-typescript/

https://developer-stage.adobe.com/photoshop/uxp/2022/guides/uxp_guide/uxp-misc/manifest-v4/photoshop-manifest/


## Kwik Editor

### Help instructions
1. New App

	please create folder in Photoshop.
	```
	 Photoshop/appName
	```

1. New Page

	please create a new .psd in Photoshop/appName folder

	```
	 Photoshop/appName/page01.psd
	```


1. New Layer Image for App > book01 > page01

	please create a new layer in .psd 

1. Export in Kwik UXP plugin
	- open Kwik UXP plugin
	- export .psd to Solar2D/src/App/appName/

### Commands
- list entries in App

	App > book01 > page01

	- tab for components
		- list entries
		- select an entry

	- tab for comands
		- list entries
		- select an entry

- CRUD Props for component/command
	- Props panel
		- Update
			- update the props in the model table in runtime?
			- output .lua
			- reload to back the panel
		- OK
			- close the panel
			- reload
		- Cancel

- publish for App  or App/book01 or App/book01/page01
	- select all checkbox
	- options
		- images
		- layer props

> Normally a CRMD Compnent updates App/book01/models and renderer .lua files for components and commands so that the state of App/book01 are ready for preview lively.

#### .json

- models/book01/
	- index.json
	- commands/action.json
	- components/layer_image.json

#### .lua

-  models/book01.lua
-  commands/book01/action.lua
-  components/book01/layer_image.lua


> If manually code/assets are added, use Publish commands to render App/book01/models/book01.lua
## Assets

- copy spritesheet, audio, video etc files to App/bookName/assets or assets/
- add language code folder for additional, for example fr.lproj for French language


Kwik Editor in the simulator
-	select an audio to play
	-  .json/.lua are generated in models/page01/components
## UXP

1. layers - images

	1. select layerGroup and choose export children or not

		if yes, create components/docName/groupName

		- put index.lua
		- put layerName.lua
		- create groupName folder in assets/images/docName

		⭐️ Code first apporoach for components

	-  export layers

		if components/docName/groupName then
			index.lua if not, create else not overwrite end
			layerName.lua
		end

	-  export images

		if assets/images/docName/groupName then
			generate .png @2x, @4x
		end

## Kwik Editor

1. types for components

	1. create .json of Props in models/components/docName
	1. render .lua to components/docName folder

1. events for commands

	1. create .json of Props in models/events/docName
	1. render .lua or layerName/.lua to commands/docName folder


Publish

- export layers
- export images
- export types
- export events

	we may update models/scene.lua immeditatly with each export

	- model/scene.json
	- modesl/docName.lua

> .json for props and .lua are published at the same time.

## Manually commands & components

- Add .lua (Code first, next generate model)  to components or commndas folder at the root of src folder⭐️

	```
	├── App
	│   ├── book01
	│      ├── assets
	│      ├── components
	│      │   └── pag01
	│      └── models
	├── commands
	├── components
	│   ├── book01
	│       └── page01
	│           └── handmade.lua

	```

	1. edit props in .lua.

	1. run tools/generate


	> you may add .lua under src/App/bookName folder if never use UXP plugin. UXP export will delete them if same name of layer exists in .psd

	#### Output

	> .json files could be useful for a UXP plugin to edit props in GUI.
	> can we generate it by reading Props from each .lua?
	>    see Application.createUI
	>    see components/kwik/scene.lua getEvents()

	>    for a tool to read .lua, it maybe prepare dummy require for Application or compents.kwik.layer_xxx

	>    or editing mode to run in the simulator to select a target component/event
	>    and next to show a props for the component, then submit to output .json
	>    finally render(update) .lua with .json. Auto reload back to the state with the updated Props.


	- scene.json and models/scene.lua
	- models/docName
		- /commands

			act_erase.json

		- /comonents

			button_image_animation.json

	we also generate assets/images/docName/subfolder for exporting images in UXP

	> if you create a new layer component in .lua, you need to add the new layer to .psd manually.

- (optional) Edit models/scene.lua (Model first, next scaffold code)
    ```
	layer
		events
		types
	```

	run tools/scaffolld read scene.lua to copy

	- commands/base.lua
	- components/base.lua

	to the destinitation with a name
		- if subfoler, put index.lua

---

```mermaid
graph LR

book01(App/book01/Files <br> folders for layer group) -. open .-> sim(Simulator <br> edit > book01.page01)

Photoshop -.uxp generate.-> book01

sim -.update .-> book01

````

Create a folder for a layer group so that UXP plugin ouput images for entries of a layer group.


```mermaid
graph TB

subgraph Simulator/book01/page01
	Editor[Kwik Live Edit <br> CRUD components <br> CRUD commands]
	Editor -.json.-> Renderer
end

subgraph App/book01/Files
	custom(custom/book01/components/)
	app01(assets/images <br> components/layer_image)
	app02(commands)
	app03(components/layer_animation etc)
	app01---app02
	app01---app03
end

subgraph Photoshop
	subgraph book01
		psd1[ page01 layers]
		psd2[ page02 layers]
	end

	subgraph book02
		psd21[ page01 layers]
		psd22[ page02 layers]
	end

end

psd1 -. layers .-> UXP


UXP -.png/lua/json.-> app01
app01 -. folders' for layer group .-> UXP


Renderer -.json/lua.-> app01
Renderer -.json/lua.-> app02
Renderer -.json/lua.-> app03

````

### Renderer outputs
- models/docName/
	- index.json
	- commands/ .json
	- components/ .json

-  models/docName.lua
-  commands/docName/ .lua
-  components/docName/ .lua


	> components/.json can be updated from .lua but not commands.json


### Lock/Unlock editing .lua

Props of .lua has a property for read only. You can manually edit .lua and then enable readOnly true. Then Editor shows it in read-only mode.
### use cases

1. Export images for entries of a layer group.

	1. UXP exports App/book01/Files from book01.psd
	1. Open it Solar2D simulator. Kwik Live Edit is available.
		1. Update a layer group Props for generate images for entries
	1. Back to UXP to export images


1. A layer in .psd is deleted

	1. UXP exports App/book01/Files from book01.psd
		1. compare scene.model
		1. remove related files

	> this would delete a component injected manually too. So use custom/components/ folder to add a component manually.

	> (TODO) Renderer to iterate through custom folder to append a custom enry with an attribute custom = true to models/docName.lua

	> Alternatively,  a file named components/xxx-custom.lua is not removed.lua.

1. Export images only from UXP