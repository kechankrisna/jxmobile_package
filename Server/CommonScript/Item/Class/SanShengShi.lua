local tbItem = Item:GetClass("SanShengShi")
function tbItem:GetUseSetting(nItemTemplateId, nItemId)
	local function fnUse()
		local nMapTID = me.nMapTemplateId == 10 and 10 or 15
		Ui.HyperTextHandle:Handle(string.format("[url=npc:Nguyệt Lão, 2371, %d]", nMapTID), 0, 0)
		Ui:CloseWindow("ItemTips")
		Ui:CloseWindow("ItemBox")
	end
	return {szFirstName = "Đặt trước hôn lễ", fnFirst = fnUse};
end