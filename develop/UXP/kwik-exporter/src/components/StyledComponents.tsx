import React, { useState, useEffect } from 'react';
import styled from "styled-components"
import { Layer } from 'photoshop/dom/Layer'; // Credit to Hans Otto Wirtz for the Typescript library
import {exportLayerAsPng, exportLayerAsPngAndLoad, exportLayerAsJpegAndLoad } from './exportLayer';

import Spectrum from 'react-uxp-spectrum';

interface Props {
  exportLayer: Layer;
  folder:any
  // token:any;
}

export const ModuleStyles: React.FC<Props> = (props: Props) => {
//const ModuleStyles = () => {
  const { exportLayer, folder} = props;
  const [loading, setLoading] = useState(false);
  const [imageUrl, setImageUrl] = useState(null);

  const data = async(exportLayer, folder) => {
    const url = await exportLayerAsPngAndLoad(exportLayer, folder);
    console.log(url);
    setImageUrl(url);
  }

  console.log("ModuleStyles", folder)
  if (folder && exportLayer && imageUrl == null){
     data(exportLayer, folder);
  }

//  useEffect(() => {
//     if(exportLayer && folder==null) {
//        console.log("useEffect", folder)
//        setLoading(true);
//        data(exportLayer, folder)
//        setLoading(false);
//     }
//  }, [exportLayer]);

const Container = styled.div`
  border: 1px solid #888;
  border-radius: 4px;
  padding: 10px;
  margin-bottom: 4px;
  min-width: min-content;
  sp-detail { min-width: 150px; }
  sp-textfield { flex-grow: 1; min-width: 150px; }
  sp-action-button { flex-grow: 1; max-width: 100px; }
`
  return (
    <Container className="row">
      {(imageUrl && (
        <div>
          <img className="background" src="/img/BackGround.png" alt="Background" />
          {(!loading && <img className="image" src={imageUrl} alt="BaseLayer" />) || (
            <img className="loading" src="/img/Loading.gif" alt="loading" />
          )}
        </div>
      )) || <sp-action-button>Select</sp-action-button>}
    </Container>
  );
}

export default ModuleStyles;