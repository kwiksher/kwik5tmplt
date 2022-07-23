import { action, core, app} from 'photoshop';
import { Layer} from 'photoshop/dom/Layer';
import { storage } from 'uxp';
import selectLayerByID from './selectLayer';
import {loadImageFromFolder} from './loadImage';
import {formatText} from 'lua-fmt'; // not working?

const fs = require('uxp').storage.localFileSystem;
import * as Mustache from 'mustache'
import { Component } from 'react';

let templateMap = new Map<string, string>();

const getTemplateData = async (fileName:string): Promise<string> => {
  let data = templateMap.get(fileName);
  if (data == null){
    console.log("getTemplateData")
    try{
      let folder  = await fs.getPluginFolder();
      folder  = await folder.getEntry("kwik/contentX");
      console.log("", folder.nativePath, fileName);
      const file  = await folder.getEntry(fileName);
      data = await file.read()
      //console.log("", data.length)
      templateMap.set(fileName, data);
    }catch(e){
      console.log(e)
    }
  }
  return data;
};

const renderLua = async (tmplt, model, destFolder): Promise<void> => {
  console.log("renderLua", model)
  var result = Mustache.render(tmplt, model);
  console.log("", result.length)
  try{
    const file = await destFolder.createFile(model.name + ".lua",{overwrite: true});
    result = result.replaceAll("&#x2F;", "/");
    await file.write(result);
  }catch(e) {
    console.log(e)
  }
};

const renderJSON = async (tmplt, model, destFolder): Promise<void> => {
  console.log("renderJSON", model)
  var jsonString = Mustache.render(tmplt, model);
  try{
    const file = await destFolder.createFile(model.name + ".json",{overwrite: true});
    var result = JSON.stringify(JSON.parse(jsonString),null,2);
    console.log("", result.length)
    await file.write(result);
  }catch(e) {
    console.log(e)
  }
};

export const exportIndexLua = async (weight:number, destFolder:storage.Folder): Promise<void> => {
  const tmplt = await getTemplateData('scenes/pageX/index.lua');
  await renderLua(tmplt, {name:"index", weight:weight}, destFolder);
};


function objs2list(arr) {
  const r = [];
  if (arr){
    arr.forEach(function(obj, index, array) {
      // console.log(obj, index)
      Object.keys(obj).forEach(function(key){
        if (key!="events" && key!="types" && key!="weight"){
          let elements = obj[key];
          if (elements && elements.length > 0 ) {
            let ret = objs2list(elements)
            r.push({"name":key,"layers":ret});
          } else{
            r.push({"name":key,"layers":null});
          }
        }
      });
    })
  }
  return r;
}

export const exportIndex = async (model, sceneFolder:storage.Folder, modelFolder:storage.Folder): Promise<void> => {
  const result = JSON.stringify(model.layers)
  try{
    const file = await modelFolder.createFile("index.json",{overwrite: true});
    await file.write(result);
  }catch(e) {
    console.log(e)
  }

  //https://stackoverflow.com/questions/24190254/include-a-partial-in-mustache-js
  //https://stackoverflow.com/questions/31885263/mustache-js-how-to-create-a-recursive-list-with-an-unknown-number-of-sub-lists

  const layers = objs2list(model.layers);
  console.log("-----exportIndex------")
  console.log(model.layers)
  const layerPartial = {"recursive": '{{#layers}}{ {{name}} = { {{>layers}} } },{{/layers}}'};
  //  const layerPartial = {"recursive": '{ {{#layers}}{{name}} = { {{>layers}} },{{/layers}} }'};
  //
  // events =["eventOne", "eventTwo"]
  const events = objs2list(model.events);

  const components = {
    audios:objs2list(model.components.audios),
    groups:objs2list(model.groups),
    others:objs2list(model.others),
    timers:objs2list(model.timers),
    variables:objs2list(model.variables)};

  const tmplt = await getTemplateData('scenes/pageX/book_index.lua');

  console.log( {"name":model.name, "layers":layers})
  const out = Mustache.render(tmplt, {"name":model.name, "layers":layers, "events":events, "components":components}, layerPartial);
  try{
    const file = await sceneFolder.createFile("index.lua",{overwrite: true});
    await file.write(out);
    console.log(out)
  }catch(e) {
    console.log(e)
  }
};

