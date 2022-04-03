local _Class = {}

local model = require("components.store.model")
local cmd = require("components.store.command").new()
local downloadManager = require("components.store.downloadManager")
local IAP = require("components.store.IAP")
local composer = require("composer")

local _instance = nil

function _Class.getInstance()
    if _instance == nil then
        local o = {}
        o.fsm = require("components.store.store_sm"):new {owner = o}
        _instance = setmetatable(o, {__index = _Class})
    end

    return _instance
end

function _Class:destroy()
    --cmd:dispose()
    --self.view:destroy()
end
------------------------------
--- INIT state
---
function _Class:initModel()
end
------------------------------
-- Downloading State
--
function _Class:startDownload(id, version)
    if id then
        -- print("storeFSM startDownload id=", id.name, version)
        self.fromDialog = true -- downlaoding a version must be from dialog
        cmd:startDownload(id.name, version)
    else
        --print("storeFSM:startDownload", version)
        cmd:startDownload()
    end
end

function _Class:unzip(id)
    -- obsolete
end

function _Class:queue(id)
end

------------------------------
-- Downloaded
--
function _Class:updateDialog(id, version)
    self.view:updateDialog(id, version)
end

------------------------------
-- ThumnailDisplayed state
--
function _Class:createThumbnail()
    print("== storeFSM createThumbnail ==")
    self.view:createThumbnail()
    self.view:controlThumbnail()
    --print("== storeFSM createThumbnail ==", "end")
end

function _Class:destroyThumbnail()
    print("== storeFSM destoryThumbnail ==")
    cmd:dispose()
    self.view:destroyThumbnail()
end

function _Class:removeEventListener()
    Runtime:removeEventListener("hideOverlay", self.fsm.onClose)
end
------------------------------
-- DisplayingDialog state
--
function _Class:isBookPurchased(episode)
    print("storeFSM isBookPurchased")
    self.episode = episode
    local isPurchased = false
    local isDownloaded = false
    if episode.isFree then
        isPurchased = true
        isDownloaded = downloadManager.hasDownloaded(episode.name)
        if not downloadManager.isUpdateAvailableInVersions(episode.name) then
            print("isUpdateAvailableInVersions", false)

            timer.performWithDelay(
                100,
                function()
                    self.fsm:onClose()
                    self.fsm:gotoBook(episode)
                end
            )
        else
            local event = {
                target = {
                    episode = episode,
                    selectedPurchase = episode.name,
                    isPurchased = isPurchased,
                    isDownloaded = isDownloaded
                }
            }
            if cmd.showOverlay(event) then
                timer.performWithDelay(
                    100,
                    function()
                        self.fsm:createDialog(episode, isPurchased, isDownloaded)
                    end
                )
            end
        end
    else
        -- Runtime:addEventListener("hideOverlay", self.fsm.onClose)
        if (IAP.getInventoryValue("unlock_" .. episode.name) == true) then
            isPurchased = true
            if downloadManager.hasDownloaded(episode.name) then
                isDownloaded = true
                print(episode.name .. "(saved)")
            else
                print(episode.name .. "(saving)")
            end
        end
        local event = {
            target = {
                episode = episode,
                selectedPurchase = episode.name,
                isPurchased = isPurchased,
                isDownloaded = isDownloaded
            }
        }
        if cmd.showOverlay(event) then
            timer.performWithDelay(
                100,
                function()
                    self.fsm:createDialog(episode, isPurchased, isDownloaded)
                end
            )
        else
            print("---------- not overlay -------- ")
            if isPurchased then
                timer.performWithDelay(
                    100,
                    function()
                        self.fsm:onClose()
                        self.fsm:gotoBook(episode)
                    end
                )
            else
                print("not purchased")
                timer.performWithDelay(
                    100,
                    function()
                        self.fsm:onClose()
                    end
                )
            end
        end
    end
end

------------------------------
-- BookPurchased/BookNotPurchased
--
function _Class:onCreateDialog(id, isPurchased, isDownloaded)
    print("storeFSM onCreateDialog")
    self.view:createDialog(id, isPurchased, isDownloaded)
    --print("### createDialog end")
    self.view:controlDialog(id, isPurchased, isDownloaded)
    --print("### control end")
    self.fromDialog = true
    local episode = id
    timer.performWithDelay(
        100,
        function()
            if isPurchased then
                self.fsm:showDialogPurchased()
                --print("showDialogPurchased end")
                if not isDownloaded then
                    if #episode.versions == 0 and not episode.isFree then
                        --print("onCreateDialog onRestore ", episode.name)
                        self.fsm:onRestore(episode)
                    end
                end
            else
                --print("showDialogNotPurchased")
                self.fsm:showDialogNotPurchased()
            end
        end
    )
