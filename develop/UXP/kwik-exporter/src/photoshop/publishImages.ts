import { storage } from 'uxp';
import { app } from 'photoshop';
import { Layer} from 'photoshop/dom/Layer';
import { LayerKind} from 'photoshop/dom/Constants';

import {getFolder, isFile, isFolder, isUpdated} from '../utils/storage'
import { exportLayerAsPng, resettLayer } from '../photoshop/exportLayer';


export async function publishImages (bookFolder) {

  const docName = app.activeDocument.name.replace(".psd","");
  const docLayers = app.activeDocument.layers;
  const layer: Layer = docLayers[0];

  // setEntry(entry);
  //
  //let token = fs.createSessionToken(entry);
  //setToken(token);
  //
  /// MOVE ///
  const imagesRoot: any = await bookFolder.getEntry('assets/images');
  const assetFolder = await getFolder(docName, imagesRoot)
  /////////////
  const exportLayers = async (layers, parentName, imageSuffix: string) => {
    let tmpFolder = await getFolder(imageSuffix + parentName, assetFolder);
    let count = 0;
    for (var i = layers.length-1; i >= 0; i--) {
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
    let tmpFolder = await getFolder(imageSuffix + parentName, assetFolder);
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
    let tmpFolder = await getFolder(imageSuffix + parentName, assetFolder);
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