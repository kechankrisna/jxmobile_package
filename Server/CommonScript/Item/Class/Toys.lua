local tbItem = Item:GetClass("Toy")
function tbItem:OnUse(it)
	local nId = KItem.GetItemExtParam(it.dwTemplateId, 1)
	if not nId or nId <= 0 then
		Log("[x] Toy:OnUse, cfg err", it.dwTemplateId, nId)
		me.CenterMsg("Đạo cụ thiết lập lỗi")
		return 0
	end
	Toy:Unlock(me, nId)
	return 1
end