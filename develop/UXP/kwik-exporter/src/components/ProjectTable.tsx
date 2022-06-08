import React, { useState, useEffect } from 'react';
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
  return (
    <>
      <sp-heading>{props.path}</sp-heading>
      <sp-menu multiple slot="options">
      {props.files.map((item, idx) => (
            <sp-menu-item key={idx}>{item.name}</sp-menu-item>
          ))}
      </sp-menu>
    </>
  );
}

export default ProjectTable;