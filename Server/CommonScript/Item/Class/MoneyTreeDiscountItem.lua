local tbItem = Item:GetClass("MoneyTreeDiscountItem")
function tbItem:OnUse(it)
	MoneyTree:OnUseDiscountItem(me)
	me.CenterMsg("Dùng thành công")
    return 1
end