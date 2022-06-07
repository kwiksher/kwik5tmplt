import React, { useState, useEffect } from 'react';

import Spectrum, { ActionButton, Checkbox } from 'react-uxp-spectrum';
// import StyledComponents from "./components/StyledComponents";

import { publishHandler } from './commands/publishHandler';
import { newProjectHandler } from './commands/newProjectHandler';
import { publishAssetsHandler } from './commands/publishAssetHandler';
import { selectProjectHandler } from './commands/selectProjectHandler';
import {ProjectTable} from './components/ProjectTable';

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
  const [projectPath, setProjectPath] = useState("")


  const onChange = () =>{
    setIsReset(!isReset);
  }

  const selectProject = () =>{
    selectProjectHandler(isReset, setPSDs, setProjectPath);
  }

  return (
    <>
      <ul>
      <li><ActionButton onClick={publishAssetsHandler}>Export Images</ActionButton></li>
      <li><ActionButton onClick={publishHandler}>Export Codes</ActionButton></li>
      </ul>
      <hr/>
      <ul>
      <li><ActionButton onClick={newProjectHandler}>New Project</ActionButton></li>
      <li><ActionButton onClick={ selectProject }>Select Project</ActionButton><Checkbox onChange={onChange}>:Reset</Checkbox></li>
      </ul>

      <ProjectTable files={psds} path={projectPath}/>

      //
      {/* <ActionButton onClick={newProjectHandler}>New Projectt</ActionButton>
      <ActionButton onClick={openProjectHandler}>Open Project</ActionButton>
      <ActionButton onClick={newDocumentHandler}>New Document</ActionButton>
      <ActionButton onClick={openDocumentHandler}>Open Document</ActionButton> */}
      {/* <StyledComponents exportLayer={layer} folder={entry} /> */}
    </>
  )
}

export default App;
