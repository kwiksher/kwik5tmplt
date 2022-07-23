import React, { useState, useEffect, useRef } from 'react';
import ReactDOM from 'react-dom'
import './style.css';
import { storage } from 'uxp';


import Spectrum, { ActionButton, Checkbox, Textfield } from 'react-uxp-spectrum';
// import StyledComponents from "./components/StyledComponents";

import { publishCodeHandler } from './commands/publishCodeHandler';
import { newProjectHandler } from './commands/newProjectHandler';
import { publishAssetsHandler } from './commands/publishAssetHandler';
import { selectPSDHandler } from './commands/selectPSDHandler';
import { PhotoshopTable } from "./components/PhotoshopTable"
import { publishAllHandler } from './commands/publishAllHandler';
import { PublishPopup} from './components/PublishPopup'

import { SortSampleApp } from './components/SortSampleApp';

import { DroppableListBoxExample } from './components/DroppableListBoxExample'
import { TextFonts } from 'photoshop/dom/collections/TextFonts';

const App: React.FC<any> = () => {

  //const [token, setToken] = useState(false);
  //const [entry, setEntry] = useState(null);

  /*
    projectRoot/App/book
  */


  //// Publish with export image
  // const docLayers = app.activeDocument.layers;
  //   exportLayer

  //// Publish without export image - Refresh
  // const docLayers = app.activeDocument.layers;
  //   scaffoldLayer
  //   render models/page/
  //                     /components
  //                     /events
  //                     /layers
  //    if layer is not found, rename .lua to .lua.bak
  //    if layer has a binded component or an event
  //       layer.type = {button, animation ..}, layer.events = {drag, select..}
  //   render scenes/page.json or page.lua
  //
  //   list .lua.bak for removed events or components
  //   list components/actions/events
  //
  //   if user select a layer in Layer panel
  //      update Kwik original Layer Props Panel
  //         lists components
  //   current model.lua or .json does not relate an event with a component.
  //   This is done by a button editor or by a action editor
  //   for a component/action to dispatch a selected event.
  //   each event has a corresponding action.
  //
  //   so UI for user to add an event, it creates an event in scens/page.lua
  //   and also create eventname.lua in models/page/events folder.
  //   eventname.lua has a props table for actions.


  ////////

  const openProjectHandler = async() =>{
    // list the projects
    // user selects a project
    //   getEntryForPersistentToken(token)
    // list .psd from views/index.lua or index.json
    // open the psd of the first order
  }

  const newDocumentHandler = async() =>{
    // new psd
    //   views/index.lua to add the entry
  }

  const openDocumentHandler = async() =>{
    // user selects a psd in the list
  }

  const [isReset, setIsReset] = useState(false);
  const [psds, setPSDs] = useState([])
  const [selections, setSelections] = useState([])
  const [psdFolder, setPSDFolder] = useState()
  const [bookFolder, setBookFolder] = useState({nativePath:'please set an output book folder under App'});
  const [isAll, setIsAll] = useState(false)
  const [textRange, setTextRange] = useState("")

  const onChange = () =>{
    setIsReset(!isReset);
  }

  const onAll = () =>{
    setIsAll(!isAll);
    if (!isAll){
      setTextRange("0-"+(psds.length-1))
    }else{
      setTextRange("")
    }
  }

  const selectPSDFolder = () =>{
    selectPSDHandler(isReset, setPSDs, setPSDFolder);
  }

  const selectBookFolder = async () =>{
    const fs = storage.localFileSystem;
    let folder = await fs.getFolder();
    if (folder) setBookFolder(folder);
  }

  const onTextfield = (event) =>{
    console.log(event.target.value)
  }

  const publishPopup = useRef(); // Reference for the <dialog> element
  let publishDialog = null

  const publishAll = async (event) =>{
    //dialog
    if (!publishDialog) {
      publishDialog = document.createElement("dialog");
      ReactDOM.render(<PublishPopup dialog={publishDialog} bookFolder = {bookFolder} setBookFolder={setBookFolder} />, publishDialog);
    }
    document.body.appendChild(publishDialog);

    const response = await publishDialog.uxpShowModal({
      title: "Export Settings",
      resize: "both",
      size: {
        width: 400,
        height: 200
      }
    });
    console.log("RESPONZE", response);
    // God, why have I to do that
    if (!response ||
      response === "reasonCanceled" ||
      response.reason === "reasonCanceled") {
      }else if (response.reason === "OK") {
        const target = {selections:selections, isAll:isAll, textRange:textRange};
        console.log("publishAll",target);
        publishAllHandler(event, target, psdFolder, bookFolder)
      }
      publishDialog.remove();
  }

  return (
    <>
      <sp-heading size="XXS">Photoshop Files</sp-heading>
      <ul>
      <li>
        <ActionButton onClick={selectPSDFolder}>Open</ActionButton>
        <Checkbox onChange={onChange}>Reset</Checkbox>
      </li>
      </ul>
      <hr/>
      <PhotoshopTable files={psds} psdFolder={psdFolder} setSelections = {setSelections} setFiles = {setPSDs} selected={isAll?true:null} />
      <hr/>
      <sp-heading size="XXS">Solar2D Project</sp-heading>
      <ul>
      <li>
        <ActionButton onClick={newProjectHandler}>New</ActionButton>
        <ActionButton onClick={selectBookFolder}>Select Book</ActionButton>
        <sp-heading size="XXS">{bookFolder.nativePath}</sp-heading>
      </li>
      </ul>
      <sp-heading size="XXS">Publish</sp-heading>
      <ul>
      <li>
         <ActionButton onClick={publishAll}>Publish</ActionButton>
         <Checkbox onChange={onAll}>all</Checkbox>
         <Textfield placeholder={textRange} className="textField" onChange={onTextfield}></Textfield>
      </li>
      </ul>
      <sp-heading size="XXS">Active Document</sp-heading>
      <ActionButton onClick={publishAssetsHandler}>Export Images</ActionButton>
      <ActionButton onClick={publishCodeHandler}>Export Code</ActionButton>
      <hr/>

      //
      {/*
      <SortSampleApp />
      <DroppableListBoxExample />
      <ActionButton onClick={newProjectHandler}>New Projectt</ActionButton>
      <ActionButton onClick={openProjectHandler}>Open Project</ActionButton>
      <ActionButton onClick={newDocumentHandler}>New Document</ActionButton>
      <ActionButton onClick={openDocumentHandler}>Open Document</ActionButton> */}
      {/* <StyledComponents exportLayer={layer} folder={entry} /> */}
    </>
  )
}

export default App;
