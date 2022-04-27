local M = {}
--
local composer = require("composer")
local model = require("components.store.model")
local cmd = require("components.store.command").new()
local _K = require("Application")
local marker = require("extlib.marker")
--
---------------------------------------------------
--
local LABEL_NAME = "saved_"
--
function M.new()
    local VIEW = {}
    --
    VIEW.downloadGroup = {}
    VIEW.versionGroup = {}
    VIEW.sceneGroup = nil
    VIEW.episode = nil
    --
    --
    local function copyDisplayObject(src, dst, id, group)
        local obj = display.newImageRect(_K.imgDir .. src.imagePath, _K.systemDir, src.width, src.height)
        if obj == nil then
            print("copyDisplay object fail", id)
        end
        if dst then
            obj.x = dst.x + src.x - _W / 2
            obj.y = dst.y + src.y - _H / 2
        else
            obj.x = src.x
            obj.y = src.y
        end
        src.alpha = 0
        obj.alpha = 0
        obj.selectedPurchase = id
        group:insert(obj)
        obj.fsm = VIEW.fsm
        return obj
    end

    local function setUpdateMark(dst, group)
        marker.new(dst, group)
    end
    --

    local function setButton(self, button, episode, lang, label)
        button.selectedPurchase = episode.name
        button.lang = lang
        self.downloadGroup[episode.name] = button
        --If the user has purchased the episode before, change the button
        button.purchaseBtn = copyDisplayObject(self.layer.purchaseBtn, button, episode.name, self.sceneGroup)
        if model.URL then
            button.downloadBtn =
                copyDisplayObject(self.layer.downloadBtn, button, episode.name, self.sceneGroup)
            button.savingTxt = copyDisplayObject(self.layer.savingTxt, button, episode.name, self.sceneGroup)
        end
        button.savedBtn = copyDisplayObject(self.layer.savedBtn, button, episode.name, self.sceneGroup)
        if model.bookShelfType == 0 then -- pages
            if cmd.hasDownloaded(episode.name) then
                button.savedBtn.alpha = 1
            else
                button.purchaseBtn.alpha = 1
            end
        end

        if episode.isFree then
            button.purchaseBtn.alpha = 0
        end
        --
        -- button image
        --
        if episode.isOnlineImg then
            cmd:setButtonImage(button, episode.name, lang)
        end
        if cmd.isUpdateAvailableInVersions(episode.name) then
            setUpdateMark(button, self.sceneGroup)
        end
        --
        -- label
        --
        if episode.isOnlineImg then
            cmd:setButtonImage(label, episode.name, lang)
        end

    end
    --
    function VIEW:createThumbnail()
        print("--- VIEW create ---")
        for k, episode in pairs(model.episodes) do
            -- print(episode.name)
            local button = self.layer[episode.name .. "Icon"] 
            local label = self.layer[episode.name .. "Label"]
            if button then
                setButton(self, button, episode, nil, label)
            else
                if episode.versions then
                    for i = 1, #episode.versions do
                        button = self.layer[episode.name .. "_"..episode.versions[i]] 
                        label = self.layer[episode.name .."_"..episode.versions[i].. "Label"]
                        --print(episode.name .. "_"..episode.versions[i])
                        if button and label then
                            setButton(self, button, episode, episode.versions[i], label)
                        end
                    end
                end
            end            
        end
        --
    end
    --
    local function setButtonListener(button, episode, version)
        button.episode = {name = episode.name, versions = episode.versions, isOnlineImg = episode.isOnlineImg, isFree = episode.isFree} 
        button.episode.selectedVersion = version

        -- Not work this transition because BookPurchased state is necessay to goto a book version
        -- function button:tap(e)
        --     VIEW.fsm:gotoScene(self.episode, _K.lang)
        -- end

        -- if episode.versions == nil or #episode.versions == 0 then
        function button:tap(e)
            VIEW.fsm:clickImage(self.episode)
            return true
        end
        button:addEventListener("tap", button)
        -- else
        -- button:addEventListener("tap", button)
        -- end
        --
        if model.bookShelfType == 0 then -- pages
            function button.purchaseBtn:tap(e)
                VIEW.fsm:clickPurchase(self.selectedPurchase, false)
                --cmd.onPurchase(self.selectedPurchase)
                return true
            end
            function button.downloadBtn:tap(e)
                --cmd.onDownload(self.selectedPurchase)
            end
            function button.savedBtn:tap(e)
                VIEW.fsm:gotoBook(self.episode)
                return true
            end
            button.purchaseBtn.selectedPurchase = episode.name
            button.downloadBtn.selectedPurchase = episode.name
            button.savedBtn.selectedPurchase = episode.name
            button.purchaseBtn.episode = episode
            button.downloadBtn.episode = episode
            button.savedBtn.episode = episode
            button.purchaseBtn:addEventListener("tap", button.purchaseBtn)
            button.downloadBtn:addEventListener("tap", button.downloadBtn)
            button.savedBtn:addEventListener("tap", button.savedBtn)
            button.version = version
        end
