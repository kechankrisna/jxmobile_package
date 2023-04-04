local tbItem = Item:GetClass("KinDinnerPartyItem")

function tbItem:GetUseSetting(nTemplateId, nItemId)
	if Shop:CanSellWare(me, nItemId, 1) then
		return {szFirstName = "Bán", fnFirst = "SellItem"}
	end
	return {}
end