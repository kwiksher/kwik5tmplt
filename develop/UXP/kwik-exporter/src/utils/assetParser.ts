import {getFolder, isFile, isFolder} from '../utils/storage';

const imageIterator = async(imageMap, folder, parent) =>{
  const children  = new Map();
  //
  let  parentPath = ""
  if (parent){
      parentPath = parent.name + ".";
  }
  //
  const entries = await folder.getEntries();
  for (var i = 0; i < entries.length; i++) {
    let element = entries[i];
    if (element.isFile){
      //imageMap.set(element.name, {isFolder:false, parent:parentPath})
    }else if(element.isFolder){
      const elements = await imageIterator(imageMap, element, folder)
      children.set(element.name,elements);
      imageMap.set(element.name, {isFolder:true, parent:parentPath, children:children})
    }
  }
  return imageMap
}

export const getImageFolders = async(folder) =>{
  const imageMap = new Map()

  imageIterator(imageMap, folder, null);

  return imageMap
}