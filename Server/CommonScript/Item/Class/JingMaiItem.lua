local tbItem = Item:GetClass("JingMaiItem")

function tbItem:OnUse(it)
	if not JingMai:CheckOpen(me) then 
		me.CenterMsg("Kinh mạch hiện không thể đả thông, hãy quay lại sau.", true)
		return
	end
	local nJingMaiId = KItem.GetItemExtParam(it.dwTemplateId, 1);
	me.CallClientScript("Ui:OpenWindow", "JingMaiPanel", nJingMaiId)
	me.CallClientScript("Ui:CloseWindow", "ItemTips")
end