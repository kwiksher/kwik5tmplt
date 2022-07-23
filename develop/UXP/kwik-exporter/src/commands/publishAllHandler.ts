import { app } from 'photoshop'
import { publishCode } from '../photoshop/publishCode';
import { publishImages } from '../photoshop/publishImages';
import {getFolder, isFile, isFolder} from '../utils/storage'


const executeAsModal = require("photoshop").core.executeAsModal;

export const publishAllHandler = async (event, target, srcFolder, outFolder) => {

  let selections = target.selections.filter(item=>item.selected);

  if ((selections.length ==0) && target.isAll ){
    selections = target.selections;
  }
  const entries = await outFolder.getEntries();
  const b = isFolder('models', outFolder);

  if (! await isFolder('models', outFolder)){
    await outFolder.createFolder("models");
  }

  if (! await isFolder('scenes', outFolder)){
    await outFolder.createFolder("scenes");
  }
  if (! await isFolder('assets', outFolder)){
    const parent = await outFolder.createFolder("assets");
    if (! await isFolder('images', parent)){
      await parent.createFolder("images");
    }
  }

  // TODO target.textRange
  //
  // open&close
  try{
    for( const item of selections){
      const psd = await srcFolder.getEntry(item.value)
      await executeAsModal(async()=>{
        const doc = await app.open(psd);
        await publishCode(outFolder)
        await publishImages(outFolder)
        doc.closeWithoutSaving();
      },{ "commandName": "Opening..." })
    }
  }catch(e){
    console.log(e)
  }
}

