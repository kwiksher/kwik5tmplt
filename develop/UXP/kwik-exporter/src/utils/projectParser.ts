import {getFolder, isFile, isFolder} from '../utils/storage';

export async function parseCommandFiles(folder){
  const ret = [];
  const eventIterator = async(folder, parent) =>{
    let  parentPath = ""
    if (parent){
        parentPath = folder.name + ".";
    }
    const entries = await folder.getEntries();
    for (var i = 0; i < entries.length; i++) {
      let element = entries[i];
      if (element.isFile && element.name.indexOf('.lua') > 0 ){
        const value = parentPath +  element.name.replace(".lua", "")
        ret.push(value)
        console.log(value)
      }else if(element.isFolder && element.name.length > 2){
        await eventIterator(element, folder)
      }
    }
  }
  await eventIterator(folder, null)
  return ret;
}
//
//
//
const types = ["button", "animation"];

async function readWeight(file){
  const contents = await file.read();
  var lines = contents.split(/\r?\n/);
  for (const line of lines){
    if (line.indexOf("$weight") > 0){
      const pos = line.indexOf("=")
      const text = line.substring(pos +1);
      return parseInt(text);
    }
  }
  return  0
}


const layerIterator = async(folder, parent, eventsMap) =>{
  const layerMap = new Map(); //{}
  const children  = new Map(); //{weight:null}
  //
  let  parentPath = ""
  if (parent){
      parentPath = parent.name + ".";
  }
  //
  const entries = await folder.getEntries();
  for (var i = 0; i < entries.length; i++) {
    let element = entries[i];
    if (element.isFile && element.name.indexOf('.lua') > 0 ){
      const layerName = element.name.replace(".lua", "");
      if (layerName !='index'){
        let layer = layerMap.get(layerName);
        if (layer == null){
          layer = {};
          layer.weight = await readWeight(element);
          layerMap.set(layerName, layer);
          if (eventsMap){
            layer.events = eventsMap[layerName];
          }
        }
        for (const type of types){
          if (element.name.indexOf("_"+type+".lua")){
            if (layer.types == null){
              layer.types = [];
            }
            layer.types.push(type)
          }
        }
      }
    }else if(element.isFolder && element.name.length > 2){
      const elements = await layerIterator(element, folder, eventsMap)
      children.set(element.name,elements);
      const entries = (await element.getEntries()).filter(entry => entry.name == "index.lua");
      if  (entries.length > 0 && entries[0].isFile){
        children.set('weight', await readWeight(entries[0]));
      }
    }
  }
  // layerMap = {
  //     layerName:{types: [],events : [], weight : 1}),
  // },
  // convert to
  // {
  //    layerName : {types : [], events : []}, weight:1
  // }
  //
  let temp = []
  for (const [k, v] of layerMap) {
      const t = {types:null, events:null, weight:0}
      t[k] = {}
      if (v.types!=null){
        t.types = v.types
      }
      if (v.events!=null){
        t.events = v.events
      }
      if (v.weight !=null){
        t.weight = v.weight
      }
       temp.push(t)
    }

  // -- we don't know the directory name in chidren table thougn there is weight from index.lua
  for (const [k, v] of children) {
    const t = {weight:null}
    if (k !='weight'){
       t[k] = v;
       temp.push(t)
       if (t.weight == null){
         t.weight = children.get('weight')
       }
    }
  }
  return temp;
}
//
// components = {
//   audios = [audioOne:{}, audioTwo:{}]
//   groups = {},
//   others = {},
//   timers = {},
//   variables = {}
// },
//
export async function parseComponentFiles(folder){
  const ret = {}
  const folderNames = ["audios", "groups", "others", "times", "variables"];
  for (const name of folderNames){
    const subFolder = await getFolder(name, folder);
    ret[name]= await layerIterator(subFolder, null, null);
  }
  return ret;
}

export async function parseLayerFiles(folder, commands){
  const eventsMap = {}
  for (const event of commands){
      const splitTable = event.split('.');
    if (splitTable.length > 1 ){
      let t = eventsMap[splitTable[0]];
      if (t == null ){
        t = []
        eventsMap[splitTable[0]] = t
      }
      t.push(splitTable[1]);
    }
  }
  return await layerIterator(folder, null, eventsMap)
}