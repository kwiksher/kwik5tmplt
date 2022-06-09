import {classNames} from '@react-spectrum/utils';
import {DroppableCollectionDropEvent} from '@react-types/shared';
import {FocusRing} from '@react-aria/focus';
//import Folder from '@spectrum-icons/workflow/Folder';
import {Item} from '@react-stately/collections';
import {ListKeyboardDelegate} from '@react-aria/selection';
import {mergeProps} from '@react-aria/utils';
import React from 'react';
import {useDropIndicator, useDroppableCollection, useDroppableItem} from '@react-aria/dnd';
import {useDroppableCollectionState} from '@react-stately/dnd';
import {useListBox, useOption} from '@react-aria/listbox';
import {useListData} from '@react-stately/data';
import {useListState} from '@react-stately/list';
import {useVisuallyHidden} from '@react-aria/visually-hidden';

const dndStyles = require('./dnd.css')
const dropIndicatorStyles = require('./dropindicator/vars.css');

export function DroppableListBoxExample(props) {
  let id = React.useRef(props.items?.length || 3);
  let list = useListData({
    initialItems: props.items || [
      {id: '1', type: 'item', text: 'One'},
      {id: '2', type: 'item', text: 'Two'},
      {id: '3', type: 'item', text: 'Three'}
    ]
  });

  let ref = React.useRef(null);

  let onDrop = async (e: DroppableCollectionDropEvent) => {
    console.log("onDrop")
    if (e.target.type === 'root' || e.target.dropPosition !== 'on') {
      let items = [];
      for (let item of e.items) {
        let type: string;
        if (item.kind === 'text') {
          if (item.types.has('folder')) {
            type = 'folder';
          } else if (item.types.has('item')) {
            type = 'item';
          }

          if (!type) {
            continue;
          }

          items.push({
            id: String(++id.current),
            type,
            text: await item.getText(type)
          });
        }
      }

      if (e.target.type === 'root') {
        list.prepend(...items);
      } else if (e.target.dropPosition === 'before') {
        list.insertBefore(e.target.key, ...items);
      } else {
        list.insertAfter(e.target.key, ...items);
      }
    }
  };

  return (
    <DroppableListBox items={list.items} onDrop={onDrop} ref={ref}>
      {item => (
        <Item textValue={item.text}>
          {/* {item.type === 'folder' && <Folder size="S" />} */}
          <span>{item.text}</span>
        </Item>
      )}
    </DroppableListBox>
  );
}

