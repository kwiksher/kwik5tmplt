---
title: Naming Rule
weight: 2
---

# Naming .psd file anad layers in documents

1. Project and file names

    Avoid long names for your projects and files and, DO NOT use characters like +-<>%,#;!. 

1. Layer names

    Before you start adding buttons and animations, follow the rules below. It is much easier to add interactivity with finalized names rather than to edit all of them afterward. Basic rules include:
    
    * Only user Western characters are allowed for layer names.
        
        * DO NOT use characters such as + - <> %,#;!. for naming layers
        
            These characters conflict with Lua language. Kwik removes these “strange” characters but, if they were used before in any button actions, it would generate errors during export.

        * Do NOT name your layers starting with numbers. 
        
            For example, a layer named "1", will generate an error. A layer named "01_Name" will also generate an error. However, a layer named "Name_01" is correct.
        
        * Do not use Lua commands as names. 
        
            For example, a layer named “if” will conflict with the command if. Some Lua commands are: if, end, local, transition, play. A full list of Lua commands is here. Kwik will generate an alert error if it finds layers named with Lua commands 

    * Avoid having multiple layers with the same name. 
    
        Kwik will not export the second layer with the same name as it will overwrite the first one, (which will make the Lua code crazy). Kwik will provide an alert error if it finds layers with identical names.


    * Avoid long names. 
    
        All layer names become variables when exported, meaning they use more memory and are more difficult to read. Also, they are going to be shortening anyways, as Lua will not allow variable names with more than 15 characters.


        - Keep Layer Names Short for text layers

            Text layer names are originally created using the content of the text from the canvas in Photoshop. If you have a long paragraph, the layer name will be the entire content of the long paragraph! Long layer names cause problems in the generated code, so edit the layer names to make them shorter. (This is the most common problem we have seen from our users reporting issues.) Don’t forget all text, besides the ones used in Sync audio feature, also are exported as images.

1. Grouped layers

    Kwik can export grouped layers as a single image. Use them to create more complex elements (for example, a multi-layered button with text, shadows, etc.), or for the creation of static elements. A common issue is to have all page elements in a group layer that images are not rendered separately. If you have a group with several layers, try to flatten them whenever it is possible. It will make the export process much faster.

1. Button and Animation names of Kwik components

    Although Kwik offers an auto-naming feature, try to enter your own names (follow the rules above). It will help you to quickly edit your actions from the project view. This is a time saver for a project with several actions.


