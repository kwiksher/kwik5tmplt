import { useState } from "react";
import {Button, Checkbox } from 'react-uxp-spectrum';

export const PublishPopup = ({ dialog }) => {

  const [exportCode, setExportCode] = useState(true);
  const [exportImages, setExportImages] = useState(true);

  const buttonHandler = (reason) => {
    const retObj = {
      reason,
      isExportImages: exportImages,
      isExportCode:exportCode
    }
    dialog.close(retObj);
  }

  return (
    <form method="dialog" className="aboutDialog">
      <div className="column">
        <Checkbox checked onChange={(event) => setExportCode(!exportCode)}>
        Export Code</Checkbox>
        <Checkbox checked onChange={(event) => setExportImages(!exportImages)}>
        Export Images
        </Checkbox>

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