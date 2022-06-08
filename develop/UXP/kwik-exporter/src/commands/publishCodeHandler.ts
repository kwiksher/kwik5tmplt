import { storage } from 'uxp';
import { publishCode } from '../photoshop/publishCode';

export const publishCodeHandler = async (event) => {
  if (event.ctrlKey) {
    console.log("crt")
  } else if (event.metaKey) {
    console.log("meta")
  } else {
    console.log(event)
  }

  const fs = storage.localFileSystem;
  let bookFolder = await fs.getFolder();

  publishCode(bookFolder);
}

