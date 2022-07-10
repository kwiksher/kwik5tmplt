import {getFolder, isFile, isFolder} from './storage';
import { storage } from 'uxp';
import { Children } from 'react';


export async function parseCommandFiles(folder){ 
  const ret = [];
  const eventIterator = async(folder, parent) =>{
    let  parentPath = ""
    if (parent){
        parentPath = parent.name + ".";
    }
    const entries = await folder.getEntries();
    for (var i = 0; i < entries.length; i++) {
      let element = entries[i];
      if (element.isFile && element.name.indexOf('.lua') > 0 ){
        const value = parentPath +  element.name.gsub(".lua", "")
        ret.push(value)
        console.log(value)
      }else if(element.isFolder && element.name.len() > 2){
        eventIterator(element, folder)
      }
    }    
  }
  await eventIterator(folder, null) 
  return ret;
}


const types = ["button", "animation"];

const layerIterator = async(folder, parent, eventsMap) =>{
  const layerMap = {};
  const children  = {}

  let  parentPath = ""
  if (parent){
      parentPath = parent.name + ".";
  }
  const entries = await folder.getEntries();
  for (var i = 0; i < entries.length; i++) {
    let element = entries[i];
    if (element.isFile && element.name.indexOf('.lua') > 0 ){
      const layerName = element.name.gsub(".lua", "");
      if (layerName !='index'){
        let layer = layerMap[layerName];
        if (layer == null){
          layer = {};
          layer.weight = readWeight(element);
          layerMap[layerName] = layer;
          if (eventsMap){
            layer.events = eventsMap[layerName];
          }
        }
        for (const type of types){
          if (element.name.indexOf("_"..type..".lua")){
            if (layer.types == null){
              layer.types = {}
            } 
            layer.types.push(type)
          }
        }
      }
    }else if(element.isFolder && element.name.len() > 2){
      const elements = await layerIterator(element, folder, eventsMap)
      children[element.name] = elements;
      children.weight = readWeight(element, "index.lua")
    }
  }    
  // -- we don't know the directory name in chidren table thougn there is weight from index.lua
  // for k, v in pairs(children) do
  //     -- print("child key", k)
  //     local t = {}
  //     if tostring(k) ~= "weight" then
  //         t[tostring(k)] = v
  //         temp[#temp +1] = t
  //         if t.weight == nil then
  //             -- set the weight from index.lua
  //             t.weight = children.weight
  //         end
  //     end
  // end
  
  // table.sort(temp,
  // function(a,b)
  //     return (a.weight < b.weight)
  // end)
  
  // for index, value in pairs(temp) do
  //     temp[index].weight = nil
  // end
  
  // return temp
  // end
  // --
  
  
  export async function parseComponentFiles(folder){ 
    
    // local children = layerIterator(path)
  
  return [];
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
  //
  // local children = layerIterator(path)
  //
 return [];
}