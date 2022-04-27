local M = {}
--
local composer = require("composer")
local model = require("components.store.model")
local cmd = require("components.store.command").new()
local _K = require("Application")
--
---------------------------------------------------
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
    --
    --
    VIEW.createThumbnail  = thumbnail.create
    VIEW.controlThumbnail = thumbnail.control
    VIEW.refreshThumbnail = thumbnail.refresh
    VIEW.destroy          = thumbnail.destroy

    ---
    VIEW.createDialog      = dialog.create
    VIEW.setVersionButtons = dialog.setVersionButtons
    VIEW.controlDialog     = dialog.control
    VIEW.updateDialog      = dialog.update
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
