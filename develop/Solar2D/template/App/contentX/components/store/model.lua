local M = {}
--
local IAP             = require("components.store.IAP")
--
{{#bookShelfType}}
M.bookShelfType  = {{bookShelfType}} --{none = -1, pages = 0, embedded = 1, tmplt=2}
if M.bookShelfType  == 1 then
    M.downloadManager = "V2"
end
{{/bookShelfType}}
--
M.debug     = {{iapDebug}}
----------------------------------
-- M.URL = nil means simple IAP store without network download like Kwik3 IAP
-- downloadBtn, savingTxt won'T be used. You don't need to create them.
--
{{#simpleLock}}
M.episodes = {
    {{#list}}
        {{product}}  ={name = "{{product}}", dir = "", numOfPages = 0, info = ""},
    {{/list}}
}
{{/simpleLock}}
{{#Pages}}
-- local YourHost  = "http://localhost:4000/tutorials/Kwik4"
M.downloadable  = {{downloadable}}
M.URL           = "{{serverURL}}" -- YourHost.."/BookShelf/"
M.backgroundImg = "bg.png"
----------
----------
M.episodes = {
    {{#list}}
        {{product}}  ={name = "{{product}}", startPage = {{startPage}}, dir = "assets/images/p{{startPage}}", numOfPages = {{numOfPages}}, info = "{{info}}"},
    {{/list}}
}
--
M.tocPage = {{tocPage}}
{{/Pages}}
{{#Books}}
M.downloadable  = {{downloadable}}
M.URL           = "{{serverURL}}" -- YourHost.."/BookShelf/"
M.backgroundImg = "bg.png"
----------
----------
M.TOC_PAGE = "views.page0".."{{tocPage}}".."Scene"
M.INFO_PAGE = "views.page0".."{{infoPage}}".."Scene" -- "views.page02Scene" -- for bookshelf embedded and tmplt
--
function M:initPages(lang)
    if lang == "en" then
        -- self.TOC_PAGE = "views.page0".."2".."Scene"
        -- self.INFO_PAGE = "views.page0".."4".."Scene" 
    elseif lang == "jp" then
        -- self.TOC_PAGE = "views.page0".."3".."Scene"
        -- self.INFO_PAGE = "views.page0".."5".."Scene" 
    end
end
--
M.episodes = {
    {{#list}}
        {{product}}  ={name = "{{product}}", dir = "{{product}}", numOfPages = {{numOfPages}}, info = "{{desc}}", versions ={ {{ver}} }, isFree={{bFree}}, isOnlineImg={{bOnlineImg}} },
    {{/list}}
}
{{/Books}}
--
M.catalogue = {
    products = {
    {{#list}}
        {{product}} = {
            productNames = { apple="{{appleID}}", google="{{googleID}}", amazon="{{amazonID}}"},
            productType  = "non-consumable",
            onPurchase   = function() IAP.setInventoryValue("unlock_{{product}}") end,
            onRefund     = function() IAP.removeFromInventory("unlock_{{product}}") end,
        },
    {{/list}}
    },
    inventoryItems = {
    {{#list}}
        unlock_{{product}} = { productType="non-consumable" },
    {{/list}}
    }
}
--
M.purchaseAlertMessage = "Your purchase was successful"
M.restoreAlertMessage  = "Your items are being restored"
M.downloadErrorMessage = "Check network alive to download the content"
--
M.gotoSceneEffect   = "slideRight"
M.showOverlayEffect = "slideBottom"
--
M.getPageNum = function(episode)
    local pNum = M.episodes[episode].startPage
    pNum = pNum:sub(16)
    return pNum
end
--
--
local _K = require("Application")
--
--
M.getPageName = function (episode)
    local pNum = M.episodes[episode].dir
    pNum = pNum:sub(16)
    return "views.page0"..pNum.."Scene"
end
--
--
M.getPageInfo = function (episode)
    print(episode)
    local pNum = M.episodes[episode].info
    if string.len(pNum) > 0 then
        return "views.page0"..pNum.."Scene"
    else
        return nil
    end
end
--
{{#Pages}}
--
M.isIAP = function(pageNum)
    for k, v in pairs(M.episodes) do
        local pNum = v.dir
        pNum = tonumber(pNum:sub(16))
        if pageNum >= pNum and pageNum <= pNum + v.numOfPages -1 then
            return v.name
        end
    end
    return false
end
--
local composer = require("composer")
local _gotoScene = composer.gotoScene
--
composer.gotoScene = function( sceneName, options)
    local pageNum = string.sub(sceneName, 11, 12)
    if M.isIAP(tonumber(pageNum)) then
        _K.systemDir = system.ApplicationSupportDirectory
    else
        _K.systemDir   = system.ResourceDirectory
    end
    _gotoScene(sceneName, options)
end
{{/Pages}}
--
return M