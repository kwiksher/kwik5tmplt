import { app } from 'photoshop'
import { publishCode } from '../photoshop/publishCode';
import { publishImages } from '../photoshop/publishImages';

const executeAsModal = require("photoshop").core.executeAsModal;

export const publishAllHandler = async (event, selections, projectPath, appFolder, setAppFolder) => {
  //
  // open&close
  try{
    for( const item of selections){
      const psd = await projectPath.getEntry(item.name)
      await executeAsModal(async()=>{
        const doc = await app.open(psd);
        await publishCode(appFolder)
        await publishImages(appFolder)
        doc.closeWithoutSaving();
      },{ "commandName": "Opening..." })
    }
  }catch(e){
    console.log(e)
  }
}

