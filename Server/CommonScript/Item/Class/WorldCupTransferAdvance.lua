local tbItem = Item:GetClass("WorldCupTransferAdvance")

function tbItem:OnUse(it)
	local tbAct = Activity:GetClass("WorldCupAct")
	if GetTime() > tbAct.nTransferTokenExpire then
		me.CenterMsg("Đã quá thời hạn dùng")
		return 1
	end
	me.CallClientScript("Ui:CloseWindow", "ItemTips")
	me.CallClientScript("Ui:OpenWindow", "WorldCupTransferPanel", false)
	return
end