import React, { useState, useEffect } from 'react';
import { Button } from 'react-uxp-spectrum';
import { DragDropContext, Droppable, Draggable } from "react-beautiful-dnd";

export interface ProjectProps {
  files:any;
  path:string;
  selections:any;
  setSelections:any;
}

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

  const [characters, updateCharacters] = useState([]);
  function handleOnDragEnd(result: any) {
    const items = Array.from(characters);
    const [reorderedItem] = items.splice(result.source.index, 1);
    items.splice(result.destination.index, 0, reorderedItem);

    updateCharacters(items);
  }

  //https://zenn.dev/uttk/articles/b90454baec68c8

  return (
    <>
      <sp-heading>{props.path}</sp-heading>
      <DragDropContext onDragEnd={handleOnDragEnd}>
      <Droppable droppableId="characters">
      {(provided) => (
                <ul className="characters" {...provided.droppableProps} ref={provided.innerRef}>
                {props.files.map(({id, name}) => {
                    return (
                    <li key={id}>
                        <p>
                        { name }
                        </p>
                    </li>
                    );
                })}
                </ul>
            )}
      </Droppable>
      </DragDropContext>
      <sp-menu multiple slot="options">
      {props.files.map((item, idx) => (
        <sp-menu-item key={idx}>
              <div             onClick={handleClick}
                onDoubleClick = {handleDoubleClick} >
              {item.name}
              </div>
            </sp-menu-item>
          ))}
      </sp-menu>

    </>
  );
}

export default ProjectTable;