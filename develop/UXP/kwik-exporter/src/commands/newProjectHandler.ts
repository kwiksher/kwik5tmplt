import { storage } from 'uxp';
import {copyAll} from '../utils/storage'

export const newProjectHandler = async() =>{
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
