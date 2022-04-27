local M = {}

local model = require("components.store.model")
local cmd   = require("components.store.command").new()

function M:create()
    print("--- VIEW create ---")
    for k, episode in pairs(model.episodes) do
        -- print(episode.name)
        local button = self.layer[episode.name .. "Icon"]
        if button then
            button.selectedPurchase = episode.name
            button.lang = _K.lang
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
                cmd:setButtonImage(button, episode.name, _K.lang)
            end
            if cmd.isUpdateAvailableInVersions(episode.name) then
                setUpdateMark(button, self.sceneGroup)
            end
        end
    end
    --
end
--
function M:control()
    for k, episode in pairs(model.episodes) do
        -- print(episode.name)
        local button = self.layer[episode.name .. "Icon"]
        if button then
            button.episode = episode

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
function M:refresh()
    print("VIEW refreshThumbnail")
    for k, episode in pairs(model.episodes) do
        local button = self.layer[episode.name .. "Icon"]
        if button then
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
    end
end

function M:destroyl()
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


return M