end
    --
    function VIEW:controlThumbnail()
        for k, episode in pairs(model.episodes) do
            --print("controlThumbnail",episode.name)
            local button = self.layer[episode.name .. "Icon"]
            if button then
                setButtonListener(button, episode)
            else 
                if episode.versions then
                    for i = 1, #episode.versions do
                        button = self.layer[episode.name .. "_"..episode.versions[i]] 
                        if button then
                            setButtonListener(button, episode, episode.versions[i] )
                        end
                    end
                end
            end
        end
        if self.layer.restoreBtn then
            self.layer.restoreBtn:addEventListener("tap", cmd.restore)
        end
        if self.layer.hideOverlayBtn then
            self.layer.hideOverlayBtn:addEventListener("tap", cmd.hideOverlay)
        end
    end
    --
    local function refreshButton (button, episode, self)
        button.purchaseBtn.alpha = 0
        button.downloadBtn = 0
        button.savedBtn.alpha = 0
        if cmd.hasDownloaded(episode.name) then
            button.purchaseBtn.alpha = 0
            button.downloadBtn = 0
            button.savedBtn.alpha = 1
        else
            button.purchaseBtn.alpha = 1
            button.downloadBtn = 0
            button.savedBtn.alpha = 0
        end

        if cmd.isUpdateAvailable(episode.name) then
            if button.updateMark then
                button.updateMark.alpha = 1
            else
             setUpdateMark(button, self.sceneGroup)
            end
        else
            if button.updateMark then
                button.updateMark.alpha = 0
            end
        end
    end

    function VIEW:refreshThumbnail()
        print("VIEW refreshThumbnail")
        for k, episode in pairs(model.episodes) do
            local button = self.layer[episode.name .. "Icon"]
            if button then
                refreshButton(button, episode, self)
            else
                if episode.versions then
                    for i = 1, #episode.versions do
                        button = self.layer[episode.name .. "_"..episode.versions[i]] 
                        if button then
                            refreshButton(button, episode, self)
                        end
                    end
                end
            end
        end
    end
    --
    local function setDialogButton(bookXXIcon, episode, self, lang)
        bookXXIcon.lang = lang
        self.downloadGroup[episode.name] = bookXXIcon
        bookXXIcon.versions = {}
        bookXXIcon.labels   = {}
        bookXXIcon.selectedPurchase = episode.name
        bookXXIcon.selectedVersion = episode.selectedVersion

        print("createDialog with", episode.name, episode.selectedVersion, episode.isOnlineImg)
        
        --If the user has purchased the episode before, change the bookXXIcon
        bookXXIcon.purchaseBtn = copyDisplayObject(self.layer.purchaseBtn, nil, episode, self.sceneGroup)
        bookXXIcon.purchaseBtn.selectedPurchase = episode.name
        if model.URL then
            bookXXIcon.savingTxt = copyDisplayObject(self.layer.savingTxt, nil, episode, self.sceneGroup)
            bookXXIcon.savedBtn = copyDisplayObject(self.layer.savedBtn, nil, self.episode, self.sceneGroup)
            if episode.versions == nil or #episode.versions == 0 then
                bookXXIcon.downloadBtn = copyDisplayObject(self.layer.downloadBtn, nil, episode, self.sceneGroup)
            end
        end
        --
        -- bookXXIcon image then
        --
        if episode.isOnlineImg then
            cmd:setButtonImage(bookXXIcon, episode.name, lang)
        else
            local src = self.layer[episode.name.."Icon"] or self.layer[episode.name.."_"..lang]
            if src then
                --print(src.imagePath)
                bookXXIcon.fill = {
                    type = "image",
                    filename = _K.imgDir .. src.imagePath,
                    baseDir = _K.systemDir
                }
            end
        end
        bookXXIcon.alpha = 1

    end
    ---
    function VIEW:createDialog(episode, isPurchased, isDownloaded)
        -- init
        for k, v in pairs(model.episodes) do
            if self.layer[v.name.."Icon"] then
                self.layer[v.name.."Icon"].alpha = 0
            end
            for i = 1, #v.versions do
               local obj  = self.layer[v.name.."_"..v.versions[i]]
                if obj then
                    obj.alpha = 0
                end
            end

        end
        --
        self.episode = episode
        print("VIEW:createDialog", episode.name)
        local bookXXIcon = self.layer[episode.name.."Icon"] or self.layer[episode.name.."_"..episode.selectedVersion]
        if model.bookShelfType == 0 then
            bookXXIcon = self.layer[episode.name .. "Icon"]
        end
       
        if bookXXIcon then
            setDialogButton(bookXXIcon, episode, self, episode.selectedVersion)
        end
        --
        if episode.versions then
            for i = 1, #episode.versions do
                --print(episode.versions[i])
                local iconLayer = self.layer[episode.name.."_"..episode.versions[i]] or {}
                iconLayer.alpha = 0
                if episode.versions[i] == episode.selectedVersion then
                    iconLayer.alpha = 1
                end

                if self.layer["version_" .. episode.versions[i]] and string.len(episode.versions[i]) > 1 then
                    local versionBtn =
                        copyDisplayObject(
                        self.layer["version_" .. episode.versions[i]],
                        nil,
                        episode.name .. self.episode.versions[i],
                        self.sceneGroup
                    )

                    versionBtn.alpha = 1
                    versionBtn.episode = episode
                    versionBtn.selectedPurchase = episode.name
                    versionBtn.selectedVersion = episode.versions[i]
                    table.insert(bookXXIcon.versions, versionBtn)
                    self.versionGroup[episode.name .. episode.versions[i]] = versionBtn
                    --
                    -- labels
                    local labelBtn = self.layer[LABEL_NAME .. episode.versions[i]]
                    labelBtn.alpha = 0
                    table.insert(bookXXIcon.labels, labelBtn)

                end
            end
            if model.URL and #bookXXIcon.versions == 0 then
                bookXXIcon.downloadBtn = copyDisplayObject(self.layer.downloadBtn, nil, episode, self.sceneGroup)
            end
        end
        
    end
    --
    --
    function VIEW:setVersionButtons(bookXXIcon, _isFree)
        local isFree = _isFree or bookXXIcon.episode.isFree
        print("setVersionButtons", #bookXXIcon.versions, isFree)
        if #bookXXIcon.versions == 0 then
            if _K.lang == "" then
                bookXXIcon.selectedVersion = "en"
            else
                bookXXIcon.selectedVersion = _K.lang
            end
            if cmd.hasDownloaded(bookXXIcon.selectedPurchase, bookXXIcon.selectedVersion) then
                print("downloaded")
                function bookXXIcon:tap(e)
                    VIEW.fsm:clickImage(self.episode, self.selectedVersion)
                    return true
                end
                bookXXIcon:addEventListener("tap", bookXXIcon)
            else
                print("not downloaded yet")
                if isFree then
                    bookXXIcon.downloadBtn.episode = bookXXIcon.episode
                    bookXXIcon.downloadBtn.selectedVersion = bookXXIcon.selectedVersion
                    function bookXXIcon.downloadBtn:tap(e)
                        VIEW.fsm:startDownload(self.episode, self.selectedVersion)
                        return true
                    end
                    bookXXIcon.downloadBtn.alpha = 1
                    bookXXIcon.downloadBtn:addEventListener("tap", bookXXIcon.downloadBtn)
                else
                    function bookXXIcon:tap(e)
                        VIEW.fsm:startDownload(self.episode, self.selectedVersion)
                        return true
                    end
                    bookXXIcon:addEventListener("tap", bookXXIcon)
                end
            end

            if cmd.isUpdateAvailable(bookXXIcon.selectedPurchase, bookXXIcon.selectedVersion) then
                -- show downloadBtn
                --print("", "isUpdateAvailable")
                bookXXIcon.downloadBtn.episode = bookXXIcon.episode
                bookXXIcon.downloadBtn.selectedVersion = bookXXIcon.selectedVersion
                function bookXXIcon.downloadBtn:tap(e)
                    VIEW.fsm:startDownload(self.episode, self.selectedVersion)
                    return true
                end
                bookXXIcon.downloadBtn.alpha = 1
                bookXXIcon.downloadBtn:addEventListener("tap", bookXXIcon.downloadBtn)
                --print(self.sceneGroup)
                --print ("", "setUpdateMark", bookXXIcon.downloadBtn, self.sceneGroup)
                setUpdateMark(bookXXIcon.downloadBtn, self.sceneGroup)
                --print("", "setUpdateMark ended")
            end
        else
            for i = 1, #bookXXIcon.versions do
                local versionBtn = bookXXIcon.versions[i]
                local labelBtn   = bookXXIcon.labels[i] or {}
                labelBtn.alpha = 0
                if versionBtn then
                    if cmd.hasDownloaded(versionBtn.selectedPurchase, versionBtn.selectedVersion) then
                        print(versionBtn.selectedVersion .. "(saved)")
                        function versionBtn:tap(e)
                            print("versionBtn tap for gotoScene")
                            --self.gotoScene
                            VIEW.fsm:clickImage(self.episode, self.selectedVersion)
                            return true
                        end
                        versionBtn:addEventListener("tap", versionBtn)
                        labelBtn.alpha = 1
                    else
                        print(versionBtn.selectedVersion .. "(not saved)")
                        -- Runtime:dispatchEvent({name = "downloadManager:purchaseCompleted", target = _episode.versions[i]})
                        function versionBtn:tap(e)
                            print("versionBtn tap for download")
                            VIEW.fsm:startDownload(self.episode, self.selectedVersion)
                            return true
                        end
                        versionBtn:addEventListener("tap", versionBtn)
                    end

                    if cmd.isUpdateAvailable(versionBtn.selectedPurchase, versionBtn.selectedVersion) then
                        -- show downloadBtn
                        function versionBtn:tap(e)
                            VIEW.fsm:startDownload(self.episode, self.selectedVersion)
                            return true
                        end
                        versionBtn:addEventListener("tap", versionBtn)
                        setUpdateMark(versionBtn, self.sceneGroup)
                    end

                else
                    print("Error to find versionBtn")
                end

            end
        end
    end
    --
    --
    function VIEW:controlDialog(episode, isPurchased, isDownloaded)
        local bookXXIcon = self.layer[episode.name.."Icon"] or self.layer[episode.name.."_"..episode.selectedVersion]
        if model.bookShelfType == 0 then
            bookXXIcon = self.layer[episode.name .. "Icon"]
        end
        if bookXXIcon then
            bookXXIcon.episode = episode
            if isPurchased then
                print(episode.name .. "(purchased)")
                if episode.versions == nil or #episode.versions == 0 then
                    if isDownloaded then
                        function bookXXIcon:tap(e)
                            VIEW.fsm:clickImage(self.episode)
                            return true
                        end
                        bookXXIcon:addEventListener("tap", bookXXIcon)
                        if model.URL then
                            -- bookXXIcon.savingTxt.alpha = 0
                        end
                        
                        if cmd.isUpdateAvailable(episode.name) then
                            bookXXIcon.savedBtn.alpha = 1
                            bookXXIcon.savedBtn:addEventListener("tap", function(e)
                                 VIEW.fsm:clickImage(_episode)
                            end)
                            --if episode.isFree then
                                function bookXXIcon.downloadBtn:tap(e)
                                    print("free book to be downloaded", self.episode)
                                    VIEW.fsm:startDownload(self.episode)
                                    return true
                                end
                                bookXXIcon.downloadBtn.alpha = 1
                                bookXXIcon.downloadBtn.episode = bookXXIcon.episode
                                bookXXIcon.downloadBtn:addEventListener("tap", bookXXIcon.downloadBtn)                        
                                setUpdateMark(bookXXIcon.downloadBtn, self.sceneGroup)
                            --cend
                        end
                         
                    else
                        print(episode.name .. "(saving)")
                        if episode.isFree then
                            function bookXXIcon.downloadBtn:tap(e)
                                print("free book to be downloaded", self.episode)
                                VIEW.fsm:startDownload(self.episode)
                                return true
                            end
                            bookXXIcon.downloadBtn.alpha = 1
                            bookXXIcon.downloadBtn.episode = bookXXIcon.episode
                            bookXXIcon.downloadBtn:addEventListener("tap", bookXXIcon.downloadBtn)                        
                        else
                            bookXXIcon.savingTxt.alpha = 1
                        end
                        Runtime:dispatchEvent({name = "cmd:purchaseCompleted", target = episode})
                    end
                else
                    -----------------
                    -- version
                    self:setVersionButtons(bookXXIcon, episode.isFree)
                    --print("### setVersionButtons end")
                end
            else
                print(episode.name .. "(not purchased)")
                --Otherwise add a tap listener to the bookXXIcon that unlocks the episode
                bookXXIcon.purchaseBtn.alpha = 1
                function bookXXIcon.purchaseBtn:tap(e)
                    print("tap purchaseBtn", self.selectedPurchase, e.target.selectedPurchase)
                    VIEW.fsm:clickPurchase(self.selectedPurchase, true)
                    return true
                end
                bookXXIcon.purchaseBtn:addEventListener("tap", bookXXIcon.purchaseBtn)
                --Otherwise add a tap listener to the button that unlocks the episode
                -----------
                --
                if episode.versions then
                    for i = 1, #bookXXIcon.versions do
                        local versionBtn = bookXXIcon.versions[i]
                        if versionBtn then
                            function versionBtn:tap(e)
                                --self.cmd.startDownloadVersion
                                VIEW.fsm:clickPurchase(self.selectedPurchase, true)
                                return true
                            end
                            versionBtn:addEventListener("tap", versionBtn)
                        end
                    end
                end
            end
        end
        --
        if self.layer.hideOverlayBtn then
            -- composer.hideOverlay("fade", 400 )
            function self.layer.hideOverlayBtn:tap(e)
                print("hideOverlayBtn")
                VIEW.fsm:clickCloseDialog()
                return true
            end
            self.layer.hideOverlayBtn:addEventListener("tap", self.layer.hideOverlayBtn)
        end

        if self.layer.infoTxt then
            self.layer.infoTxt.text = model.episodes[episode.name].info
            self.layer.infoTxt.x = self.layer.infoTxt.oriX
            self.layer.infoTxt.y = self.layer.infoTxt.oriY
            self.layer.infoTxt.anchorX = 0
            self.layer.infoTxt.anchorY = 0.3
        end
    end
    --
    --
    function VIEW.purchaseAlert()
        native.showAlert("Info", model.purchaseAlertMessage, {"Okay"})
    end
    --
    --Tell the user their items are being restore
    function VIEW.restoreAlert()
        native.showAlert("Restore", model.restoreAlertMessage, {"Okay"})
    end
    --
    function VIEW:updateDialog(selectedPurchase)
        local button = VIEW.downloadGroup[selectedPurchase]
        --self.episode  = selectedPurchase
        print("VIEW.updateDialog", selectedPurchase)
        -- button.text.text=selectedPurchase.."(saved)"
        if button.episode.versions == nil or #button.episode.versions == 0 then
            if model.URL then
                button.savingTxt.alpha = 0
                button.savedBtn.alpha = 1
                button.downloadBtn.alpha = 0
                button.purchaseBtn.alpha = 0
            end
            if button.tap then
                button.downloadBtn:removeEventListener("tap", button)
            end
            if button.updateMark then
                button.updateMark.alpha = 0
            end
            function button:tap(e)
                VIEW.fsm:clickImage(self.episode)
                return true
            end
            button:addEventListener("tap", button)
        else
            -- local versions = model.episodes[selectedPurchase].versions
            -- for k, v in pairs(versions) do print(k, v) end
            -- for i=1, #versions do
            --     local versionBtn = self.versionGroup[selectedPurchase..versions[i]]
            --     print(selectedPurchase..versions[i],versionBtn)
            --     if versionBtn then
            --         if versionBtn.tap then
            --                 print("removeEventListener")
            --             versionBtn:removeEventListener("tap", versionBtn)
            --         end
            --         function versionBtn:tap(e)
            --                 self.fsm:clickImage(self.episode, self.selectedVersion)
            --         end
            --         versionBtn:addEventListener("tap", versionBtn)
            --         self.versionGroup[selectedPurchase..versions[i]] = nil
            --     end
            -- end
            if model.URL then
                if button.savingTxt then
                    button.savingTxt.alpha = 0
                end
                if button.savedBtn then
                    button.savedBtn.alpha = 1
                end
                if button.downloadBtn then
                    button.downloadBtn.alpha = 0
                end
                if button.purchaseBtn then
                    button.purchaseBtn.alpha = 0
                end
            end
            if button.updateMark then
                button.updateMark.alpha = 0
            end
            -- not found. It means it is a version button
            self:setVersionButtons(button)
        end
    end
    --
    function VIEW.onDownloadError(selectedPurchase, message)
        -- CMD.downloadGroup[selectedPurchase].text.text="download error"
        native.showAlert(
            "Failed",
            model.downloadErrorMessage,
            {"Okay"},
            function()
                VIEW.fsm:back()
            end
        )
    end
    --
    function VIEW:destroyThumbnail()
        print("VIEW:destroyThumbnail")
        for k, episode in pairs(model.episodes) do
            local button = self.layer[episode.name .. "Icon"]
            if button then
                if button.purchaseBtn then
                    button.purchaseBtn:removeEventListener("tap", button.purchaseBtn)
                end
                button:removeEventListener("tap", cmd.showOverlay)
                if button.savedBtn then
                    button.savedBtn:removeEventListener("tap", cmd.gotoScene)
                end
                button:removeEventListener("tap", cmd.gotoScene)
            end
        end
        if self.layer.hideOverlayBtn then
            self.layer.hideOverlayBtn:removeEventListener("tap", cmd.hideOverlay)
        end
        if self.layer.restoreBtn then
            self.layer.restoreBtn:removeEventListener("tap", cmd.restore)
        end
        print("VIEW:destroyThumbnail", "exit")
    end
    ------
    function VIEW:destroyDialog()
    end
    --
    function VIEW:refresh()
        cmd:init(self)
        for k, episode in pairs(model.episodes) do
            local button = self.layer[episode.name .. "Icon"]
            if button then
                print("-------- refresh ---------", self, button)
                self.downloadGroup[episode.name] = button
                button.purchaseBtn.alpha = 0
                if model.URL then
                    if button.savingTxt then
                        button.savingTxt.alpha = 0
                    end
                    if button.savedBtn then
                        button.savedBtn.alpha = 0
                    end
                    if button.downloadBtn then
                        button.downloadBtn.alpha = 0
                    end
                end
            --
            end
        end
    end

    function VIEW:init(group, layer, fsm)
        self.sceneGroup = group
        self.layer = layer
        self.fsm = fsm

        model:initPages(_K.lang)

        cmd:init(self)
        if model.URL then
            if layer.savingTxt then
                layer.savingTxt.alpha = 0
            end
            if layer.savedBtn then
                layer.savedBtn.alpha = 0
            end
            if layer.downloadBtn then
                layer.downloadBtn.alpha = 0
            end
        end
    end
    --
    return VIEW
end

return M