export const exportLayerProps = async (index, layer: Layer, bounds, sceneFolder:storage.Folder, modelFolder:storage.Folder, parent:string): Promise<void> => {
  console.log("exportLayerProps");

  const props = {
    "bounds"    : bounds,
    "opacity"   : layer.opacity,
    "blendMode" : layer.blendMode,
    "height"    : bounds.bottom-bounds.top,
    "width"     : bounds.right -bounds.left,
    "kind"      : layer.kind,
    "name"      : layer.name,
    "x"         : bounds.right + (bounds.left -bounds.right)/2,
    "y"         : bounds.top + (bounds.bottom - bounds.top)/2,
    "alpha"     : layer.opacity/100,
    "parent"    : parent,
    "weight"    : index
  }
  const tmplt = await getTemplateData('scenes/pageX/layer_image.lua');
  //console.log(tmplt)
  await renderLua(tmplt, props, sceneFolder);
  //
  const tmpltJSON = await getTemplateData('models/pageX/layer_image.json');
  await renderJSON(tmpltJSON, props, modelFolder);

  // const tmplt = 'My favorite template engine is {{it.favorite}}.'
  // var data = {
  //   name:'test'
  //   favorite: 'Squirrelly'
  // }
  // await renderLua(data, tmplt, destFolder);
};

export const exportLayerAsPng = async (layer:Layer, path:string, imageSuffix:string): Promise<void> => {
  const { id, name } = layer;

  console.log("exportLayerAsPng",imageSuffix, name);
  console.log("", path)

  //await selectLayerByID(id);
  const selectCommand = 	  {
    _obj: 'select',
    _target: [
      {
      _ref: 'layer',
       _id: id,
      },
    ],
    makeVisible: false,
    layerID: [id],
    _isCommand: false,
  }

  //https://forums.creativeclouddeveloper.com/t/layer-transformation-in-a-for-loop/4524/3
  function transformFactory(widthPercent, heightPercent){
      return {
            _obj: "transform",
            _target: [
                {
                    _ref: "layer",
                    _enum: "ordinal",
                    _value: "targetEnum"
                }
            ],
            freeTransformCenterState: {
                _enum: "quadCenterState",
                _value: "QCSAverage"
            },
            width: {
                _unit: "percentUnit",
                _value: widthPercent
            },
            height: {
                _unit: "percentUnit",
                _value: heightPercent
            },
            interfaceIconFrameDimmed: {
                _enum: "interpolationType",
                _value: "bicubic"
            },
            _options: {
                dialogOptions: "dontDisplay"
            }
        }
  }

  const exportCommand = {
    _obj: 'exportSelectionAsFileTypePressed',
    _target: { _ref: 'layer', _enum: 'ordinal', _value: 'targetEnum' },
    fileType: 'png',
    quality: 32,
    metadata: 0,
    //destFolder: destFolder.nativePath,
    destFolder: path,
    sRGB: true,
    openWindow: false,
    _options: { dialogOptions: 'dontDisplay' },
  };

  await core.executeAsModal(
    async () => {

      if (imageSuffix == '2x'){
        await action.batchPlay([selectCommand, transformFactory(50, 50), exportCommand], { modalBehavior: 'wait' }); //, synchronousExecution:true

      }else if(imageSuffix == '1x'){
        await action.batchPlay([selectCommand, transformFactory(25, 25), exportCommand], { modalBehavior: 'wait' }); //,synchronousExecution:true

      }else{
        await action.batchPlay([selectCommand,  exportCommand], { modalBehavior: 'wait' });
      }
    },
    { commandName: `Export ${layer.name} Layer As PNG start` }
  );


};

export const resettLayer = async (layer:Layer, path:string, imageSuffix:string): Promise<void> => {
  const { id, name } = layer;

  //await selectLayerByID(id);
  const selectCommand = 	  {
    _obj: 'select',
    _target: [
      {
      _ref: 'layer',
       _id: id,
      },
    ],
    makeVisible: false,
    layerID: [id],
    _isCommand: false,
  }

  //https://forums.creativeclouddeveloper.com/t/layer-transformation-in-a-for-loop/4524/3
  function transformFactory(widthPercent, heightPercent){
      return {
            _obj: "transform",
            _target: [
                {
                    _ref: "layer",
                    _enum: "ordinal",
                    _value: "targetEnum"
                }
            ],
            freeTransformCenterState: {
                _enum: "quadCenterState",
                _value: "QCSAverage"
            },
            width: {
                _unit: "percentUnit",
                _value: widthPercent
            },
            height: {
                _unit: "percentUnit",
                _value: heightPercent
            },
            interfaceIconFrameDimmed: {
                _enum: "interpolationType",
                _value: "bicubic"
            },
            _options: {
                dialogOptions: "dontDisplay"
            }
        }
  }

    await core.executeAsModal(
    async () => {

      if (imageSuffix == '2x'){
        await action.batchPlay([selectCommand, transformFactory(200, 200)], { modalBehavior: 'wait'}); //, synchronousExecution:true

      }else if(imageSuffix == '1x'){
        await action.batchPlay([selectCommand, transformFactory(400, 400)], { modalBehavior: 'wait' });//, synchronousExecution:true

      }
    },
    { commandName: `Export ${layer.name} Layer As PNG Reset` }
  );

};



