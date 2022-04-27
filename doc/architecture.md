## Architecure

html panel
- browser
- uxp panel
- webview


```mermaid
flowchart LR

Designer((fas:fa-user Designer))
Developer((fas:fa-user Developer))

subgraph Photoshop
	graphics
	UXP
end

subgraph Editor[Editor]
	subgraph App
		assets[(assets/images<br>models/json)]
		lua[(Source .lua)]
	end
	tools(renderer<br>scafolder)
	httpServer
	GUI(GUI<br>transform<br>animation)
	GUI -.- tools
end

subgraph htmlPanel[REST API]
	form(Properties <br> CRUD)
end

subgraph VSCode
	httpYac(httpYac)
end

Photoshop -.img/json.-> assets
htmlPanel <-.img/json.-> httpServer
httpServer <-.-> assets
httpServer -.- tools
tools -.- App

Browser-.- htmlPanel
httpYac -.- htmlPanel
VSCode -.- lua

GUI -.- assets

Designer --- GUI
Designer --- Photoshop
Designer --- Browser

Developer --- VSCode

```
rest api

> pegasus is runningin Editor

1. run Editor

1. upload an image to pegasus server
	- save it assets/images/book/
    - create display.object
    - .json


uxp

> indirect, async

1. outputs images/json to App

	> offline

1. run Editor


```mermaid
flowchart LR

Designer((fas:fa-user Designer))
Developer((fas:fa-user Developer))
User((fas:fa-user User))

subgraph Photoshop
	graphics
	UXP
end

subgraph VisualStudioCode
	httpYac(httpYac .http <br> CRUD)
	coding(coding src/properties)
end

subgraph Editor[Editor]
	subgraph App[ Application]
		src(lua files <br>layerX.json<br>layerX_animation.json<br>)
		assets(images, audios ...)
		runtime(Runtime<br> data)
		GUI(GUI <br> material widgets for Solar2D? <br> Or webview?)
		webview
		setter
	end
	subgraph renderer
		parser(parser<br>lua/json/yaml)
		writer(writer)
		templates[(templates)]
	end
	subgraph httpServer
		doGet
		doPost
	end
	subgraph htmlPanel[html panel]
	form(Properties <br> CRUD)
end

end


parser -.- writer
writer -.- templates
setter -.- runtime
GUI    -.- writer
GUI    -.- setter

coding -.-> src


UXP -.- graphics
UXP -.-> assets

doPost -.-> parser
writer -.-> src

form -.-> httpServer
doGet -.- src
doGet -.- assets

httpYac -.-> httpServer

webview -.- form
GUI -.- webview

User -.- GUI
Designer -.-> Photoshop
Designer -.-> htmlPanel

Developer -.-> htmlPanel
Developer -.-> VisualStudioCode


```