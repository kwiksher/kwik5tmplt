import { storage } from 'uxp';

const getImageData = async (image: storage.Entry) => {
  if (!image) return null;
  if (!image.isFile) throw new Error(`${image.name} is not a file`);

  const file = image as storage.File;
  const data = (await file.read({ format: storage.formats.binary })) as ArrayBuffer;
  console.log('bytelength', data.byteLength);
  if (data.byteLength === 0) return null;
  return data;
};

export const loadImageFromFolder = async (
  folder: storage.Folder,
  imageName: string,
  attempts = 100
): Promise<string> => {
  const name = imageName.concat('.png');

  let image: storage.Entry;
  let attemptsLeft = attempts;
  let data: ArrayBuffer | false;

  console.log((await folder.getEntries()).map((entry) => entry.name));

  while ((!image || !data) && attemptsLeft > 0) {
    const entriesArray = await folder.getEntries();
    image = entriesArray.find((entry) => entry.name === name);
    data = await getImageData(image);
    await new Promise((res) => setTimeout(res, 50));
    attemptsLeft -= 1;
  }

  console.warn('loaded file with', attemptsLeft, 'attempts left');

  if (!image) throw new Error(`Image ${imageName}.png not found`);
  if (!data) throw new Error(`No data in image: ${imageName}.png`);

  const uInt8Array = new Uint8Array(data);
  const blob = new Blob([uInt8Array]);
  const url = URL.createObjectURL(blob);

  //await image.delete();

  return url;
};
