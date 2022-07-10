import { storage } from 'uxp';
import { app } from 'photoshop'

import { Layer} from 'photoshop/dom/Layer';
import { LayerKind} from 'photoshop/dom/Constants';

import {getFolder, isFile, isFolder} from '../utils/storage';
import {parseCommandFiles, parseLayerFiles, parseComponentFiles } from '../utils/projectParser';
import {exportIndex, exportIndexLua, exportLayerProps, exportLayerAsPng, resettLayer, exportLayerAsPngAndLoad, exportLayerAsJpegAndLoad } from './exportLayer';

export async function publishCode (bookFolder) {
  const docName = app.activeDocument.name.replace(".psd","");
  const docLayers = app.activeDocument.layers;
  const layer: Layer = docLayers[0];
  const boundsCalc = (bounds)=>{
    const ret = {bottom:bounds.bottom, top:bounds.top, right:bounds.right, left:bounds.left};
    const xDiff = -(app.activeDocument.width-1920)/2
    const yDiff = -(app.activeDocument.height-1280)/2
    ret.left +=  xDiff
    ret.right += xDiff
    ret.top += yDiff
    ret.bottom += yDiff
    return ret;
  }
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
        await exportLayerProps(docLayers[i], boundsCalc(docLayers[i].bounds), sceneFolder, modelFolder, parent);
      }
      objs[i] = obj;
    }
    return objs.reverse();
  }


  
  try{
    const modelsRoot = await getFolder('models', bookFolder);
    const modelFolder = await getFolder(docName, modelsRoot);
    const scenesRoot = await getFolder('scenes', bookFolder);
    const sceneFolder = await getFolder(docName, scenesRoot);
    const commandRoot = await getFolder('commands', bookFolder);
    const commandFolder = await getFolder(docName, commandRoot);
    const componentRoot = await getFolder('components', bookFolder);
    const componentFolder = await getFolder(docName, componentRoot);
    //
    const lua_commands = await parseCommandFiles(commandFolder);
    const lua_components = await parseComponentFiles(commandFolder);
    const lua_layers   = await parseLayerFiles(sceneFolder);
    //
    const elements = await exportLayer(docLayers, sceneFolder, modelFolder, "");
    //
    // merge
    //
    for (const layer of lua_layers){
        const element = elements.filter(entry=>entry.name==layer.name)
        if (element==null ){
          //add
        }else{
          // exists
          //   get entry.weight
          // check types
        }
    }
    // sort by weight
    //
    // add lua_commands to elements
    // add lua_components to elements
    //
    await exportIndex({"name":docName, "layers":elements}, sceneFolder, modelFolder);

  }catch(e){
    console.log(e)

  }

}
