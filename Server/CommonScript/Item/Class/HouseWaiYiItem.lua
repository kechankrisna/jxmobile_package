
local tbItem = Item:GetClass("HouseWaiYiItem");

function tbItem:OnUse(it)
	local nHouseWaiYiId = KItem.GetItemExtParam(it.dwTemplateId, 1);
	if not House.tbHouseWaiYiSetting[nHouseWaiYiId] then
		me.CenterMsg("Đạo cụ vô hiệu");
		return;
	end

	local bRet, szMsg = House:AddHouseWaiYi(me, nHouseWaiYiId);
	if not bRet then
		me.CenterMsg(szMsg or "Đại hiệp đã có trang sức này");
		return;
	end

	me.CenterMsg("Đã đặt trang sức Gia Viên, mau về Gia Viên xem thử!");
	return 1;
end


function tbItem:GetUseSetting(nTemplateId, nItemId)
	if not nItemId then
		return {};
	end

	return {szFirstName = "Đặt trang sức Gia Viên", fnFirst = "UseItem"};
end