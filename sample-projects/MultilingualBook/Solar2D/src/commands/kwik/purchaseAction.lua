-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--

local _M = {}
--
function _M:restorePurchase()
	local IAP = require("components.store.IAP")
	IAP.restore()
end
--
function _M:refoundPurchase()
 --Add code for refund
end
--
function _M:buyProduct(product)
	local IAP = require("components.store.IAP")
	if IAP.canMakePurchases() then
			local event = {target={selectedPurchase=product}}
			IAP.buyEpisode(event)
	  -- store.purchase(product)
	else
	  native.showAlert("Alert", "Store purchases are not available, please try again later",  { "OK" } )
	end
end
--
return _M