import { useState } from "react";
import {Button, Checkbox } from 'react-uxp-spectrum';
import { storage } from 'uxp';


export const PublishPopup = ({ dialog, bookFolder, setBookFolder }) => {

  const [exportCode, setExportCode] = useState(true);
  const [exportImages, setExportImages] = useState(true);
  const [distFolder, setDistFolder] = useState(bookFolder.nativePath);

  const buttonHandler = (reason) => {
    const retObj = {
      reason,
      isExportImages: exportImages,
      isExportCode:exportCode
    }
    dialog.close(retObj);
  }

  const appFolderHandler = async (event) =>{
    const fs = storage.localFileSystem;
    let folder = await fs.getFolder();
    setBookFolder(folder);
    setDistFolder(folder.nativePath)
    console.log(folder.nativePath);

  }


  return (
    <form method="dialog" className="aboutDialog">
      <div className="column">
        <Checkbox checked onChange={(event) => setExportCode(!exportCode)}>
        Export Code</Checkbox>
        <Checkbox checked onChange={(event) => setExportImages(!exportImages)}>
        Export Images
        </Checkbox>

        <sp-heading size="XXS">{distFolder}</sp-heading>

        <Button
            quiet
            onClick={appFolderHandler}
            style={{ marginLeft: "auto" }}>
            Browse
          </Button>


        <footer>
          <Button
            variant="secondary"
            quiet
            onClick={() => buttonHandler("reasonCanceled")}
            style={{ marginLeft: "auto" }}>
            Cancel
          </Button>
          <Button
            autofocus
            variant="primary"
            onClick={() => buttonHandler("OK")}>
            Export
          </Button>

        </footer>
      </div>
    </form>
  );
}

export default PublishPopup;