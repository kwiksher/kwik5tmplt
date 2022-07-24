import { storage } from 'uxp';
import { app } from 'photoshop'
import { LayerKind} from 'photoshop/dom/Constants';

export const unmergeHandler = async (props) => {
  console.log("unmerge groups")
  const layers = app.activeDocument.activeLayers;
  let ret = []
  for (const layer of layers){
    if (layer.kind == LayerKind.GROUP){
      console.log(layer.name)
      ret.push({name:layer.name, key:layer.id})
    }
  }
  props.setGroups(ret)

  // TODO create foldes in App/book/assets/images/bookX/

}

export const unmergeCancelHandler = async (props) => {
  console.log("unmerge cancel")

  //TODO remove folders

}

export const loadUnmergedGroups = async(bookFolder, setGroups) =>{
  const bookName = app.activeDocument.name;
  let ret = []

  // TODO read folders in App/book/assets/images/bookX/

  setGroups(ret);
}

export const initListener = (bookFolder, setGroups) =>{
  require('photoshop').action.addNotificationListener([
    { event: "select" },
    { event: "open" },
    { event: "close" }
  ], () => loadUnmergedGroups(bookFolder, setGroups));
}