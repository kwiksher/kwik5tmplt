-- Template Version 2017.0006
-- Code created by Kwik - Copyright: kwiksher.com 2016
-- Version: 4.0.2 01
-- Project: HelloWorld
--
require("controller.index").bootstrap({name="book", sceneIndex = 1, position = {x=100, y=100}}) -- scenes.index

-- require("controller.index").bootstrap({name="bookCopy", sceneIndex = 1, position = {x=0, y=0}}) -- scenes.index
-- only one instance becasue onRobotlegsViewCreated is Runtime:addEventListener, it fires to all
-- should we change it to app == display.newGroup?