import { storage } from 'uxp';
import { app, core } from 'photoshop'
import { LayerKind} from 'photoshop/dom/Constants';
import {getImageFolders} from '../utils/assetParser'
import {getFolder, isFile, isFolder} from '../utils/storage';

//https://github.com/t-kuni/js-hira-kata-romanize
const Romanizer = require('js-hira-kata-romanize')

const r = new Romanizer({
  chouon: Romanizer.CHOUON_SKIP
});

function validate (str){
  let test = str.replace(/\s+/g, '_')
  test = r.romanize(test);
  test = test.replace(/[^A-Z a-z0-9]/ , '_')
  test = test.slice(0, 16)
  test = isNaN(test)?test:"_" + test

  if (test == str){
    return null
  }else{
    return test
  }
}

export const validateLayerNamesHandler = async (event) => {
  console.log("validateLayerNamesHandler")

  const docName = app.activeDocument.name.replace(".psd","")
  const docLayers = app.activeDocument.layers;
  const objs = [];

  const iterator = async (docLayers, parent):Promise<any> => {
    for (let i = 0; i < docLayers.length; i++) {
      const layer = docLayers[i];
      const obj = {};
      obj[docLayers[i].name] = [];

      const changed = validate(layer.name)
      if (changed !=null){
        objs.push(parent + layer.name)
        layer.name = changed
      }

      if (layer.kind == LayerKind.GROUP){
        await iterator(layer.layers, layer.name + "/");
      }

    }
  }

  await core.executeAsModal(
    async () => {
      await iterator(docLayers, "");
    },
    { commandName: `Validate Layer Names` }
  );
}

