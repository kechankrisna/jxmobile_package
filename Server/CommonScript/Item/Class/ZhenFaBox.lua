
local tbItem = Item:GetClass("ZhenFaBox");

function tbItem:OnUse(it)
	local bRet, szMsg = me.CheckNeedArrangeBag();
	if bRet then
		me.CenterMsg(szMsg);
		return;
	end

	local nParamId = KItem.GetItemExtParam(it.dwTemplateId, 1);
	nParamId = Item:GetClass("RandomItemByTimeFrame"):GetRandomKindId(nParamId);
	local bRet, szMsg, tbAllAward = Item:GetClass("RandomItem"):RandomItemAward(me, nParamId, it.szName, Env.LogWay_ZhenFaOpenBoxAward);
	if not bRet or bRet ~= 1 then
		me.CenterMsg(szMsg);
		return;
	end

	me.SendAward(tbAllAward, false, true, Env.LogWay_ZhenFaOpenBoxAward);
	Log("[ZhenFaBox] OnUse", me.dwID, me.szName, me.szAccount, it.dwTemplateId);
	return 1;
end

function tbItem:GetCombineCountInfo(nItemTemplateId)
	local tbCount = {};
	for i = 2, 1, -1 do
		local nDstTemplateId = KItem.GetItemExtParam(nItemTemplateId, i + 1);
		local nCount = me.GetItemCountInBags(nDstTemplateId);
		tbCount[i] = nCount;
	end
	return unpack(tbCount);
end

function tbItem:Combine(nItemTemplateId)
	local nItemId = 0;
	local szName = "";
	local tbItemInfo= {};
	for i = 2, 1, -1 do
		local nDstTemplateId = KItem.GetItemExtParam(nItemTemplateId, i + 1);
		local tbBaseInfo = KItem.GetItemBaseProp(nDstTemplateId);
		local tbItem = me.FindItemInBag(nDstTemplateId);
		local nCount = me.GetItemCountInBags(nDstTemplateId);
		szName = tbBaseInfo.szName;
		if nCount > 0 and tbItem and tbItem[1] then
			table.insert(tbItemInfo, {tbItem[1].dwId, nCount});
		end
	end

	if #tbItemInfo <= 0 then
		me.CenterMsg(string.format("Không có %s, không thể ghép!", szName));
	else
		local nItemCount = me.GetItemCountInBags(nItemTemplateId);
		for _, tbInfo in ipairs(tbItemInfo) do
			if nItemCount > 0 then
				RemoteServer.UseAllItem(tbInfo[1]);
				nItemCount = nItemCount - tbInfo[2];
			else
				break;
			end
		end
	end
end

function tbItem:GetUseSetting(nItemTemplateId, nItemId)
	local function fnCombine()
		Ui:CloseWindow("ItemTips");
		local nCount1, nCount2 = self:GetCombineCountInfo(nItemTemplateId);
		local nItemCount = me.GetItemCountInBags(nItemTemplateId);
		nCount2 = math.min(nCount2, nItemCount);
		nCount1 = math.min(nItemCount - nCount2, nCount1);
		me.MsgBox(string.format("Đại hiệp sửa số lượng tối đa [aa62fc]Bí Quyển Trận Pháp Cổ[-]?\nQuy tắc sửa: Ưu tiên ghép [ff8f06]Mật Tịch Trận Pháp Hiếm[-] (Được ghép [FFFE0D]%s[-] quyển), kế đến ghép [ff578c]Mật Tịch Trận Pháp Kế Thừa[-] (Được ghép [FFFE0D]%s[-] quyển)", nCount2, nCount1), {
			{"Sửa hết", function () self:Combine(nItemTemplateId) end, bLight = true},
			{"Hủy"},
		});
	end
	return {szFirstName = "Dùng", fnFirst = "UseItem", szSecondName = "Sửa", fnSecond = fnCombine};
end