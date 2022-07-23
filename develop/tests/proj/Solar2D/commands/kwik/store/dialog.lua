local M = {}
---

function M:create(episode, isPurchased, isDownloaded)
    self.episode = episode
    local bookXXIcon = self.layer["bookXXIcon"]
    if model.bookShelfType == 0 then
        bookXXIcon = self.layer[episode.name .. "Icon"]
    end
    if bookXXIcon then
        bookXXIcon.lang = _K.lang
        self.downloadGroup[episode.name] = bookXXIcon
        bookXXIcon.versions = {}
        bookXXIcon.selectedPurchase = episode.name
        print("createDialog with", episode.name)
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
            cmd:setButtonImage(bookXXIcon, episode.name, _K.lang)
        else
            local src = self.layer[episode.name]
            bookXXIcon.fill = {
                type = "image",
                filename = _K.imgDir .. src.imagePath,
                baseDir = _K.systemDir
            }
            for k, v in pairs(model.episodes) do
                if self.layer[v.name] then
                    self.layer[v.name].alpha = 0
                end
            end
        end

        --
        if episode.versions then
            for i = 1, #episode.versions do
                if self.layer["version_" .. episode.versions[i]] and string.len(episode.versions[i]) > 1 then
                    local versionBtn =
                        copyDisplayObject(
                        self.layer["version_" .. episode.versions[i]],
                        nil,
                        episode.name .. self.episode.versions[i],
                        self.sceneGroup
                    )
                    print(episode.versions[i])
                    versionBtn.alpha = 1
                    versionBtn.episode = episode
                    versionBtn.selectedPurchase = episode.name
                    versionBtn.selectedVersion = episode.versions[i]
                    table.insert(bookXXIcon.versions, versionBtn)
                    self.versionGroup[episode.name .. episode.versions[i]] = versionBtn
                end
            end
            if model.URL and #bookXXIcon.versions == 0 then
                bookXXIcon.downloadBtn = copyDisplayObject(self.layer.downloadBtn, nil, episode, self.sceneGroup)
            end
        end
    end
end
--
--
function M:setVersionButtons(bookXXIcon, isFree)
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
            print("", "isUpdateAvailable")
            bookXXIcon.downloadBtn.episode = bookXXIcon.episode
            bookXXIcon.downloadBtn.selectedVersion = bookXXIcon.selectedVersion
            function bookXXIcon.downloadBtn:tap(e)
                VIEW.fsm:startDownload(self.episode, self.selectedVersion)
                return true
            end
            bookXXIcon.downloadBtn.alpha = 1
            bookXXIcon.downloadBtn:addEventListener("tap", bookXXIcon.downloadBtn)
            print(self.sceneGroup)
            print ("", "setUpdateMark", bookXXIcon.downloadBtn, self.sceneGroup)
            setUpdateMark(bookXXIcon.downloadBtn, self.sceneGroup)
            print("", "setUpdateMark ended")
        end
    else
        for i = 1, #bookXXIcon.versions do
            local versionBtn = bookXXIcon.versions[i]
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
function M:control(episode, isPurchased, isDownloaded)
    local bookXXIcon = self.layer["bookXXIcon"]
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
                        print("~~~~~~~~~~~~~~~~")
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
function M:update(selectedPurchase)
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

return M