export const DroppableListBox = React.forwardRef(function (props: any, ref) {
  let domRef = React.useRef<HTMLDivElement>(null);
  let state = useListState({...props, selectionMode: 'multiple'});
  let keyboardDelegate = new ListKeyboardDelegate(state.collection, new Set(), domRef);

  React.useImperativeHandle(ref, () => ({
    focusItem(key) {
      state.selectionManager.setFocusedKey(key);
      state.selectionManager.setFocused(true);
    }
  }));

  let dropState = useDroppableCollectionState({
    collection: state.collection,
    selectionManager: state.selectionManager,
    getDropOperation(target, types, allowedOperations) {
      if (target.type === 'root') {
        return 'move';
      }

      if (target.key === '2' && target.dropPosition === 'on') {
        return 'cancel';
      }

      return target.dropPosition !== 'on' ? allowedOperations[0] : 'copy';
    }
  });

  let {collectionProps} = useDroppableCollection({
    keyboardDelegate,
    onDropEnter: null,
    // onDropMove: action('onDropMove'),
    onDropExit: null,
    onDropActivate: null,
    onDrop: async e => {
      props.onDrop?.(e);
    },
    getDropTargetFromPoint(x, y) {
      let rect = domRef.current.getBoundingClientRect();
      x += rect.x;
      y += rect.y;
      let closest = null;
      let closestDistance = Infinity;
      let closestDir = null;

      for (var i=0; i< domRef.current.children.length;i++) {
        const child = domRef.current.children.item(i);
        if (!(child as HTMLElement).dataset.key) {
          continue;
        }

        let r = child.getBoundingClientRect();
        let points: [number, number, string][] = [
          [r.left, r.top, 'before'],
          [r.right, r.top, 'before'],
          [r.left, r.bottom, 'after'],
          [r.right, r.bottom, 'after']
        ];

        for (let [px, py, dir] of points) {
          let dx = px - x;
          let dy = py - y;
          let d = dx * dx + dy * dy;
          if (d < closestDistance) {
            closestDistance = d;
            closest = child;
            closestDir = dir;
          }
        }

        if (y >= r.top + 10 && y <= r.bottom - 10) {
          closestDir = 'on';
        }
      }

      let key = closest?.dataset.key;
      if (key) {
        return {
          type: 'item',
          key,
          dropPosition: closestDir
        };
      }
    }
  }, dropState, domRef);

  let {listBoxProps} = useListBox({
    ...props,
    'aria-label': 'List',
    keyboardDelegate
  }, state, domRef);

  let isDropTarget = dropState.isDropTarget({type: 'root'});
  let dropRef = React.useRef();
  let {dropIndicatorProps} = useDropIndicator({
    target: {type: 'root'}
  }, dropState, dropRef);
  let {visuallyHiddenProps} = useVisuallyHidden();

  const collectionArray =[];
  for (var i=0; i< state.collection.size;i++){
    collectionArray[i] = state.collection.at(i);
  }

  return (
    <div
      {...mergeProps(collectionProps, listBoxProps)}
      ref={domRef}
      className={classNames(dndStyles, 'droppable-collection', {'is-drop-target': isDropTarget})}>
      {!dropIndicatorProps['aria-hidden'] &&
        <div
          role="option"
          aria-selected="false"
          {...visuallyHiddenProps}
          {...dropIndicatorProps}
          ref={dropRef} />
      }
      {collectionArray.map(item => (
        <>
          <InsertionIndicator
            key={item.key + '-before'}
            collectionRef={domRef}
            target={{type: 'item', key: item.key, dropPosition: 'before'}}
            dropState={dropState} />
          <CollectionItem
            key={item.key}
            item={item}
            state={state}
            dropState={dropState} />
          {state.collection.getKeyAfter(item.key) == null &&
            <InsertionIndicator
              key={item.key + '-after'}
              target={{type: 'item', key: item.key, dropPosition: 'after'}}
              collectionRef={domRef}
              dropState={dropState} />
          }
        </>
      ))}
    </div>
  );
});

function CollectionItem({item, state, dropState}) {
  let ref = React.useRef();
  let {optionProps} = useOption({
    key: item.key,
    isSelected: state.selectionManager.isSelected(item.key)
  }, state, ref);

  let {dropProps} = useDroppableItem({
    target: {type: 'item', key: item.key, dropPosition: 'on'}
  }, dropState, ref);

  return (
    <FocusRing focusRingClass={classNames(dndStyles, 'focus-ring')}>
      <div
        {...mergeProps(optionProps, dropProps)}
        ref={ref}
        className={classNames(dndStyles, 'droppable', {
          'is-drop-target': dropState.isDropTarget({type: 'item', key: item.key, dropPosition: 'on'}),
          'is-selected': state.selectionManager.isSelected(item.key)
        })}
        style={{margin: '4px 0'}}>
        {item.rendered}
      </div>
    </FocusRing>
  );
}

function InsertionIndicator(props) {
  let ref = React.useRef();
  let {dropIndicatorProps} = useDropIndicator(props, props.dropState, ref);

  // If aria-hidden, we are either not in a drag session or the drop target is invalid.
  // In that case, there's no need to render anything at all unless we need to show the indicator visually.
  // This can happen when dragging using the native DnD API as opposed to keyboard dragging.
  if (!props.dropState.isDropTarget(props.target) && dropIndicatorProps['aria-hidden']) {
    return null;
  }

  return (
    <div
      role="option"
      aria-selected="false"
      {...dropIndicatorProps}
      ref={ref}
      className={props.dropState.isDropTarget(props.target)
        ? classNames(dropIndicatorStyles, 'spectrum-DropIndicator', 'spectrum-DropIndicator--horizontal')
        : null
      }
      style={{
        width: '100%',
        marginLeft: 0,
        height: 2,
        marginBottom: -2,
        outline: 'none'
      }} />
  );
}
