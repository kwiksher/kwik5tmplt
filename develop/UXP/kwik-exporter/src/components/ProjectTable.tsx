import React, { useState, useEffect, useRef } from 'react';
import { Button } from 'react-uxp-spectrum';
import { useDnDSort, DnDRef} from "./useDnDSort";

export interface ProjectProps {
  files:any;
  path:string;
  selections:any;
  setSelections:any;
  setFiles:any;
}


type Style<T extends HTMLElement> = React.HTMLAttributes<T>["style"];

const bodyStyle: Style<HTMLDivElement> = {
  height: "100vh",
  display: "flex",
  overflow: "hidden",
  alignItems: "center",
  justifyContent: "center"
};

const containerStyle: Style<HTMLDivElement> = {
  display: "flex",
  flexWrap: "wrap",
  justifyContent: "space-between",
  width: "100%",
  maxWidth: "350px",
  maxHeight: "500px"
};

const imageCardStyle: Style<HTMLDivElement> = {
  cursor: "grab",
  userSelect: "none",
  width: "100px",
  height: "130px",
  overflow: "hidden",
  borderRadius: "5px",
  margin: 3
};

export const ProjectTable: React.FC<ProjectProps> =(props:ProjectProps)=> {
  //
  // https://forums.creativeclouddeveloper.com/t/bug-disabled-in-select-option-does-not-work/2270/5
  // https://codereview.stackexchange.com/questions/242077/parsing-numbers-and-ranges-from-a-string-in-javascript
  // https://www.npmjs.com/package/parse-numeric-range
  //
  //
  // selections [{psd=item, alias=alias}]
  //
  // change order by drag & drop
  // save the ordered list to a json file
  //

  let timer = 0;
  let delay = 200;
  let prevent = false;

  const doClickAction = (event) => {
    console.log(' click');
  }

  const doDoubleClickAction = (event) => {
    console.log('Double Click')
  }

  const handleClick = (event) => {
    timer = setTimeout(function() {
      if (!prevent) {
        doClickAction(event);
      }
      prevent = false;
    }, delay);
  }

  const handleDoubleClick = (event) =>{
    clearTimeout(timer);
    prevent = true;
    doDoubleClickAction(event);
  }

  //https://zenn.dev/uttk/articles/b90454baec68c8

  console.log("ProjectTable props.files.length", props.files.length);


  const list:string[] = [];
  const [itemsSorted, setItems] = useState([]);
  const [dnds, setDnDs] = useState([]);

  // props.files.map(item=>list.push(item.name))
  // const dnds = useDnDSort(list, setItems);
  // setDnDs(ret)

  // 状態をrefで管理する
  const state = useRef<DnDRef<any>>({
    dndItems: [],
    keys: new Map(),
    dragElement: null,
    canCheckHovered: true,
    pointerPosition: { x: 0, y: 0 }
  }).current;

  useEffect(() => {
    props.files.map(item=>list.push(item.name))
    const ret = useDnDSort(list, setDnDs, props.setFiles, state);
    setDnDs(ret);
  }, [props.files]);

  console.log(list, dnds);

  return (
    <>
      <sp-heading>{props.path}</sp-heading>
      <sp-menu multiple slot="options">
      {dnds.map((item, idx) => (
        <div key={item.key} {...item.events}>
          <sp-menu-item key={idx}>
              <div onClick={handleClick}
                onDoubleClick = {handleDoubleClick} >
              {item.value}
              </div>
            </sp-menu-item>
        </div>))}
      </sp-menu>
      <hr/>
      <div style={bodyStyle}>
      <div style={containerStyle}>
        {dnds.map((item) => (
          <div key={item.key} style={imageCardStyle} {...item.events}>
            <h1>
            {item.value}
            </h1>
          </div>
        ))}
      </div>
    </div>
    </>
  );
}

export default ProjectTable;