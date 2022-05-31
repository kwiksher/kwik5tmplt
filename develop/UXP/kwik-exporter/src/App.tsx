import React, { useState, useEffect } from 'react';
import { app } from 'photoshop'
import { storage } from 'uxp';
import { Layer} from 'photoshop/dom/Layer';
import { LayerKind} from 'photoshop/dom/Constants';

import Spectrum, { ActionButton } from 'react-uxp-spectrum';

import StyledComponents from "./components/StyledComponents";
import {exportIndex, exportIndexLua, exportLayerProps, exportLayerAsPng, resettLayer, exportLayerAsPngAndLoad, exportLayerAsJpegAndLoad } from './components/exportLayer';

const docName = app.activeDocument.name.replace(".psd","");
const docLayers = app.activeDocument.layers;
const layer: Layer = docLayers[0];


const isUpdated = async (
  after: number,
  folder: storage.Folder,
  attempts = 10000
): Promise<boolean> => {
  let attemptsLeft = attempts;

  const entries = await folder.getEntries();
  let files = entries.filter(entry => entry.isFile);

  //console.log("isUpdated", after, folder.nativePath)
  while (files.length < after && attemptsLeft > 0) {
    const entries = await folder.getEntries();
    files = entries.filter(entry => entry.isFile);
    await new Promise((res) => setTimeout(res, 50));
    attemptsLeft -= 1;
  }
  //
  console.warn('isUpdated', folder.nativePath, attemptsLeft);
  return attemptsLeft > 0
};

const isFolder = async (folderName, parentFolder): Promise<boolean> => {
  let destArr = (await parentFolder.getEntries()).filter(entry => entry.name == folderName);
  return destArr.length > 0 && destArr[0].isFolder;
}

const isFile = async (folderName, parentFolder): Promise<boolean> => {
  let destArr = (await parentFolder.getEntries()).filter(entry => entry.name == folderName);
  return destArr.length > 0 && destArr[0].isFile;
}

const getKwikFolder = async (folderName, parentFolder): Promise<storage.Folder> => {
  const destArr = (await parentFolder.getEntries()).filter(entry => entry.name == folderName);
  if (destArr.length == 0) {
    return  await parentFolder.createFolder(folderName);
  } else {
    return destArr[0];
  }
}