export const exportLayerAsPngAndLoad = async (layer:Layer, folder:any): Promise<string> => {
  const { id, name } = layer;
  const tempFolder = await storage.localFileSystem.getTemporaryFolder();
//  const destFolder = await tempFolder.createFolder(`${Math.round(Math.random() * 1000000)}`);
  const destFolder = (folder!=null)?folder:tempFolder;
  const path = (folder!=null)?folder.nativePath:tempFolder.nativePath;

  console.log("exportLayerAsPngAndLoad",id, name);
  console.log("", path)

  await core.executeAsModal(
    async () => {
      await selectLayerByID(id);
      const exportCommand = {
        _obj: 'exportSelectionAsFileTypePressed',
        _target: { _ref: 'layer', _enum: 'ordinal', _value: 'targetEnum' },
        fileType: 'png',
        quality: 32,
        metadata: 0,
        //destFolder: destFolder.nativePath,
        destFolder: path,
        sRGB: true,
        openWindow: false,
        _options: { dialogOptions: 'dontDisplay' },
      };
      await action.batchPlay([exportCommand], { modalBehavior: 'execute' });
    },
    { commandName: `Export ${layer.name} Layer As PNG` }
  );
  try {
    const image = await loadImageFromFolder(destFolder, name, 10);
    return image;
  } catch (e) {
    console.error(`Error loading image: ${e}`);
  }
  //await destFolder.delete();
  return '';
};

export const exportLayerAsJpegAndLoad = async (layer:Layer): Promise<string> => {
  const { id, name } = layer;
  const tempFolder = await storage.localFileSystem.getTemporaryFolder();
//  const destFolder = await tempFolder.createFolder(`${Math.round(Math.random() * 1000000)}`);
  const destFolder = tempFolder;

  console.log(id, name);
  console.log(destFolder.nativePath)

  await core.executeAsModal(
    async () => {
      await selectLayerByID(id);

      //await resizeLayer();

      const exportCommand = {
        _obj: 'exportSelectionAsFileTypePressed',
        _target: { _ref: 'layer', _enum: 'ordinal', _value: 'targetEnum' },
        fileType: 'jpg',
        jpegQuality: 8,
        metadata: 0,
        destFolder: destFolder.nativePath,
        sRGB: true,
        openWindow: false,
        _options: { dialogOptions: 'dontDisplay' },
      };
      await action.batchPlay([exportCommand], { modalBehavior: 'execute' });
    },
    { commandName: `Export ${layer.name} Layer As JPG` }
  );
  try {
    const image = await loadImageFromFolder(destFolder, name, 10);
    return image;
  } catch (e) {
    console.error(`Error loading image: ${e}`);
  }
  //await destFolder.delete();
  return '';
};


export const resizeLayer = async () => {
      const command = {
          _obj: "transform",
          _target: [
            {
                _ref: "layer",
                _enum: "ordinal",
                _value: "targetEnum"
            }
          ],
          freeTransformCenterState: {
            _enum: "quadCenterState",
            _value: "QCSAverage"
          },
          offset: {
            _obj: "offset",
            horizontal: {
                _unit: "pixelsUnit",
                _value: 0
            },
            vertical: {
                _unit: "pixelsUnit",
                _value: 0
            }
          },
          width: {
            _unit: "percentUnit",
            _value: 50
          },
          height: {
            _unit: "percentUnit",
            _value: 50
          },
          interfaceIconFrameDimmed: {
            _enum: "interpolationType",
            _value: "bicubic"
          },
          _options: {
            dialogOptions: "dontDisplay"
          }
      }
      await action.batchPlay([command], { modalBehavior: 'execute' });
}