local M ={
  audios = {class = "audio", modify = require("editor.audio.audioTable").commandHandler, icons = {"addAudio", "trash"}, tool="selectAudio"},
  videos = {class = "video", modify = require("editor.parts.layerTableCommands").commandHandlerClass, icons={"repVideo", "trash"}, tool="selectTool"},
  sprites = {class = "sprite", modify = require("editor.parts.layerTableCommands").commandHandlerClass, icons={"repSprite", "trash"}, tool="selectTool"},

}

return M
