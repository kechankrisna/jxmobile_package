local tbItem = Item:GetClass("XingYiDouZhuanItem")

function tbItem:OnClientUse()
	Ui:CloseWindow("ItemTips");
	Ui:CloseWindow("ItemBox");
	if me.nMapTemplateId == ChangeFaction.tbDef.nMapTID then
		me.CenterMsg("Chỉ có thể chuyển phái ở khu an toàn hoặc thành chính");
		return;
	end
	local bIsForbit = Item:CheckIsForbid("XingYiDouZhuanItem");
	if bIsForbit then return end;
	Ui:OpenWindow("ChangeFactionPanel");
end