end

function _Class:destroyDialog()
    print("storeFSM destroyDialog")
    self.view:destroyDialog()
    composer.hideOverlay("fade", 400)
    self.fromDialog = false
end

function _Class:gotoScene(episode, version)
    print("storeFSM gotoScene", episode.name, version)
    local _version = version
    if #episode.versions > 0 and version == nil then
        local _K = require("Application")
        _version = _K.lang
    end
    local event = {target = {episode = episode, selectedPurchase = episode.name}}
    composer.hideOverlay("fade", 100)
    self.fromDialog = false
    timer.performWithDelay(
        300,
        function()
            --print("#############")
            cmd.gotoScene(event, _version)
        end
    )
    -- Runtime:dispachEvent("hideOverlay")
end

------------------------------
-- IAPBadger
--

function _Class:purchase(id, fromDialog)
    print("storeFSM purchase", id, fromDialog)
    self.fromDialog = fromDialog
    IAP.buyEpisode({target = {selectedPurchase = id}})
end

function _Class:refreshDialog(isDownloaded)
    print("refreshDialog", isDownloaded)
    -- if isDownloaded then
    --     self.view:updateDialog()
    -- end
end

function _Class:refreshThumbnail()
    print("storeFSM refreshThumbnail")
    self.view:refreshThumbnail()
end
------------------------------
-- BookDisplayed
--
function _Class:onEntryBookDisplayed()
end

function _Class:onExitBookDisplayed()
    -- addEventListner ("tap", self.fsm:showThumbnail() )
end

function _Class:exit()
    print("-------- exit ------------")
    self.fsm:exit()
end

------------------------------
--
--
function _Class.onDownloadComplete(selectedPurchase, version)
    local self = _Class.getInstance()
    self.fsm:onSuccess()
    if self.fromDialog then
        self.fsm:fromDialog(selectedPurchase, version)
        self.fromDialog = false
        print("onDownloadComplete fromDialog false")
    else
        self.fsm:backThumbnail()
        self.fromThumbnail = false
    end
end

function _Class.onDownloadError(selectedPurchase, message)
    local self = _Class.getInstance()
    if self.fromDialog then
        --self.fsm:fromDialog(selectedPurchase)
        self.fsm:onFailure()
        self.fromDialog = false
    else
        self.fsm:backThumbnail()
        self.fromThumbnail = false
    end
    self.view.onDownloadError(selectedPurchase, message)
end
--
-- purchase and restore call this purchaseListener
-- and IAP.lua also fires command:purcahseComplted wth purchase/restore
--
function _Class.purchaseListener(product)
    local self = _Class.getInstance()
    if #model.episodes[product].versions == 0 then
        self.fsm:startDownload()
    else
        self.fsm:showDialogPurchased()
        self.view:updateDialog(product)
    end
end

function _Class.failedListener()
    local self = _Class.getInstance()
    print("page02", "failedListener", self.fromDialog)
    if self.fromDialog then
        self.fsm:onPurchaseCancel()
    else
        self.fsm:backThumbnail()
    end
end
--
function _Class:init(overlay, view)
    print("========= storeFSM init ===============")
    self.view = view
    --cmd:init(view)
    IAP:init(
        model.catalogue,
        view.restoreAlert,
        function(product)
            self.purchaseListener(product)
            view.purchaseAlert()
        end,
        self.failedListener,
        model.debug
    )
    downloadManager:init(self.onDownloadComplete, self.onDownloadError) --
    self.fsm:enterStartState()
    if (system.getInfo("environment") == "simulator") then
        self.fsm:setDebugFlag(true)
    end
    if overlay then
        if downloadManager.isDownloadQueue() then
            self.fromThumbnail = true
            self.fsm:onDownloadQueue()
        else
            self.fsm:showThumbnail()
        end
    else
        -- mydebug.print()
        if model.currentEpisode.isPurchased then
            self.fsm:showDialogPurchased()
        else
            self.fsm:showDialogNotPurchased()
        end
    end
end

function _Class:resume()
    print("storeFSM resume")
    self.view:refresh(true)
end

return _Class
