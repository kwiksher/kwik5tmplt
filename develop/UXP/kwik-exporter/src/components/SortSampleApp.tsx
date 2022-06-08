import React from "react";

import { useDnDSort } from "./useDnDSort";

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

const imageStyle: Style<HTMLImageElement> = {
  pointerEvents: "none",
  objectFit: "cover",
  width: "100%",
  height: "100%"
};

/**
 * @description 並び替えしたい画像URLの配列
 */
const imageList: string[] = [
  "/images/pexels-matheus-bertelli-1830252.jpg",
  "/images/pexels-daria-rem-2759658.jpg",
  "/images/pexels-pixabay-277253.jpg",
  "/images/pexels-aron-visuals-1743165.jpg",
  "/images/pexels-ekrulila-3246665.jpg",
  "/images/pexels-steve-johnson-1690351.jpg",
  "/images/pexels-eberhard-grossgasteiger-2086361.jpg",
  "/images/pexels-eberhard-grossgasteiger-2088203.jpg",
  "/images/pexels-alexander-ant-5603660.jpg"
];

/**
 * @description ドラッグ＆ドロップ並び替えサンプルのコンポーネント
 */
export const SortSampleApp = () => {
  const results = useDnDSort(imageList);

  return (
    <div style={bodyStyle}>
      <div style={containerStyle}>
        {results.map((item) => (
          <div key={item.key} style={imageCardStyle} {...item.events}>
            <h1>
            {item.value}
            </h1>
          </div>
        ))}
      </div>
    </div>
  );
};