const App: React.FC<any> = () => {

  //const [token, setToken] = useState(false);
  //const [entry, setEntry] = useState(null);

  /*
    projectRoot/App/book
  */

  const publishHandler = async (event) => {

    if (event.ctrlKey) {
      console.log("crt")
    } else if (event.metaKey) {
      console.log("meta")
    } else {
      console.log(event)
    }

    const fs = storage.localFileSystem;
    let bookFolder = await fs.getFolder();
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

    const modelsRoot = await getKwikFolder('models', bookFolder);
    const modelFolder = await getKwikFolder(docName, modelsRoot)
    const scenesRoot = await getKwikFolder('scenes', bookFolder);
    const sceneFolder = await getKwikFolder(docName, scenesRoot)
    // .lua
    const exportLayer = async (docLayers, sceneFolder, modelFolder):Promise<any> => {
      const objs = [];
      for (let i = 0; i < docLayers.length; i++) {
        const layer = docLayers[i];
        const obj = {};
        obj[docLayers[i].name] = [];

        if (layer.kind == LayerKind.GROUP && await isFolder(layer.name, sceneFolder)){
          const sfolder = await getKwikFolder(layer.name, sceneFolder);
          const mFolder = await getKwikFolder(layer.name, modelFolder)
          //
          const element = await exportLayer(layer.layers, sfolder, mFolder);
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
          await exportLayerProps(docLayers[i], sceneFolder, modelFolder);
        }
        objs[i] = obj;
      }
      return objs
    }
    const element = await exportLayer(docLayers, sceneFolder, modelFolder);
    await exportIndex({"name":docName, "layers":element}, sceneFolder, modelFolder);

  }

  const publishAssetsHandler = async (event)  => {
    const fs = storage.localFileSystem;
    let bookFolder = await fs.getFolder();
    // setEntry(entry);
    //
    //let token = fs.createSessionToken(entry);
    //setToken(token);
    //
    /// MOVE ///
    const imagesRoot: any = await bookFolder.getEntry('assets/images');
    const assetFolder = await getKwikFolder(docName, imagesRoot)
    /////////////
    const exportLayers = async (layers, parentName, imageSuffix: string) => {
      let tmpFolder = await getKwikFolder(imageSuffix + parentName, assetFolder);
      let count = 0;
      for (var i = 0; i < layers.length; i++) {
        const layer = layers[i];
        if (layer.kind == LayerKind.GROUP && await isFolder(layer.name, assetFolder)){
          await exportLayers(layer.layers,layer.name, imageSuffix);
        }else{
          await exportLayerAsPng(layer, tmpFolder.nativePath, imageSuffix);
          count = count + 1;
          await isUpdated(count, tmpFolder)
        }
      }
    }
    //////////
    const resetLayers = async (layers, parentName, imageSuffix: string) => {
      let tmpFolder = await getKwikFolder(imageSuffix + parentName, assetFolder);
      let count = 0;
      //
      for (var i = 0; i < layers.length; i++) {
        const layer = layers[i];
        if (layer.kind == LayerKind.GROUP && await isFolder(layer.name, assetFolder)){
          await resetLayers(layer.layers,layer.name, imageSuffix);
        }else{
          await resettLayer(layer, tmpFolder.nativePath, imageSuffix);
        }
      }
    }

    const cleanupLayers = async (layers, parentName, imageSuffix: string) => {
      //
      for (var i = 0; i < layers.length; i++) {
        const layer = layers[i];
        if (layer.kind == LayerKind.GROUP && await isFolder(layer.name, assetFolder)){
          // clean up if
          let fileName = layer.name;
          if (imageSuffix == '4x' || imageSuffix == '2x') {
            fileName = fileName + "@" + imageSuffix + ".png";
          } else {
            fileName = fileName + ".png";
          }
          if (await isFile(fileName, assetFolder)){
            const file = await assetFolder.getEntry(fileName);
            console.log("cleanuptLayers delete", fileName);
            await file.delete();
          }

          await cleanupLayers(layer.layers,layer.name, imageSuffix);
        }
      }
    }

    const moveImages = async (layers, parentName, imageSuffix: string) => {
      console.log("moveImages", parentName, imageSuffix);
      let tmpFolder = await getKwikFolder(imageSuffix + parentName, assetFolder);
      console.log("", tmpFolder.nativePath);
      let targetFolder = assetFolder;
      if (parentName.length > 0 ){
        targetFolder = (await assetFolder.getEntry(parentName)) as storage.Folder;
        console.log("", targetFolder.nativePath)
      }
      //
      const currententries = await targetFolder.getEntries();
      let files = currententries.filter(entry => entry.isFile);
      const before = files.length;
      //
      const entries = await tmpFolder.getEntries();
      let count = 0;
      for (var i = 0; i < layers.length; i++) {
        const layer = layers[i];
        console.log("", layer.name, layer.kind)
        if (layer.kind == LayerKind.GROUP && await isFolder(layer.name, assetFolder)){
          try{
            await moveImages(layer.layers,layer.name, imageSuffix);
          }catch(e){
            console.log("Error", e)
          }
        }else{
          const someFile = entries[i];
          console.log("", someFile.nativePath);
          try{
            if (imageSuffix == '4x' || imageSuffix == '2x') {
              const newName = someFile.name.replace(".png", "@" + imageSuffix + ".png");
              await someFile.moveTo(targetFolder, { newName: newName, overwrite: true })
            } else {
              await someFile.moveTo(targetFolder, { newName: someFile.name, overwrite: true })
            }
          }catch(e){
            console.log(e)
          }
          count = count + 1
        }
      }
      const isFinished = await isUpdated(count, targetFolder);
      if (isFinished){
        await tmpFolder.delete();
      }
    }
    //
    await exportLayers(docLayers, "", '4x');
    await exportLayers(docLayers, "", '2x');
    await resetLayers(docLayers,"", '2x');
    await exportLayers(docLayers, "", '1x');
    await resetLayers(docLayers,"", '1x');
    //
    await moveImages(docLayers, "", '4x');
    await moveImages(docLayers, "", '2x');
    await moveImages(docLayers, "", '1x');
    //
    // this clears layerSet images exists under images/book if rendering chidlren of layerSet instead.
    await cleanupLayers(docLayers, "", '4x');
    await cleanupLayers(docLayers, "", '2x');
    await cleanupLayers(docLayers, "", '1x');


  }

  //// Publish with export image
  // const docLayers = app.activeDocument.layers;
  //   exportLayer

  //// Publish without export image - Refresh
  // const docLayers = app.activeDocument.layers;
  //   scaffoldLayer
  //   render models/page/
  //                     /components
  //                     /events
  //                     /layers
  //    if layer is not found, rename .lua to .lua.bak
  //    if layer has a binded component or an event
  //       layer.type = {button, animation ..}, layer.events = {drag, select..}
  //   render scenes/page.json or page.lua
  //
  //   list .lua.bak for removed events or components
  //   list components/actions/events
  //
  //   if user select a layer in Layer panel
  //      update Kwik original Layer Props Panel
  //         lists components
  //   current model.lua or .json does not relate an event with a component.
  //   This is done by a button editor or by a action editor
  //   for a component/action to dispatch a selected event.
  //   each event has a corresponding action.
  //
  //   so UI for user to add an event, it creates an event in scens/page.lua
  //   and also create eventname.lua in models/page/events folder.
  //   eventname.lua has a props table for actions.


  async function copyAll(src, dist){
    const entries = await src.getEntries();
    for (var i = 0; i < entries.length; i++) {
      let element = entries[i];
      if (element.isFile){
        console.log(element)
        element.copyTo(dist, {overwrite:false})
      }else{
        console.log("", element)
        let folder = await getKwikFolder(element.name, dist);
        await copyAll(element, folder);
      }
    }

  }
  ////////
  const newProjectHandler = async() =>{
    // open dialog
    // getFolder

    const fs = storage.localFileSystem;
    let distFolder = await fs.getFolder();

    let pluginFolder  = await fs.getPluginFolder();
    let tmpltFolder = await pluginFolder.getEntry("kwik/Solar2D") as storage.Folder;

    await copyAll(tmpltFolder, distFolder);

    // cp kwik
    //    user choose KwikShelf structure or single structre
    //
    // new psd
    // add the project to the list
    // createPersistentToken(entry)


  }

  const openProjectHandler = async() =>{
    // list the projects
    // user selects a project
    //   getEntryForPersistentToken(token)
    // list .psd from views/index.lua or index.json
    // open the psd of the first order
  }

  const newDocumentHandler = async() =>{
    // new psd
    //   views/index.lua to add the entry
  }

  const openDocumentHandler = async() =>{
    // user selects a psd in the list
  }

  return (
    <>
      <ActionButton onClick={publishAssetsHandler}>Export Images</ActionButton>
      <ActionButton onClick={publishHandler}>Export Codes</ActionButton>
      <ActionButton onClick={newProjectHandler}>New Project</ActionButton>

      //
      {/* <ActionButton onClick={newProjectHandler}>New Projectt</ActionButton>
      <ActionButton onClick={openProjectHandler}>Open Project</ActionButton>
      <ActionButton onClick={newDocumentHandler}>New Document</ActionButton>
      <ActionButton onClick={openDocumentHandler}>Open Document</ActionButton> */}
      {/* <StyledComponents exportLayer={layer} folder={entry} /> */}
    </>
  )
}

export default App;
