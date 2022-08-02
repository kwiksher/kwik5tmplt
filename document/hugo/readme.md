docdocks の theme を採用

https://github.com/vjeantet/hugo-theme-docdock

hugo の設定に mermaid.js と Lastmod を追加した

- mermaid.js

  https://anis.se/posts/add-mermaidjs-support-to-hugo/

  ファイル

  themes/hugo-theme-docdock-master/layouts/partials/custom-footer.html

  ````
  <!-- Add mermaid min js file -->
  <script
  	src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/8.6.0/mermaid.min.js"
  	crossorigin="anonymous"
  ></script>
  <!-- Initializes mermaid js.
  	Main reason to use .init rather than .initialize is that .init allows to pass in a class selector.
  	Hugo's markdown code fences ```mermaid ``` will create a html code block with class .language-mermaid.
  	This can then be used by mermaid to generate the correct diagrams with code fences
  -->
  <script>
  	mermaid.init(undefined, ".language-mermaid");
  </script>
  ````

- lastmod

  > うまく動作していないみたい (TODO デバッグ)

  ファイル

  themes/hugo-theme-docdock-master/layouts/partials/flex/body-beforecontent.html

  ```
  {{if not .IsHome}}<div align="right">Last Modified: {{ .Lastmod.Format "2006-01-02" }}</div>{{end}}
  ```

- archtypes/default.md

- config.dev.tom, cofig.toml

  一階層上の docs フォルダに、ビルド出力される html が格納されるように設定。コンテンツであある md ファイルは、src フォルダがルートフォルダである

- layouts/shotcode/img.html

  VS Code Extension の Paste Image を利用する。

  <img src="./img/2021-09-23-16-14-16.png" width="300">

  <img src="./img/2021-09-23-16-10-51.png" width="600">

  Insert Patter に下記を設定する。２重のブラッケトあると Hugo の shortcode として認識される。

  ```
  {{<img src="./${imageFilePath}" width="600">}}
  ```

  <img src="./img/2021-09-23-16-11-27.png" width="600">

  img フォルダに、スクリーンコピーした image ファイルを格納する。そして、hugo の shortcode は、認識された場合は、img フォルダのパスを参照。

  ```
  ${currentFileDir}/img
  ```

  **注意**: hugo の shortcode として <img>を取り扱う必要があるのは、\_index.md 以外の場合である。\_indewx.md では、２重のブラッケトは必要ない。
