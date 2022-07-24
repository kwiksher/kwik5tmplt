import { storage } from 'uxp';
import { publishImages } from '../photoshop/publishImages';

export const publishAssetsHandler = async (event) => {
  if (event.ctrlKey) {
    console.log("crt")
  } else if (event.metaKey) {
    console.log("meta")
  } else {
    console.log(event)
  }

  const fs = storage.localFileSystem;
  let bookFolder = await fs.getFolder();

  publishImages(bookFolder);
}
