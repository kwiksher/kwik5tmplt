import { storage } from 'uxp';

export const isUpdated = async (
  after: number,
  folder: storage.Folder,
  attempts = 1000
): Promise<boolean> => {
  let attemptsLeft = attempts;

  const entries = await folder.getEntries();
  let files = entries.filter(entry => entry.isFile);

  //console.log("isUpdated", after, folder.nativePath)
  while (files.length < after && attemptsLeft > 0) {
    const entries = await folder.getEntries();
    files = entries.filter(entry => entry.isFile);
    await new Promise((resolve) => setTimeout( async () =>{
      resolve(true)}, 50));
    attemptsLeft -= 1;
  }
  //
  if (attemptsLeft < 0 ){
    console.warn('isUpdated', folder.nativePath, attemptsLeft);
  }
  return attemptsLeft > 0
};

export const isFolder = async (folderName, parentFolder): Promise<boolean> => {
  let destArr = (await parentFolder.getEntries()).filter(entry => entry.name == folderName);
  return destArr.length > 0 && destArr[0].isFolder;
}

export const isFile = async (folderName, parentFolder): Promise<boolean> => {
  let destArr = (await parentFolder.getEntries()).filter(entry => entry.name == folderName);
  return destArr.length > 0 && destArr[0].isFile;
}

export const getFolder = async (folderName, parentFolder): Promise<storage.Folder> => {
  const destArr = (await parentFolder.getEntries()).filter(entry => entry.name == folderName);
  if (destArr.length == 0) {
    return  await parentFolder.createFolder(folderName);
  } else {
    return destArr[0];
  }
}

export async function copyAll(src, dist){
  const entries = await src.getEntries();
  for (var i = 0; i < entries.length; i++) {
    let element = entries[i];
    if (element.isFile){
      console.log(element)
      element.copyTo(dist, {overwrite:false})
    }else{
      console.log("", element)
      let folder = await getFolder(element.name, dist);
      await copyAll(element, folder);
    }
  }
}
