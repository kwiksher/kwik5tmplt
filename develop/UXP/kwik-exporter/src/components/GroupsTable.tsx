import React, { useState, useEffect, useRef } from 'react';

export interface groupsProps {
  groups:any;
  setGroups:any;
}

export const GroupsTable: React.FC<groupsProps> =(props:groupsProps)=> {

  let timer = 0;
  let delay = 200;
  let prevent = false;

  const doClickAction = (event, idx, groups) => {
    console.log('Single click');
    groups[idx].selected  = !groups[idx].selected;
  }

  const doDoubleClickAction = async (event, idx, groups) => {
    console.log('Double Click')
  }

  const handleClick = (event, idx, groups) => {
    timer = setTimeout(function() {
      if (!prevent) {
        doClickAction(event, idx, groups);
      }
      prevent = false;
    }, delay);
  }

  const handleDoubleClick = (event, idx, groups) =>{
    clearTimeout(timer);
    prevent = true;
    doDoubleClickAction(event, idx, groups);
  }

  return (
    <>
      <sp-menu multiple slot="options">
      {
        props.groups.map((item, idx) => (
          <sp-menu-item key={idx} >
          <div key={item.key} onClick={(event)=>handleClick(event, idx, props.groups)}>{item.name}</div>
          </sp-menu-item>
        ))
      }
      </sp-menu>
    </>
  );
}
export default GroupsTable;