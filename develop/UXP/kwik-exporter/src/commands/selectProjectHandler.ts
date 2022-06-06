import { storage } from 'uxp';

// import Spectrum, { ActionButton } from 'react-uxp-spectrum';
// import StyledComponents from "../components/StyledComponents";

export const selectProjectHandler = async() =>{
  // open dialog
  // getFolder

  const fs = storage.localFileSystem;
  let distFolder = await fs.getFolder();

  let pluginFolder  = await fs.getPluginFolder();
  let tmpltFolder = await pluginFolder.getEntry("kwik/Solar2D") as storage.Folder;


  const entries = await distFolder.getEntries();
  const psds = entries.filter(entry=>entry.name.endsWith('.psd'))

  const app = require("photoshop").app;
  const index = 0;
  await app.open(psds[index]);

  // cp kwik
  //    user choose KwikShelf structure or single structre
  //
  // new psd
  // add the project to the list
  // createPersistentToken(entry)

}
