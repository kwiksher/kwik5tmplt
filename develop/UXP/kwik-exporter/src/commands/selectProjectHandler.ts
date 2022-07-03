import { storage } from 'uxp';

// import Spectrum, { ActionButton } from 'react-uxp-spectrum';
// import StyledComponents from "../components/StyledComponents";

const app = require("photoshop").app;
const executeAsModal = require("photoshop").core.executeAsModal;

export const selectProjectHandler = async(reset:boolean, setPSDs, setProjectFolder) =>{
  // open dialog
  // getFolder
  const fs = storage.localFileSystem;
  //const pluginFolder  = await fs.getPluginFolder();
  //const tmpltFolder = await pluginFolder.getEntry("kwik/Solar2D") as storage.Folder;

  let projectFolder, doc, doc1, tries = 3, success = false;

  if (reset){
    projectFolder = await fs.getFolder();
    localStorage.setItem("persistent-project-folder", await fs.createPersistentToken(projectFolder));
  }else{
    while (tries > 0) {
        try {
            projectFolder = await fs.getEntryForPersistentToken(localStorage.getItem("persistent-project-folder"));
            tries = 0;
            success = true;
        } catch (err) {
            projectFolder = await fs.getFolder();
            localStorage.setItem("persistent-project-folder", await fs.createPersistentToken(projectFolder));
            tries--;
        }
    }
  }

  if (success) {
    const entries = await projectFolder.getEntries();
    const psds = entries.filter(entry=>entry.name.endsWith('.psd'))
    for (const psd of psds) {
      console.log("Opening", psd.name);
    }
    setPSDs(psds);
    setProjectFolder(projectFolder);
    //
    // test open&close
    /*
    try{
      const psd = await projectFolder.getEntry(psds[0].name)
      await executeAsModal(async()=>{
        doc = await app.open(psd);
        doc.closeWithoutSaving();
      },{ "commandName": "Opening..." })
      //doc1 = await app.open(psds[1]);
      //
      //doc1.closeWithoutSaving()
    }catch(e){
      console.log(e)
    }
    */

  }else{
    // fail gracefully somehow
  }

  // cp kwik
  //    user choose KwikShelf structure or single structre
  //
  // new psd
  // add the project to the list
  // createPersistentToken(entry)

}
