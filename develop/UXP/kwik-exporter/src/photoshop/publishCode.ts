import { storage } from 'uxp';
import { app } from 'photoshop'

import { Layer} from 'photoshop/dom/Layer';
import { LayerKind} from 'photoshop/dom/Constants';

import {getFolder, isFile, isFolder} from '../utils/storage'
import {exportIndex, exportIndexLua, exportLayerProps, exportLayerAsPng, resettLayer, exportLayerAsPngAndLoad, exportLayerAsJpegAndLoad } from './exportLayer';

export async function publishCode (bookFolder) {
  const docName = app.activeDocument.name.replace(".psd","");
  const docLayers = app.activeDocument.layers;
  const layer: Layer = docLayers[0];
  // setEntry(entry);
  //
  //let token = fs.createSessionToken(entry);
  //setToken(token);
  //

    /*
    (base) ymmtny@kwiksher mui-tool_tmp % tree
    .
    ├── commands
    │   └── editor
    │       └── layersList
    │           ├── drag.lua
    │           └── select.lua
    ├── models
    │   └── editor
    │       ├── background.lua
    │       ├── plus.lua
    │       └── sidepanel
    │           ├── index.lua
    │           ├── layersList.lua
    │           └── topbar
    │               ├── deleteIcon.lua
    │               ├── deleteIcon_button.lua
    │               ├── index.lua
    │               └── newIcon.lua
    */

  const modelsRoot = await getFolder('models', bookFolder);
  const modelFolder = await getFolder(docName, modelsRoot)
  const scenesRoot = await getFolder('scenes', bookFolder);
  const sceneFolder = await getFolder(docName, scenesRoot)
  // .lua
  const exportLayer = async (docLayers, sceneFolder, modelFolder, parent):Promise<any> => {
    const objs = [];
    for (let i = 0; i < docLayers.length; i++) {
      const layer = docLayers[i];
      const obj = {};
      obj[docLayers[i].name] = [];

      if (layer.kind == LayerKind.GROUP && await isFolder(layer.name, sceneFolder)){
        const sfolder = await getFolder(layer.name, sceneFolder);
        const mFolder = await getFolder(layer.name, modelFolder)
        //
        const element = await exportLayer(layer.layers, sfolder, mFolder, layer.name + "/");
        obj[docLayers[i].name] = element;
        //
        if (false == await isFile("index.lua", sfolder)){
          await exportIndexLua(1, sfolder);
        }
        //
        if (await isFile(layer.name + ".lua", sceneFolder)){
          const file = await sceneFolder.getEntry(layer.name + ".lua");
          await file.delete();
        }
        if (await isFile(layer.name + ".json", modelFolder)){
          const file = await modelFolder.getEntry(layer.name + ".json");
          await file.delete();
        }
      }else{
        await exportLayerProps(docLayers[i], sceneFolder, modelFolder, parent);
      }
      objs[i] = obj;
    }
    return objs.reverse();
  }
  const element = await exportLayer(docLayers, sceneFolder, modelFolder, "");
  await exportIndex({"name":docName, "layers":element}, sceneFolder, modelFolder);

}
