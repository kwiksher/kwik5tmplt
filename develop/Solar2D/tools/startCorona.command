{{#tmp}}
open "corona://open?url=file:///{{projPath}}/temp&skin={{pdev}}"
{{/tmp}}
{{^tmp}}
open "corona://open?url=file:///{{projPath}}/build4&skin={{pdev}}"
{{/tmp}}
