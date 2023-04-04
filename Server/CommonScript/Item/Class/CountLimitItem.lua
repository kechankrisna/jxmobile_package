local tbItem = Item:GetClass("CountLimitItem");

function tbItem:GetTip(it)
	if not it.dwId then
		return "";
	end

	local nMaxCount = KItem.GetItemExtParam(it.dwTemplateId, 1);
	local nUsedCount = it.GetIntValue(1);
	return string.format("Số lần tưới nước còn: %d/%d", nMaxCount - nUsedCount, nMaxCount);
end

function tbItem:GetUseSetting()
	return {};
end