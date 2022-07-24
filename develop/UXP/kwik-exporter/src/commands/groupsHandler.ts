import { storage } from 'uxp';
import { app } from 'photoshop'
import { LayerKind} from 'photoshop/dom/Constants';
import {getImageFolders} from '../utils/assetParser'
import { getFolder } from '../utils/storage';

const getParent = (element) =>{
  let parentPath = ""
  if (element.parent != null) {
    const path = getParent(element.parent);
    if (path.length > 0){
      parentPath = element.parent.name + "." + path
    }else{
      parentPath = element.parent.name
    }
  }
  return parentPath
}

export const unmergeHandler = async (props) => {
  console.log("unmerge groups")

  const imageMap = await getImageFolders(props.bookFolder)

  const layers = app.activeDocument.activeLayers;
  let ret = []
  for (const layer of layers){
    if (layer.kind == LayerKind.GROUP){
      console.log(layer.name)
      const obj = imageMap.get(layer.name);
      if (obj == null){
        const parentPath = getParent(layer);
        ret.push({name:layer.name, key:ret.length, parent:parentPath, isNew:true})
      }
    }
  }

  console.log("imageMap length", imageMap.size)
  imageMap.forEach((value, key) => {
    ret.push({name:key, key:ret.length, parent:value.parent})
  });

  console.log(ret)
  props.setGroups(ret)
  //
  // create foldes under App/book/assets/images/bookX/
  /*
  {
    "name": "SubA", "key": 0, "parent": "GroupA", "isNew": true
  }
  */
  //
  const docName = app.activeDocument.name.replace(".psd","")
  const assetsFolder = await getFolder("assets", props.bookFolder)
  const imagesFolder = await getFolder("images", assetsFolder)
  const pageFolder   = await getFolder(docName, imagesFolder)

  const newFolders = ret.filter(element=>element.isNew)
  for (let folder of newFolders){
    if (folder.parent.length > 0){
      const paths = folder.parent.split(".")
      let lastFolder = await getFolder(paths[0], pageFolder)
      for (var i=0;i<paths.length-1;i++){
          const folderName = paths[i+1]
          const parentFolder = paths[i]
          lastFolder = await getFolder(folderName, parentFolder)
      }
      await getFolder(folder.name, lastFolder)
    }else{
      await getFolder(folder.name, pageFolder)
    }
  }
}

export const unmergeCancelHandler = async (props) => {
  console.log("unmerge cancel", props)
  const docName = app.activeDocument.name.replace(".psd","")
  const assetsFolder = await getFolder("assets", props.bookFolder)
  const imagesFolder = await getFolder("images", assetsFolder)
  const pageFolder   = await getFolder(docName, imagesFolder)
  const deleteGroups = props.groups.filter(element=>element.selected)
  console.log("delete groups length", deleteGroups.length)
  //
  for (let folder of deleteGroups){
    let targetFolder
    if (folder.parent.length > 0){
      const paths = folder.parent.split(".")
      let lastFolder = await getFolder(paths[0], pageFolder)
      for (var i=0;i<paths.length-1;i++){
          const folderName = paths[i+1]
          const parentFolder = paths[i]
          lastFolder = await getFolder(folderName, parentFolder)
      }
      targetFolder = await getFolder(folder.name, lastFolder)
    }else{
      targetFolder = await getFolder(folder.name, pageFolder)
    }

    let entries = await targetFolder.getEntries()
    for (let entry of entries){
      await entry.delete()
    }
    await targetFolder.delete()
  }
  const updated = props.groups.filter(element=>element.selected !=true)
  props.setGroups(updated)
}

export const loadUnmergedGroups = async(bookFolder, setGroups) =>{
  const bookName = app.activeDocument.name;
  let ret = []

  // TODO read folders in App/book/assets/images/bookX/

  setGroups(ret);
}

export const initListener = (bookFolder, setGroups) =>{
  require('photoshop').action.addNotificationListener([
    { event: "select" },
    { event: "open" },
    { event: "close" }
  ], () => loadUnmergedGroups(bookFolder, setGroups));
}