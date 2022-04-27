local M = {}
--
local IAP             = require("components.store.IAP")
local downloadManager = require("components.store.downloadManager")
local model           = require("components.store.model")
local master          = require("model") -- case tmplt, it returns the pages table. case embedded, it is overwritten as {isEmbedded = true} at the runtime by Kwikshelf plugin
local composer        = require("composer")
local UI              = require("components.store.UI")


local type={pages = 0, embedded = 1, tmplt=2}
local bookShelfType = model.bookShelfType -- please set one of them

local downloadGroup = nil
local onDownloadComplete = nil

function M.new ()
    local CMD = {}
    print("commands.new", CMD)
    --
    function CMD:init(view)
        self.view = view
        downloadGroup = view.downloadGroup
    	--IAP:init(model.catalogue, restoreAlert, purchaseAlert)
    	--downloadManager:init(self.onDownloadComplete, onDownloadError)
    end
    -- Called when the scene's view does not exist:

    function CMD:startDownload(id, version)
        downloadManager:startDownload(id, version)
    end

    function CMD:dispose()
        print("------------------CMD:dispose")
        -- Runtime:removeEventListener("command:purchaseCompleted", self.onPurchaseComplete)
        -- for i=1, #CMD.buttons do
        --     CMD.buttons[i]:removeEventListener("tap", CMD.gotoScene)
        -- end
    end

    function CMD.gotoScene(event, version)
        print("CMD.gotoScene")
        UI.gotoScene(event, version)
    end
    --
    function CMD.showOverlay(event)
        local episode =  event.target.episode
        local options = {
            isModal = true,
            effect = model.showOverlayEffect,
            time = 200,
            params = {selectedPurchase=episode.name}
        }
        local page = model.INFO_PAGE
        if  bookShelfType == type.pages then
             page = model.getPageInfo(episode.name)
        end
        if page then
            if master.isEmbedded then
                package.loaded[page] = require("plugin.KwikShelf."..page)
            end
            model.currentEpisode = {name=episode.name, isPurchased = event.target.isPurchased}
            timer.performWithDelay(1, function()
                composer.showOverlay(page, options)
            end)
            print("--- done showOverlay---")
            return true
        else
            return false
        end
    end

    function CMD.hideOverlay()
        print("CMD.hideOverlay")
        composer.hideOverlay("fade", 400 )
        return true
    end

    function CMD.restore(event)
        for k, episode in pairs (model.episodes) do
            local button = CMD.view.layer[episode.name.."Icon"]
            if button then
            button:removeEventListener("tap", CMD.gotoScene)
            button.savedBtn:removeEventListener("tap", CMD.gotoScene)
        end
        end
        IAP.restorePurchases(event)
    end

    function CMD:setButtonImage(button, id, version)
        downloadManager.setButtonImage(button, id, version)
    end

    function CMD.hasDownloaded(name, version)
        return downloadManager.hasDownloaded(name, version)
    end

    function CMD.isUpdateAvailableInVersions(name)
        return downloadManager.isUpdateAvailableInVersions(name)
    end

    function CMD.isUpdateAvailable(name, version)
        return downloadManager.isUpdateAvailable(name, version)
    end

    function CMD.buyBook(e)
        IAP.buyEpisode(e)
    end

    function CMD.onPurchase(name)
        IAP.buyEpisode({target = {selectedPurchase = name}})
    end

    function CMD.onDownload(name)
       downloadManager:startDownload(name)
    end

    function CMD.onSaved(name)
        if downloadManager.hasDownloaded(name) then
            UI.gotoScene({target = {selectedPurchase = name}})
        end
    end
    return CMD
end

-- it will be called from the purchaseListener and the restoreListener functions
function M.onPurchaseComplete(event)
    local selectedPurchase = event.product
    local button = downloadGroup[selectedPurchase]
    print("CMD onPurchaseComplete", selectedPurchase)
    --
    if button and button.purchaseBtn.removeEventListener then
        button.purchaseBtn:removeEventListener("tap", IAP.buyEpisode)
        --
        if (event.actionType == "purchase") then
            -- button.text.text="saving"
            if model.URL then
                if #model.episodes[selectedPurchase].versions == 0 then
                print("startDownload")
                downloadManager:startDownload(event.product)
                elseif (button.versions==nil or #button.versions == 0) then
                   downloadManager:startDownload(event.product, button.lang )
                else
                    print("user can download a version now")
                end
            else
               -- onDownloadComplete(event.product)
            end
        elseif (event.actionType == "restore") then
            -- restore
            --button.text.text="press to download"
            if model.URL then
                if not button.tap then
                    function button:tap (event)
                        local selectedPurchase = event.target.selectedPurchase
                           downloadManager:startDownload(selectedPurchase)
                            return true
                    end
                    button.downloadBtn:addEventListener("tap", button)
                end
            else
                -- onDownloadComplete(event.product)
            end
        end
    end
end

Runtime:addEventListener("command:purchaseCompleted", M.onPurchaseComplete)

return M