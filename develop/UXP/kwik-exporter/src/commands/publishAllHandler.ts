import { app } from 'photoshop'
import { publishCode } from '../photoshop/publishCode';
import { publishImages } from '../photoshop/publishImages';
import {getFolder, isFile, isFolder} from '../utils/storage'


const executeAsModal = require("photoshop").core.executeAsModal;

export const publishAllHandler = async (event, target, projectFolder, bookFolder) => {

  let selections = target.selections.filter(item=>item.selected);

  if ((selections.length ==0) && target.isAll ){
    selections = target.selections;
  }
  const entries = await bookFolder.getEntries();
  const b = isFolder('models', bookFolder);

  if (! await isFolder('models', bookFolder)){
    await bookFolder.createFolder("models");
  }

  if (! await isFolder('scenes', bookFolder)){
    await bookFolder.createFolder("scenes");
  }
  if (! await isFolder('assets', bookFolder)){
    const parent = await bookFolder.createFolder("assets");
    if (! await isFolder('images', parent)){
      await parent.createFolder("images");
    }
  }

  // TODO target.textRange
  //
  // open&close
  try{
    for( const item of selections){
      const psd = await projectFolder.getEntry(item.value)
      await executeAsModal(async()=>{
        const doc = await app.open(psd);
        await publishCode(bookFolder)
        await publishImages(bookFolder)
        doc.closeWithoutSaving();
      },{ "commandName": "Opening..." })
    }
  }catch(e){
    console.log(e)
  }
}

