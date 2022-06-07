import React, { useState, useEffect } from 'react';
//import {Cell, Column, Row, TableView, TableBody, TableHeader} from '@adobe/react-spectrum'
//import {Flex, ListBox, Item, Section} from '@adobe/react-spectrum'
import Spectrum, { ActionButton } from 'react-uxp-spectrum';


export interface ProjectProps {
  folder:any
  // token:any;
}

export const ProjectTable: React.FC =()=> {

  let columns = [
    {name: 'Name', uid: 'name'},
    {name: 'Type', uid: 'type'},
    {name: 'Date Modified', uid: 'date'}
  ];

  let rows = [
    {id: 1, name: 'Games', date: '6/7/2020', type: 'File folder'},
    {id: 2, name: 'Program Files', date: '4/7/2021', type: 'File folder'},
    {id: 3, name: 'bootmgr', date: '11/20/2010', type: 'System file'},
    {id: 4, name: 'log.txt', date: '1/18/2016', type: 'Text Document'}
  ];

//   return (
//   <TableView
//   aria-label="Example table with static contents"
//   selectionMode="multiple"
// >
//   <TableHeader>
//     <Column>Name</Column>
//     <Column>Type</Column>
//     <Column align="end">Date Modified</Column>
//   </TableHeader>
//   <TableBody>
//     <Row>
//       <Cell>Games</Cell>
//       <Cell>File folder</Cell>
//       <Cell>6/7/2020</Cell>
//     </Row>
//     <Row>
//       <Cell>Program Files</Cell>
//       <Cell>File folder</Cell>
//       <Cell>4/7/2021</Cell>
//     </Row>
//     <Row>
//       <Cell>bootmgr</Cell>
//       <Cell>System file</Cell>
//       <Cell>11/20/2010</Cell>
//     </Row>
//     <Row>
//       <Cell>log.txt</Cell>
//       <Cell>Text Document</Cell>
//       <Cell>1/18/2016</Cell>
//     </Row>
//   </TableBody>
// </TableView>);

  // return(
  // <TableView aria-label="Example table with dynamic content"
  //   maxWidth="size-6000">
  //   <TableHeader columns={columns}>
  //     {column => (
  //       <Column
  //         key={column.uid}
  //         align={column.uid === 'date' ? 'end' : 'start'}>
  //         {column.name}
  //       </Column>
  //     )}
  //   </TableHeader>
  //   <TableBody items={rows}>
  //     {item => (
  //       <Row>
  //         {columnKey => <Cell>{item[columnKey]}</Cell>}
  //       </Row>
  //     )}
  //   </TableBody>
  // </TableView>);

  // let options = [
  //   {name: 'Koala'},
  //   {name: 'Kangaroo'},
  //   {name: 'Platypus'},
  //   {name: 'Bald Eagle'},
  //   {name: 'Bison'},
  //   {name: 'Skunk'}
  // ];
  // let [animal, setAnimal] = React.useState(['Bison']);

  // return (
  //   <Flex direction="row" gap="size-350">
  //     <ListBox
  //       selectionMode="multiple"
  //       aria-label="Pick an animal"
  //       defaultSelectedKeys={['Bison', 'Koala']}
  //       width="size-2400">
  //         <Item>Left</Item>
  //         <Item>Middle</Item>
  //         <Item>Right</Item>
  //         <Item>1</Item>
  //       {/* {item => <Item key={item.name}>{item.name}</Item>} */}
  //     </ListBox>
  //   </Flex>
  // );

  // https://forums.creativeclouddeveloper.com/t/bug-disabled-in-select-option-does-not-work/2270/5
  // https://codereview.stackexchange.com/questions/242077/parsing-numbers-and-ranges-from-a-string-in-javascript
  // https://www.npmjs.com/package/parse-numeric-range
  return (
  // <sp-dropdown placeholder="Make a selection...">
    <sp-menu multiple slot="options">
        <sp-menu-item> Deselect </sp-menu-item>
        <sp-menu-item> Select inverse </sp-menu-item>
        <sp-menu-item> Feather... </sp-menu-item>
        <sp-menu-item> Select and mask... </sp-menu-item>
        <sp-menu-item> Save selection </sp-menu-item>
        <sp-menu-item> Make work path </sp-menu-item>
    </sp-menu>
// </sp-dropdown>
  );
}

export default ProjectTable;