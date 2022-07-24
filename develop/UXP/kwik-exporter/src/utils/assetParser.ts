import {getFolder, isFile, isFolder} from '../utils/storage';

const imageIterator = async(folder, path) =>{
  const imageMap  = new Map();
  //
  let  parentPath = path || ""
  //
  const entries = await folder.getEntries();
  for (var i = 0; i < entries.length; i++) {
    let element = entries[i];
    if (element.isFile){
      //imageMap.set(element.name, {isFolder:false, parent:parentPath})
    }else if(element.isFolder){
      imageMap.set(element.name, {isFolder:true, parent:parentPath})
      const children = await imageIterator(element, element.name)
      children.forEach((value, key) => {
        if (parentPath.length > 0){
          imageMap.set(key,{isFolder:true, parent:parentPath + "." + value.parent})
        }else{
          imageMap.set(key,{isFolder:true, parent:value.parent})
        }
      })
    }
  }
  return imageMap
}

export const getImageFolders = async(folder) =>{
  const imageMap = await imageIterator(folder, null);
  return imageMap
}